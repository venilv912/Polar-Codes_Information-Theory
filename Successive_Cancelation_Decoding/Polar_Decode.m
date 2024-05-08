function [u_cap, x_cap] = Polar_Decode(L, Frozen, node)
    N = size(L, 2);
    if (N==1)
        if any(Frozen==node) % To check if node is frozen
                x_cap = 0;
                u_cap = 0;
        else
            if L >= 0
                x_cap = 0;
                u_cap = 0;
            else
                x_cap = 1;
                u_cap = 1;
            end
        end
    else
        % Partitioning Beliefs into two parts
        L1 = L(1:N/2);
        L2 = L(N/2+1:N);
        % Finding the Beliefs for Left Part by SPC Decoding
        L_Left = SPC_Decode(L1, L2);

        % Recursively calling function to get u1_cap and x1_cap
        [u1_cap, x1_cap] = Polar_Decode(L_Left, Frozen, node(1:N/2));

        % Finding the Beleifs for Right Part by Repetition Decoding
        L_Right = Rep_Decode(L1, L2, x1_cap);

        % Recursively calling function to get u2_cap and x2_cap
        [u2cap, x2cap] = Polar_Decode(L_Right, Frozen, node(N/2+1:N));
        x_cap = [mod((x1_cap+x2cap), 2) x2cap];
        u_cap = [u1_cap u2cap];
    end
end