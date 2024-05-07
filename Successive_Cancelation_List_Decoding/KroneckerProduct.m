function C = KroneckerProduct(A, B)
    [m, n] = size(A);
    [p, q] = size(B);
    C = zeros(m*p, n*q);
    for i=1:m
        for j=1:n
            % rows from r1 to r2
            r1 = 1 + p*(i-1);
            r2 = p*i;

            % columns from c1 to c2
            c1 = 1 + q*(j-1);
            c2 = q*j;
            C(r1:r2, c1:c2) = A(i, j)*B;
        end
    end
end