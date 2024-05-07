function L = SPC_Decode(a, b)
    % Calculating the sign of 'a' and 'b' respectively
    signA = (1-2*(a<0));
    signB = (1-2*(b<0));
    
    % Calculating the minimum of the absolute values of 'a' and 'b'
    minAbs = min(abs(a), abs(b));
    
    % Calculating the final result
    L = signA.*signB.*minAbs;
end