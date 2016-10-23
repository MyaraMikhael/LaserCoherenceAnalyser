function varargout = LinewidthExplorerGUI(varargin)
% LINEWIDTHEXPLORERGUI MATLAB code for LinewidthExplorerGUI.fig
%      LINEWIDTHEXPLORERGUI, by itself, creates a new LINEWIDTHEXPLORERGUI or raises the existing
%      singleton.
%      
%      Is a GUI (Graphic User INterface) for LaserLine Explorer. Permits to
%      define the "good" conditions of sample simplifications to reach
%      acceptable computation time with accurate results.
%      by M. Myara
%
%      for Optics Express 2016 Article "Time-Dependant Laser Linewidth :
%      beat-note digital acquisition and numerical analysis",
%      N.Von Bandel, M. Myara, M. Sellahi, T. Souici, R. Dardaillon and P.
%      Signoret.
%
%      This Code is under BSD Licence. 
%      Please cite our Optics Express publication if you use
%      this software or part of this software in the frame of 
%      scientific works or publications
%
%      Please mention the three authors of this software if you reuse this 
%      code or part of this code in another software
%
%
%
%      H = LINEWIDTHEXPLORERGUI returns the handle to a new LINEWIDTHEXPLORERGUI or the handle to
%      the existing singleton*.
%
%      LINEWIDTHEXPLORERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINEWIDTHEXPLORERGUI.M with the given input arguments.
%
%      LINEWIDTHEXPLORERGUI('Property','Value',...) creates a new LINEWIDTHEXPLORERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LinewidthExplorerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LinewidthExplorerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LinewidthExplorerGUI


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LinewidthExplorerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LinewidthExplorerGUI_OutputFcn, ...
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


% --- Executes just before LinewidthExplorerGUI is made visible.
function LinewidthExplorerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LinewidthExplorerGUI (see VARARGIN)

% Choose default command line output for LinewidthExplorerGUI
handles.output = hObject;

% Update handles structure
uiProgressBar(handles.progressBar);

handles.LaserLineExplorer = LaserLineExplorer;
set(handles.HPF,'String',sprintf('%e',handles.LaserLineExplorer.HPFilter));
set(handles.LPF,'String',sprintf('%e',handles.LaserLineExplorer.LPFilter));
set(handles.maxPoints,'String',num2str(handles.LaserLineExplorer.maxPoints));
set(handles.minLor,'String',sprintf('%.2e',handles.LaserLineExplorer.LLWEstimation(1)));
set(handles.startLor,'String',sprintf('%.2e',handles.LaserLineExplorer.LLWEstimation(2)));
set(handles.maxLor,'String',sprintf('%.2e',handles.LaserLineExplorer.LLWEstimation(3)));
set(handles.minGauss,'String',sprintf('%.2e',handles.LaserLineExplorer.GLWEstimation(1)));
set(handles.startGauss,'String',sprintf('%.2e',handles.LaserLineExplorer.GLWEstimation(2)));
set(handles.maxGauss,'String',sprintf('%.2e',handles.LaserLineExplorer.GLWEstimation(3)));
guidata(hObject, handles);

% UIWAIT makes LinewidthExplorerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LinewidthExplorerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SetDataFileName.
function SetDataFileName_Callback(hObject, eventdata, handles)
% hObject    handle to SetDataFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[guiFileName,guiPath] = uigetfile('');
if ~isempty(guiPath)
    handles.LaserLineExplorer.dataFile = [guiPath filesep guiFileName];
    set(handles.DataPathEdit,'String',handles.LaserLineExplorer.dataFile);
end

function DataPathEdit_Callback(hObject, eventdata, handles)
% hObject    handle to DataPathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataPathEdit as text
%        str2double(get(hObject,'String')) returns contents of DataPathEdit as a double


% --- Executes during object creation, after setting all properties.
function DataPathEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataPathEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.isComputing,'String','Analyse des données en cours ...');
set(handles.isComputing,'ForegroundColor',[1,0,0]);
drawnow();

