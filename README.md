# License-Plate-Detection
Detects the car License plate and segment characters by morphological operations
![License Plate Detection & Segmentation](https://github.com/earthat/License-Plate-Detection/raw/master/Images/characters%20of%20license%20plate.png)

_**step 1**_
Convert the image into gray color and take DWT transform of gray colored image

_**step 2**_
Use sobel edge detcetion of vertical component of DWT transformed image

_**step 3**_
apply imclose, imopen morphological operations with strcutural co-efficient like
```matlab
se=strel('rectangle',[20,30]);
eroded=imdilate(edgy,se);
eroded=imclose(edgy,se);
se=strel('disk',10);
eroded=imopen(eroded,se);
```
_**step 4**_
Use bounding box method to extract all possible bounding boxes and below condition to select the bounding box of license plate only
```matlab
dim(jj)=BB(jj).BoundingBox(3)/BB(jj).BoundingBox(4);
if dim(jj)>4
end
```
BoundingBox(3)= height
BoundingBox(4)= width

![Detected License Plate](https://github.com/earthat/License-Plate-Detection/blob/master/Images/Detceted%20number%20plate.png)

**For more details visit https://free-thesis.com/product/license-plate-detection-segmentation/**
