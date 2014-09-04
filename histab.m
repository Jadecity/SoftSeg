function hst = histab( pixlab, binnum )
%HISTAB calculate histogram in the ab subspace of lab
%   function hst = histab( imglab, binnum )
%   pixlab: img in lab color space, N-by-3 matrix
%   binnum: histogram bin number
%   Author: lvhao
%   Email: lvhaoexp@163.com
%   Date: 2014-09-04

hst = zeros(1, binnum);
binnum = sqrt ( binnum );
step = 255/sqrt(binnum);
[rows, cols] = size( pixlab );

for n=1:rows
  b1 = ceil ( pixlab( n, 2 )/step );
  b2 = ceil ( pixlab( n, 3 )/step );
  hst( b1 + (b2-1)*binnum ) = hst( b1 + (b2-1)*binnum ) + 1;
end

end