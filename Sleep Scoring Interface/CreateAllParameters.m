function varargout = CreateAllParameters(varargin)
% CREATEALLPARAMETERS MATLAB code for CreateAllParameters.fig
%      CREATEALLPARAMETERS, by itself, creates a new CREATEALLPARAMETERS or raises the existing
%      singleton*.
%
%      H = CREATEALLPARAMETERS returns the handle to a new CREATEALLPARAMETERS or the handle to
%      the existing singleton*.
%
%      CREATEALLPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEALLPARAMETERS.M with the given input arguments.
%
%      CREATEALLPARAMETERS('Property','Value',...) creates a new CREATEALLPARAMETERS or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CreateAllParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CreateAllParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CreateAllParameters

% Last Modified by GUIDE v2.5 05-Jun-2024 13:26:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CreateAllParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @CreateAllParameters_OutputFcn, ...
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

% --- Executes just before CreateAllParameters is made visible.
function CreateAllParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CreateAllParameters (see VARARGIN)

% Choose default command line output for CreateAllParameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%UIWAIT makes CreateAllParameters wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CreateAllParameters_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;



% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AllParameters.bullChannel = str2num(get(handles.GammaChannel,'String'));
AllParameters.thetaChannel = str2num(get(handles.ThetaChannel,'String'));
AllParameters.gammaThreshold = str2num(get(handles.GammaThreshold,'String'));
AllParameters.ratioThreshold = str2num(get(handles.ThetaThreshold,'String'));
AllParameters.durationStim = str2num(get(handles.DurationStim,'String'));
AllParameters.InterStimTime = str2num(get(handles.InterStimTime,'String'));
AllParameters.consolidationTime = str2num(get(handles.ConsolidationTime,'String'));
if handles.triggerNREM.Value ==1
    AllParameters.StimState = 1;
elseif handles.triggerREM.Value ==1
    AllParameters.StimState = 2;
elseif handles.triggerWAKE.Value ==1
    AllParameters.StimState = 3;
end

handles.Path =[];
currentFolder = pwd;
pathname = uigetdir(currentFolder, 'Pick a directory to save data');
if isequal(pathname,0)
    % User cancelled
else
    % Set basename
    handles.Path = pathname;
end

save([handles.Path, '\AllParameters.mat'],'AllParameters');
close all





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function GammaChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GammaChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ThetaChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThetaChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function GammaThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GammaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function ThetaThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThetaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function InterStimTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterStimTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function DurationStim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DurationStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function ConsolidationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConsolidationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ConsolidationTime_Callback(hObject, eventdata, handles)
% hObject    handle to ConsolidationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ConsolidationTime as text
%        str2double(get(hObject,'String')) returns contents of ConsolidationTime as a double

function DurationStim_Callback(hObject, eventdata, handles)
% hObject    handle to DurationStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DurationStim as text
%        str2double(get(hObject,'String')) returns contents of DurationStim as a double



function InterStimTime_Callback(hObject, eventdata, handles)
% hObject    handle to InterStimTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InterStimTime as text
%        str2double(get(hObject,'String')) returns contents of InterStimTime as a double

function ThetaThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to ThetaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThetaThreshold as text
%        str2double(get(hObject,'String')) returns contents of ThetaThreshold as a double



function GammaThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to GammaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GammaThreshold as text
%        str2double(get(hObject,'String')) returns contents of GammaThreshold as a double



function ThetaChannel_Callback(hObject, eventdata, handles)
% hObject    handle to ThetaChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThetaChannel as text
%        str2double(get(hObject,'String')) returns contents of ThetaChannel as a double

function GammaChannel_Callback(hObject, eventdata, handles)
% hObject    handle to GammaChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GammaChannel as text
%        str2double(get(hObject,'String')) returns contents of GammaChannel as a double
