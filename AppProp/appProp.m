function [ e ] = appProp( imin, g, w )
%APPPROP an implementation of "all-pairs appearance-space edit propagation"
%   im, input image in Lab color space and m-by-n-by-3 dimension
%   g, a vector user specified edits' parameters
%   w, a vector holds user specified strength of g, range in [0,1]
%   imout, output image, edited using AppProp algorithm
%   e, the propagated edit parameters
%   Author: Hao Lv
%   Email: lvhaoexp@163.com
%   Notice: this function is to be implemented.

if exist('U.mat','file')
    load U;
    A = U(1:100,1:100);
else
    %get size
    [imsz.rows, imsz.cols, imsz.channels] = size(imin);

    %randomly sample 100 points in origin image
    sampleDim = 10;
    srows = sort(randi(imsz.rows, 1, sampleDim));
    scols = sort(randi(imsz.cols, 1, sampleDim));
    %create random selected image
    im = imin(srows, scols);

    %get feature map
    fvec_all = featVec(imin);
    fvec = fvec_all(srows, scols,:);

    %compute U
    delta_a_2 = 500;
    delta_s_2 = 0.05;
    A = zeros(sampleDim, sampleDim);
    B = zeros(sampleDim, imsz.rows - sampleDim);
    %B = zeros(sampleDim, imsz.rows);
    fv_1 = zeros(1,3);
    fv_2 = zeros(1,3);
    for c=1:sampleDim^2
        sc = mod(c, sampleDim);
        sr = ceil(c/sampleDim);
        if sc == 0
            sc = sampleDim;
        end
        xi = [srows(sr),scols(sc)];
        fv_1 = [fvec(sr,sc,1), fvec(sr,sc,2), fvec(sr,sc,3)];
        for r=1:sampleDim^2
            sc2 = mod(r, sampleDim);
            if sc2 == 0
                sc2 = sampleDim;
            end
            sr2 = ceil(r/sampleDim);
            fv_2 = [fvec(sr2,sc2,1), fvec(sr2,sc2,2), fvec(sr2,sc2,3)];
            A(r,c) = exp(-norm(fv_1 - fv_2)/delta_a_2)*...
                     exp(-norm(xi - [srows(sr2), scols(sc2)])/delta_s_2);
        end

        rcnt = sampleDim^2;
        elenum = imsz.rows*imsz.cols;
        cnt = 0;
        for r=1:elenum
            sc3 = mod(r, imsz.cols);
            sr3 = ceil(r/imsz.cols);
            if sc3 == 0
                sc3 = imsz.rows;
            end

            if(any(scols == sc3) && any(srows == sr3))
                cnt = cnt + 1;
                continue;
            end

            rcnt = rcnt + 1;
            if rcnt > imsz.rows*imsz.cols
                rcnt
            end
            fv_2 = [fvec_all(sr3,sc3,1), fvec_all(sr3,sc3,2), fvec_all(sr3,sc3,3)];
            B(c, rcnt)= exp(-norm(fv_1 - fv_2)/delta_a_2)*...
                     exp(-norm(xi - [sr3, sc3])/delta_s_2); 
        end
    end
    U = [A;B'];
    size(A);
    size(B');
    save U.mat U;
end
lamda = mean(w);
tic
one  = 0.5*lamda*U*(A\(U'*w'));
two = U*(A\(U'*ones(n,1)));
d = one + two;
toc
e = d;

end

