clear
close all;

% Parameter Setup
Start_Frequency = 0.1;
End_Frequency   = 200;

Ts = 0.00025;                  % sampling time
End_Time = 10;
L = length(1:(End_Time/Ts));   % length of signal
Fs = 1/Ts;                     % sampling frequency 4[kHz], 4000[Hz]
Fn = Fs/2;                     % nyquist frequency  2[kHz], 2000[Hz]

% Read csv file
M = readmatrix('Chirp.csv');
tarpos = M(1:(End_Time/Ts),5);
actpos = M(1:(End_Time/Ts),4);

% Do fft
x = tarpos';   % input 
y = actpos';   % output
fft_x = fft(x)/L;
fft_y = fft(y)/L;
TF = fft_y./fft_x;
          
Fv = linspace(0, 1, fix(L/2)+1)*Fn;   % Frequency Vector
Iv = 1:length(Fv);                    % Index Vector

% Ploting
subplot(2,1,1)
semilogx(Fv, 20*log10(abs(TF(Iv))))
yline(-3,'r','LineWidth', 2)
yline(0,'k','LineWidth', 2)
subtitle('Magnitude')
xlabel('freq [Hz]')
ylabel('Magnitude [dB]')
xlim([0.1 200])
grid on
subplot(2,1,2)
semilogx(Fv, angle(TF(Iv))*180/pi)
yline(-180,'k','LineWidth', 2)
subtitle('Phase')
xlabel('freq [Hz]')
ylabel('Phase [deg]')
xlim([0.1 200])
grid on
sgtitle('Bode Plot','fontweight','bold','fontsize',16,'color','b');
