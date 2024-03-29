function [ compSeq ] = compressOhead( stego,cover,Qyx,xRange,yRange)
%COMPRESSOHEAD Summary of this function goes here
%   Detailed explanation goes here
eps=0.0001;
eps2 = 0.000001;
[nB,mB]=size(Qyx);

coverLen = length(cover);
coverind = zeros(coverLen,1);
for xi=1:mB
    coverind(cover==xRange(xi)) = xi;
end
cover = coverind;

compSeq = zeros(coverLen,1);
compLen = 0;
for yi=1:nB
    pos = find(stego==yRange(yi));
     if ~isempty(pos) && ~any(abs(Qyx(yi,:)-1.0)<eps) %&& abs(sum(Qyx(yi,:))-1.0)<1e-8
        source = cover(pos);
        fq = repmat(Qyx(yi,:),length(source),1);

%new
% fq1 = fq+eps2;
% [qm,qn] = size(fq);
% for qi=1:qm
%     max_index = find(fq1(qi,:)==max(fq1(qi,:)));
%     zero_num = find(fq1(qi,:)==eps2);
%     fq1(qi,max_index(1)) = fq1(qi,max_index(1)) - length(zero_num)*eps2;
%     sss=0;
% end
% fq = fq1;

%old
        zero_num = find(fq==0);
        fq1 = fq*(1-length(zero_num)*eps2);
        fq1(fq1==0) = eps2;
        fq = fq1;

        compT = arith_encode(source,fq);
        
        lenT = length(compT);
        compSeq(compLen+1:compLen+lenT) = compT;
        compLen = compLen+lenT;
    end
end
compSeq = compSeq(1:compLen);

end

