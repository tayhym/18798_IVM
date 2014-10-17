% p5.m does mean shift alogrithm to track, using the green color
% to track primarily (mean-shift on intensity alone is supposed
% to work well as well)

clear all; close all;
% Input frames with VideoReader

inputObj = VideoReader('SAM_0562.MP4');
nFrames = inputObj.NumberOfFrames;

% Set up output video with VideoWriter
workingDir = pwd;
outputVideo = VideoWriter(fullfile(workingDir,'finding_greens.avi'));
outputVideo.FrameRate = inputObj.FrameRate;
open(outputVideo);

first_frame = imresize(read(inputObj,1),0.3);
nrows = size(first_frame,1);
ncols = size(first_frame,2);
background = first_frame;
foreground = zeros(size(background));
green_pixels = first_frame(:,:,2);
[~,max_green_indice] = max(green_pixels(:));
[x_0, y_0] = ind2sub(size(first_frame(:,:,2)), max_green_indice);

% Display and write frames
for k = 2 :1:nFrames
    fprintf('frame %.f\n',k);
    my_rgb_frame = imresize(read(inputObj, k),0.3);
    
    search_length = 50;
    error = 10;
    tol = 3;
    while (error>tol) 
        new_mean = 0;
        
        x_min = max(1,x_0-search_length);
        y_min = max(1,y_0-search_length);
        x_max = min(nrows,x_0+search_length);
        y_max = min(ncols,y_0+search_length);
        
        green_all = my_rgb_frame(:,:,2);
        [x_greens, y_greens] = find(green_all(x_min:x_max, y_min:y_max));
        x_new = mean(x_greens);
        y_new = mean(y_greens);
        error = norm([x_new-x_0; y_new-y_0]);
        x_0 = x_new;
        y_0 = y_new;
        
        
        
%         for i=-search_length:search_length
%             for j=-search_length:search_length
%                 if (i<0)
%                     x_s = max(1,x_0+i);
%                 else
%                     x_s = min(nrows,x_0+i);
%                 end 
%                 if (j<0)
%                     y_s = max(1, y_0+j);
%                 else 
%                     y_s = min(ncols,y_0+j);
%                 end 
%                 new_mean = new_mean + ind
        % compute mean shift vector
            % : get indices of all green points in search region
            % : get mean of indices
            % : compute mean shift vector 
            % : add mean shift vector to initial estimate
            % : recompute until no change in initial estimate
%         [green_pts_x, green_pts_y] = find(my_rgb_frame(:,:,2)>0);
%         new_mean_x = sum(green_pts_x)/(numel(green_pts_x));
%         new_mean_y = sum(green_pts_y)/(numel(green_pts_y));
%         error = norm([(x_0-new_mean_x);(y_0-new_mean_y)]);
%         x_0=new_mean_x; y_0 = new_mean_y;
    end
    % converged to target
    radius = 5;
    a = imread('pout.tif');
    a = insertShape(a,'FilledCircle',[x_0,y_0,radius],'Color',{'white'},...
                 'LineWidth',5);
    
    figure(1), imshow(uint8(a));
    writeVideo(outputVideo, uint8(foreground));
end
close(outputVideo);

