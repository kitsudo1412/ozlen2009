function [ values, solutions ] = solveCWBOIP(C1, C2, C3, w3, l3)

values = [];
solutions = [];

B1 = C1 + w3 * C3;
B2 = C2 + w3 * C3;

% f1 = calculateCost(B1, x)
% f2 = calculateCost(B2, x)

% Constraint: calculateCost(C3, x) <= l3

[f2GlbSolution, f2Glb] = hungarian(B2);
[f2GubSolution, f2Gub] = hungarianMax(B2);

w2 = 1/(f2Gub - f2Glb + 1);
l2 = f2Gub;

while 1
    [CWSOIPValue,CWSOIPSolution] = solveCWSOIP(B1, B2, C3, w2, l2, l3);
    if CWSOIPValue == 0
        break
    end
    
    f1value = calculateCost(B1, CWSOIPSolution);
    f2value = calculateCost(B2, CWSOIPSolution);
    values = [values; f1value f2value];
    solutions = [solutions; CWSOIPSolution];
    
    l2 = f2value - 1;
end

end

