for c = 1:6
    img_filename = strcat(strcat('ac-', int2str(c)), '.jpg');
    %img_filename = strcat(int2str(c), '.jpg');
    img_original = imread(img_filename);
    img_bw = rgb2gray(img_original);
    
    k=double(img_bw);
    [row,col]=size(k);
    T1=0;
    T2=100;
    for x=1:row            
        for y=1:col        
            if((img_bw(x,y)>T1) && (img_bw(x,y)<T2))
                k(x,y)=255;
            else
                k(x,y)=0;
            end
        end
    end
    
    [edges, thresh] = edge(img_bw,'Roberts');
    sens = thresh + 0.07;
    imgsep = edge(img_bw,'Roberts', sens);
    
    figure(c), subplot(2,2,1), imshow(img_bw), subplot(2,2,2), imshow(k), subplot(2,2,3), imshow(imgsep), subplot(2,2,4), imshow(k&imgsep);
    input('asd');
end