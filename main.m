fft_size = 512;
step_size = 128;

[sig, Fs] = load_data("wav_test/t_female_07_4ch.wav");
sig = normalize_signal(sig);
[ssf, ss] = stft(sig, hamming(fft_size,'periodic'), step_size, fft_size);

% lifter signal to cpestrum domain
figure(1); imagesc(log(abs(ssf)))
sc = cpestrum(ss, fft_size, 1);
if sum(sum(imag(sc))) / size(sc,1) / size(sc,2) > 0.1
    print("imag(sc) should be all 0")
else
    sc = real(sc); % remove small imag parts
end

% filtering in cpestrum domain
if 0
    %     Num is a highpass fir
    sc_filtered = filter(Num, 1, sc, [], 2);
    figure(2); imagesc(abs(sc))
    figure(3); imagesc(abs(sc_filtered))
    sc_out = sc_filtered;
else
    avg_sc = sum(sc,2)/size(sc,2);
    sc_sub = sc - avg_sc;
    sc_out = sc_sub;
end

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
