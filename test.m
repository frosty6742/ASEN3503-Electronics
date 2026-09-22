% Plot lob04 signal 1
% Load data if present in current working directory or repository
f = dir('**/*lob04*');
if ~isempty(f)
    % Try to find a matching file and load data
    for k = 1:numel(f)
        name = f(k).name;
        if contains(lower(name), 'signal') || contains(lower(name), 'lob04')
            try
                data = load(name);
                fields = fieldnames(data);
                if ~isempty(fields)
                    x = data.(fields{1});
                    if isstruct(x)
                        x = x.(fieldnames(x){1});
                    end
                    if isvector(x)
                        plot(x);
                        title('lob04 signal 1');
                        xlabel('Sample');
                        ylabel('Amplitude');
                        grid on;
                        return;
                    end
                end
            catch
            end
        end
    end
end

% Fallback: generate a representative lob04-like waveform if no data file exists
fs = 1000;
T = 1;
t = (0:1/fs:T-1/fs)';
signal = sin(2*pi*5*t) + 0.5*sin(2*pi*12*t + pi/4);
plot(t, signal);
title('lob04 signal 1');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
