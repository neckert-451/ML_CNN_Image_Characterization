%%This code actually works
%%This code is a neural network that works to determine the difference
%%between cracks, inclusions, and matrices in images

clear;

categories = {'Cracks', 'Inclusions'};
rootFolder = 'C:\Users\nbtar\Documents\MSE 490\Training Data';
imds = imageDatastore(fullfile(rootFolder, categories), ...
    'LabelSource', 'foldernames');

%%Specify training and validation sets by randomly dividing the data for training and validation
Q = 225;
trainRatio = 0.7;
valRatio = 0.15;
testRatio = 0.15;
[imdsTrain, imdsValidation, imdsTest] = dividerand(Q,trainRatio,valRatio,testRatio);

%%The following architecture is defining layers
varSize = 64;
conv1 = convolution2dLayer(13,varSize,'Padding',2,'BiasLearnRateFactor',2);
conv1.Weights = gpuArray(single(randn([13 13 3 varSize])*0.0001));
fc1 = fullyConnectedLayer(1,'BiasLearnRateFactor',2);
fc1.Weights = gpuArray(single(randn([1 128])*0.1));
fc2 = fullyConnectedLayer(2,'BiasLearnRateFactor',2);  %2 = number of classes we are analyzing
fc2.Weights = gpuArray(single(randn([2 1])*0.1));      %2 = number of classe we are analyzing

layers = [
    imageInputLayer([varSize varSize 3]);               %imageInputLayer inputs 2-D images to a network and applies data normalization
    conv1;                                              %from the convl function above
    batchNormalizationLayer;                            %normalizes the activations and gradients in the network- optimizes the training
    reluLayer();                                        %nonlinear activation function
    maxPooling2dLayer(11,'Stride',2);                   %down-sampling operation 
    reluLayer();
    convolution2dLayer(13,64,'Padding',2,'BiasLearnRateFactor',2);
    reluLayer();
    averagePooling2dLayer(3,'Stride',2);    
    convolution2dLayer(7,128,'Padding',2,'BiasLearnRateFactor',2);
    reluLayer();
    averagePooling2dLayer(5,'Stride',2);
    fc1;
    reluLayer();
    fc2;
    softmaxLayer()
    classificationLayer()];

%%Defining training options
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.001, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 20, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 80, ...
    'MiniBatchSize', 80, ...
    'ValidationData', imdsValidation, ...
    'ValidationFrequency', 10, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

%%One line code to train the network
[net, info] = trainNetwork(imdsTrain, layers, options);

%%Classify validation images and compute accuracy
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)

labels = classify(net, imdsTest);
ii = randi(100);
im = imread(imdsTest.Files{ii});
imshow(im);
if labels(ii) == imdsTest.Labels(ii)
   colorText = 'b'; 
else
    colorText = 'r';
end
title(char(labels(ii)),'Color',colorText);

% This could take a while if you are not using a GPU
confMat = confusionmat(imdsTest.Labels, labels);
confMat = confMat./sum(confMat,2);
mean(diag(confMat))