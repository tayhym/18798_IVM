clear all; close all;
% Input frames with VideoReader

inputObj = VideoReader('SAM_0562.MP4');
nFrames = inputObj.NumberOfFrames;

% Set up output video with VideoWriter
workingDir = pwd;
outputVideo = VideoWriter(fullfile(workingDir,'output_mei.avi'));
outputVideo.FrameRate = inputObj.FrameRate;
open(outputVideo);

first_frame = rgb2gray(imresize(read(inputObj,1),0.1));
background = first_frame;
foreground = zeros(size(background));
% Display and write frames
for k = 2 :3:nFrames
    fprintf('frame %.f\n',k);
    my_rgb_frame = rgb2gray(imresize(read(inputObj, k),0.1));
    
    diff = abs(my_rgb_frame - background);
    thres = 10;
    for i=1:size(my_rgb_frame,1)
        for j=1:size(my_rgb_frame,2)
            % MEI is uses grayscale
            if (diff(i,j)>0)
                 background(i,j) = background(i,j) + 1;
            else
                 background(i,j) = background(i,j) - 1;
            end
            
            
            if (diff(i,j) > thres)
                % motion energy (set to 1)
                foreground(i,j) = 255;
%             else
%                 foreground(i,j) = 0;
            end 
        end 
    end 
    figure(1), imshow(uint8(foreground));
    writeVideo(outputVideo, uint8(foreground));
end
save('MEI.mat','foreground');
close(outputVideo);
