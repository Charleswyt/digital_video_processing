function varargout = GUIWelcome(varargin)
% GUIWELCOME M-file for GUIWelcome.fig
%      GUIWELCOME, by itself, creates a new GUIWELCOME or raises the existing
%      singleton*.
%
%      H = GUIWELCOME returns the handle to a new GUIWELCOME or the handle to
%      the existing singleton*.
%
%      GUIWELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIWELCOME.M with the given input arguments.
%
%      GUIWELCOME('Property','Value',...) creates a new GUIWELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIWelcome_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIWelcome_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools guiwelcome.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIWelcome

% Last Modified by GUIDE v2.5 13-Apr-2005 12:23:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIWelcome_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIWelcome_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIWelcome is made visible.
function GUIWelcome_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIWelcome (see VARARGIN)

% Choose default command line output for GUIWelcome
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Initialisations for image handling
%Degradation Process          Restoration Process
%0 - Image Not Opened         0 - Image Not Opened
%1 - Image Opened             1 - Image Opened
%2 - Image Degraded           2 - Image Restored

%Initialising image status to signify that image is not opened yet
assignin('base', 'degimstatus', 0);
assignin('base', 'resimstatus', 0);

%Initialisations for algorithm
%0 - --Not Selected--
%1 - Inverse Filter
%2 - Wiener Filter
%3 - Lucy-Richardson
%Initialising start to signify that image is not opened yet
assignin('base', 'algo', 0);

%Disabling the File menu item
set(handles.FileLoadDegraded, 'Enable', 'off');
set(handles.FileLoadRestored, 'Enable', 'off');
set(handles.FileOpen, 'Enable', 'off');
set(handles.FileSave, 'Enable', 'off');

%Disabling the Edit menu item
set(handles.EditUndo, 'Enable', 'off');
set(handles.EditRedo, 'Enable', 'off');
set(handles.EditCrop, 'Enable', 'off');
set(handles.EditZoom, 'Enable', 'off');

%Displaying the Image Restoration Logo
axes(handles.axeslogo);
logo = imread('Help\Logo\LogoGUI.jpg');
imshow(logo);

%Setting the close function
set(gcf, 'CloseRequestFcn', 'my_closereq');

% UIWAIT makes GUIWelcome wait for user response (see UIRESUME)
% uiwait(handles.GUIWelcome);


% --- Outputs from this function are returned to the command line.
function varargout = GUIWelcome_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% -------------------Start of GUIWelcome ----------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function FileLoadDegraded_Callback(hObject, eventdata, handles)
% hObject    handle to FileLoadDegraded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function FileLoadRestored_Callback(hObject, eventdata, handles)
% hObject    handle to FileLoadRestored (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function FileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to FileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function FileSave_Callback(hObject, eventdata, handles)
% hObject    handle to FileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function FileExit_Callback(hObject, eventdata, handles)
% hObject    handle to FileExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% ----------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function EditUndo_Callback(hObject, eventdata, handles)
% hObject    handle to EditUndo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function EditRedo_Callback(hObject, eventdata, handles)
% hObject    handle to EditRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function EditCrop_Callback(hObject, eventdata, handles)
% hObject    handle to EditCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function EditZoom_Callback(hObject, eventdata, handles)
% hObject    handle to EditZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function FilterDegrade_Callback(hObject, eventdata, handles)
% hObject    handle to FilterDegrade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Welcome GUI & Opening the Degrade GUI
delete(gcf);
GUIDegrade;


% ----------------------
function FilterRestore_Callback(hObject, eventdata, handles)
% hObject    handle to FilterRestore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function RestoreInverse_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreInverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Welcome GUI & Opening the Restore GUI
assignin('base', 'algo', 1);
delete(gcf);
GUIRestore;


% ----------------------
function RestoreWiener_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreWiener (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Welcome GUI & Opening the Restore GUI
assignin('base', 'algo', 2);
delete(gcf);
GUIRestore;


% ----------------------
function RestoreLucyRichardson_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreLucyRichardson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Welcome GUI & Opening the Restore GUI
assignin('base', 'algo', 3);
delete(gcf);
GUIRestore;


% ----------------------
function RestoreCompare_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreCompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Welcome GUI & Opening the Compare GUI
delete(gcf);
GUICompare;


% ----------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----------------------
function HelpHelp_Callback(hObject, eventdata, handles)
% hObject    handle to HelpHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'pointer','watch');
web ([cd '\Help\Home.html'], '-browser');
set(gcf,'pointer','arrow');


% ----------------------
function HelpAboutUs_Callback(hObject, eventdata, handles)
% hObject    handle to HelpAboutUs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'pointer','watch');
web ([cd '\Help\About Us.html'], '-browser');
set(gcf,'pointer','arrow');


% ----------------------- End of GUIWelcome --------------------------


% --- Executes on button press in pbinverse.
function pbinverse_Callback(hObject, eventdata, handles)
% hObject    handle to pbinverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RestoreInverse_Callback(hObject, eventdata, handles);


% --- Executes on button press in pbwiener.
function pbwiener_Callback(hObject, eventdata, handles)
% hObject    handle to pbwiener (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RestoreWiener_Callback(hObject, eventdata, handles);


% --- Executes on button press in pblucy.
function pblucy_Callback(hObject, eventdata, handles)
% hObject    handle to pblucy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RestoreLucyRichardson_Callback(hObject, eventdata, handles);


% --- Executes on button press in pbhelp.
function pbhelp_Callback(hObject, eventdata, handles)
% hObject    handle to pbhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Call help
HelpHelp_Callback(hObject, eventdata, handles);


% --- Executes on button press in pbgettingstarted.
function pbgettingstarted_Callback(hObject, eventdata, handles)
% hObject    handle to pbgettingstarted (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'pointer','watch');
web ([cd '\Help\Getting Started.html'], '-browser');
set(gcf,'pointer','arrow');