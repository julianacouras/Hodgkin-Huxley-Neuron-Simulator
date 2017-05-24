function varargout = HH_Simulator(varargin)
% HH_SIMULATOR MATLAB code for HH_Simulator.fig
%      HH_SIMULATOR, by itself, creates a new HH_SIMULATOR or raises the existing
%      singleton*.
%
%      H = HH_SIMULATOR returns the handle to a new HH_SIMULATOR or the handle to
%      the existing singleton*.
%
%      HH_SIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HH_SIMULATOR.M with the given input arguments.
%
%      HH_SIMULATOR('Property','Value',...) creates a new HH_SIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HH_Simulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HH_Simulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HH_Simulator

% Last Modified by GUIDE v2.5 24-May-2017 01:01:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HH_Simulator_OpeningFcn, ...
                   'gui_OutputFcn',  @HH_Simulator_OutputFcn, ...
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


% --- Executes just before HH_Simulator is made visible.
function HH_Simulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HH_Simulator (see VARARGIN)

% Choose default command line output for HH_Simulator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HH_Simulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HH_Simulator_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in clamp.
function clamp_Callback(hObject, eventdata, handles)
% hObject    handle to clamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clamp

handles.start.Value=0;
handles.pulso.Value=0;
handles.alternada.Value=0;

Ve = -65; %mV voltagem de membrana em repouso

dt = 0.01;
t_f = 50; %ms duração do recording
t = 0:dt:t_f;

i = handles.clamp.UserData;
dV = handles.dV.Value;
t_Si = t(i); %ms início do estímulo
t_Sf = t(i) + str2double(handles.dur.String);

%corrente clamp
it = @(x) x*100+1; %converte um tempo t no indície correspondente do vetor t
Vc = ones(1,length(t)).*Ve;
Vc(it(t_Si):it(t_Sf))= Ve + dV;

[n m h JL JK JNa gKv gNav]=euler_nmh_clamp(t,Vc);


for j=i:length(t)
    try
    if handles.pulso.Value ==1
        break
    elseif handles.alternada.Value ==1
        break
    elseif handles.start.Value ==1
        break
    end
    aa=plot(handles.axes1,t(1:j),Vc(1:j),'b');
    bb=plot(handles.axes2,t(1:j),JL(1:j),'b', t(1:j), JK(1:j), 'r',t(1:j), JNa(1:j),'g');
    cc=plot(handles.axes3,t(1:j),gKv(1:j), 'r',t(1:j),gNav(1:j),'g');
    drawnow
    %guardar plot
    [xIL, xIK, xINA]=bb.XData;
    [xGK, xGNA]=cc.XData;
    [yIL, yIK, yINA]=bb.YData;
    [yGK, yGNA]=cc.YData;
    handles.save.UserData=[aa.XData;aa.YData;xIL;yIL;xIK;yIK;xINA;yINA;xGK;yGK;xGNA;yGNA];
    catch
        break
    end
end

% --- Executes on slider movement.
function dV_Callback(hObject, eventdata, handles)
% hObject    handle to dV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function dV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function dur_Callback(hObject, eventdata, handles)
% hObject    handle to dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dur as text
%        str2double(get(hObject,'String')) returns contents of dur as a double


% --- Executes during object creation, after setting all properties.
function dur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start

handles.pulso.Value=0;
handles.alternada.Value=0;
handles.clamp.Value=0;

handles.pulso.UserData = zeros(2,50);
handles.Ie_p.UserData = 0;

Ve = -65; %mV voltagem de membrana em repouso

dt = 0.01;
t_f = 50; %ms duração do recording
t = 0:dt:t_f;
Vi = ones(1,length(t)).*Ve;
zz = zeros(1,length(t));

for i= 1:length(t)
    try
    handles.clamp.UserData = i;
    handles.pulso_1.UserData = i;
    handles.alternada.UserData = i;
    if handles.clamp.Value==1
        break
    elseif handles.pulso.Value ==1
        break
    elseif handles.alternada.Value ==1
        break
    end

    plot(handles.axes1,t(1:i),Vi(1:i),'b')
    plot(handles.axes2,t(1:i),zz(1:i),'b')
    plot(handles.axes3,t(1:i),zz(1:i),'b')

    pause(dt)
    catch
        break
    end
end


% --- Executes on button press in pulso.
function pulso_Callback(hObject, eventdata, handles)
% hObject    handle to pulso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pulso

handles.start.Value=0;
handles.clamp.Value=0;
handles.alternada.Value=0;

