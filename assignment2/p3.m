%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% converts images (of a car, truck and van) to chain code
% where where each number in the chain code string corresponds
% to 1 of 8 directions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read in image
th = 0.5;
I = im2bw(imread('car.jpg'),th);
figure; imshow(I);
%%
% extract the main component of image (car/truck/van) and remove
% other small objects
pixels = 8;     % smaller than 8 pixels
BW2 = bwareaopen(I,pixels); 
figure; imshow(BW2);

%% 
% trace outline of image
B = bwtraceboundary(BW2,[196,531],'N');
figure; imshow(B);
figure; imshow('blobs.png');
BW = imread('blobs.png');
imshow(BW,[]);
s=size(BW);
for row = 2:55:s(1)
   for col=1:s(2)
      if BW(row,col),
         break;
      end
   end

   contour = bwtraceboundary(BW, [row, col], 'W', 8, 50,...
                                   'counterclockwise');
   if(~isempty(contour))
      hold on;
      plot(contour(:,2),contour(:,1),'g','LineWidth',2);
      hold on;
      plot(col, row,'gx','LineWidth',2);
   else
      hold on; plot(col, row,'rx','LineWidth',2);
   end
end
