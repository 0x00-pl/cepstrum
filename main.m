

[sig, Fs] = load_data("wav_test/t_TSP1min48_8ch_room3_near_SNR30.wav");
[ssf, ss] = stft(sig, hamming(512,'periodic'), 256, 512);

% lifter signal to cpestrum domain
figure(1); imagesc(log(abs(ssf)))
sc = cpestrum(ss, 512, 1);

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
rss = invcpestrum(sc_out, 512, 1);
rsig = overlap_concat(rss, 256);
figure(4); plot([real(rsig) imag(rsig)]);

% normalize output signal
rrsig = real(rsig);
% rrsig = 2*rrsig/(max(rrsig)-min(rrsig));
% sig = 2*sig/(max(sig)-min(sig));
rrsig = normalize_signal(rrsig);
sig = sig(1:length(rrsig));
sig = normalize_signal(sig);
plot(rrsig)
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
