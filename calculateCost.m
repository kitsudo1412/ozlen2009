function [result] = calculateCost(C, v)
    result = 0;
    for i = 1 : length(v)
        result = result + C(i, v(i));
    end
end

