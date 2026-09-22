%time domain plots
signalNumber = 3;

scriptDir = fileparts(mfilename('fullpath'));
fig_dir = fullfile(scriptDir, 'figures'); 
A = load(fullfile(scriptDir, sprintf('lab04_analysis_signal%d.mat', signalNumber)));

s = settings;
s.matlab.appearance.figure.GraphicsTheme.TemporaryValue = "light";


fs = A.Fs;
%samples =  100;
samples =  length(A.x);


plot(A.t(1:samples), A.x(1:samples));
title(sprintf('Lab04 signal %d', signalNumber));
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
saveas(gcf, fullfile(fig_dir, sprintf('Lab04_signal%d_timedomain.png', signalNumber)));