[min,max] = handles.LaserLineExplorer.loadData();
set(handles.IntegrrationTimeSlider,'Min',min); 
set(handles.IntegrrationTimeSlider,'Max',max);
set(handles.IntegrrationTimeSlider,'Value',min); 
set(handles.IntegrrationTimeSlider, 'SliderStep',[1/(max-min) 10/(max-min)]);
changePointsAmount(handles,min,handles.IntegrationTimeValue);

set(handles.TminSlider,'Min',min); 
set(handles.TminSlider,'Max',max);
set(handles.TminSlider,'Value',min); 
set(handles.TminSlider, 'SliderStep',[1/(max-min) 10/(max-min)]);
changePointsAmount(handles,min,handles.TminText);

set(handles.TmaxSlider,'Min',min); 
set(handles.TmaxSlider,'Max',max);
set(handles.TmaxSlider,'Value',max); 
set(handles.TmaxSlider, 'SliderStep',[1/(max-min) 10/(max-min)]);
changePointsAmount(handles,max,handles.TmaxText);
set(handles.isComputing,'String','No Processing.');
set(handles.isComputing,'ForegroundColor',[0,0,0]);

set(handles.avgAmount,'String',num2str(handles.LaserLineExplorer.maxAvgAmount));

drawnow();
updateMainPlot(handles);



% --- Executes on slider movement.
function OffsetSlider_Callback(hObject, eventdata, handles)
% hObject    handle to OffsetSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
changeOffset(handles,get(hObject,'Value'));
updateMainPlot(handles);

% --- Executes during object creation, after setting all properties.
function OffsetSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OffsetSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function IntegrrationTimeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to IntegrrationTimeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
changePointsAmount(handles,get(hObject,'Value'),handles.IntegrationTimeValue);
updateMainPlot(handles);

% --- Executes during object creation, after setting all properties.
function IntegrrationTimeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntegrrationTimeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function changePointsAmount(handles,k,textFieldID)
    k=floor(k);
    [np,tp] = handles.LaserLineExplorer.getTimeByPower(k);
    str = sprintf('%.3e s  --  %.3e pts',tp,np);
    set(textFieldID,'String',str);
    changeOffset(handles,0);

function changeOffset(handles,offset)
    k = floor(get(handles.IntegrrationTimeSlider,'Value'));
     max_sub = handles.LaserLineExplorer.getSubSpectraAmountByPower(k);
    set(handles.OffsetSlider,'Min',0); 
    set(handles.OffsetSlider,'Max',max_sub-1);
    set(handles.OffsetSlider,'Value',offset); 
    set(handles.OffsetSlider, 'SliderStep',[1/(max_sub) 10/(max_sub)]);
    [n_sub,t_sub] = handles.LaserLineExplorer.getSubSpectrumOffset(k,offset);
    str = sprintf('%.3e s --- %.3e pts',t_sub,n_sub);
    set(handles.OffsetValue,'String',str);

function updateMainPlot(handles)

    k = floor(get(handles.IntegrrationTimeSlider,'Value'));
    numSample = floor(get(handles.OffsetSlider,'Value'));
    length = handles.LaserLineExplorer.getTimeByPower(k);

    offset = handles.LaserLineExplorer.getSubSpectrumOffset(k,numSample);
    set(handles.isComputing,'String','Computing Fourier Transform ...');
    set(handles.isComputing,'ForegroundColor',[1,0,0]);
    drawnow();

    [Y,f] = handles.LaserLineExplorer.PrepareSubSpectrumForFitting(handles.LaserLineExplorer.timeData,...
                                                        handles.LaserLineExplorer.dt,...
                                                        offset,length);
    set(handles.isComputing,'String','No Processing.');
    set(handles.isComputing,'ForegroundColor',[0,0,0]);
    
    
    axes(handles.Plot);
    cla(handles.Plot);
    hold off;
    semilogy(f,Y,'o');
    hold on;
    drawnow();

    set(handles.isComputing,'String','No Processing.');
    set(handles.isComputing,'ForegroundColor',[0,0,0]);
    salehLinewidth =handles.LaserLineExplorer.salehFwhm(f,Y,1);

    set(handles.fwhm,'String',sprintf('Width (Mandel & Wolf) :  %.3e', salehLinewidth));
    handles.f = f;
    handles.Y = Y;
    handles.YSalehFWHM = salehLinewidth;
    guidata(handles.figure1,handles);

