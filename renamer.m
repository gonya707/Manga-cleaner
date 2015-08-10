name_pre_number  = 'Stand by me\anteriores traductores\Stand_By_Me_';
name_post_number = '.png';
add_zeros = 1;
first_page = 1;
last_page = 114;



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

        movefile(strname,[strnum '.png']);
    else
        disp(['Caution: file "' strname ' doesnt exist']);
    
    end
    
end