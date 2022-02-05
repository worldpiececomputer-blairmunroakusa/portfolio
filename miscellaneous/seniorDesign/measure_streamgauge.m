%% initialize
close all
clear all

%% setup
% set blob detection threshold
threshold = 0.2;
% load setup data
load( 'user_setup_folder/setup_data.mat' )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load in calibration data here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% user input: number of photos in batch
prompt = { 'Please enter the number of images to process:' };
N = inputdlg( prompt );
N = str2double( N{1} );
n = 1:N;

%% intake and crop images
% get image names
files = dir('newImages_IN/*JPG');
Filename = char({files.name});
Filename = strcat('newImages_IN/',Filename);
% preallocate
imagesFull = cell( size(n) );
imagesCropped = cell( size(n) );
imagesColorSample = cell( size(n) );
imagesThreshold = cell( size(n));
imagesEroded = cell( size(n) );
imagesFinal = cell( size(n) );
color = cell( size(n) );
colorDist = cell( size(n) );
measuresTrivial = zeros( size(n) );
% read and crop images
for i = n
    imagesFull{i} = imread(Filename(i,:));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate extrinsics here
    % remove distortion here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imagesCropped{i} = imcrop( imagesFull{i}, rectBigCrop ); 
	imagesColorSample{i} = imcrop( imagesCropped{i}, rectColorCrop );  
end
% read in timestamp data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% camera timestamp data goes in here
% these below are the timestamps read manually from images' bottom edge
% metaTimes = [{'09:00'}    {'10:00'}    {'10:45'}    {'17:30'} ...
%              {'12:45'}    {'15:00'}    {'15:00'}    {'16:45'}    {'14:00'}];
% metaDates = [{'1/30/18'}    {'1/30/18'}    {'1/30/18'}    {'1/30/18'} ...
%              {'1/31/18'}    {'1/31/18'}    {'2/01/18'}    {'2/01/18'}    {'2/02/18'}];
% metaStamp = [{'1/30/18 09:00'}    {'1/30/18 10:00'}    {'1/30/18 10:45'} ...
%              {'1/30/18 17:30'}    {'1/31/18 12:45'}    {'1/31/18 15:00'} ...
%              {'2/01/18 15:00'}    {'2/01/18 16:45'}    {'2/02/18 14:00'}];
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% detect blobs
for i = n
    % get rectangle average color
	color{i} = mean( imagesColorSample{i} );
	color{i} = mean( color{i} );
	color{i} = round( color{i} );
	color{i} = uint8( color{i} );
	color{i} = repmat( color{i}, [size( imagesCropped{i}, 1 ), size( imagesCropped{i}, 2 ), 1] );
    % pixel color distance from average color (this finds the rectangle)
	imagesCropped{i} = im2double( imagesCropped{i} );
	color{i} = im2double( color{i} );
    % simple distance function
	colorDist{i} =  sqrt(( imagesCropped{i}(:,:,1) - color{i}(:,:,1) ).^2 + ...
                         ( imagesCropped{i}(:,:,2) - color{i}(:,:,2) ).^2 + ...
                         ( imagesCropped{i}(:,:,3) - color{i}(:,:,3) ).^2   ) ;
    % compare color distance to threshold, binary matrix output
	imagesThreshold{i} = colorDist{i} < threshold;
end

%% condition blobs
pix = zeros( size(n) );
% erode blob
for i = n
    % if results are inaccurate, vector in strel() may need to be adjusted
    structureElement = strel( 'rectangle', [1,4] );
    imagesEroded{i} = imerode( imagesThreshold{i}, structureElement );
    pix(i) = sum( sum(imagesEroded{i}) );
end
% reshape and fill blob
Pixels = min(pix) - round(totalLengthPix);
for i = n
   imagesFinal{i} = bwareaopen( imagesEroded{i}, Pixels, 4 );
   imagesFinal{i} = imfill( imagesFinal{i}, 'holes' );
end

%% compute measurement
for i = n
    M = size(imagesFinal{i});
% find top of blob
j = 0;
test = 0;
while 1
    j = j + 1;
    if j > M(1)
        measureA = totalLengthPix;
        break
    end
    if test == 1
        break
    end
    for k = 1 : M(2)
        if imagesFinal{i}(j,k) == 1
            test = 1;
        end
    end
end
measureA = j;
% find bottom of blob
j = M(1) + 1;
test = 0;
while 1
    j = j - 1;
    if j < 1
        measureB = totalLengthPix;
        break
    end
    if test == 1
        break
    end
    for k = 1 : M(2)
        if imagesFinal{i}(j,k) == 1
            test = 1;
        end
    end
end
    measureB = j;
% calculate distance
measuresTrivial(i) = measureB - measureA;
end

%% demo timestamp metadata
% had to generate manually due to absence of timestamp data in image files
hour = 10;
timestamps = cell(size(n));
for i = n
minute = mod(45 + 15*(i-1),60);
    if minute == 0
    hour = hour + 1;
    end
hourstr = num2str(hour);
minstr = num2str(minute);
    if minstr == '0'
    minstr = '00';
    end
timestamps{i} = strcat('1/22___',' ',hourstr,':',minstr);
end

%% plot
% convert pixels to feet
plotmeasures = totalLengthPix - measuresTrivial;
pixPerInch = totalLengthPix/totalLength;
pixPerFoot = pixPerInch*12;
plotmeasuresft = plotmeasures/pixPerFoot;
ERRORft = ERROR/pixPerFoot;

% y axis labels in feet and inches
y = -6:1:totalLength;
Y = zeros(size(y));
Ystr  =cell(size(y));
    Ystr{1} = num2str(-0.5);
    Ystr{7} = '0';
j = 0.5;
for i = 1:y(end)
    if mod(i,6) == 0
    Ystr{i+7} = num2str(j);
    j = j + 0.5;
    end
end
% display
figure( 'Name', 'waterlevel measurements' )
yyaxis left
errorbar( n, plotmeasuresft, ERRORft*ones(size(n)) )
xlim( [ (n(1)-1) (n(end)+1) ] )
xticks( n )
xticklabels( timestamps );
xtickangle( 60 )
grid on
title( 'Timeseries of measured water levels','Fontsize',24 )
xlabel( 'time and date','Fontsize',14 )
ylabel( 'waterlevel, ft','Fontsize',14 )
ylim([-0.5,totalLength/12])
yticks( y/12 )
yticklabels( Ystr )
yyaxis right
ylabel('exposed pixels','Fontsize',14)
set ( gca, 'ydir', 'reverse' )
ylim([0 (totalLength+6)/12*round(pixPerFoot)])
hold on
% horizontal grid lines in feet and inches
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*0*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*1*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*1.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*2*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*2.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*3*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*3.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*4*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*4.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*5*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*5.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*6*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*6.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*7*round(pixPerFoot),'--','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*7.5*round(pixPerFoot),':','Color',[0 0.447 0.741])
plot(n(1)-1:n(end)+1,ones(size(n(1)-1:n(end)+1))*8*round(pixPerFoot),'--','Color',[0 0.447 0.741])
