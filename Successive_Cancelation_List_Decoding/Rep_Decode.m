function L = Rep_Decode(a, b, c)
    % c=0 --> L = b+a
    % c=1 --> L = b-a
    L = b + (1-2*c).*a;
end