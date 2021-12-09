diseases = {'h-s-','pm-s-','fs-s-','ac-s-'};
pixels = zeros(1,length(diseases));
disease_name = {};
last = 1;
for diseaseno = 1:length(diseases)
    for c = 1:5
        img_filename = strcat(strcat(diseases{diseaseno}, int2str(c)), '.jpg');
        img_original = imread(img_filename);
        img_bw = rgb2gray(img_original);
        img_red = img_original(:,:,1);
        img_green = img_original(:,:,2);
        img_blue = img_original(:,:,3);
        
        % Gray level slicing
        bin_red = double(img_red);
        bin_green = double(img_green);
        bin_blue = double(img_blue);
        bin_apple = double(img_green);
        bin_black_disease=double(img_bw);
        [row,col]=size(bin_red);
        red_l1=0;
        red_l2=90;
        green_l1=150;
        green_l2=250;
        blue_l1=0;
        blue_l2=0;
        black_disease_l1 = 0;
        black_disease_l2 = 100;
        disease_area = 0;
        apple_area = 0;
        for x=1:row            
            for y=1:col        
                if((img_red(x,y)>red_l1) && (img_red(x,y)<red_l2))
                    bin_red(x,y)=255;
                    disease_area = disease_area + 1;
                else
                    bin_red(x,y)=0;
                end
                
                if((img_green(x,y)>green_l1) && (img_green(x,y)<green_l2))
                    bin_green(x,y)=255;
                else
                    bin_green(x,y)=0;
                end
                
                if((img_blue(x,y)>blue_l1) && (img_blue(x,y)<blue_l2))
                    bin_blue(x,y)=255;
                else
                    bin_blue(x,y)=0;
                end
                
                if((img_green(x,y)>=250) && (img_green(x,y)<=255))
                    apple_area = apple_area + 1;
                    bin_apple(x,y)=0;
                else
                    bin_apple(x,y)=255;
                end
                
                if((img_bw(x,y)>black_disease_l1) && (img_bw(x,y)<black_disease_l2))
                    bin_black_disease(x,y)=255;
                else
                    bin_black_disease(x,y)=0;
                end
            end
        end
        
        [~,red_8m] = bwlabel(bin_red,8);
        [~,green_8m] = bwlabel(bin_green,8);
        
        % Add roberts filter, increase sensitivity by 0.07
        % Identificaiton for Powdery Mildew on Blue channel
        [~, thresh] = edge(img_blue,'Roberts');
        sens = thresh + 0.01;
        img_seg = edge(img_blue,'Roberts', sens);
        [~,edge_8m] = bwlabel(img_seg,8);
        
        % Identificaiton for Flyspeck vs Apple Cod
        [~, thresh] = edge(img_bw,'Roberts');
        sens = thresh + 0.07;
        imgsep = edge(img_bw,'Roberts', sens);
        [~, edge_4m] = bwlabel(bin_black_disease&imgsep, 4);
        
        bin_apple = imfill(bin_apple,'holes');
        apple_area = sum(bin_apple(:))/255;
        
        black_disease_ratio = disease_area/apple_area;
        if (black_disease_ratio > 0.008)
            if (edge_4m > 50)
                disease = 'Fly Speck';
            else 
                disease = 'Apple Cod';
            end
        else
            if (edge_8m < 150)
                disease = 'No disease';
            else 
                disease = 'Powdery Mildew';
            end
        end
        

        figure(c), 
            subplot(2,4,1), imshow(img_original), title(img_filename),
            subplot(2,4,2), imshow(img_red), title('Red channel'),
            subplot(2,4,3), imshow(img_green), title('Green channel'),
            subplot(2,4,4), imshow(img_blue), title('Blue channel'),
            subplot(2,4,5), imshow(bin_apple), title(disease),
            subplot(2,4,6), imshow(bin_red), title(strcat('Area = ', int2str(disease_area))),
            subplot(2,4,7), imshow(bin_green), title(strcat('Green-8m(150-250) connected regions = ', int2str(green_8m))),
            subplot(2,4,8), imshow(img_seg), title(edge_8m);
            
        input('Press enter..');
        
        last = last + 1;
    end
end