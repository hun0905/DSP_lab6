
%%
%% Note that you have to fill the "???" parts by yourself before running the codes
%% You also can modify the codes to meet your applications
%%
%%
%% Clear and close everything
clear all;
fclose('all');
% Check if serial port object or any communication interface object exists
serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end
clc;
clear all;
close all;
%% ---------- Serial port setting ----------
s1 = serial('COM6');  % Construct serial port object
s1.BaudRate =115200;     % Define baud rate of the serial port
fopen(s1); % Connect the serial port object to the serial port

%% ---------- Sampling setting ----------
NSample = 1000; % Number of sampling points, i.e., number of data points to acquire
fs = 500; % Sampling rate, check the setting in Arduino 

%% ---------- Display buffer setting ----------
display_length = 1000; % Display buffer length 
display_buffer = nan(1, display_length); % Display buffer is a first in first out queue
time_axis =(0:display_length-1)*(1/fs); % Time axis of the display buffer
% Initialize figure object
figure
h_plot = plot(nan,nan);
hold off 
tic
for i = 1:NSample
    data = fscanf(s1); % Read from Arduino
    data = str2double(data);
    disp(data);

    % Add data to display buffer
    if i <= display_length
        display_buffer(i) = data;
    else
        display_buffer = [display_buffer(2:end) data]; % first in first out
    end

    % Update figure plot
    set(h_plot, 'xdata', time_axis, 'ydata', display_buffer)
    %title('test');
    xlabel('Time(sec)');
    %ylabel('Quantized value');
    ylabel('Amplitude');
    drawnow;
end
toc
fclose(s1);
% Disconnect the serial port object from the serial port
display_buffer(1)=0;

saveas(gcf,'waveform_nofilterHz','png');
Magnitude = fftshift(abs(fft(display_buffer)));
%save('display_buffer_nofilter.mat','display_buffer')
%save('Magnitude_nofilter.mat','Magnitude')
f = fs*(0:display_length-1)/display_length;
plot(f-fs/2,Magnitude)
%xlim([-250 250])
xlabel('frequency(Hz)');
ylabel('magnitude');
saveas(gcf,'FFT_nofilterHz','png');
