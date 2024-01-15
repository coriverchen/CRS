function [ stego,mesLen ] = entropyEmbed2( cover,mess,Qxy,xRange,yRange)
%ENTROPYEMBED Summary of this function goes here
%   Detailed explanation goes here
%   cover:  the cover signal
%   mess:   the message to embed
%   Qxy:    the conditional probability Py|x
eps=0.0001;
eps2 = 0.000001;
stego = cover;
mesLen = 0;
[mB,nB] = size(Qxy);
for xi=1:mB
    pos = find(cover==xRange(xi));
    xN = length(pos);
    if xN>0
        yi = find(abs(Qxy(xi,:)-1.0) < eps);
        if yi
            stego(pos) = yRange(yi)*ones(xN,1);
        else%if abs(sum(Qxy(xi,:))-1.0)<1e-8
            fq = repmat(Qxy(xi,:),xN,1);
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
            [symbols,mLen] = arith_decode(mess(mesLen+1:end),fq);
            stego(pos) = yRange(symbols);
            mesLen = mesLen+mLen;
        end
    end
end



end

