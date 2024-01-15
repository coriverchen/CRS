%source code of arithmetic embeding (AAC)
%Cover Reproducible Steganography via Deep Generative Models, TDSC 2022
%For Generative Model

addpath('STC_Toolbox')
addpath('utils')

file_name = [cover_dir '/' files(i).name]; % generated audio via deep generative models
rec_name = [rec_dir '/' files(i).name]; % AAC compressed and decompressed audio
stego_name = [stego_dir '/' files(i).name]; %stego audio 
[y1, fs] = audioread(file_name, 'native');
[y2, ~] = audioread(rec_name, 'native');
diff = y1 - y2;
diff = double(diff);
rhoP1 = zeros(length(diff), 1);
rhoM1 = zeros(length(diff), 1);

for j = 1:length(diff)
    
    if diff(j) < 0
        rhoP1(j) = 1 / abs(diff(j));
        rhoM1(j) = 10 / abs(diff(j));
    elseif diff(j) > 0
        rhoP1(j) = 10 / abs(diff(j));
        rhoM1(j) = 1 / abs(diff(j));
    else
        rhoP1(j) = 10;
        rhoM1(j) = 10;
    end
    
end
m = randi(2, round(payload * length(y1)), 1) - 1;

[stego, pChangeP1, pChangeM1] = simulate(y1, rhoP1, rhoM1, length(m));
eps=0.000001;
pChangeP1=pChangeP1';
pChangeM1=pChangeM1';
pchange=[pChangeM1+eps;1-pChangeP1-pChangeM1-2*eps;pChangeP1+eps]';
y2 = arith_decode(m,pchange);
y2 = int16(y2);
y = zeros(size(y1));
y(I1) = y1(I1)+y2-2;            
y = int16(y);
audiowrite(stego_name,y,fs);