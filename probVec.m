function [ pvecs ] = probVec( edits, fv )
%PROBVEC to produce probability vector when given edits and propagated
%   influence value.
%   edits: a vector contains K scalars
%   fv: influence value matrix for all image pixel points
%   Author: Hao Lv
%   Email: lvhaoexp@163.com

[rows, cols] = size(fv);
K = size(edits, 2);
pvecs = zeros(rows, cols, K);
alpha_2 = 0.09;
for r = 1:rows
    for c=1:cols
        pv = zeros(1, K);
        for k = 1:K
            pv(k) = exp((fv(r,c) - edits(k))^2/alpha_2);
        end
        pvecs(r,c,:) = pv/sum(pv);
    end
end

end

