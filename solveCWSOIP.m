function [ result_c, result_p ] = solveCWSOIP( C1, C2, C3, w2, l2, l3 )
    CMatrix = C1 + w2 * C2;
    [c, p] = allcosts(CMatrix);

    [y, mapping] = sort(c);
    
    i = 1;
    result_p = 1 : length(C1);
    
    while i <= length(c)
        result_p = p(mapping(i), :);
        result_c = c(mapping(i));
        
        if calculateCost(C2, result_p) > l2 || calculateCost(C3, result_p) > l3
            i = i + 1;
        else
            break
        end
    end
    
    if (calculateCost(C2, result_p) > l2 || calculateCost(C3, result_p) > l3)
        result_c = 0;
        result_p = 1:length(C1);
    end
end