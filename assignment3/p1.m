clear all; close all;
% Input frames with VideoReader

inputObj = VideoReader('SAM_0562.MP4');
nFrames = inputObj.NumberOfFrames;

% Set up output video with VideoWriter
workingDir = pwd;
outputVideo = VideoWriter(fullfile(workingDir,'output_bg.avi'));
outputVideo2 = VideoWriter(fullfile(workingDir,'output_fg.avi'));
outputVideo.FrameRate = inputObj.FrameRate;
outputVideo2.FrameRate = inputObj.FrameRate;
open(outputVideo);
open(outputVideo2);

first_frame = read(inputObj,1);
first_frame = imresize(first_frame,0.2);
background = first_frame;
foreground = zeros(size(background));
% Display and write frames
for k = 2 : round(nFrames/10)
    fprintf('frame %.f\n',k);
    my_rgb_frame = read(inputObj, k);
    my_rgb_frame = imresize(my_rgb_frame,0.2);
    
    diff = abs(my_rgb_frame - background);
    thres = 5;
    for i=1:size(my_rgb_frame,1)
        for j=1:size(my_rgb_frame,2)
            % repeat measurements for 3 layers
            if (diff(i,j,1)>0)
                 background(i,j,1) = background(i,j,1) + 1;
            else
                 background(i,j,1) = background(i,j,1) - 1;
            end
            if (diff(i,j,2)>0)
                 background(i,j,2) = background(i,j,2) + 1;
            else
                 background(i,j,2) = background(i,j,2) - 1;
            end
            if (diff(i,j,3)>0)
                 background(i,j,3) = background(i,j,3) + 1;
            else
                 background(i,j,3) = background(i,j,3) - 1;
            end
            
            
            if (diff(i,j,1) > thres)
                foreground(i,j,1) = my_rgb_frame(i,j,1);
            else
                foreground(i,j,1) = 0;
            end 
            if (diff(i,j,2) > thres)
                foreground(i,j,2) = my_rgb_frame(i,j,2);
            else
                foreground(i,j,2) = 0;
            end 
            if (diff(i,j,3) > thres)
                foreground(i,j,3) = my_rgb_frame(i,j,3);
            else
                foreground(i,j,3) = 0;
            end 
            
        end 
    end 
    figure(1), imshow(uint8(foreground));
    figure(2), imshow(uint8(background));
    writeVideo(outputVideo, uint8(foreground));
    writeVideo(outputVideo2, uint8(background));

end
close(outputVideo);
close(outputVideo2);