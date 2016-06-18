function [smilarity title Max]=Hashsearch(path, LUT, Countbuffer)
    [y fs]=audioread(path);
    y=y(:,2)+y(:,1);
    y=resample(y,1,4); % downsampling freq 1/4 44100 --> 11025
    fs = fs/4;
    window = hamming(1024);
    noverlap = 512;
    nfft = 1024;
    [S] = spectrogram(y,window,noverlap,nfft,fs,'yaxis');
    S = 10*log10(abs(S));
   %% find the max point in the spectrogram
    col = size(S,2);
    %step1
    [p1, f1]= max(S(1:10,:));    % 0-10 bins
    [p2, f2]= max(S(11:20,:));   % 11-20 bins
    [p3, f3]= max(S(21:40,:));   % 21-40 bins
    [p4, f4]= max(S(41:80,:));   % 41-80 bins
    [p5, f5]= max(S(81:160,:));  % 81-160 bins
    [p6, f6]= max(S(161:511,:)); % 161-511 bins
    %step2
    section_peak_val=[p1;p2;p3;p4;p5;p6];
    section_peak_freq=[f1;f2+10;f3+20;f4+40;f5+80;f6+160];
    %step3
    total_mean = mean(max(section_peak_val'));
    total_mean = repmat(total_mean,6,col);
    peak_bool = section_peak_val > total_mean;
    peak_point_freq = section_peak_freq.*peak_bool;
    peak_point_time = repmat(1:col,6,1).*peak_bool;
    %step4
    N = find(peak_point_freq);
    peak_point_freq = peak_point_freq(N);
    peak_point_time = peak_point_time(N);
    %% make hashkey
    N=length(N);
    fingerprints = zeros(1,N - 5); %make the vector to save the fingerprints
    for i = 1 : N - 5
        st= i + 3; en= i + 5;
        for j = st : en
            hashkey = bitor(bitor(peak_point_freq(i), bitshift(peak_point_freq(j),10)) , bitshift(peak_point_time(j)-peak_point_time(i),20));
            fingerprints(1,i) = hashkey;
        end
    end
    %% find the music
    % fingerprints=unique(fingerprints); 중복 허용
    N = length(fingerprints);
    for i = 1 : N - 5
            key = fingerprints(i);
            key = mod(key,500000000)+1;
            l = length(LUT{1,key});
            for j = 1: l
                index = LUT{1,key}(j);
                Countbuffer(1,index)=Countbuffer(1,index)+1;
            end
    end
    f = fingerprints;
    [Max id] = max(Countbuffer);
    title = id;
    smilarity = Countbuffer;
end