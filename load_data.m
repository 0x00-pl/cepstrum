function [data, Fs] = load_data(filename)
    [data_all, Fs] = audioread(filename);
    data = data_all(:, 1);
end

