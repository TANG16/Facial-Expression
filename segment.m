%function to segment the image given to 2x2 grid of size 128x128 each
function segment(row,column,I)
row=0;
column=0;
 
%for loop for the segmentation of row grid
for i=1:2
    %for loop for the segmention of column grid
    for j=1:2
        %new array to save the segmented image
        %leaf_segment is a 4-D image array (X,Y,indexi,indexj)
        I_segment(:,:,i,j)=I(row+1:row+128,column+1:column+128);
        column=column+128;
    end
    %reset the column and row values
    column=0;
    row=row+128;
end

%for loop to show the segmented images
for i=1:2
    for j=1:2
        %figure;
        %imshow(I_segment(:,:,i,j));
        
    end
end

%save the 4-D segmented leaf array
save I_segment;