function HPF_Callback(hObject, eventdata, handles)
% hObject    handle to HPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HPF as text
%        str2double(get(hObject,'String')) returns contents of HPF as a double


% --- Executes during object creation, after setting all properties.
function HPF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LPF_Callback(hObject, eventdata, handles)
% hObject    handle to LPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LPF as text
%        str2double(get(hObject,'String')) returns contents of LPF as a double


% --- Executes during object creation, after setting all properties.
function LPF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxPoints_Callback(hObject, eventdata, handles)
% hObject    handle to maxPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxPoints as text
%        str2double(get(hObject,'String')) returns contents of maxPoints as a double


% --- Executes during object creation, after setting all properties.
function maxPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LaserLineExplorer.LPFilter = str2double(get(handles.LPF,'String'));
handles.LaserLineExplorer.HPFilter = str2double(get(handles.HPF,'String'));
handles.LaserLineExplorer.maxPoints = str2double(get(handles.maxPoints,'String'));
updateMainPlot(handles);

function addFit(handles)
if(~isempty(handles.f))
    e = handles.LaserLineExplorer.AnalyseSubSpectrumForFitting(handles.f,handles.Y);
    handles.LaserLineExplorer.plotGuessForFit(handles.Plot,e,handles.f);
    handles.LaserLineExplorer.LLWEstimation(1) = str2double(get(handles.minLor,'String'));
    handles.LaserLineExplorer.LLWEstimation(2) = str2double(get(handles.startLor,'String'));
    handles.LaserLineExplorer.LLWEstimation(3) = str2double(get(handles.maxLor,'String'));
    handles.LaserLineExplorer.GLWEstimation(1) = str2double(get(handles.minGauss,'String'));
    handles.LaserLineExplorer.GLWEstimation(2) = str2double(get(handles.startGauss,'String'));
    handles.LaserLineExplorer.GLWEstimation(3) = str2double(get(handles.maxGauss,'String'));
    cf_ = handles.LaserLineExplorer.fitSubSpectrum(handles.f,handles.Y,e);
    handles.LaserLineExplorer.plotFit(cf_,handles.Plot);

     str_LW = sprintf('FWM - Lorentzian part: %.3e Gaussian part: %.3e',cf_.LorLW,cf_.GaussLW);
     set(handles.fwhmPadeh,'String',str_LW);
     
     handles.YVoigtFit = feval(cf_,handles.f);
     handles.YVoigtLor = cf_.LorLW;
     handles.YVoigtGauss = cf_.GaussLW;
     guidata(handles.figure1,handles);

     
%    fwhm (fit voigt/pade) -- lor :   -- gauss : 
end


% --- Executes on button press in fitPadeh.
function fitPadeh_Callback(hObject, eventdata, handles)
% hObject    handle to fitPadeh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.isComputing,'String','Processing Voigt-Pade Fitting ...');
set(handles.isComputing,'ForegroundColor',[1,0,0]);
drawnow();
addFit(handles);
set(handles.isComputing,'String','No Processing.');
set(handles.isComputing,'ForegroundColor',[0,0,0]);


function minLor_Callback(hObject, eventdata, handles)
% hObject    handle to minLor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minLor as text
%        str2double(get(hObject,'String')) returns contents of minLor as a double


% --- Executes during object creation, after setting all properties.
function minLor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minLor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startLor_Callback(hObject, eventdata, handles)
% hObject    handle to startLor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startLor as text
%        str2double(get(hObject,'String')) returns contents of startLor as a double


% --- Executes during object creation, after setting all properties.
function startLor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startLor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxLor_Callback(hObject, eventdata, handles)
% hObject    handle to maxLor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxLor as text
%        str2double(get(hObject,'String')) returns contents of maxLor as a double


% --- Executes during object creation, after setting all properties.
function maxLor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxLor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minGauss_Callback(hObject, eventdata, handles)
% hObject    handle to minGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minGauss as text
%        str2double(get(hObject,'String')) returns contents of minGauss as a double


