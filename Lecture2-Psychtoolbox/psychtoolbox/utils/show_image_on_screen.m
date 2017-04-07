function timePtr = show_image_on_screen(fn_image, windowPtr, timePtr_prev, duration, bkgcolor)
%SHOW_IMAGE_ON_SCREEN is a function to show image on a screen
%  fn_image      : fullpath of image
%  windowPtr     : pointer of window
%  timePtr_prev  : pointer of time stamp 
%  duration      : duration of presentation
%  bkgcolor      : background color
%  
%  Example)
%    fn_image = '/Users/skyeong/fix.png';
%    [windowPtr, windowRect] = PsychImaging('OpenWindow', 0, gray);
%    duration = 3;  % to show image for 3 second
%    SHOW_IMAGE_ON_SCREEN(fn_image, windowPtr, [], duration);
%    
%    This function works with two input arguments without duration.
%    SHOW_IMAGE_ON_SCREEN(fn_image, windowPtr);


% Read image file
if nargin<3, timePtr_prev = GetSecs; end;
if nargin<4, duration=[]; end;
if nargin<5,
    imageData = imread(fn_image);
else
%     try
        imageData = imread(fn_image,'BackgroundColor',bkgcolor);
%     catch
%         imageData = imread(fn_image);
%     end
end

% [w,h] = size(imageData);
% screens = Screen('Screens');
% screenNumber = max(screens);
% [width, height]=Screen('WindowSize',screenNumber);
% if w~=width || h~=height,
%     [Xq,Yq] = meshgrid(1:width,1:height);
%     imageData2 = zeros(height,width,size(imageData,3));
%     for i=1:size(imageData,3),
%         Vq = interp2(single(imageData(:,:,i)),Xq,Yq,'cubic');
%         imageData2(:,:,i) = double(Vq);
%     end
%     imageData = imageData2;
% end

% Make the image into a texture
imageTexture = Screen('MakeTexture', windowPtr, imageData);

% Draw image into buffer
Screen('DrawTexture', windowPtr, imageTexture, [], [], 0);

% Show image on screen
Screen('Flip', windowPtr);


% Duration of visual stimulation
if ~isempty(duration),
    WaitSecs('UntilTime',timePtr_prev + duration);
end

% Update time stamp
timePtr = timePtr_prev + duration;
