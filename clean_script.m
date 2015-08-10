clear;
clc;
close all;

tic;

%settings ONLY MODIFY THIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%file names
name_pre_number  = 'chicchai\';
name_post_number = '.jpg';
add_zeros = 1;
first_page = 8;
last_page = 215;

%levels
black_floor = 60;
white_ceiling =245;

%profile (negative = darker, positive = lighter)
llog = -0.00001; 

%cropping
cropping = 0;
even_crop_up =0;
even_crop_left =0;
even_crop_right =0;
even_crop_down =0;
odd_crop_up =0;
odd_crop_left =0;
odd_crop_right =0;
odd_crop_down =0;

%dusting
dust =1;
black_dust = 2245;
white_dust = 50;

%resize
resize = 1;
height = 1600;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

black_floor = black_floor + 1;
white_ceiling = white_ceiling + 1;

j = 255-white_ceiling;
white_ceiling = 255-black_floor;
black_floor=j;

f = zeros(1,256);
f((255-black_floor) : end) = 255;

if llog > 0
    logari = log(1:llog/(255-black_floor-(255-white_ceiling)-1):llog+1) / max(log(1:llog/(255-black_floor-(255-white_ceiling)-1):llog+1)) * 255;
else
    llog = -llog;
    logari = log(1:llog/(255-black_floor-(255-white_ceiling)-1):llog+1) / max(log(1:llog/(255-black_floor-(255-white_ceiling)-1):llog+1)) * 255;
    logari = fliplr(logari);
    logari = -(logari-255);
end


f((255 - white_ceiling):(255 - black_floor - 1)) = logari;

% f = fliplr(f);
% f = (f-255) *(-1);
f = uint8(f);

for k = first_page:last_page

    strnum = num2str(k);
    
    if(1 == add_zeros)
        if k<100
            strnum = ['0' strnum];
            if k<10
                strnum = ['0' strnum];
            end
        end
    end
    
    strname = [name_pre_number strnum name_post_number];

    if (exist(strname, 'file') == 2)

        x = imread(strname);
        [M N Z] = size(x);
        if(Z > 1)
            x = rgb2gray(x);
        end

        %cropping
        if (cropping==1)
            if(rem(k, 2)) %%odd
                crop_up =odd_crop_up;
                crop_left =odd_crop_left;
                crop_right =odd_crop_right;
                crop_down =odd_crop_down;
            else %even
                crop_up =even_crop_up;
                crop_left =even_crop_left;
                crop_right =even_crop_right;
                crop_down =even_crop_down;
            end

            [M N] = size(x);
            x = x(1 + crop_up : (M - crop_down), 1 + crop_left : (N - crop_right));

        end
        [M N] = size(x);

        % filter
        h = fspecial('gaussian', 5, 1) ;
        zx = imfilter(x, h,'replicate');


        %level correction
        y = zeros(size(x));
        z = y; 

        for i = 0:1:255
            y(x==i) = f(i+1);
            z(zx==i) = f(i+1);
        end


     %   white dots in black masses deletion and black dots in white masses deletion
     
         if(dust == 1)
            for i=2:M-1
                for j =2:N-1
                    ex = y(i-1:i+1, j-1:j+1);
                    pix = sum(sum(ex));
                    if((pix < white_dust)||(pix > black_dust))
                        y(i,j) = z(i,j);
                    end
                end
            end
         end
         
        y=uint8(y);
        
        if (resize == 1)
           y = imresize(y, height / M);
        end

        imwrite(y,[strnum '.png'],'png');
        disp ([strnum ' done!']);
        
    else
        disp(['Caution: file "' strname ' doesnt exist']);
    
    end
    
end
figure;
movegui('northeast') 
plot(f)
xlabel('Input');
ylabel('Output');
colormap gray;
c1 = colorbar('southoutside');
c2 = colorbar('westoutside');
caxis([0,255]);
grid;
axis([0 255 0 255])

toc;
