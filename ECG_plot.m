
%%
%% Note that you have to fill the "???" parts by yourself before running the codes
%% You also can modify the codes to meet your applications
%%
%%


%% ---------- Sampling setting ----------
NSample = 1000; % Number of sampling points, i.e., number of data points to acquire
fs = load('ECG.mat').Fs; % Sampling rate, check the setting in Arduino 

%% ---------- Display buffer setting ----------
%display_length = 15000; % Display buffer length 
display_length = 1507-375+1;
ECG = load('ECG.mat').ECG(1:1507-374)
time_axis =(0:display_length-1)*(1/fs); % Time axis of the display buffer
figure
plot(time_axis,ECG)


saveas(gcf,'waveform','png');
Magnitude = fftshift(abs(fft(ECG)));
f = fs*(0:display_length-1)/display_length;
plot(f-fs/2,Magnitude)
xlim([-250 250])
xlabel('frequency');
ylabel('magnitude');
saveas(gcf,'FFT','png');
