function varargout = read_continuously(varargin)
% READ_CONTINUOUSLY MATLAB code for read_continuously.fig
%      Example of reading, plotting, and (optionally) saving, using GUIDE.      
%
%      READ_CONTINUOUSLY, by itself, creates a new READ_CONTINUOUSLY or raises the existing
%      singleton*.
%

%      H = READ_CONTINUOUSLY returns the handle to a new READ_CONTINUOUSLY or the handle to
%      the existing singleton*.


%
%      READ_CONTINUOUSLY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in READ_CONTINUOUSLY.M with the given input arguments.
%
%      READ_CONTINUOUSLY('Property','Value',...) creates a new READ_CONTINUOUSLY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before read_continuously_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application


%      stop.  All inputs are passed to read_continuously_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%      See comments in the script for more information.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%--------------------------------------------------------------------
% Overview: we store several different data items in the handles variable,
% including a board object that handles communication to the board.
%
% When you hit 'Run', we start a timer, whose callback reads data from
% board and plots it.  Note that this strategy runs into problems if you
% have 256 channels, save, and run at 30 kHz.  This example is not
% optimized for that high a throughput.  See read_optimized for a
% non-GUIDE, optimized example.  We have successfully run the current
% script with:
%    * 256 channels at 20 kHz while saving
%    * 192 channels at 30 kHz while saving
%    * 256 channels at 30 kHz, not saving
%
% See individual callbacks for more information.


% Edit the above text to modify the response to help read_continuously

% Last Modified by GUIDE v2.5 03-Jun-2024 15:49:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @read_continuously_OpeningFcn, ...
                   'gui_OutputFcn',  @read_continuously_OutputFcn, ...
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

%--------------------------------------------------------------------
% --- Executes just before read_continuously is made visible.
function read_continuously_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to read_continuously (see VARARGIN)

% Attach to a board
handles.COM_No=5;
handles.audio_record = 1;
handles.arduino=serial('COM200'); %with a impossibly big number to avoid all possible conflict. just to initialise the serial class

handles.driver = rhd2000.Driver;

handles.spectre_refresh_every = 1; % Jingyuan
handles.spectre_lastsave = now*24*3600; % Jingyuan the last time we collect the data in the past 3s; the value renew every 60 points
handles.spectre_lastcal = now*24*3600; % Jingyuan the last time we calculate the spectre density ; the value renew every 3s
handles.spectre_counter = 0;  % Jingyuan note relative calculation time of the spectre data
handles.fire_lastcounter = 0; % the number of detection beyond threshold from 0s to (now-3)s
handles.detection_lastcounter=0;
handles.detections=0;

handles.boardUI = BoardUI(handles.driver.create_board(), ...
                          handles.sleep_stage,handles.phase_space, handles.gamma_distribution,...
                          handles.ratio_distribution, handles.chips, handles.channels_to_display, ...
                          handles.FifoLag, handles.FifoPercentageFull,2);  %Jingyuan
handles.boardUI.Plot.sound_tone = 0; % default sound is tone

handles.saveUI = SaveConfigUI(handles.intan, handles.file_per_signal_type, ...
                              handles.file_per_channel, handles.save_file_dialog);

% Initialize the sampling rate in the popup to the one from the board.
% Note that the board is 0-based; the popup is 1-based
set(handles.sampling_rate_popup, 'Value', handles.boardUI.Board.SamplingRate + 1);

handles.fire_counter=0;
handles.detection_counter=0;

handles.detections_exist=0;
handles.fires_exist=0;

handles.matrix_digin=0; 
handles.curseur_digin=1;


%Stim is that way impossible before you use the ChangeStim OK push button
%and so that you chose your parameters

handles.stimulation_status = 0;
handles.fired = 0;
handles.inprogress = 0;
handles.boardUI.Board.DigitalOutputs(13)=0;

handles.boardUI.webcaminit(handles.webcam);
% When running, we'll refresh the plot every three times through the timer
% callback function
handles.refresh_every = 3;
handles.refresh_count = 0;


handles.gamma_threshold=6.5; %Default value for the threshold
handles.ratio_threshold=1.1;% Default value for the ratio
% Clear the saving information
handles.saving = true;
handles.saveUI.BaseName = '';

