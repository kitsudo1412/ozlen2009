function [ solutionTable ] = TAP( n )
%TAP Tri-objective assignment problem
%   We considered a n by n problem instance

for i = 1 : 3
    coefficientMatrix(:,:,i) = randi([1 100], n, n);
end

% 3 mock coefficient matrices for testing
coefficientMatrix = [99 19 74 55 41; 23 81 93 39 49; 66 21 63 24 38; 65 41 7 39 66; 93 30 5 4 13];
coefficientMatrix(:,:,2) = [28 39 19 42 7; 66 98 49 83 42; 73 26 42 13 54; 46 42 28 27 99; 80 17 99 59 68];
coefficientMatrix(:,:,3) = [29 67 2 90 7; 84 37 64 64 87; 54 11 100 83 61; 75 63 69 96 3; 66 99 34 33 21];

for i = 1 : 3
    disp(['CoefficientMatrix C' num2str(i)]);
    disp(coefficientMatrix(:,:,i));
end

disp('Finding general lower and upper bounds:');

for i = 1 : 3
    [fGlbSolution(:, i), fGlb(:, i)] = hungarian(coefficientMatrix(:,:,i));
    [fGubSolution(:, i), fGub(:, i)] = hungarianMax(coefficientMatrix(:,:,i));
    disp(['f^GLB_' num2str(i) ' = ' num2str(fGlb(:, i))]);
    disp(fGlbSolution(:, i)');
    disp(['f^GUB_' num2str(i) ' = ' num2str(fGub(:, i))]);
    disp(fGubSolution(:, i)');
end

w3 = 1/((fGub(:, 2) - fGlb(:, 2) - 1)*(fGub(:, 3) - fGlb(:, 3) - 1));
disp(['w_3 = ' num2str(w3)]);
l3 = fGub(:, 3);
disp(['l_3 = ' num2str(l3)]);

values = [];
solutions = [];

while 1
    [CWBOIPValues, CWBOIPSolutions] = solveCWBOIP(coefficientMatrix(:,:,1), coefficientMatrix(:,:,2), coefficientMatrix(:,:,3), w3, l3);
    if isempty(CWBOIPValues)
        break
    end
    
    values = [values;CWBOIPValues];
    solutions = [solutions;CWBOIPSolutions];
    
    [numOfSolutions, nAlias] = size(CWBOIPSolutions);
    
    l3 = calculateCost(coefficientMatrix(:,:,3), CWBOIPSolutions(1, :));
    if numOfSolutions >= 2
        for i = 2 : numOfSolutions
            cost = calculateCost(coefficientMatrix(:,:,3), CWBOIPSolutions(i, :));
            if (cost > l3)
                l3 = cost;
            end
        end
    end
    
    l3 = l3 - 1;
end

solutionTable = [];

[C, ia, ic] = unique(solutions, 'rows');
ia = sort(ia);
for i = 1 : length(ia)
    solutionTable = [solutionTable; values(ia(i), :) calculateCost(coefficientMatrix(:,:,3), solutions(ia(i), :)) solutions(ia(i), :)];
end

end