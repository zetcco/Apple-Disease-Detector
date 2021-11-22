diseases = {'pm-s-','fs-s-','ac-s-'};
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
        
        % Gray level slicing
        bin_red = double(img_red);
        bin_green = double(img_green);
        [row,col]=size(bin_red);
        red_l1=0;
        red_l2=90;
        green_l1=150;
        green_l2=250;
        for x=1:row            
            for y=1:col        
                if((img_red(x,y)>red_l1) && (img_red(x,y)<red_l2))
                    bin_red(x,y)=255;
                else
                    bin_red(x,y)=0;
                end
                
                if((img_green(x,y)>green_l1) && (img_green(x,y)<green_l2))
                    bin_green(x,y)=255;
                else
                    bin_green(x,y)=0;
                end
            end
        end
        
        [L,red_8m] = bwlabel(bin_red,8);
        [L,green_8m] = bwlabel(bin_green,8);
        
        % Add roberts filter, increase sensitivity by 0.07
        % img_seg = edge(img_red,'Prewitt');
        [edges, thresh] = edge(img_green,'Roberts');
        sens = thresh + 0.01;
        img_seg = edge(img_green,'Roberts', sens);
        
        [L,edge_8m] = bwlabel(img_seg&bin_red,8);
        [L, inter_8m] = bwlabel(bin_red&bin_green,8);
        
        figure(c), 
            subplot(2,4,1), imshow(img_original), title(img_filename),
            subplot(2,4,2), imshow(img_red), title('Red channel'),
            subplot(2,4,3), imshow(img_green), title('Green channel'),
            subplot(2,4,4), imshow(img_seg), title('Edge detection'),
            subplot(2,4,6), imshow(bin_red), title(strcat('Red-8m(0-75) connected regions = ', int2str(red_8m))),
            subplot(2,4,7), imshow(bin_green), title(strcat('Green-8m(150-250) connected regions = ', int2str(green_8m)));
            
            
        input('Press enter..');
        
        last = last + 1;
    end
end