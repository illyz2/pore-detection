clc
close all
clear all
RGB=imread('color2.jpg');

 RGB=imresize(RGB,[512 512]);
  figure
  imshow(RGB)
% I=rgb2gray(RGB); % convert the image to grey 
% YCbCr = rgb2ycbcr(RGB); %convert the image to YCbCr
I = RGB(:,:,3);
figure
imshow(I)
I = adapthisteq(I);
figure
imshow(I)
axis on
% I=imgaussfilt(I,4);
% figure
% imshow(I)
%improfile()
BW = I<90;
figure
imshow(BW)


BW2 = bwmorph(BW,'majority',Inf);
%  BW2 = bwpropfilt(BW,'Perimeter',15);
figure
imshow(BW2)
L = bwlabel(BW2);
% figure
% imshow(L,[])
coloredLabels = label2rgb (L, 'hsv', 'k', 'shuffle');
figure
imshow(coloredLabels)
blobMeasurements = regionprops(L, I, 'all');
numberOfBlobs = size(blobMeasurements, 1);
figure
imshow(I);
title('Outlines, from bwboundaries()', 'FontSize', 12); 
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
boundaries = bwboundaries(BW2,'noholes');
numberOfBoundaries = size(boundaries,1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'b', 'LineWidth', 1);
end
hold off;
blobECD = zeros(1, numberOfBlobs);
% Print header line in the command window.
fprintf(1,'Blob #      Mean Intensity  Area   Perimeter    Centroid       Diameter circularity\n');
% Loop over all blobs printing their measurements to the command window.
for k = 1 : numberOfBlobs           % Loop through all blobs.
	% Find the mean of each blob.  (R2008a has a better way where you can pass the original image
	% directly into regionprops.  The way below works for all versions including earlier versions.)
	thisBlobsPixels = blobMeasurements(k).PixelIdxList;  % Get list of pixels in current blob.
	meanGL = mean(I(thisBlobsPixels)); % Find mean intensity (in original image!)
%  	mean = blobMeasurements(k).MeanIntensity; % Mean again, but only for version >= R2008a
	blobArea = blobMeasurements(k).Area;		% Get area.
	blobPerimeter = blobMeasurements(k).Perimeter;		% Get perimeter.
    perim(k)=blobPerimeter;
	blobCentroid = blobMeasurements(k).Centroid;		% Get centroid one at a time
	blobECD(k) = sqrt(4 * blobArea / pi);					% Compute ECD - Equivalent Circular Diameter.
   
    circularity(k)=(blobMeasurements(k).Perimeter^2)/(4*pi*blobMeasurements(k).Area); %Get circularity
   
%     if circularity(k)<2
	fprintf(1,'#%2d %17.1f %11.1f %8.1f %8.1f %8.1f % 8.1f % 8.1f\n', k, meanGL, blobArea, blobPerimeter, blobCentroid, blobECD(k),circularity(k));
	% Put the "blob number" labels on the "boundaries" grayscale image.
	text(blobCentroid(1) + (2), blobCentroid(2), num2str(k), 'FontSize', 8, 'FontWeight', 'Bold');
    
end


blobMeasurements = regionprops(L,I,'all');
numberOfBlobs = size(blobMeasurements, 1);
figure
imshow(I);
title('Outlines, from bwboundaries()', 'FontSize', 10); 
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
hold on;
boundaries = bwboundaries(BW2,'noholes');
numberOfBoundaries = size(boundaries,1);
for i=1:numberOfBoundaries
    if perim(i)<116  %&& blobPerimeter<160
      thisBoundary = boundaries{i};
      plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 1);
    end
end
hold off;
%-----------------------------------------------------------------------


