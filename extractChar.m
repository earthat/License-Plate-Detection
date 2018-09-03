function final=extractChar(cropedimg)
g=rgb2gray(cropedimg);              % Converting the RGB (color) image to gray (intensity).
g=medfilt2(g,[3 3]);                % Median filtering to remove noise.
se=strel('disk',1);                 % Structural element (disk of radius 1) for morphological processing.
gi=imdilate(g,se);                  % Dilating the gray image with the structural element.
ge=imerode(g,se);                   % Eroding the gray image with structural element.
gdiff=imsubtract(gi,ge);            % Morphological Gradient for edges enhancement.
gdiff=mat2gray(gdiff);              % Converting the class to double.
gdiff=conv2(gdiff,[1 1;1 1]);       % Convolution of the double image for brightening the edges.
gdiff=imadjust(gdiff,[0.5 0.7],[0 1],0.1); % Intensity scaling between the range 0 to 1.
B=logical(gdiff);                   % Conversion of the class from double to binary. 
% Eliminating the possible horizontal lines from the output image of regiongrow
% that could be edges of license plate.
er=imerode(B,strel('line',50,0));
out1=imsubtract(B,er);
% Filling all the regions of the image.
F=imfill(out1,'holes');
% Thinning the image to ensure character isolation.
H=bwmorph(F,'thin',1);
H=imerode(H,strel('line',3,90));
% Selecting all the regions that are of pixel area more than 100.
final=bwareaopen(H,100);

