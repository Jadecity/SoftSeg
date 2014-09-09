function [ pvecs ] = probVec( edits, fv )
%PROBVEC to produce probability vector when given edits and propagated
%   influence value.
%   edits: a vector contains K scalars
%   fv: influence value vector for all image pixel points
%   Author: Hao Lv
%   Email: lvhaoexp@163.com

pixnum = size(fv,2);
K = size(edits, 2);
pvecs = zeros( K, pixnum);
alpha_2 = 0.2;

for c=1:pixnum
  pv = zeros(1, K);
  for k = 1:K
    pv(k) = exp( ((fv(c) - edits(k))^2) /alpha_2);
  end
  pvecs(:,c) = pv/sum(pv);
end

end

