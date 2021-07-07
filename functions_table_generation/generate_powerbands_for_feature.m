function [power_bands, power_bands_full, power_bands_fft, power_bands_full_fft] = generate_powerbands_for_feature(EEG, epoch_idx)
%power_bands_dBWs: 14x4 matrix (length of electrodes x bands generated from
%10*log10 matlab bandpower function within an epoch_idx

scale_log = true;
vars = globals();

Fs = vars.sampling_rate;

electrode_names = {EEG.chanlocs.labels};
electrode_data = containers.Map;

% Power band matrix - rows are electrodes and columns are bands
power_bands = ones(length(electrode_names), 4);
power_bands_full = ones(length(electrode_names), 4);
power_bands_fft = ones(length(electrode_names), 4);
power_bands_full_fft = ones(length(electrode_names), 4);

for chan_i = 1:length(electrode_names)
    electrode_idx_for_chan_i = strcmpi(electrode_names(chan_i), {EEG.chanlocs.labels});
    electrode_data(electrode_names{chan_i}) = EEG.data(electrode_idx_for_chan_i, :, epoch_idx);
    
    data_for_electrode = electrode_data(electrode_names{chan_i});
    
    for j = 1:length(vars.band_freq)
        band_range = [vars.band_freq(j,:)];
        
        power_bands(chan_i,j) = bandpower(data_for_electrode(1,65:256), Fs, band_range);
        power_bands_full(chan_i,j) = bandpower(data_for_electrode, Fs, band_range);
        power_bands_fft(chan_i,j) = computeFFT(data_for_electrode(1,65:256), Fs, band_range);
        power_bands_full_fft(chan_i,j) = windowedFFT(data_for_electrode, Fs, band_range);
        
        % Scale logarithmically
        if scale_log
            power_bands(chan_i,j) = 10*log10(power_bands(chan_i,j));
            power_bands_full(chan_i,j) = 10*log10(power_bands_full(chan_i,j));
        end
        
    end
end

    function power_fft = windowedFFT(x, Fs, curBand)
        winSize = 64;
        stepSize = 2;
        displacement = winSize - (winSize - stepSize);
        numFeatureVectors = floor((size(x, 2) - winSize) / displacement) + 1;
        fft_values = zeros(numFeatureVectors,1);
        for n = 0:numFeatureVectors-1
            startPos = 1 + n * displacement;
            endPos = startPos + winSize - 1;
            newData = x(1, startPos:endPos);
            fft_values(n+1) = computeFFT(newData, Fs, curBand);
        end
        power_fft = mean(fft_values);
    end

    function power_fft = computeFFT(x, Fs, curBand)
        N = length(x);
        xdft = fft(x);
        xdft = xdft(1:N/2+1);
        psdx = (1/(Fs*N)) * abs(xdft).^2;
        psdx(2:end-1) = 2*psdx(2:end-1);
        freq = 0:Fs/length(x):Fs/2;
        psdx = 10*log10(psdx);
        
        freq1 = freq >= curBand(1);
        freq2 = freq <= curBand(2);
        freq_idx = freq1 & freq2;
        power_fft = mean(psdx(freq_idx));
    end

end