% Create a timer - it's used when you click Run
handles.timer = timer(...
    'ExecutionMode', 'fixedSpacing', ...       % Run timer repeatedly
    'Period', 0.001, ...
    'TimerFcn', {@update_display,hObject}); % Specify callback

% Choose default command line output for read_continuously
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
% GUIDE generated this; no changes
function sampling_rate_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_rate_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
% GUIDE generated this; no changes
function chips_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
% GUIDE generated this; no changes
function channels_to_display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channels_to_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------

% --- Executes on selection change in channels_to_display.
% GUIDE generated this; no changes
function channels_to_display_Callback(hObject, eventdata, handles)
% hObject    handle to channels_to_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channels_to_display contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channels_to_display

%--------------------------------------------------------------------

% --- Outputs from this function are returned to the command line.
% GUIDE generated this; no changes
function varargout = read_continuously_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%--------------------------------------------------------------------

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Enable/disable UI elements as appropriate
%initialise the counters
handles.boardUI.Plot.counter=ceil(handles.boardUI.Plot.countermax)+1;
handles.boardUI.Plot.counter_detection=ceil(handles.boardUI.Plot.countermax_detection)+1;

%UI set up
set(handles.sampling_rate_popup, 'Enable', 'off');
set(handles.stop_button, 'Enable', 'on');
handles.saveUI.Enable = 'off';
set(hObject, 'Enable', 'off');
set(handles.save_box,'Enable','off');
set(handles.chips,'Enable','off');
set(handles.channels_to_display,'Enable','off');


if handles.saving==1
    handles=start_saving(handles);
    handles.matrix_digin=0; %initialise the matrix_digin for every run
end

% Set the chunk_size; this is used in the timer callback function
config_params = handles.boardUI.Board.get_configuration_parameters();

% added by SB november 2018

config_params.Chip.Bandwidth.DesiredDsp = 0.1;
handles.boardUI.Board.set_configuration_parameters(config_params)

handles.chunk_size = config_params.Driver.NumBlocksToRead;

% Create a datablock for reuse
handles.datablock = rhd2000.datablock.DataBlock(handles.boardUI.Board);

% Tell the board to run continuously
handles.boardUI.Board.run_continuously();
%handles.boardUI.Board.DigitalOutputs=zeros(1,16);
handles.last_status=0;

handles.boardUI.set_channels_chips();

handles.fires=0;

handles.last_db_digin=zeros(1,60); %???
handles.boardUI.Board.DigitalOutputs(13)=0; %stim output to arduino


handles.allresult = [];%Jingyuan

% Update handles structure
guidata(hObject, handles);   
            
% Start the timer
start(handles.timer);

%--------------------------------------------------------------------

% --- Executes on button press in stop_button.
% This is mostly the opposite of run_button_Callback, in reverse order
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stop the timer; it's important to do this first so we don't call the
% timer callback while we're in the middle of doing the rest of the
% operations in this function

handles.boardUI.Board.DigitalOutputs(13)=0;  % Make sure to stop the in progress Stimulation
stop(handles.timer);

% Stop and flush the board
handles.boardUI.Board.stop();
handles.boardUI.Board.flush();

% Free the datablock
if isfield(handles, 'datablock')
    delete(handles.datablock);
    handles.datablock = [];
end

if handles.saving==1
    handles=stop_saving(handles);
end

% save the data concerning spectre plot Jingyuan
if handles.saving
    allresult = handles.allresult;
    if handles.saveUI.Format==0 %if intan format
        save([handles.pathandname, '_sleepstage.mat'],'allresult');
    else
        save([handles.pathandname, '\sleepstage.mat'],'allresult');
    end
    clear allresult;
end

if handles.fires_exist==1 && handles.saving
    fires=handles.fires;
    if handles.saveUI.Format==0 %if intan format
        save([handles.pathandname, '_fires_matrix.mat'],'fires');
    else
        save([handles.pathandname, '\fires_matrix.mat'],'fires');
    end
    %clear fires
end

