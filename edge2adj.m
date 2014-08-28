function [ adj ] = edge2adj( labels, segment, edges, nodenum )
%EDGE2ADJ used to convert a binary edge matrix to adjacency matrix
%   function [ adj ] = edge2adj( labels, segment, edges, nodenum )
%   labels = unique(segment)
%   segment, a labeled image
%   edges, a binary matrix with 1 represents edge, 0 not edge
%   nodenum, the number of graph node
%   Author : lvhao
%   Email : lvhaoexp@163.com
%   Date : 2014-08-27

%init var
adj = zeros(nodenum, nodenum);
[ rnum, cnum ] = size(segment);
%extract edge position
[ ridx, cidx ] = find(edges == 1);
ridx = ridx';
cidx = cidx';
%create adjacency matrix
for r=ridx
    %do not touch boundary
    if r == 1 || r == rnum
        continue;
    end
    for c=cidx
       %do not touch boundary
       if c == 1 || c == cnum
           continue;
       end
       
       adjlab = unique(segment(r-1:r+1, c-1:c+1));
       adjlab = adjlab';
       if size(adjlab,2) ~= 1
            [~, cl] = find( ismember(labels, adjlab ) == 1);
            pos = nchoosek(cl,2);
            for rtmp = 1:size(pos,1)
                adj(pos(rtmp,1), pos(rtmp,2)) = 1;
            end
       end
    end
end
adj = adj + adj';%symmetric matrix

end

