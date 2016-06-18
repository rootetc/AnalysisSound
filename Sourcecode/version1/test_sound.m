<<<<<<< HEAD
clear
clc
%% make the structure
Path='music_path'; val_music_path='';
Key='hash_key'; val_hash_key=[];
Name='name'; name='';
Music=struct(Path,val_music_path,Key,val_hash_key);
%% test open the continous file
PathName='C:\Users\Public\Music\Sample Music';
lists = dir(fullfile(PathName,'*.mp3'));
k=length(lists);
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
    [S,F,T]=spectrogram(y,window,noverlap,nfft,fs,'yaxis');
    %% find the max point in the spectrogram
    S = 10*log10(abs(S));
    [~, col] =size(S);
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
    peak_bool = section_peak_val>total_mean;
    peak_point_freq = section_peak_freq.*peak_bool;
    %step4
    peak_point_time=zeros(size(peak_point_freq));
    for i = 1:length(peak_point_freq)
        for j = 1: 6
            if peak_point_freq(j,i) ~= 0
                %peak_point_freq(j,i) = F(peak_point_freq(j,i));
                peak_point_time(j,i) = T(i);
            else
                peak_point_freq(j,i)=0;
                peak_point_time(j,i)=0;
            end
        end
     end
    %% draw the graph
    subplot(3,1,id);
    plot(peak_point_time,peak_point_freq,'o');
    %plot(T,peak_point_freq,'o');
    %plot(T,peak_point,'o');
    %xlabel('time');ylabel('frequency');title('spectrogram peak');
    %% make the fingerprints
    [row col]=size(peak_point_freq);
    num=row*col;
    fingerprints=zeros(1,numel(find(peak_point_freq))); %make the vector to save the fingerprints
    index=1;
    for i = 1 : num - 1
        if peak_point_freq(i) ~= 0
            j=i+1;
            cnt=0;
            while true
                if peak_point_freq(j) ~= 0
                cnt=cnt+1; 
                bb = peak_point_freq(i) + bitshift(peak_point_freq(j),10)+ bitshift(ceil(j/6)-ceil(i/6),19);
                fingerprints(1,index)=bb;
                index=index+1;
                end
                j=j+1;
                if cnt==5 || j>num
                    break;
                end
            end
        end
    end
    Music(id).music_path=file_name;
    Music(id).hash_key=unique(fingerprints);
    Music(id).name = lists(id).name;
end
=======
clear
clc
%% make the structure
Path='music_path'; val_music_path='';
Key='hash_key'; val_hash_key=[];
Name='name'; name='';
Music=struct(Path,val_music_path,Key,val_hash_key);
%% test open the continous file
PathName='C:\Users\Public\Music\Sample Music';
lists = dir(fullfile(PathName,'*.mp3'));
k=length(lists);
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
    [S,F,T]=spectrogram(y,window,noverlap,nfft,fs,'yaxis');
    %% find the max point in the spectrogram
    S = 10*log10(abs(S));
    [~, col] =size(S);
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
    peak_bool = section_peak_val>total_mean;
    peak_point_freq = section_peak_freq.*peak_bool;
    %step4
    peak_point_time=zeros(size(peak_point_freq));
    for i = 1:length(peak_point_freq)
        for j = 1: 6
            if peak_point_freq(j,i) ~= 0
                %peak_point_freq(j,i) = F(peak_point_freq(j,i));
                peak_point_time(j,i) = T(i);
            else
                peak_point_freq(j,i)=0;
                peak_point_time(j,i)=0;
            end
        end
     end
    %% draw the graph
    subplot(3,1,id);
    plot(peak_point_time,peak_point_freq,'o');
    %plot(T,peak_point_freq,'o');
    %plot(T,peak_point,'o');
    %xlabel('time');ylabel('frequency');title('spectrogram peak');
    %% make the fingerprints
    [row col]=size(peak_point_freq);
    num=row*col;
    fingerprints=zeros(1,numel(find(peak_point_freq))); %make the vector to save the fingerprints
    index=1;
    for i = 1 : num - 1
        if peak_point_freq(i) ~= 0
            j=i+1;
            cnt=0;
            while true
                if peak_point_freq(j) ~= 0
                cnt=cnt+1; 
                bb = peak_point_freq(i) + bitshift(peak_point_freq(j),10)+ bitshift(ceil(j/6)-ceil(i/6),19);
                fingerprints(1,index)=bb;
                index=index+1;
                end
                j=j+1;
                if cnt==5 || j>num
                    break;
                end
            end
        end
    end
    Music(id).music_path=file_name;
    Music(id).hash_key=unique(fingerprints);
    Music(id).name = lists(id).name;
end
>>>>>>> d2a4927c51aa93dd8032ac2b4abdb6ef701b7689
