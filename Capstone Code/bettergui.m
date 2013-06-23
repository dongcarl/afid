 function varargout = bettergui(varargin)
% BETTERGUI MATLAB code for bettergui.fig
%      BETTERGUI, by itself, creates a new BETTERGUI or raises the existing
%      singleton*.
%
%      H = BETTERGUI returns the handle to a new BETTERGUI or the handle to
%      the existing singleton*.
%
%      BETTERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BETTERGUI.M with the given input arguments.
%
%      BETTERGUI('Property','Value',...) creates a new BETTERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bettergui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bettergui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bettergui

% Last Modified by GUIDE v2.5 29-May-2013 13:55:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bettergui_OpeningFcn, ...
                   'gui_OutputFcn',  @bettergui_OutputFcn, ...
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


% --- Executes just before bettergui is made visible.
function bettergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bettergui (see VARARGIN)

% Choose default command line output for bettergui
handles.output = hObject;
handles.gesturearray=[];
handles.pointarray=struct([]);
handles.toggle=0;
delete(instrfind({'Port'},{'/dev/tty.usbmodem411'}));
handles.gloveard=arduino('/dev/tty.usbmodem411');
handles.gloveard.pinMode(7, 'output');
handles.gloveard.pinMode(8, 'output');
handles.svd_vects=zeros(2, 10);
handles.svd_points=struct([]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bettergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bettergui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in recbutton.
function recbutton_Callback(hObject, eventdata, handles)
% hObject    handle to recbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
counters=[0, 0, 0];
avg=zeros(15, 10);
on=0;
readingmat=zeros(10, 1000);
handles.toggle=0;
guidata(hObject, handles)
handles=guidata(hObject);
vect1=handles.svd_vects(1, :);
vect2=handles.svd_vects(2, :);
paramstruct=newparams(handles.pointarray);
bufstr='';

while(on==0)
    readings=getreadings(handles.gloveard, 7, 8);
    
    readingmat(:, 2:1000)=readingmat(:, 1:999);
    readingmat(:, 1)=readings';
    [avg, counters, name] = precognize(avg, counters, readings, paramstruct);

    
    if name~=0
        set(handles.outtext, 'string', name);
        bufstr=strcat(bufstr, name);
        if (length(bufstr)>21)
            bufstr=bufstr(2:21);
        end
        set(handles.buffer, 'string', bufstr);
    end
    x=handles.svd_vects(1, :)*readings';
    y=handles.svd_vects(2, :)*readings';
    
    plot(handles.svdaxes, x, y, 'ko')
    hold on
    for i=1:size(handles.svd_points, 2)
        plot(handles.svd_points(i).mat(1, :), handles.svd_points(i).mat(2, :), '.','color', rand(1, 3))
    end
    hold off
    
    t=1:1000;
    plot(handles.sensoraxes, t, readingmat(1, :), t, readingmat(2, :), t, readingmat(3, :), t, readingmat(4, :), t, readingmat(5, :), t, readingmat(6, :), t, readingmat(7, :), t, readingmat(8, :), t, readingmat(9, :), t, readingmat(10, :))
    pause(.00001)
    handles=guidata(hObject);
    if (handles.toggle==1)
        on=1;

    end
    
end



% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
readings=getreadings(handles.gloveard, 7, 8);
char=get(handles.edit, 'String');
handles.gesturearray=newaction(handles.gesturearray, char, readings);
handles.pointarray=newpoint(handles.pointarray, char, readings);
handles.toggle=1;
cla(handles.sensoraxes);
cla(handles.svdaxes);

if size(horzcat(handles.pointarray.mat), 2)>1
    
    [handles.svd_points, handles.svd_vects]=svdcalc(handles.pointarray);
    axes(handles.svdaxes)
    hold on
    for i=1:size(handles.svd_points, 2)
        plot(handles.svd_points(i).mat(1, :), handles.svd_points(i).mat(2, :), '.','color', rand(1, 3))
    end
    hold off
end
guidata(hObject, handles)



% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.gesturearray=[];
cla(handles.sensoraxes);
cla(handles.svdaxes);
handles.pointarray=[];
handles.toggle=1;
guidata(hObject, handles)

function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit as text
%        str2double(get(hObject,'String')) returns contents of edit as a double


% --- Executes during object creation, after setting all properties.
function edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