% --- Executes during object creation, after setting all properties.
function minGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startGauss_Callback(hObject, eventdata, handles)
% hObject    handle to startGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startGauss as text
%        str2double(get(hObject,'String')) returns contents of startGauss as a double


% --- Executes during object creation, after setting all properties.
function startGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxGauss_Callback(hObject, eventdata, handles)
% hObject    handle to maxGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxGauss as text
%        str2double(get(hObject,'String')) returns contents of maxGauss as a double


% --- Executes during object creation, after setting all properties.
function maxGauss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxGauss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function TminSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TminSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
changePointsAmount(handles,get(hObject,'Value'),handles.TminText);


% --- Executes during object creation, after setting all properties.
function TminSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TminSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function TmaxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TmaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
changePointsAmount(handles,get(hObject,'Value'),handles.TmaxText);


% --- Executes during object creation, after setting all properties.
function TmaxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TmaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in activateVoigtFit.
function activateVoigtFit_Callback(hObject, eventdata, handles)
% hObject    handle to activateVoigtFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of activateVoigtFit



function avgAmount_Callback(hObject, eventdata, handles)
% hObject    handle to avgAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avgAmount as text
%        str2double(get(hObject,'String')) returns contents of avgAmount as a double


% --- Executes during object creation, after setting all properties.
function avgAmount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avgAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcLwVsTime.
function calcLwVsTime_Callback(hObject, eventdata, handles)
% hObject    handle to calcLwVsTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
minP = get(handles.TminSlider,'Value');
maxP = get(handles.TmaxSlider,'Value');
maxAvgAmountStr = get(handles.avgAmount,'String');
handles.LaserLineExplorer.maxAvgAmount = str2double(maxAvgAmountStr);
activateVoigtFit = get(handles.activateVoigtFit,'Value');

handles.LaserLineExplorer.setProgressBarHandle(handles.progressBar);
data = handles.LaserLineExplorer.calcLinewidthVsTime(minP,maxP,...
                                                handles.LaserLineExplorer.maxAvgAmount,...
                                                activateVoigtFit);
                                            
handles.lwVsTimeData = data;

figure();
subplot(2,1,1);
hold off;
%spline
% loglog(data.t,data.fwhm_spline_avg,'r'); hold on;
% errorbar(data.t,data.fwhm_spline_avg,data.fwhm_spline_stdev,'r');
loglog(data.t,data.fwhm_saleh_avg,'k'); hold on;
errorbar(data.t,data.fwhm_saleh_avg,data.fwhm_saleh_stdev,'k');


title('Linewidth (Hz) vs time (s)');
leg={'Mandel & Wolf width (moy.)','Mandel & Wolf width (stdev.)'};

if ~isempty(data.fwhm_lor_avg)
hold on;
loglog(data.t,data.fwhm_lor_avg,'b'); hold on;
leg{end+1} = 'Lorentzian part of Voigt profile (moy.)';
errorbar(data.t,data.fwhm_lor_avg,data.fwhm_lor_stdev,'b');
leg{end+1} = 'Lorentzian part of Voigt profile (stdev.)';
loglog(data.t,data.fwhm_gauss_avg,'g'); hold on;
leg{end+1} = 'Gaussian part of Voigt profile FWHM (moy.)';
errorbar(data.t,data.fwhm_gauss_avg,data.fwhm_gauss_stdev,'g');
leg{end+1} = 'Gaussian part of Voigt FWHM profile (stdev.)';
end
legend(leg);

subplot(2,1,2);
hold off;
semilogx(data.t,data.avg_amount,'b');
title('Amount of averages vs time (s)');

guidata(hObject, handles);

% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%export.LwVsTime = 
singleSpectrum.f = handles.f;
singleSpectrum.Y = handles.Y;
singleSpectrum.YSalehFWHM = handles.YSalehFWHM;
if isfield(singleSpectrum, 'YVoigtFit')
    singleSpectrum.YVoigtFit = handles.YVoigtFit';
    singleSpectrum.YVoigtLorFWHM = handles.YVoigtLor;
    singleSpectrum.YVoigtGaussFWHM = handles.YVoigtGauss;
end
LinewidthVsTime = handles.lwVsTimeData;
uisave({'singleSpectrum','LinewidthVsTime'});
