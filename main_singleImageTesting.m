%% this is the first part of the work which is locating the number plate in
% the image and seprating the charactaers in number plate. Extracted number
% plates are also stored in the directory 'noplate'.

% *Note* - not all number plates and characters in the plate can be located
% well. For CNN work, will remove the files which are not detceted
% properly.

%%
% close all
% clear
% clc
%%
% addpath(genpath(cd))
[imgname,dirpath]=uigetfile('*','Select image');     % select the directory of input images

%%
scale=2;

% for ii=3
img=imread([dirpath,'/',imgname]);
img=imresize(img,1/scale);
% figure(1), imshow(img)


%%
% convert to gray image
grayimg=rgb2gray(img);
% figure(2),imshow(grayimg)
grayimg=medfilt2(grayimg,[4,4]);
[cA,cH,cV,cD]=dwt2(grayimg,'haar');  % apply wavelet transform

%%
edgy=edge(cV,'sobel');              %edge detetion for vertical component of DWT
% figure(3),imshow(edgy)
%% Morpjologcal operations
se=strel('rectangle',[20,30]);
eroded=imdilate(edgy,se);
eroded=imclose(edgy,se);
se=strel('disk',10);
eroded=imopen(eroded,se);
% figure(4),imshow(eroded)

%% detecting the number plate based on bounding box and width/height ratio
% figure,    imshow(img)
BB=regionprops(eroded,'BoundingBox');
cnt=1;
for jj=1:numel(BB)
    
    dim(jj)=BB(jj).BoundingBox(3)/BB(jj).BoundingBox(4);
    if dim(jj)>4
        BBno(cnt)=jj;
        [BB10]=BB(jj).BoundingBox;
        BBnew(cnt,:)=scale.*BB10;
%         rectangle('Position',BBnew(cnt,:),'EdgeColor','r')
        cnt=cnt+1;
    end
    
    
end
%condition to check if no bounding box has ratio greater than 4 then
%chose maximum ratio bounding box
if ~exist('BBno','var')
    [~,ind]=max(dim);
    BBno=ind;
    [BB10]=BB(ind).BoundingBox;
    BBnew=scale.*BB10;
%     rectangle('Position',BBnew,'EdgeColor','r')
end

%% crop the image to seprate the number plate and locate numbers in plate
for pp=1:numel(BBno)
    cropedimg=imcrop(img,BBnew(pp,:));
    figure,imshow(cropedimg)
    final=extractChar(cropedimg);
    Iprops=regionprops(final,'BoundingBox','Image');
    % figure,imshow(final)
    plateBB=regionprops(final,'BoundingBox');
    cnt=1;
    for kk=1:numel(plateBB)
        box{pp}(cnt,:)=plateBB(kk).BoundingBox;
        ratio(kk)=plateBB(kk).BoundingBox(3)/plateBB(kk).BoundingBox(4);
        if ratio(kk)<1
            rectangle('Position',box{pp}(cnt,:),'EdgeColor','r')
            cnt=cnt+1;
        end
    end
       
end




