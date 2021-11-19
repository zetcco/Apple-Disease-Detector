for c = 1:5
    img_filename = strcat(int2str(c), '.jpg');
    img = imread(img_filename);
    img = rgb2gray(img);
    [edges, thresh] = edge(img,'Roberts');
    sens = thresh + 0.07;
    imgsep = edge(img,'Roberts', sens);
    [L, n] = bwlabel(imgsep);
    n
    figure(c), subplot(1,2,1), imshow(img), subplot(1,2,2), imshow(imgsep);
    input('Press');
end