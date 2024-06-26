fft_size = 256;
step_size = 128;

[sig, Fs] = load_data("wav_test/t_female_07_4ch.wav");
% sig = rand(size(sig));
sig = normalize_signal(sig);
[ssf, ss] = stft(sig, hann(fft_size), step_size, fft_size);

% lifter signal to cpestrum domain
figure(1); imagesc(log(abs(ssf)))
sc = cpestrum(ss, fft_size, 1);
if sum(sum(imag(sc))) / size(sc,1) / size(sc,2) > 0.1
    print("imag(sc) should be all 0")
else
    sc = real(sc); % remove small imag parts
end

% filtering in cpestrum domain
switch(0)
    case 0
        %   remove average
        avg_sc = sum(sc,2)/size(sc,2);
        figure(10); plot(avg_sc);
        sc_sub = sc - avg_sc;
        sc_out = sc_sub;
    case 1
        % apply highpass fir in frames dimension
        %     Num is a highpass fir
        sc_filtered = filter(Num, 1, sc, [], 2);
        sc_out = sc_filtered;
    case 2
        % apply highpass fir in qerfency dimension
        sc_filtered = sc;
        sc_filtered(1:3, :) = 0;
        sc_filtered(end-1:end, :) = 0;
        sc_out = sc_filtered;
    case 3
        % apply lowpass fir in qerfency dimension
        sc_filtered = sc;
        sc_filtered(21:end-20, :) = 0;
        sc_out = sc_filtered;
        
end
figure(2); imagesc(abs(sc))
figure(3); imagesc(abs(sc_out))


% reconstruct signal
rss = invcpestrum(sc_out, fft_size, 1);
rsig = overlap_concat(rss, step_size);
figure(4); plot([real(rsig) imag(rsig)]);

% normalize output signal
if sum(sum(imag(rsig))) / size(rsig,1) / size(rsig,2) > 0.1
    print("imag(rsig) should be all 0")
else
    rsig = real(rsig); % remove small imag parts
end

% rrsig = 2*rrsig/(max(rrsig)-min(rrsig));
% sig = 2*sig/(max(sig)-min(sig));
rrsig = normalize_signal(rsig);
sig = sig(1:length(rrsig));
sig = normalize_signal(sig);
figure(5); plot(rrsig)
lr = [rrsig sig];

% output to left and right channel
% sound(lr, Fs);
save_data('output/output.wav', lr, Fs);

function s = normalize_signal(ss)
    ss_avg = sum(ss)/length(ss);
    ss = ss-ss_avg;
    ss = ss/max(abs(ss));
    s = ss;
end
