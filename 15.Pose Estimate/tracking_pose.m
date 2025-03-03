%%



%% Setting YOLOv4 
yolov4Detector = yolov4ObjectDetector("csp-darknet53-coco");
keyPtDetector = hrnetObjectKeypointDetector('human-full-body-w48');
keyPtDetector.Threshold = 0.2;

%% Video Reader
%reader = VideoReader("atrium.mp4");
reader = VideoReader("test01.mp4");
tracker = trackerGNN(MaxNumSensors=1,MaxNumTracks=10);
tracker.ConfirmationThreshold = [2 5];
tracker.DeletionThreshold = [23 23];

frameRate = reader.FrameRate;
frameSize = [reader.Width reader.Height];
tracker.FilterInitializationFcn = @(detection)initvisionbboxkf(detection,FrameRate=frameRate,FrameSize=frameSize);

%% 
skipFrame = 2;
detectionThreshold = 0.5;
minDetectionSize = [5 5];

%player = vision.VideoPlayer(Position=[20 400 700 400]);
player = vision.VideoPlayer(Position=[10 10 1300 680]);

%% Tracking Loop
frameCount = 0;
numFrames = reader.NumFrames;
% Track multiple people and estimate their body poses throughout the input video.
while hasFrame(reader)
    frame = readFrame(reader);
    frameCount = frameCount + 1;

    % Step 1: Detect people and predict bounding box.
    bboxes = helperDetectObjects(yolov4Detector,frame,detectionThreshold,frameCount,skipFrame,minDetectionSize);
    
    %if ~isempty(bboxes)
        % Step2: Track people across video frames.
        [trackBboxes,labels] = helperTrackBoundingBoxes(tracker,reader.FrameRate,frameCount,bboxes);

        % Step 3: Detect keypoints of tracked people.
        [keypoints,validity] = helperDetectKeypointsUsingHRNet(frame,keyPtDetector,trackBboxes);

        % Step 4: Display tracked people and their body pose.
        frame = helperDisplayResults(frame,keyPtDetector.KeypointConnections,keypoints,validity,trackBboxes,labels,frameCount);
    %else
        %frame = frame;
    %end
    
    % Display video
    player(frame);
end

%% Support Function

function box = helperDetectObjects(yolov4Det,frame,detectionThreshold,frameCount,skipFrame,minDetectionSize)
if mod(frameCount,skipFrame) == 0
    [box,~,class] = detect(yolov4Det,frame,Threshold=detectionThreshold, ...
        MinSize=minDetectionSize);
    box = box(class=="person",:);
    if isempty(box)
        box = [];
    end
else
    box = [];
end
end

function [boxes,labels] = helperTrackBoundingBoxes(tracker,frameRate,frameCount,boxes)

% Convert bounding boxes into the objectDetection format.
thisFrameBboxes = boxes;
numMeasurementsInFrame = size(thisFrameBboxes,1);
detectionsInFrame = cell(numMeasurementsInFrame,1);
for detCount = 1:numMeasurementsInFrame
    detectionsInFrame{detCount} = objectDetection( ...
        frameCount*frameRate, ...                % Use frame count as time
        thisFrameBboxes(detCount,:), ...         % Use bounding box as measurement in pixels
        MeasurementNoise=diag([25 25 25 25]) ... % Bounding box measurement noise in pixels
        );
end

% Update the tracker.
if isLocked(tracker) || ~isempty(detectionsInFrame)
    tracks = tracker(detectionsInFrame,frameCount*frameRate);
else
    tracks = objectTrack.empty;
end
positionSelector = [1 0 0 0 0 0 0 0; 0 0 1 0 0 0 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 1 0];
boxes = getTrackPositions(tracks,positionSelector);
ids = [tracks.TrackID];
isCoasted = [tracks.IsCoasted];

% Customize labels to show when a track was not corrected with any measurement and is coasted
labels = arrayfun(@(a)num2str(a),ids,"uni",0);
isPredicted = cell(size(labels));
isPredicted(isCoasted) = {'predicted'};
labels = strcat(labels,isPredicted);
end

function [keypoints,validity] = helperDetectKeypointsUsingHRNet(frame,keyPtDet,boxes)
if ~isempty(boxes)
    if ~any(boxes<=0,"all")
        [keypoints,~,validity] = detect(keyPtDet,frame,boxes);
    else
        keypoints = [];
        validity = [];
    end
else
    keypoints = [];
    validity = [];
end
end

function frame = helperDisplayResults(frame,keypointConnections,keypoints,validity,boxes,labels,frameCount)

% Draw keypoints and their connection.
if ~isempty(validity)
    frame = insertObjectKeypoints(frame,keypoints,"KeypointVisibility",validity, ...
        Connections=keypointConnections,ConnectionColor="green", ...
        KeypointColor="yellow",LineWidth=4);
    % Draw the bounding boxes in the frame.
    frame = insertObjectAnnotation(frame,"rectangle",boxes,labels, ...
        TextBoxOpacity=0.5,LineWidth =4);
    % Add frame count on the top right corner.
    frame = insertText(frame,[0 0],"Frame: "+int2str(frameCount), ...
        BoxColor="black",TextColor="yellow",BoxOpacity=1);
end
end