handles.Ie_p.UserData = handles.Ie_p.UserData +1;
Ve = -65; %mV voltagem de membrana em repouso

dt = 0.01;
t_f = 50; %ms duração do recording
t = 0:dt:t_f;

Ie = handles.Ie_p.Value;
i = handles.pulso_1.UserData;
t_Si = t(i); %ms início do estímulo
t_Sf = t(i) + str2double(handles.dur_pulso.String);

handles.pulso.UserData(:,handles.Ie_p.UserData) = [t_Si;t_Sf];

%corrente single pulse
it = @(x) x*100+1; %converte um tempo t no indície correspondente do vetor t
JE = zeros(1,length(t));


for z = 1:handles.Ie_p.UserData
    ti = handles.pulso.UserData(1,z);
    tf = handles.pulso.UserData(2,z);
    JE(it(ti):it(tf))= Ie;
end

[n m h JL JK JNa gKv gNav V]=euler_nmh_pulse(t,JE);
for j=i:length(t)
    try
    if handles.clamp.Value==1
        break
    elseif handles.alternada.Value ==1
        break
    elseif handles.start.Value==1
        break
    end
    handles.pulso_1.UserData=j;
    aa=plot(handles.axes1,t(1:j),V(1:j));
    bb=plot(handles.axes2,t(1:j),JL(1:j), 'b', t(1:j), JK(1:j), 'r', t(1:j), JNa(1:j), 'g');
    cc=plot(handles.axes3,t(1:j),gKv(1:j), 'r',t(1:j),gNav(1:j),'g');
    drawnow
        %guardar plot
    [xIL, xIK, xINA]=bb.XData;
    [xGK, xGNA]=cc.XData;
    [yIL, yIK, yINA]=bb.YData;
    [yGK, yGNA]=cc.YData;
    handles.save.UserData=[aa.XData;aa.YData;xIL;yIL;xIK;yIK;xINA;yINA;xGK;yGK;xGNA;yGNA];
    catch
        break
    end
end


function dur_pulso_Callback(hObject, eventdata, handles)
% hObject    handle to dur_pulso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dur_pulso as text
%        str2double(get(hObject,'String')) returns contents of dur_pulso as a double




% --- Executes during object creation, after setting all properties.
function dur_pulso_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dur_pulso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Ie_p_Callback(hObject, eventdata, handles)
% hObject    handle to Ie_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Ie_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in alternada.
function alternada_Callback(hObject, eventdata, handles)
% hObject    handle to alternada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of alternada

handles.start.Value=0;
handles.clamp.Value=0;
handles.pulso.Value=0;

f=str2double(handles.freq.String);
Ve = -65; %mV voltagem de membrana em repouso

dt = 0.01;
t_f = 50; %ms duração do recording
t = 0:dt:t_f;

Ie = handles.Ie_a.Value;
i = handles.alternada.UserData;
t_Si = t(i); %ms início do estímulo


%corrente alternada
it = @(x) x*100+1; %converte um tempo t no indície correspondente do vetor t
JE = zeros(1,length(t));
JE(it(t_Si):length(t))= Ie*sin(2*pi*f*t(it(t_Si):length(t)));

[n m h JL JK JNa gKv gNav V]=euler_nmh_pulse(t,JE);

for j=i:length(t)
    try
    if handles.pulso.Value ==1
        break
    elseif handles.clamp.Value ==1
        break
    elseif handles.start.Value==1
        break;
    end
    aa=plot(handles.axes1,t(1:j),V(1:j));
    bb=plot(handles.axes2,t(1:j),JL(1:j), 'b', t(1:j), JK(1:j), 'r', t(1:j), JNa(1:j), 'g');
    cc=plot(handles.axes3,t(1:j),gKv(1:j), 'r',t(1:j),gNav(1:j),'g');
    drawnow
    
    %guardar plot
    [xIL, xIK, xINA]=bb.XData;
    [xGK, xGNA]=cc.XData;
    [yIL, yIK, yINA]=bb.YData;
    [yGK, yGNA]=cc.YData;
    handles.save.UserData=[aa.XData;aa.YData;xIL;yIL;xIK;yIK;xINA;yINA;xGK;yGK;xGNA;yGNA];
    catch
        break
    end
end





