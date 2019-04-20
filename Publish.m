clc;
clear all;
%% Modify the signal as you wish
%required datas:

%enter the file name here
file = 'sweep-2mmta 5cm-5mmta8cm-93hz.txt';
data = dlmread(file);

%exclude the parts where the device is unlocked
data = data(5390:14920);

%medium samples per scan
av_cycle = 300;

%%
av = data;
figure(1)
subplot(4,1,1)
plot(data)
title('raw signal')
% Cleaning and eliminating the DC
for k = 1:length(data)-av_cycle
    av(k) = sum(data(k:k+av_cycle-1))/av_cycle;
end
data = data-av;
data = -1*data;
figure(1)
subplot(4,1,2)
plot(data)
title('Signal without dc')
% Smoothing the signal
av_cycle = 10;
for k = 1:length(data)-av_cycle
    av(k) = sum(data(k:k+av_cycle))/av_cycle;
end
av = av(1:end-10);
data = av;
% denoising and finding the crack
[peaks,locs] = findpeaks(data,'MinPeakDistance',200);
figure(1)
subplot(4,1,3)
plot(data)
hold all
plot(locs,peaks,'x')
title('peaks detected')
image = zeros(length(peaks),2*locs(1));
for i = 1:length(peaks)
    image(i,:) = data(locs(i)-locs(1)+1:locs(i)+locs(1));
end
figure(2)
surf(image)
title('2D of the signals - each test')
[U,S,V] = svd(image);
S_modified = zeros(size(S));
S_modified(1,1) = S(1,1);
image = U*S_modified*V';
figure(3)
surf(image)
title('after applying singular value decomposition')
S = sum(image);
[r,o] = max(S);
figure(1)
subplot(4,1,4)
plot(S)
hold all
plot(o,r,'x')
title('final signal - peak identified')
