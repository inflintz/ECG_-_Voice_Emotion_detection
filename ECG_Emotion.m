ecg = load('ECGdata_s1p10v4.dat'); 

fs = 250; 
low_cutoff = 0.5; 
high_cutoff = 45; 
[b, a] = butter(2, [low_cutoff, high_cutoff] / (fs / 2), 'bandpass');
ecg_filtered = filtfilt(b, a, ecg);
[~, R_locs] = findpeaks(ecg_filtered, 'MinPeakHeight', 0.5, 'MinPeakDistance', round(0.6 * fs));
RR_intervals = diff(R_locs) / fs; 
HR = 60 ./ RR_intervals; 
mean_HR = mean(HR);
std_HR = std(HR);
mean_RR = mean(RR_intervals);
std_RR = std(RR_intervals);

if mean_HR < 75 && std_RR < 0.05
    emotion = 'Calm';
elseif mean_HR >= 75 && mean_HR < 100 && std_RR >= 0.05 && std_RR < 0.1
    emotion = 'Stress';
elseif mean_HR >= 100 || std_RR >= 0.1
    emotion = 'Anxiety';
else
    emotion = 'Unknown';
end

fprintf('Detected emotion based on ECG signal: %s\n', emotion);

figure;
plot(ecg_filtered);
hold on;
plot(R_locs, ecg_filtered(R_locs), 'ro'); 
title(['ECG Signal with Detected Emotion: ' emotion]);
xlabel('Sample');
ylabel('Amplitude');
legend('Filtered ECG', 'R-peaks');
