function [u_cap, PathMetrics, x_cap, positions] = Polar_Decode(LLR, PathMetrics, Frozen, node, Ls)
    N = size(LLR, 2);
    if (N==1)
        if any(Frozen==node) % To check if node is frozen
                x_cap = zeros(Ls, 1); % Assigning 0 if node is frozen
                u_cap = zeros(Ls, 1); % Assigning 0 if node is frozen
                PathMetrics = PathMetrics + abs(LLR).*(LLR < 0); % Adding |LLR| value if it is negative
                positions = 1:Ls; % No extra Path Metrics Added, So Positions will remain Unchanged
        else
            decision = LLR < 0; % Decisions as per LLR values

            % Creating All Path Metrics such that, first Ls are: PathMetrics
            % Next Ls are (opposite to Decision Metrics): Pathmetrics + |LLR|
            AllPathMetrics = [PathMetrics; PathMetrics+abs(LLR)];
            [PathMetrics, positions] = mink(AllPathMetrics, Ls);

            greater_pos = positions > Ls; % Positions which are opposite of Decision Metrics
            positions(greater_pos) = positions(greater_pos) - Ls; % Adjusting to their actual Index in List

            decision = decision(positions); % Decisions of Selected Ls Decoders
            decision(greater_pos) = 1 - decision(greater_pos); % Flipping the Decisions opposite to Decision Metrics 

            x_cap = decision; % Assigning Decisions
            u_cap = decision; % Assigning Decisions
        end
    else
        % Partitioning Beliefs into two parts
        L1 = LLR(:, 1:N/2);
        L2 = LLR(:, N/2+1:N);

        % Finding the Beliefs for Left Part by SPC Decoding
        L_Left = SPC_Decode(L1, L2);

        % Recursive function to get u1cap x1cap, PathMetrics and positions
        [u1_cap, PathMetrics, x1_cap, positions1] = Polar_Decode(L_Left, PathMetrics, Frozen, node(1:N/2), Ls);

        % Adjusting L1 and L2 according to received positions of Decision
        L1 = L1(positions1, :);
        L2 = L2(positions1, :);

        % Finding the Beleifs for Right Part by Repetition Decoding
        L_Right = Rep_Decode(L1, L2, x1_cap);
        
        % Recursive function to get u1_cap x1_cap, PathMetrics and positions
        [u2_cap, PathMetrics, x2_cap, positions2] = Polar_Decode(L_Right, PathMetrics, Frozen, node(N/2+1:N), Ls);

        % Adjusting u1_cap and x1_cap according to received positions of Decision
        u1_cap = u1_cap(positions2, :);
        x1_cap = x1_cap(positions2, :);

        x_cap = [mod((x1_cap+x2_cap), 2) x2_cap];
        u_cap = [u1_cap u2_cap];
        positions = positions1(positions2); % Final Position according to the Decisions
    end
end