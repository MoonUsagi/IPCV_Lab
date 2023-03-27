%%
cap = webcam(1);
player = vision.DeployableVideoPlayer();
image = cap.snapshot();
step(player, image);

%%
while player.isOpen()
    
    image = cap.snapshot();
    
    image = cat(3,image(:,:,3),image(:,:,2),image(:,:,1));
    [bboxes, scores, labels] = detect(yolov2Detector, image);
    text = [labels,':',scores];
    detectedImg = insertObjectAnnotation(videoFrame, 'rectangle', bbox, score);
    videoPlayer(detectedImg);
end
