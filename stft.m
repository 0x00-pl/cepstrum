function [Xtwz, xtwz] = stft(x, w, R, N)
    nframes = floor((length(x)-N)/R) + 1;
    xtwz = zeros(N,nframes); % pre-allocate splited output array
    Xtwz = zeros(N,nframes); % pre-allocate STFT output array
    M = length(w);           % M = window length, N = FFT length
    zp = zeros(N-M,1);       % zero padding (to be inserted)
    xoff = 0;                % current offset in input signal x
    for m=1:nframes
      xt = x(xoff+1:xoff+M); % extract frame of input data
      xtw = w .* xt;         % apply window to current frame
      xtwz(:,m) = [xtw; zp]; % windowed, zero padded
      Xtwz(:,m) = fft(xtwz(:,m)); % STFT for frame m
      xoff = xoff + R;       % advance in-pointer by hop-size R
    end
end