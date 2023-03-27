%% Read video frames from the ball.avi file.
clc;clear;close all;

videoFReader = vision.VideoFileReader('a12.mp4',...
    'VideoOutputDataType','double');

%% Play the video file using the video player
%  Retrieve the screen size in pixels
r = groot;
scrPos = r.ScreenSize;
%  Size/position is always a 4-element vector: [x0 y0 dx dy]
dx = scrPos(3); dy = scrPos(4);

videoPlayer = vision.VideoPlayer('Position',[dx/8, dy/8, dx*(3/4), dy*(3/4)]);

%% Create a AlphaBlender object to highlight the detected object in the
% original video frame.
alphaBlender = vision.AlphaBlender;
alphaBlender.Operation = 'Highlight selected pixels';

pedestrianDetector = vision.PeopleDetector;
%%
while ~isDone(videoFReader)
    
videoFrame = videoFReader();

[bbox,score]= pedestrianDetector(videoFrame);

if ~isempty(bbox)
detectedImg = insertObjectAnnotation(videoFrame, 'rectangle', bbox, score);
videoPlayer(detectedImg);
else
    videoPlayer(videoFrame);
end

end
