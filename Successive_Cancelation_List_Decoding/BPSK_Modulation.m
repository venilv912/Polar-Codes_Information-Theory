function s = BPSK_Modulation(code_word)
    % 0 --> 1       1 --> -1
    s = 1 - (2*code_word);
end