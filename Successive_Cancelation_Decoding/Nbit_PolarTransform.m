function GN = Nbit_PolarTransform(G, n)
    GN = G;
    for i = 1:n-1
        GN = KroneckerProduct(G, GN);
    end
end