% --- Executes on slider movement.
function Ie_a_Callback(hObject, eventdata, handles)
% hObject    handle to Ie_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Ie_a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function freq_Callback(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freq as text
%        str2double(get(hObject,'String')) returns contents of freq as a double


% --- Executes during object creation, after setting all properties.
function freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in variaveis.
function variaveis_Callback(hObject, eventdata, handles)
% hObject    handle to variaveis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of variaveis
V_vec = linspace(-100,50);
Am=alfa_m(V_vec);
Ah = alfa_h(V_vec);
An = alfa_n(V_vec);
Bn = beta_n(V_vec);
Bm = beta_m(V_vec);
Bh = beta_h(V_vec);

tau_n = tau(An,Bn);
tau_m = tau(Am,Bm);
tau_h = tau(Ah,Bh);

n8 = HHv(An,Bn);
m8 = HHv(Am,Bm);
h8 = HHv(Ah,Bh);

figure(1)
subplot(1,3,1)
plot(V_vec,m8)
ylabel('Na+ m')
xlabel('Voltagem (mV)')
legend('m')
subplot(1,3,2)
plot(V_vec,h8)
ylabel('Na+ h')
xlabel('Voltagem (mV)')
legend('h')
subplot(1,3,3)
plot(V_vec,n8)
ylabel('K+ n')
xlabel('Voltagem (mV)')
legend('n')

handles.variaveis.Value=0;

% --- Executes on button press in taxas.
function taxas_Callback(hObject, eventdata, handles)
% hObject    handle to taxas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
V_vec = linspace(-100,50);
Am=alfa_m(V_vec);
Ah = alfa_h(V_vec);
An = alfa_n(V_vec);
Bn = beta_n(V_vec);
Bm = beta_m(V_vec);
Bh = beta_h(V_vec);

figure(2)
subplot(1,3,1)
plot(V_vec,Am,'b',V_vec,Bm,'r')
ylabel('Am & Bm - Taxas de m')
xlabel('Voltagem (mV)')
legend('Am','Bm')
% ylim([0 1])
subplot(1,3,2)
plot(V_vec,Ah,'b',V_vec,Bh,'r')
ylabel('Ah & Bh - Taxas de h')
xlabel('Voltagem (mV)')
legend('Ah','Bh')
ylim([0 1])
subplot(1,3,3)
plot(V_vec,An,'b',V_vec,Bn,'r')
ylabel('An & Bn - Taxas de n')
xlabel('Voltagem (mV)')
legend('An','Bn')

handles.taxas.Value=0;
% Hint: get(hObject,'Value') returns toggle state of taxas


% --- Executes on button press in tau.
function tau_Callback(hObject, eventdata, handles)
% hObject    handle to tau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tau


V_vec = linspace(-100,50);
Am=alfa_m(V_vec);
Ah = alfa_h(V_vec);
An = alfa_n(V_vec);
Bn = beta_n(V_vec);
Bm = beta_m(V_vec);
Bh = beta_h(V_vec);

tau_n = tau(An,Bn);
tau_m = tau(Am,Bm);
tau_h = tau(Ah,Bh);

figure(3)
subplot(1,3,1)
plot(V_vec,tau_m)
ylabel('Na+ tau_m')
xlabel('Voltagem (mV)')
legend('tau_m')
subplot(1,3,2)
plot(V_vec,tau_h)
ylabel('Na+ tau_h')
xlabel('Voltagem (mV)')
legend('tau_h')
subplot(1,3,3)
plot(V_vec,tau_n)
ylabel('K+ tau_n')
xlabel('Voltagem (mV)')
legend('tau_n')

handles.tau.Value=0;


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% h = gcf;
% set(h,'PaperSize',[15 10]);
% print(h,'-dpdf','-fillpage','-noui')
guardar=handles.save.UserData;
% [xIL xIK xINA]=guardar(3,:)
% [xGK xGNA]=guardar(5,:)
% [yIL yIK yINA]=guardar(4,:)
% [yGK yGNA]=guardar(6,:)

h=figure('units','normalized','position',[0 0 1 1]);

subplot(3,1,1)
plot(guardar(1,:),guardar(2,:))
xlabel('Tempo (ms)')
ylabel('Voltagem membranar (mV)')
subplot(3,1,2)
plot(guardar(3,:), guardar(4,:),'b', guardar(5,:), guardar(6,:),'r',guardar(7,:),guardar(8,:),'g')
xlabel('Tempo (ms)')
ylabel('Correntes(uA)')
legend('Leak','K+','Na+')
subplot(3,1,3)
plot(guardar(9,:),guardar(10,:),'r',guardar(11,:),guardar(12,:),'g')
xlabel('Tempo (ms)')
ylabel('Condutâncias(mS)')
legend('K','Na+')
print(h,'-djpeg')
