diseases = {'fs-s-','ac-s-'};
pixels = zeros(1,length(diseases));
disease_name = {};
last = 1;
for diseaseno = 1:length(diseases)
    for c = 1:5
        img_filename = strcat(strcat(diseases{diseaseno}, int2str(c)), '.jpg');
        img_original = imread(img_filename);
        img_bw = rgb2gray(img_original);

        % Gray level slicing
        bin_black_disease=double(img_bw);
        [row,col]=size(bin_black_disease);
        black_disease_l1=0;
        black_disease_l2=100;
        for x=1:row            
            for y=1:col        
                if((img_bw(x,y)>black_disease_l1) && (img_bw(x,y)<black_disease_l2))
                    bin_black_disease(x,y)=255;
                else
                    bin_black_disease(x,y)=0;
                end
            end
        end

        % Add roberts filter, increase sensitivity by 0.07
        [edges, thresh] = edge(img_bw,'Roberts');
        sens = thresh + 0.07;
        imgsep = edge(img_bw,'Roberts', sens);
        figure(c+2), imshow(imgsep);

        % Get 4-m connected neighbors
        [L, n] = bwlabel(bin_black_disease&imgsep, 4);

        % Append number of 4-m conncted regions
        pixels(last) = n;
        
        figure(c), 
            subplot(2,2,1), imshow(img_bw), title(img_filename),
            subplot(2,2,2), imshow(bin_black_disease), 
            subplot(2,2,3), imshow(imgsep), 
            subplot(2,2,4), imshow(bin_black_disease&imgsep), title(strcat('4-m Pixels = ', int2str(n)));

        input('Press enter..');
        
        last = last + 1;
    end
end