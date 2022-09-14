clear
close all;

% Parameter Setup
Start_Frequency = 0.1;
End_Frequency   = 1000;

Ts = 0.00025;                  % sampling time
End_Time = 10;                 % end time
t = 0:Ts:End_Time-Ts;          % time vector
L = length(1:(End_Time/Ts));   % length of signal
Fs = 1/Ts;                     % sampling frequency 4[kHz], 4000[Hz]
Fn = Fs/2;                     % nyquist frequency  2[kHz], 2000[Hz]
NFFT = 2^nextpow2(L);          % next power of 2 from length of signal

% Read csv file
M = readmatrix('new.csv');

tarpos = M(1:(End_Time/Ts),5);
actpos = M(1:(End_Time/Ts),4);

tarvel = M(1:(End_Time/Ts),7);
actvel = M(1:(End_Time/Ts),8);

tartor = M(1:(End_Time/Ts),3);
acttor = M(1:(End_Time/Ts),2);

%% Target & Actual

% % [Position] 
% f1 = figure;
% subplot(2,1,1)
% plot(t,tarpos)
% ylim([-150 150])
% subtitle('target position')
% grid on
% subplot(2,1,2)
% plot(t,actpos)
% ylim([-150 150])
% subtitle('actual position')
% grid on

% % [Velocity] 
% f1 = figure;
% subplot(2,1,1)
% plot(t,tarvel)
% ylim([-150 150])
% subtitle('target velocity')
% grid on
% subplot(2,1,2)
% plot(t,actvel)
% ylim([-150 150])
% subtitle('actual velocity')
% grid on

% [Torque] 
f2 = figure;
subplot(2,1,1)
plot(t,tartor)
ylim([-15 15])
subtitle('target torque')
grid on
subplot(2,1,2)
plot(t,acttor)
ylim([-15 15])
subtitle('actual torque')
grid on

err = tartor-acttor;
rms(err)

%% Do FFT
% % [Position] 
% x = tarpos';      % input 
% y = actpos';      % output
% fft_x = fft(x)/L; % Normalized Fourier Transform Of Data
% fft_y = fft(y)/L; % Normalized Fourier Transform Of Data
% TF = fft_y./fft_x;
%           
% Fv = linspace(0, 1, fix(L/2)+1)*Fn;   % Frequency Vector
% Iv = 1:length(Fv);                    % Index Vector

% % [Velocity] 
% x = tarvel';      % input 
% y = actvel';      % output
% fft_x = fft(x)/L; % Normalized Fourier Transform Of Data
% fft_y = fft(y)/L; % Normalized Fourier Transform Of Data
% TF = fft_y./fft_x;
%           
% Fv = linspace(0, 1, fix(L/2)+1)*Fn;   % Frequency Vector
% Iv = 1:length(Fv);                    % Index Vector

% [Torque] 
x = tartor';           % input 
y = acttor';           % output
fft_x = fft(x,NFFT)/L; % Normalized Fourier Transform Of Data
fft_y = fft(y,NFFT)/L; % Normalized Fourier Transform Of Data
TF = fft_y./fft_x;       
Fv = linspace(0, 1, fix(NFFT/2)+1)*Fn;   % Frequency Vector
Iv = 1:length(Fv);                       % Index Vector

%% Ploting
f4 = figure;

subplot(2,1,1)
semilogx(Fv, 20*log10(abs(TF(Iv))))
yline(-3,'r','LineWidth', 2)
yline(0,'k','LineWidth', 2)
subtitle('Magnitude')
xlabel('freq [Hz]')
ylabel('Magnitude [dB]')
% xlim([0.1 1000])
ylim([-60 60])
grid on

subplot(2,1,2)
semilogx(Fv, angle(TF(Iv))*180/pi)
% yline(-180,'k','LineWidth', 2)
subtitle('Phase')
xlabel('freq [Hz]')
ylabel('Phase [deg]')
% xlim([0.1 1000])
grid on

sgtitle('Bode Plot','fontweight','bold','fontsize',16,'color','b');
