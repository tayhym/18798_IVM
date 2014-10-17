% p5.m does mean shift alogrithm to track, using the green color
% to track primarily (mean-shift on intensity alone is supposed
% to work well as well)

clear all; close all;
% Input frames with VideoReader

inputObj = VideoReader('SAM_0562.MP4');
nFrames = inputObj.NumberOfFrames;

% Set up output video with VideoWriter
workingDir = pwd;
outputVideo = VideoWriter(fullfile(workingDir,'tracking_greens.avi'));
outputVideo.FrameRate = inputObj.FrameRate;
open(outputVideo);

first_frame = imresize(read(inputObj,1),0.1);
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
    my_rgb_frame = imresize(read(inputObj, k),0.1);
    
    error = 10;
    tol = 1;
    while (error>tol) 
        new_mean = 0;
        % compute mean shift vector
            % : get indices of all green points
            % : get mean of indices
            % : compute mean shift vector 
            % : add mean shift vector to initial estimate
            % : recompute until no change in initial estimate
        [green_pts_x, green_pts_y] = find(my_rgb_frame(:,:,2)>0);
        new_mean_x = sum(green_pts_x)/(numel(green_pts_x));
        new_mean_y = sum(green_pts_y)/(numel(green_pts_y));
        error = norm([(x_0-new_mean_x);(y_0-new_mean_y)]);
        x_0=round(new_mean_x); y_0 = round(new_mean_y);
        x_0 
        y_0
    end
    % converged to target
    radius = 5;
%     foreground = insertShape(foreground,'FilledCircle',[x_0,y_0,radius],'Color',{'white'},...
%                  'LineWidth',5);
     a = imread('pout.tif');
     a = insertShape(a,'FilledCircle',[x_0,y_0,radius],'Color',{'white'},...
                 'LineWidth',5);
             figure(2), imshow(uint8(a));
%     figure(1), imshow(uint8(foreground));
    writeVideo(outputVideo, uint8(foreground));
end

close(outputVideo);

