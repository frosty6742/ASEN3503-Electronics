%% Record the Due's serial output to the log read by aliasing_fft.m
% Close the Arduino IDE Serial Monitor first: only one program can have
% the port open at a time.

port = '/dev/ttyACM0';
baud = 57600;               % must match Serial.begin in the sketch
captureTime_s = 30;
logFile = 'aliasing.log';

scriptDir = fileparts(mfilename('fullpath'));


%% Capture

s = serialport(port, baud);
pause(2);                   % opening the port can reset the Due
flush(s);

data = uint8([]);
tic
while toc < captureTime_s
    if s.NumBytesAvailable > 0
        data = [data, read(s, s.NumBytesAvailable, 'uint8')]; %#ok<AGROW>
    end
    pause(0.01);
end
elapsed = toc;
clear s                     % releases the port


%% Save the log and report the sample rate to use for Fs

fid = fopen(fullfile(scriptDir, logFile), 'wb');
fwrite(fid, data, 'uint8');
fclose(fid);

nSamples = sum(data == 10) - 1;   % newline count, less the partial first line
fprintf('Saved %d samples in %.1f s to %s\n', nSamples, elapsed, logFile);
fprintf('Fs = %.1f Hz\n', nSamples/elapsed);
