clear;
clc;
close all;

tic;

%settings ONLY MODIFY THIS%%%%%%%%%%%%%%%%%%%%
name_pre_number  = 'FULL TANK\';
name_post_number = '.jpg';
add_zeros = 0;

first_page = 215;
last_page = 240;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    x = imread(strname);
    
    
    imwrite(x,['' strnum '.png'],'png');
    disp ([strnum ' done!']);
    
end

toc;
