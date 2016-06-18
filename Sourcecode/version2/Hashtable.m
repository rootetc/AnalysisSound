function [Hash list]=Hashtable()
clear
LUT = cell(1,500000000);
%% make the structure
Path='music_path'; val_music_path='';
Key='hash_key'; val_hash_key=[];
Name='name'; name='';
Music=struct(Path,val_music_path,Key,val_hash_key,Name,name);
%% test open the continous file
PathName='C:\Users\Public\Music\Sample Music';
lists = dir(fullfile(PathName,'*.mp3'));
k=length(lists);
list=k;
for id = 1 : k
    file_name=strcat(PathName,'\',lists(id).name);
    [y fs]=audioread(file_name);
    %% spectrogram
    y = y(:,2)+y(:,1);
    y = resample(y,1,4);% downsampling freq 1/4 44100 --> 11025
    fs = fs/4;
    window = hamming(1024); % window with a size of 1024 points
    noverlap = 512; %the noverlaps its the number of points for reping the
    nfft=1024;
    [S]=spectrogram(y,window,noverlap,nfft,fs,'yaxis');
    %% find the max point in the spectrogram
    S = 10*log10(abs(S));
    col =size(S,2);
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
    %% draw the graph
    %subplot(3,1,id);
    %plot(peak_point_time,peak_point_freq,'o');
    %xlabel('time'); ylabel('frequency'); title('spectrogram peak');
    %% make the fingerprints
    N=length(N);
    fingerprints = zeros(1,N - 5); %make the vector to save the fingerprints
    for i = 1 : N - 5
        st= i + 3; en= i + 5;
        for j = st : en
            hashkey = bitor(bitor(peak_point_freq(i), bitshift(peak_point_freq(j),10)), bitshift(peak_point_time(j)-peak_point_time(i),19));
            hashkey = mod(hashkey,500000000)+1;
            fingerprints(1,i) = hashkey;
        end
    end
    Music(id).music_path=file_name;
    Music(id).hash_key=fingerprints;
    %Music(id).hash_key=unique(fingerprints); 중복 허용
    Music(id).name = lists(id).name;
end
%% make the look up table
for id = 1 : k % k= total music number;
    N=length(Music(id).hash_key);
    for KeyIndex = 1 : N
        key = Music(id).hash_key(KeyIndex);
        if isempty(LUT{1,key})
            LUT{1, key}=id;
        else
            LUT{1, key}= [LUT{1,key}; id];
        end
    end
end
Hash = LUT;
end