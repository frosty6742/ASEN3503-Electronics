%% FFT/PSD of the A2D samples logged from Aliasing_A2D_tTerm_lab07.ino

logFile = 'aliasing.log';   % from aliasing_capture.m, in the same folder as this script
inputFreq_Hz = 100;        % function generator frequency, for the alias prediction

% The sketch waits 1000 us per loop, but analogRead and Serial.println add
% to that, so the true rate is below 1000 Hz. Measured on the Due at 57600
% baud: 29221 samples in 30.0 s.
Fs = 974;

Vref = 3.3;                 % A2D reference voltage (V)
counts = 4096;              % analogReadResolution(12)

scriptDir = fileparts(mfilename('fullpath'));


%% Read the log

% One integer per line. The first and last lines can be cut off when the
% log starts and stops, so drop them along with anything that isn't a valid
% A2D reading.
lines = readlines(fullfile(scriptDir, logFile));
bin_val = str2double(lines(2:end-1));
isValid = bin_val >= 0 & bin_val < counts & bin_val == round(bin_val);
fprintf('Read %d samples, dropped %d bad lines\n', sum(isValid), sum(~isValid));
bin_val = bin_val(isValid);

% Convert counts to volts and remove the DC offset, since the A2D input
% can't go negative and the offset would otherwise dominate the spectrum.
x = bin_val * Vref / counts;
x = x - mean(x);
N = length(x);


%% Calculate the FFT and PSD (same method as Lab 4)

xdft = fft(x);
xdft = xdft(1:floor(N/2)+1);

psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
psdx_dB = 10*log10(psdx);

freq = (0:floor(N/2))' * Fs/N;


%% Find the dominant peak and compare it to the predicted alias

[pPeak, idx] = max(psdx_dB(2:end));   % ignore DC
fPeak = freq(idx + 1);

fAlias = abs(inputFreq_Hz - Fs*round(inputFreq_Hz/Fs));

fprintf('Fs = %.1f Hz, Nyquist = %.1f Hz\n', Fs, Fs/2);
fprintf('Measured peak: %.2f Hz, %.2f dB(Vrms^2/Hz)\n', fPeak, pPeak);
fprintf('Predicted for a %.1f Hz input: %.2f Hz\n', inputFreq_Hz, fAlias);


%% Plotting

s = settings;
s.matlab.appearance.figure.GraphicsTheme.TemporaryValue = "light";

figure;
plot(freq, psdx_dB)
hold on
plot(fPeak, pPeak, 'o', 'MarkerSize', 7, 'LineWidth', 1.5);
text(fPeak, pPeak, sprintf('  %.1f Hz, %.1f dB', fPeak, pPeak), ...
    'VerticalAlignment', 'bottom');
hold off
grid on
title(sprintf('Periodogram Using FFT (%.1f Hz input, F_s = %.1f Hz)', ...
    inputFreq_Hz, Fs))
xlabel('Frequency (Hz)')
ylabel('Power/Frequency dB(Vrms^2/Hz)')
saveas(gcf, fullfile(scriptDir, sprintf('aliasing_fft_%gHz.png', inputFreq_Hz)));
