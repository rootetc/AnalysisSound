function varargout = musicAnalysis(varargin)
% MUSICANALYSIS M-file for musicAnalysis.fig
%      MUSICANALYSIS, by itself, creates a new MUSICANALYSIS or raises the existing
%      singleton*.
%
%      H = MUSICANALYSIS returns the handle to a new MUSICANALYSIS or the handle to
%      the existing singleton*.
%
%      MUSICANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the
%      local
%      function named CALLBACK in MUSICANALYSIS.M with the given input arguments.
%
%      MUSICANALYSIS('Property','Value',...) creates a new MUSICANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before musicAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to musicAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help musicAnalysis

% Last Modified by GUIDE v2.5 09-Jun-2016 19:32:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @musicAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @musicAnalysis_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before musicAnalysis is made visible.
function musicAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to musicAnalysis (see VARARGIN)

% Choose default command line output for musicAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes musicAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = musicAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_path as text
%        str2double(get(hObject,'String')) returns contents of edit_path as
%        a double
% --- Executes during object creation, after setting all properties.
function edit_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Filepath.
function Filepath_Callback(hObject, eventdata, handles)
% hObject    handle to Filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
music_dir = uigetdir('','Select the folder');
if length(music_dir) > 2
    set(handles.Record,'Enable','off');
    set(handles.edit_path,'String',music_dir);
    guidata(hObject,handles); % handles struct를 update.
    music_list = dir(fullfile(music_dir,'*.mp3'));
    len = length(music_list);
    hash = cell(1,2^29); % make the hash table
    title = cell(2,len);
    h = waitbar(0/len,'     DB     ');
    for id =  1 : len
        %% load the music && save the file name and edit_path
        waitbar(id/len,h,sprintf('DB(%i / %i)',id,len));
        file_path = strcat(music_dir,'\',music_list(id).name);
        title{1,id}=music_list(id).name; title{2,id} = file_path;
        %% load the music and processing
        [y, fs] = audioread(file_path);
        y = y(:,1)+y(:,2); y = resample(y,1,8);
        window = hamming(2048);
        noverlap = 1985; nfft = 1024;
        s = spectrogram(y,window, noverlap,nfft,fs/8,'yaxis');
        s = abs(s);s=s.*s; 
       %% 6/10
%         S = abs(s);
%         Smax = max(S(:));
%         S = log(max(Smax/1e6,S));
%         S = S - mean(S(:));
%         % high pass filtering 
%         s = (filter([1 -1],[1 -0.98],S')');
       %% find feature
        col = size(s,2);
        st = 56;
        en = 372;
        nbits = 26;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        banding = st:round((en-st)/nbits):en;
        E = zeros(nbits,size(s,2));
        for i = 1:length(banding)-1
            E(i,:) = sum( s(banding(i):banding(i+1),:));
        end
        finger = (E(2:nbits,1:col-1) - E(2:nbits,2:col) - E(1:nbits-1,1:col-1) + E(1:nbits-1,2:col)) > 0;
        finger = bi2de(finger');
        fingerprints = unique(finger);
        len_finger = length(fingerprints);
        %% make the hash table.
        for i = 1 : len_finger
            key = fingerprints(i) + 1;
            if isempty(hash{1, key})
                hash{1,key} = id;
            else
                hash{1,key} = [hash{1, key} id];
            end
        end
    end
    close(h);
    handles.hash=hash;
    handles.title = title;
    handles.lists = len;
    guidata(hObject,handles); % handles struct에 hash의 구조를 넣어 준다.
    set(handles.Record,'Enable','on');
end

% --- Executes on button press in Record.
function Record_Callback(hObject, eventdata, handles)
% hObject    handle to Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = 44100; total_length = 0;
recObj = audiorecorder(fs,16,2);
LUT = handles.hash; title = handles.title; window = hamming(2048);
h = waitbar(0/5,'listening...');
popmap = containers.Map();

bit_mask = test_performance(26,3);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% recording for every 2 seconds
for Cnt = 1 : 5
    waitbar(Cnt/5);
    recordblocking(recObj,1.8);
    y = getaudiodata(recObj);
    y = y(:,1) + y(:,2);
    y = resample(y,1,8);
    s = spectrogram(y, window, 1984,1024,fs/8,'yaxis');
    %% find the energy of each band
    s = abs(s);
    s = s.*s;
    %% 6/10
%     S = abs(s);
%     Smax = max(S(:));
%     S = log(max(Smax/1e6,S));
%     S = S - mean(S(:));
%     % high pass filtering 
%     s = (filter([1 -1],[1 -0.98],S')');
%     
    %% find feature
    col = size(s,2);
    st = 56;
    en = 372;
    nbits = 26;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    banding = st:round((en-st)/nbits):en;
    E = zeros(nbits,size(s,2));
    for i = 1:length(banding)-1
        E(i,:) = sum( s(banding(i):banding(i+1),:));
    end
    finger = (E(2:nbits,1:col-1) - E(2:nbits,2:col) - E(1:nbits-1,1:col-1) + E(1:nbits-1,2:col)) > 0;
    finger = bi2de(finger');
    finger = unique(finger)+1;
    %% search the music by using fingerprints
    finger_len = length(finger); % for recall rate
    for i = 1 : finger_len
%         key = Similarfingerprints(finger(i),1:27) + 1;
        key = [finger(i);bitxor(bit_mask,finger(i))];
        len = length(key);
%%--------------------------------------------------------------------------
%         q = queue(len); %[key id index]
%         %% LUT 첫줄로 heap
%         for k = 1 : len
%             try  %순서   key,       id,         index
%                 q.push(key(k), LUT{1,key(k)}(1), 1); %heap을 채워준다/
%             catch
%             end            
%         end
      %% 6/10 큐 사이즈 올바르게 하기 위해,,,
       q_length = 0;
       for k= 1: len
           if ~isempty(LUT{1,key(k)}),
               q_length = q_length + 1;
           end
       end
       q = queue(q_length);
       for kk = 1: len,
           if ~isempty(LUT{1,key(kk)}),
               q.push(key(kk), LUT{1,key(kk)}(1), 1); %heap을 채워준다/
           end
       end
%--------------------------------------------------------------------------
       %% queue 순환 하며 카운팅
       popcnt = 0; popid = 0; 
       test_count = 0;
       while(q.head)
            popVal = q.pop();
            test_count = test_count+1;
            % popVal(1) is key / popVal(2) is id / popVal(3) is index
            if popVal(2) ~= popid
                if popcnt > round(q_length/7) % Threshold
                    if popmap.isKey(num2str(popid))
                        popmap(num2str(popid)) = popmap(num2str(popid)) + popcnt;
                    else
                        popmap(num2str(popid)) = popcnt;
                    end
                end
                popid = popVal(2);
                popcnt = 1;
            else
                popcnt = popcnt + 1;
            end
            %% queue에 push
            if length(LUT{1, popVal(1)}) > popVal(3) % check the length 
                q.push(popVal(1),LUT{1,popVal(1)}(popVal(3)+1),popVal(3)+1);
            end
        end
    end 
    tmp = cell2mat(popmap.values());
    [Max, ~]= max(tmp);
    total_length = total_length + finger_len; % 총 fingerprint의 계수를 나타내는 변수
    Recall = Max / total_length;
    handles.recall = Recall;
    if Recall > 0.9
        break;
    end
end
close(h);
[top_max, topid] = sort(cell2mat(popmap.values()),'descend');
top_len = min(length(topid(:)),5);  % for top five
handles.topfive = topid(1:top_len);
toptitle = cell(1,top_len);
tmpkeys = popmap.keys();
for k = 1:top_len
    tmp=cell2mat(tmpkeys(topid(k)));
    toptitle{1,k} = cell2mat(title(1,str2double(tmp)));
end
% set(handles.listbox1,'String',); % top5 
set(handles.listbox1,'String',[toptitle top_max(1:5)]);
set(handles.edit_recall,'String',Recall);   
% if Recall > 0.9
set(handles.edit_title,'String',cell2mat(toptitle(1)));   % 결과
% else
%     set(handles.edit_title,'String','잘 안들려요!!!');   
% end
guidata(hObject,handles); % handles struct에 hash의 구조를 넣어 준다.

function edit_title_Callback(hObject, eventdata, handles)
% hObject    handle to edit_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_title as text
%        str2double(get(hObject,'String')) returns contents of edit_title as a double

% --- Executes during object creation, after setting all properties.
function edit_title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_recall_Callback(hObject, eventdata, handles)
% hObject    handle to edit_recall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_recall as text
%        str2double(get(hObject,'String')) returns contents of edit_recall as a double

% --- Executes during object creation, after setting all properties.
function edit_recall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_recall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global check;
if ~isempty(handles.path)
    if check == true
        resume(handles.player);
    else
        check = false;
        try
            [y fs] = audioread(char(handles.path));
            handles.player = audioplayer(y,fs); % callback 함수가 종료되어도 노래가 재생하게 해주는 trick
            guidata(hObject,handles); % callback 함수가 종료되어도 노래가 재생하게 해주는 trick
            play(handles.player);
        catch
            handles.path=[];
        end
    end
end

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global check;
check = true;
if ~isempty(handles.player)
    try
        pause(handles.player);
    catch
        handles.player=[];
    end
end

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.player)
    try
        stop(handles.player);
    catch
        handles.player=[];
    end
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end