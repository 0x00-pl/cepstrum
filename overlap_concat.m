function sig = overlap_concat(data2d, R)
    [W, frames]= size(data2d);
    sig = zeros(W+(frames-1)*R, 1);
    for i = 1:frames
        old_val = sig((i-1)*R+1:(i-1)*R+W);
        sig((i-1)*R+1:(i-1)*R+W) = old_val + data2d(:, i);
    end
end

