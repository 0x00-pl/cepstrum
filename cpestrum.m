function cpes = cpestrum(s, N, dim)
    fft_s = fft(s, N, dim);
    log_fft_s = log(fft_s);
    cpes = ifft(log_fft_s);
end