% save the digin matrix
if handles.saving
    digin=handles.matrix_digin;
    
    if length(digin)>1
        if handles.saveUI.Format==0 %if intan format
            save([handles.pathandname, '_digin_matrix.mat'],'digin');
        else
            save([handles.pathandname, '\digin_matrix.mat'],'digin');
        end
    end
    
    fires=handles.fires;
    fires=fires(2:end,1);
    if exist('fires_actual_time','var')
        if length(fires)==length(fires_actual_time)
            fires_delay = fires_actual_time-fires;
            if handles.saveUI.Format==0 %if intan format
                save([handles.pathandname, '_fires_delay.mat'],'fires_delay');
            else
                save([handles.pathandname, '\fires_delay.mat'],'fires_delay');
            end
        end
    end
    clear digin fires;    
end




if handles.saving
    AllParameters.bullChannel =handles.boardUI.Plot.bullchannel-1;
    AllParameters.thetaChannel = handles.boardUI.Plot.Thetachannel-1;
    AllParameters.gammaThreshold = handles.gamma_threshold;
    AllParameters.ratioThreshold = handles.ratio_threshold;
    if handles.boardUI.Plot.stimulation_status == 1 
        AllParameters.durationStim = handles.boardUI.Plot.durationStim;
        AllParameters.StimState = handles.boardUI.Plot.StimState;
        AllParameters.consolidationTime = handles.boardUI.Plot.consolidationTime;
        AllParameters.InterStimTime = handles.boardUI.Plot.InterStimTime;
    else
        AllParameters.durationStim = 0;
        AllParameters.StimState = 0;
        AllParameters.consolidationTime = 0;
        AllParameters.InterStimTime = 0;
    end
    
    if handles.saveUI.Format==0 %if intan format
        save([handles.pathandname, '_AllParameters.mat'],'AllParameters');
    else
        save([handles.pathandname, '\AllParameters.mat'],'AllParameters');
    end
end



% Enable/disable UI elements as appropriate
if ~isempty(handles.saveUI.BaseName)
    set(handles.save_box,'Enable','on');
end
set(handles.sampling_rate_popup, 'Enable', 'on');
set(handles.run_button, 'Enable', 'on');
handles.saveUI.Enable = 'on';
handles.boardUI.Plot.detec_status=0;






set(hObject, 'Enable', 'off');


%--------------------------------------------------------------------

% --- Executes on selection change in sampling_rate_popup.
function sampling_rate_popup_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_rate_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set the board's sampling rate to the one the user selected
selection = get(hObject, 'Value');
handles.boardUI.Board.SamplingRate = rhd2000.SamplingRate(selection - 1);

%--------------------------------------------------------------------

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Delete the timer
if isfield(handles, 'timer')
    delete(handles.timer);
end

if strcmp(handles.arduino.Status,'open')
fclose(handles.arduino);
end

% Hint: delete(hObject) closes the figure
delete(hObject);

%--------------------------------------------------------------------

% --- Timer callback
% This function reads one chunk of data and adds it to the
% handles.boardUI.Amplifiers matrix.  Every third time through, it updates the plot
% on the screen.  It saves data to disk if appropriate.
function update_display(hObject,eventdata,hfigure)  

handles = guidata(hfigure);

% The API's chunk size is about 1/30th of a second's worth of data.  When
% we read from the API, we get that amount of data from the board into
% memory; we just go ahead and plot all the in-memory data.

for i=1:handles.chunk_size
    % Get data from the API.
    handles.datablock.read_next(handles.boardUI.Board);
    %handles.boardUI.process_data_block(handles.datablock,handles.arduino,handles.filter_activated);  
    %The line over seems to process only the delta waves
    handles.boardUI.Spectre_data_block(handles.datablock);
    
    %In original code : "write to detection matrix in workspace" --> only for
    %the detection of delta wave handles.boardUI.Plot.detected=1 is updated in
    %DeltaDetection.m
    % also an fired matrix which seems to be linked to the deltawaves which
    % have been triggered by sound.
    
    
    if handles.saving
        handles.datablock.save(); 
        index=find(sum(handles.datablock.Board.DigitalInputs(1:4,:),1));
        len=length(index);
        if len~=0
            handles.matrix_digin(handles.curseur_digin:handles.curseur_digin+len-1)=...
                handles.datablock.Timestamps(index); 
            handles.curseur_digin=handles.curseur_digin+len;
        end
    end 
