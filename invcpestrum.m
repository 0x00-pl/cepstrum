function cpes = invcpestrum(s, N, dim)
    fft_s = fft(s, N, dim);
    exp_fft_s = exp(fft_s);
    cpes = ifft(exp_fft_s);
end
