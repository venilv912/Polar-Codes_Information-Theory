function r = AWGN_Channel(s, sigma, N)
    % Additive White Gaussian Distributed Noise added to symbols
    r = s + sigma*randn(1, N);
end