end

% Every third time through, update the plot in the UI.  The UI becomes
% unresponsive if we try to do this every time through, so we update 10
% times a second instead.
if (handles.refresh_count == 0)
    handles.refresh_count = handles.refresh_every;
    handles.boardUI.refresh_fifo();
end
handles.refresh_count = handles.refresh_count - 1;
    handles.boardUI.refresh_fifo();
    handles.spectre_nowtime = now*24*3600;
    
if (handles.spectre_nowtime >= (handles.spectre_lastcal + handles.spectre_refresh_every ))
    
    
    handles.boardUI.hilbert_process(); 
    handles.boardUI.refreshWebcam(handles.webcam);
    handles.allresult = [handles.allresult;handles.spectre_counter,...
                           double(handles.datablock.Timestamps(end))/20000,handles.boardUI.Plot.result,-1,-1];
                       % add the calcualation reslut to the matrices
                       % the last -1 separately means no setting of detection threshold
     handles.boardUI.refresh_phasespace(handles.allresult(:,1),handles.allresult(:,3),handles.allresult(:,6)); 
     %Jingyuan refresh  2D phase space and distribution the 3rd and 7rd column is gamma and theta/delta ratio
        
    
    if (handles.boardUI.Plot.threshold_status == 1)
        
        %show the sleepstage on screen and INTAN communication
        if handles.boardUI.Plot.SleepState==3
            set (handles.sleepStage,'string','Wake');
            set (handles.sleepStage,'ForegroundColor',[0.7 0 0]);
            set (handles.timerNREM,'string',strcat(num2str(handles.boardUI.Plot.timerWake),'s'));
            handles.allresult(end,9) = 3; % 3 means Wake
            handles.boardUI.setDigitalOutput(3);
            handles.CurrentState = 3;
            handles.TimerState = handles.boardUI.Plot.timerWake;
            %Uncomment bellow if you are interested by waketheta
            %classification : 
            % if handles.boardUI.Plot.WakeTheta==1
            %     handles.boardUI.setDigitalOutput(4);
            % else
            %     handles.boardUI.setDigitalOutput(3);
            % end
        elseif handles.boardUI.Plot.SleepState==2%
            set (handles.sleepStage,'string','REM');
            set (handles.sleepStage,'ForegroundColor',[0 0 0.5]);
            set (handles.timerNREM,'string',strcat(num2str(handles.boardUI.Plot.timerREM),'s'));
            handles.allresult(end,9) = 2; % 2 means REM
            handles.boardUI.setDigitalOutput(2);
            handles.CurrentState = 2;
            handles.TimerState = handles.boardUI.Plot.timerREM;
        elseif handles.boardUI.Plot.SleepState==1%
            set (handles.sleepStage,'string','NREM');
            set (handles.sleepStage,'ForegroundColor',[0 0.7 0]);
            handles.allresult (end,9) = 1;% 1 means SWS
            set (handles.timerNREM,'string',strcat(num2str(handles.boardUI.Plot.timerNREM),'s'));
            handles.boardUI.setDigitalOutput(1);
            handles.CurrentState = 1;
            handles.TimerState = handles.boardUI.Plot.timerNREM;
        end
        
        %Update the hypnogram parameters
        set(handles.slider2,'Max',handles.boardUI.Plot.recordingTime);
        if get(handles.slider2,'Value')>handles.boardUI.Plot.recordingTime*0.9
            set(handles.slider2,'Value',handles.boardUI.Plot.recordingTime);
        end
        handles.boardUI.Plot.maxSleepstages = get(handles.slider2, 'Value');
        if(handles.boardUI.Plot.recordingTime<3600)
            set(handles.slider2,'SliderStep', [1, 1]);
        else
            set(handles.slider2,'SliderStep', [3600/handles.boardUI.Plot.recordingTime, 3600/handles.boardUI.Plot.recordingTime]);
        end
        handles.boardUI.refresh_sleepstage(handles.allresult(:,1),handles.allresult(:,9)); % draw the hyponogram
        %set(handles.deltaDensity,'string',num2str(handles.boardUI.Plot.deltaDensity));
        if isprop(handles.boardUI.Plot.GMModel,'NumVariables')
            set(handles.wakeProb,'String',strcat('Wake: ',num2str(handles.boardUI.Plot.probWake*100,'%.1f'),'%'));
            set(handles.REMprob,'String',strcat('REM: ',num2str(handles.boardUI.Plot.probREM*100,'%.1f'),'%'));
            set(handles.NREMprob,'String',strcat('NREM: ',num2str(handles.boardUI.Plot.probNREM*100,'%.1f'),'%'));
        end
        
        
        %% Sleeping statistics
        set (handles.text75,'string',num2str(sum(handles.allresult(:,9)==1)/60,'%.2f'   ));
        set (handles.text77,'string',num2str( 100 * sum(handles.allresult(:,9)==1) / nnz(handles.allresult(:,9)+1),'%.2f' ) );
        set (handles.numberNREM,'string',num2str(sum(diff([1 handles.allresult(:,9)'==1 1])>0)-1) );
        set (handles.meanNREM,'string',num2str((sum(handles.allresult(:,9)==1))/(sum(diff([1 handles.allresult(:,9)'==1 1])>0)-1)) );
        set (handles.text80,'string',num2str(sum(handles.allresult(:,9)==2)/60,'%.2f'));
        set (handles.text81,'string',num2str( 100 * sum(handles.allresult(:,9)==2) / nnz(handles.allresult(:,9)+1),'%.2f' ) );
        set (handles.numberREM,'string',num2str(sum(diff([1 handles.allresult(:,9)'==2 1])>0)-1) );
        set (handles.meanREM,'string',num2str((sum(handles.allresult(:,9)==2))/(sum(diff([1 handles.allresult(:,9)'==2 1])>0)-1)) );
        set (handles.text82,'string',num2str(sum(handles.allresult(:,9)==3)/60,'%.2f'));
        set (handles.text83,'string',num2str( 100 * sum(handles.allresult(:,9)==3) / nnz(handles.allresult(:,9)+1),'%.2f' ) );
        set (handles.numberWake,'string',num2str(sum(diff([1 handles.allresult(:,9)'==3 1])>0)-1) );
        set (handles.meanWake,'string',num2str((sum(handles.allresult(:,9)==3))/(sum(diff([1 handles.allresult(:,9)'==3 1])>0)-1)) );
    
        %%%% Stimulation during Specific sleep states
        if handles.boardUI.Plot.stimulation_status == 1
            %Start Stimulation
            if handles.inprogress
                if toc(handles.boardUI.Plot.TimeStim) > handles.boardUI.Plot.durationStim
                    set (handles.triggertext,'string','Waiting for Interval');
                    handles.inprogress = 0;
                    handles.boardUI.Board.DigitalOutputs(13)=0;
                    handles.boardUI.Plot.Last_Stim = tic;
                end
            elseif handles.boardUI.Plot.First_Stim == 1 || toc(handles.boardUI.Plot.Last_Stim) >= handles.boardUI.Plot.InterStimTime
                set (handles.triggertext,'string','Ready to Stimulate...');
                if handles.TimerState >= handles.boardUI.Plot.consolidationTime
                    if handles.CurrentState == handles.boardUI.Plot.StimState
                        handles.boardUI.Board.DigitalOutputs(13)=1;
                        set (handles.triggertext,'string','Stimulation In progress !!!');
                        handles.boardUI.Plot.TimeStim = tic;
                        handles.fired=1;
                        handles.inprogress = 1;
                        handles.boardUI.Plot.First_Stim = 0;
                    end
                end
                %Stop the stim after the selected time
            end
        end
        
        if handles.fired==1
            handles.fire_counter=handles.fire_counter+1;
            handles.fires(handles.fire_counter,1)=double(handles.datablock.Timestamps(1))/frequency(handles.boardUI.Board.SamplingRate)*10000; % en 0.1ms
            handles.fires(handles.fire_counter,2)=handles.boardUI.Plot.durationStim;
            handles.fires(handles.fire_counter,3)=handles.boardUI.Plot.consolidationTime;
            handles.fires(handles.fire_counter,4)=handles.boardUI.Plot.InterStimTime;
            handles.fires(handles.fire_counter,5)=handles.boardUI.Plot.StimState;
            
            handles.fired=0;
            handles.fires_exist=1;   
        end
    
    end
    handles.spectre_lastcal = handles.spectre_nowtime;
    handles.spectre_counter = handles.spectre_counter + handles.spectre_refresh_every;
    handles.boardUI.Plot.result=[];
    
end
% Update handles structure
guidata(hfigure, handles);

%--------------------------------------------------------------------

% --- Executes on selection change in chips.
% Called when you pick a new chip from the popup.  See set_chip for
% details.
function chips_Callback(hObject, eventdata, handles)
% hObject    handle to chips (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.boardUI.set_chip();

% Update handles structure
guidata(hObject, handles);

%--------------------------------------------------------------------

% --- Executes when you click Set Base Path...
function save_file_dialog_Callback(hObject, eventdata, handles)
% hObject    handle to save_file_dialog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.saveUI.save_dialog();

if ~isempty(handles.saveUI.BaseName)
    % Enable the Save checkbox.
    set(handles.save_box, 'Enable', 'on');
    % Update handles structure
    guidata(hObject, handles);
end

%--------------------------------------------------------------------

% --- Executes when you check/uncheck the Save checkbox
function save_box_Callback(hObject, eventdata, handles)
% hObject    handle to save_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject, 'Value') == 1
    if ~handles.saving
        % If were not saving, and someone clicks the checkbox, start saving

        %start_saving(hObject, handles);
        handles.saving = true;
    end
else
    if handles.saving
        % If we're saving, and someone turns off the Save checkbox, stop
        % saving
        
        %stop_saving(hObject, handles);
        handles.saving = false;
    end
    
end
guidata(hObject,handles);

%--------------------------------------------------------------------

function handles = start_saving(handles)
% hObject    handle to save_box (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Get format
format = handles.saveUI.Format;

% Get path of the form <directory><name>_<timestamp><extension>
[pathstr, name, ext] = fileparts(handles.saveUI.BaseName);
% Add timestamp
name = strcat(name, '_', datestr(now, 'yyyymmdd_HHMMSS'));
path = fullfile(pathstr,[name ext]);
handles.pathandname=fullfile(pathstr,name);%Kejian

% Open the save file and set the 'saving' variable
sigr = handles.boardUI.Board.SaveFile.SignalGroups;
sigr{5,1}.Channels{1,1}.Enabled = 1; %audio file
sigr{5,1}.Channels{2,1}.Enabled = 1; %audio file - envelope
sigr{5,1}.Channels{3,1}.Enabled = 1; %audio file - gating
sigr{5,1}.Channels{4,1}.Enabled = 1; %REM Trigger
sigr{6,1}.Channels{1,1}.Enabled=1; %Save digin
sigr{6,1}.Channels{2,1}.Enabled=1;
sigr{6,1}.Channels{3,1}.Enabled=1;
sigr{6,1}.Channels{4,1}.Enabled=1;
sigr{6,1}.Channels{5,1}.Enabled=1;
sigr{6,1}.Channels{6,1}.Enabled=1;
sigr{6,1}.Channels{7,1}.Enabled=1;
sigr{6,1}.Channels{8,1}.Enabled=1;
sigr{6,1}.Channels{9,1}.Enabled=1;
sigr{6,1}.Channels{10,1}.Enabled=1;
sigr{6,1}.Channels{11,1}.Enabled=1;
sigr{6,1}.Channels{12,1}.Enabled=1;
sigr{6,1}.Channels{13,1}.Enabled=1;
sigr{6,1}.Channels{14,1}.Enabled=1;
sigr{6,1}.Channels{15,1}.Enabled=1;
sigr{6,1}.Channels{16,1}.Enabled=1;
handles.boardUI.Board.SaveFile.SignalGroups = sigr;
handles.boardUI.Board.SaveFile.open(format, path);

% Update handles structure
%guidata(hObject, handles);

%--------------------------------------------------------------------

function handles = stop_saving(handles)
% hObject    handle to save_box (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

        
% Turn the 'saving' variable off.  We need to do this (including 
% the update) before closing the save file to be safe if the timer 
% callback function executes.
%handles.saving = false;
% Update handles structure.  
%guidata(hObject, handles);

% Now tell the API to close the save file
handles.boardUI.Board.SaveFile.close();











% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


function filter_fmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filter_fmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filter_fmax_edit as text
%        str2double(get(hObject,'String')) returns contents of filter_fmax_edit as a double
handles.filter_fmax=str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function filter_fmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_fmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function gammaThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to gammaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaThreshold as text
%        str2double(get(hObject,'String')) returns contents of gammaThreshold as a double
handles.gamma_threshold=(str2double(get(hObject,'String')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function gammaThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetaDeltaThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to thetaDeltaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetaDeltaThreshold as text
%        str2double(get(hObject,'String')) returns contents of thetaDeltaThreshold as a double
handles.ratio_threshold=(str2double(get(hObject,'String')));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function thetaDeltaThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetaDeltaThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles) %Jingyuan OK button for set the threshold
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ratio_threshold=(str2double(get(handles.thetaDeltaThreshold,'String')));
handles.gamma_threshold=(str2double(get(handles.gammaThreshold,'String')));
handles.boardUI.Plot.threshold_status = 1;
handles.boardUI.set_thethreshold(handles.gamma_threshold,handles.ratio_threshold);





% --- Executes on button press in loadChannel.
function loadChannel_Callback(hObject, eventdata, handles)
% hObject    handle to loadChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename1,filepath1]=uigetfile({'*.*','All Files'},'Select Data File 1');
file=strcat(filepath1,filename1);
handles.loadParams =load(file);
            
%             
% obj.Plot.bullchannel=obj.Plot.AllParameters.bullChannel+1;
% obj.Plot.Deltachannel=obj.Plot.AllParameters.thetaChannel+1;
% obj.Plot.Thetachannel=obj.Plot.AllParameters.thetaChannel+1;


set(handles.bullChannelText,'String',handles.loadParams.AllParameters.bullChannel);
set(handles.thetaChannelText,'String',handles.loadParams.AllParameters.thetaChannel);
set(handles.thetaDeltaThreshold,'String',handles.loadParams.AllParameters.ratioThreshold);
set(handles.gammaThreshold,'String',handles.loadParams.AllParameters.gammaThreshold);
set(handles.durationStimText,'String',handles.loadParams.AllParameters.durationStim);
set(handles.InterStimTimeText,'String',handles.loadParams.AllParameters.InterStimTime);
set(handles.consolidationTimeText,'String',handles.loadParams.AllParameters.consolidationTime);

if handles.loadParams.AllParameters.StimState == 1
    set(handles.triggerNREM, 'Value', 1);
elseif handles.loadParams.AllParameters.StimState == 3
    set(handles.triggerWAKE, 'Value', 1);
else
    set(handles.triggerREM, 'Value', 1);
end






function bullChannelText_Callback(hObject, eventdata, handles)
% hObject    handle to bullChannelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bullChannelText as text
%        str2double(get(hObject,'String')) returns contents of bullChannelText as a double


% --- Executes during object creation, after setting all properties.
function bullChannelText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bullChannelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thetaChannelText_Callback(hObject, eventdata, handles)
% hObject    handle to thetaChannelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thetaChannelText as text
%        str2double(get(hObject,'String')) returns contents of thetaChannelText as a double


% --- Executes during object creation, after setting all properties.
function thetaChannelText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thetaChannelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaChannelText_Callback(hObject, eventdata, handles)
% hObject    handle to deltaChannelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaChannelText as text
%        str2double(get(hObject,'String')) returns contents of deltaChannelText as a double


% --- Executes during object creation, after setting all properties.
function deltaChannelText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaChannelText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openNeuroscope.
function openNeuroscope_Callback(hObject, eventdata, handles)
% hObject    handle to openNeuroscope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    path=strsplit(handles.boardUI.paramsFile,filesep);
    mouseName=strsplit(path{end},'.');
    mouseName=mouseName{1};
    path=fullfile(path{1:end-1},'Neuroscope',mouseName);
    copyfile(path,handles.pathandname);
end
winopen(handles.pathandname);



% --- Executes on button press in recomputeHypnogram.
function recomputeHypnogram_Callback(hObject, eventdata, handles)
% hObject    handle to recomputeHypnogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allresultUp=recomputeHypnogram(handles.allresult,10^handles.gamma_threshold,10^handles.ratio_threshold);
handles.allresult=allresultUp;
guidata(hObject,handles);




% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.boardUI.Plot.maxSleepstages = get(hObject, 'Value'); 


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Max',eps);
set(hObject,'SliderStep', [eps, eps]);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in changeChannels.
function changeChannels_Callback(hObject, eventdata, handles)
% hObject    handle to changeChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.boardUI.Plot.bullchannel=str2num(get(handles.bullChannelText,'String'))+1;
handles.boardUI.Plot.Thetachannel=str2num(get(handles.thetaChannelText,'String'))+1;


% --- Executes on button press in computeTransitions.
function computeTransitions_Callback(hObject, eventdata, handles)
% hObject    handle to computeTransitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
computeTransitions(handles.allresult(:,9));



% --- Executes on button press in createEvt.
function createEvt_Callback(hObject, eventdata, handles)
% hObject    handle to createEvt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%extension evt
extens = 'det'; %detection

%filename
filename = 'onlineStimulation';

%evt
evt.time = handles.fires(:,1)/1E4; %in sec
for i=1:length(evt.time)
    evt.description{i}= 'online_Stimulation';
end

%create file
CreateEvent(evt, filename, extens);
movefile('onlineStimulation.evt.det',handles.pathandname);




% --- Executes on button press in enableGM.
function fitGM_Callback(hObject, eventdata, handles)
% hObject    handle to fitGM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
fitGMM(handles.allresult,handles.boardUI.Plot);



function InterStimTimeText_Callback(hObject, eventdata, handles)
% hObject    handle to InterStimTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InterStimTimeText as text
%        str2double(get(hObject,'String')) returns contents of InterStimTimeText as a double


% --- Executes during object creation, after setting all properties.
function InterStimTimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InterStimTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationStimText_Callback(hObject, eventdata, handles)
% hObject    handle to durationStimText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationStimText as text
%        str2double(get(hObject,'String')) returns contents of durationStimText as a double


% --- Executes during object creation, after setting all properties.
function durationStimText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationStimText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function consolidationTimeText_Callback(hObject, eventdata, handles)
% hObject    handle to consolidationTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of consolidationTimeText as text
%        str2double(get(hObject,'String')) returns contents of consolidationTimeText as a double


% --- Executes during object creation, after setting all properties.
function consolidationTimeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to consolidationTimeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function triggerREM_Callback(hObject, eventdata, handles)
% hObject    handle to durationStimText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationStimText as text
%        str2double(get(hObject,'String')) returns contents of durationStimText as a double

function triggerNREM_Callback(hObject, eventdata, handles)
% hObject    handle to durationStimText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationStimText as text
%        str2double(get(hObject,'String')) returns contents of durationStimText as a double

function triggerWAKE_Callback(hObject, eventdata, handles)
% hObject    handle to durationStimText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationStimText as text
%        str2double(get(hObject,'String')) returns contents of durationStimText as a double



% --- Executes on button press in ChangeStim.
function ChangeStim_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.boardUI.Plot.stimulation_status = 1;

handles.boardUI.Plot.Last_Stim = tic;
handles.boardUI.Plot.First_Stim = 1;
handles.boardUI.Plot.durationStim=str2num(get(handles.durationStimText,'String'));
handles.boardUI.Plot.InterStimTime=str2num(get(handles.InterStimTimeText,'String'));
handles.boardUI.Plot.consolidationTime=str2num(get(handles.consolidationTimeText,'String'));
set (handles.triggertext,'string','Ready to Stimulate...');

if handles.triggerNREM.Value ==1
    handles.boardUI.Plot.StimState = 1;
elseif handles.triggerREM.Value ==1
    handles.boardUI.Plot.StimState = 2;
elseif handles.triggerWAKE.Value ==1
    handles.boardUI.Plot.StimState = 3;
end





