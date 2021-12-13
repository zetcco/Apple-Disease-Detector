function [disease, black_disease_ratio, edge_4m, edge_8m]  = detector(img_filename)
        img_original = imread(img_filename);
        
        % Seperate the original image to seperate channels
        img_bw      =   rgb2gray(img_original);
        img_red     =   img_original(:,:,1);
        img_green   =   img_original(:,:,2);
        img_blue    =   img_original(:,:,3);
        
        % Grey level slicing to detect spots
        black_area_l1       =   0;      % Lower bound to detect black/dark pixels (To detect black area in the apple) 
        black_area_l2       =   90;     % Upper bound to detect black/dark pixels (To detect black area in the apple) 
        black_disease_l1    =   0;      % Lower bound to detect darker spots including less darker spots (To identify between two black diseases)
        black_disease_l2    =   100;    % Upper bound to detect darker spots including less darker spots (To identify between two black diseases)
        white_light_l1      =   250;    % Lower bound to detect white/light pixels (To detect the background excluding apple)
        white_light_l2      =   255;    % Upper bound to detect white/light pixels (To detect the background excluding apple)

        black_disease_area = 0;         % Diseased area pixels
        
        % Gets no of rows and columns
        [row,col] = size(img_bw);
        
        % Convert image to greyscale images from the 3 channels
        bin_red             =   zeros(row,col);       % Allocation for Red channel's dark spots (0 - 90)
        bin_black_disease   =   zeros(row,col);       % Area of dark/black spots in image
        bin_apple           =   zeros(row,col);       % Area of the full apple
        
        for x=1:row            
            for y=1:col        
                if((img_red(x,y)>black_area_l1) && (img_red(x,y)<black_area_l2)) % 0-90 pixels ( To detect Black/Dark areas in the apple)
                    bin_red(x,y)=255;
                    black_disease_area = black_disease_area + 1;
                else
                    bin_red(x,y)=0;
                end
                
                if((img_green(x,y)>=white_light_l1) && (img_green(x,y)<=white_light_l2)) % 250 - 255  ( To detect get apple area )
                    bin_apple(x,y)=0;
                else
                    bin_apple(x,y)=255;
                end
                
                if((img_bw(x,y)>black_disease_l1) && (img_bw(x,y)<black_disease_l2)) % 0 - 100  (To detect Black/Dark with grey colors)
                    bin_black_disease(x,y)=255;
                else
                    bin_black_disease(x,y)=0;
                end
            end
        end
        
        
        % Identificaiton for Powdery Mildew on Blue channel using Roberts
        % edge detection (with additional 0.01 sensitivity)
        [~, thresh] = edge(img_blue,'Roberts');
        sens = thresh + 0.01;
        img_seg = edge(img_blue,'Roberts', sens);
        [~,edge_8m] = bwlabel(img_seg,8);
        
        
        % Identificaiton for Flyspeck vs Apple Cod (between Black diseases)
        [~, thresh] = edge(img_bw,'Roberts');
        sens = thresh + 0.07;
        imgsep = edge(img_bw,'Roberts', sens);
        [~, edge_4m] = bwlabel(bin_black_disease&imgsep, 4);
        
        % Fill holes inside apple if there are, then sum all white pixels
        % and then divide by 255 to get count of White pixels effectively
        % area of the apple.
        bin_apple = imfill(bin_apple,'holes');
        apple_area = sum(bin_apple(:))/255;
        
        % Get the black_disease ratio (black_disease_area/apple_area);
        black_disease_ratio = black_disease_area/apple_area;
        
        % Grouping them to disease
        if (black_disease_ratio > 0.007)
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
end