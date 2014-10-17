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
foreground = zeros(size(background,1),size(background,2));


% Display and write frames
for k = 1 :1:nFrames
    fprintf('frame %.f\n',k);
    my_rgb_frame = imresize(read(inputObj, k),0.3);
    green_pixels = my_rgb_frame(:,:,2);
    
    % threshold 90% of maximum pixel brightness
    dim_pixels_idx = green_pixels <= 0.9*max(max(green_pixels));
    green_pixels(dim_pixels_idx) = 0;
    
    % color foreground
    foreground(green_pixels>0) = 255;
    figure(1), imshow(uint8(foreground));
    writeVideo(outputVideo, uint8(foreground));
end
close(outputVideo);

