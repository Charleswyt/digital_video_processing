function varargout = GUICompare(varargin)
% GUICOMPARE M-file for GUICompare.fig
%      GUICOMPARE, by itself, creates a new GUICOMPARE or raises the existing
%      singleton*.
%
%      H = GUICOMPARE returns the handle to a new GUICOMPARE or the handle to
%      the existing singleton*.
%
%      GUICOMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUICOMPARE.M with the given input arguments.
%
%      GUICOMPARE('Property','Value',...) creates a new GUICOMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUICompare_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUICompare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools guicompare.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUICompare

% Last Modified by GUIDE v2.5 20-Sep-2004 07:25:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUICompare_OpeningFcn, ...
                   'gui_OutputFcn',  @GUICompare_OutputFcn, ...
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


% --- Executes just before GUICompare is made visible.
function GUICompare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUICompare (see VARARGIN)

% Choose default command line output for GUICompare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Initialising image status to signify that image is not opened yet
assignin('base', 'cmpdegimstatus', 0);
assignin('base', 'cmpresimstatus', 0);

% Hiding the axis
set(handles.axisoriginalimg, 'Visible', 'off');
set(handles.axisdegradedimg, 'Visible', 'off');
set(handles.axisinverse,     'Visible', 'off');
set(handles.axiswiener,      'Visible', 'off');
set(handles.axislucy,        'Visible', 'off');

%Disabling File->LoadDegraded, LoadRestored & Save menu items
set(handles.FileSave, 'Enable', 'off');
set(handles.FileLoadDegraded, 'Enable', 'off');
set(handles.FileLoadRestored, 'Enable', 'off');

%Disabling the Edit menu item
set(handles.EditUndo, 'Enable', 'off');
set(handles.EditRedo, 'Enable', 'off');
set(handles.EditCrop, 'Enable', 'off');
set(handles.EditZoom, 'Enable', 'off');

%Initialising global variable to 0 to signify that GUI is freshly opened
global comein; comein = 0;

%Setting the close function
set(gcf, 'CloseRequestFcn', 'my_closereq');

% UIWAIT makes GUICompare wait for user response (see UIRESUME)
% uiwait(handles.GUICompare);


% --- Outputs from this function are returned to the command line.
function varargout = GUICompare_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% -------------------Start of GUICompare ----------------------
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
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
global comein;

[filename, pathname] = uigetfile('*.bmp;*.jpg;*.tif;', 'Open input image');

if filename ~= 0
    %Displaying the original image
    file = [pathname filename];
    originalimg = imread(file);
    
    %Converting to double
    originalimg = im2double(originalimg);

    %Converting the image to grayshade by eliminating hue and saturation
    if size(originalimg, 3) == 3,
        originalimg = rgb2gray(originalimg);
    end

    %Setting axisoriginalimg as the current axis
    axes(handles.axisoriginalimg);
    imshow(real(originalimg));
    
    %Storing the image in the base workspace
    assignin('base','originalimg',originalimg);
    
    %Setting start to 1 signifying that image is opened
    assignin('base', 'cmpdegimstatus', 1);

    %Initialising comein to 1 to signify that image is opened
    comein = 1;

    %Hiding the frame
    set(handles.frmoriginalimg, 'Visible', 'off');
    
    %Enabling the crop menu item
    set(handles.EditCrop, 'Enable', 'on');
end
set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


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
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');

%Reading the old image for undo
originalimgundo = evalin('base', 'originalimgundo');

%Reading the modified image for redo
originalimgredo = evalin('base', 'originalimg');

%Storing the modified image for redo
assignin('base', 'originalimgredo', originalimgredo);

%Storing the old image as current image
assignin('base', 'originalimg', originalimgundo);

%Displaying the old image
axes(handles.axisoriginalimg);
imshow(real(originalimgundo));

%Enabling the Redo & Disabling Undo menu item
set(handles.EditRedo, 'Enable', 'on');
set(handles.EditUndo, 'Enable', 'off');

set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% ----------------------
function EditRedo_Callback(hObject, eventdata, handles)
% hObject    handle to EditRedo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');

%Reading the old image for redo
originalimgredo = evalin('base', 'originalimgredo');

%Storing the modified image as current image
assignin('base', 'originalimg', originalimgredo);

%Displaying the old image
axes(handles.axisoriginalimg);
imshow(real(originalimgredo));

%Diabling the Redo & Enabling Undo menu item
set(handles.EditRedo, 'Enable', 'off');
set(handles.EditUndo, 'Enable', 'on');

set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% ----------------------
function EditCrop_Callback(hObject, eventdata, handles)
% hObject    handle to EditCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axisoriginalimg);
global comein;

%Enter only if image is opened first
if evalin('base', 'cmpdegimstatus') >= 1 & comein >= 1
    set(handles.lbleditstatus, 'Visible', 'on');
    set(gcf,'pointer','crosshair');
    set(handles.lblstatus, 'Foregroundcolor', 'Red');
    set(handles.lblstatus, 'String', 'Status: Starting Point');
    status = waitforbuttonpress;
    if status==0
        point1 = get(gca, 'CurrentPoint');
        point1 = round(point1(1,1:2)); % extract x1 and y1
        
        set(handles.lblstatus, 'String', 'Status: Ending Point');
        status = waitforbuttonpress;
        if status==0
            point2 = get(gca, 'CurrentPoint');
            point2 = round(point2(1,1:2)); % extract x2 and y2

            set(handles.lblstatus, 'String', 'Status: Busy');
            set(gcf,'pointer','watch');

            %Reading the original image
            originalimg = evalin('base', 'originalimg');

            %Storing the start and the end points irrespective of the
            %actual positions on the image
            startx = min(point1(2), point2(2));
            endx   = max(point1(2), point2(2));
            starty = min(point1(1), point2(1));
            endy   = max(point1(1), point2(1));
            
            %Cropping the image
            croppedimg = originalimg(startx:endx, starty:endy);

            %Backingup the old original image for Undo
            assignin('base', 'originalimgundo', originalimg);

            %Storing the cropped image
            assignin('base', 'originalimg', croppedimg);
            imshow(real(croppedimg));

            %Enabling the Undo menu item
            set(handles.EditUndo, 'Enable', 'on');
        end
    end
else
    uiwait(errordlg('Please open a file first.', 'Error', 'modal'));
end
set(handles.lbleditstatus, 'Visible', 'off');
set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


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

%Closing the Degrade GUI & Opening the Restore GUI
assignin('base', 'algo', 1);
delete(gcf);
GUIRestore;


% ----------------------
function RestoreWiener_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreWiener (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Degrade GUI & Opening the Restore GUI
assignin('base', 'algo', 2);
delete(gcf);
GUIRestore;


% ----------------------
function RestoreLucyRichardson_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreLucyRichardson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Closing the Degrade GUI & Opening the Restore GUI
assignin('base', 'algo', 3);
delete(gcf);
GUIRestore;


% ----------------------
function RestoreCompare_Callback(hObject, eventdata, handles)
% hObject    handle to RestoreCompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
web ([cd '\Help\Home.html'], '-browser');
set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% ----------------------
function HelpAboutUs_Callback(hObject, eventdata, handles)
% hObject    handle to HelpAboutUs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
web ([cd '\Help\About Us.html'], '-browser');
set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% ----------------------- End of GUICompare --------------------------

% --- Executes during object creation, after setting all properties.
function sldlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldlength_Callback(hObject, eventdata, handles)
% hObject    handle to sldlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
str = sprintf('%.0f', get(handles.sldlength, 'Value'));
set(handles.txtlength, 'String', str);


% --- Executes during object creation, after setting all properties.
function sldtheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldtheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldtheta_Callback(hObject, eventdata, handles)
% hObject    handle to sldtheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
str = sprintf('%.0f', get(handles.sldtheta, 'Value'));
set(handles.txttheta, 'String', str);


% --- Executes during object creation, after setting all properties.
function txtlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function txtlength_Callback(hObject, eventdata, handles)
% hObject    handle to txtlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtlength as text
%        str2double(get(hObject,'String')) returns contents of txtlength as a double
str = str2num(get(handles.txtlength,'String'));
if str<1 || str>100
    uiwait(errordlg('Please enter blur length in the range 1 to 100.', 'Invalid Length', 'modal'));
    
    %Resetting length
    str = sprintf('%.0f', get(handles.sldlength, 'Value'));
    set(handles.txtlength, 'String', str);
else
    set(handles.sldlength,'Value', str);
end


% --- Executes during object creation, after setting all properties.
function txttheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txttheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function txttheta_Callback(hObject, eventdata, handles)
% hObject    handle to txttheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txttheta as text
%        str2double(get(hObject,'String')) returns contents of txttheta as a double
str = str2num(get(handles.txttheta,'String'));
if str<0 || str>180
    uiwait(errordlg('Please enter blur angle in the range 0 to 180.', 'Invalid Theta', 'modal'));
    
    %Resetting theta
    str = sprintf('%.0f', get(handles.sldtheta, 'Value'));
    set(handles.txttheta, 'String', str);
else
    set(handles.sldtheta,'Value', str);
end


% --- Executes on button press in chknoise.
function chknoise_Callback(hObject, eventdata, handles)
% hObject    handle to chknoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chknoise

if get(handles.chknoise, 'Value')
    %Enabling the popup menu for noise type
    set(handles.popnoisetype, 'Enable', 'on');
    popnoisetype_Callback(hObject, eventdata, handles);
else
    %Disabling popup menu for noise type
    set(handles.popnoisetype, 'Enable', 'off');
    
    %Disabling all the sliders
    set(handles.sldnoisedensity, 'Enable', 'off');
    set(handles.sldmean, 'Enable', 'off');
    set(handles.sldvariance, 'Enable', 'off');

    %Resetting all the labels
    set(handles.lblnoisedensityval, 'String', 0);
    set(handles.lblmeanval, 'String', 0);
    set(handles.lblvarianceval, 'String', 0);
end


% --- Executes during object creation, after setting all properties.
function popnoisetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popnoisetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popnoisetype.
function popnoisetype_Callback(hObject, eventdata, handles)
% hObject    handle to popnoisetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popnoisetype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popnoisetype

%Disabling all the sliders
set(handles.sldnoisedensity, 'Enable', 'off');
set(handles.sldmean, 'Enable', 'off');
set(handles.sldvariance, 'Enable', 'off');

%Resetting all the labels
set(handles.lblnoisedensityval, 'String', 0);
set(handles.lblmeanval, 'String', 0);
set(handles.lblvarianceval, 'String', 0);

% 1: salt & pepper
% 2: gaussian
% 3: poisson
% 4: speckle
switch get(handles.popnoisetype, 'Value')
    case 1,
        set(handles.sldnoisedensity, 'Enable', 'on', 'Value', 0.05);
        set(handles.lblnoisedensityval, 'String', 0.05);
    case 2,
        set(handles.sldmean, 'Enable', 'on', 'Value', 0);
        set(handles.lblmeanval, 'String', 0);
        set(handles.sldvariance, 'Enable', 'on', 'Value', 0.01);
        set(handles.lblvarianceval, 'String', 0.01);
    case 4,
        set(handles.sldvariance, 'Enable', 'on', 'Value', 0.04);
        set(handles.lblvarianceval, 'String', 0.04);
end


% --- Executes during object creation, after setting all properties.
function sldmean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldmean_Callback(hObject, eventdata, handles)
% hObject    handle to sldmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = sprintf('%.2f', get(handles.sldmean, 'Value'));
set(handles.lblmeanval, 'String', value);


% --- Executes during object creation, after setting all properties.
function sldvariance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldvariance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldvariance_Callback(hObject, eventdata, handles)
% hObject    handle to sldvariance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = sprintf('%.2f', get(handles.sldvariance, 'Value'));
set(handles.lblvarianceval, 'String', value);


% --- Executes during object creation, after setting all properties.
function sldnoisedensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldnoisedensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldnoisedensity_Callback(hObject, eventdata, handles)
% hObject    handle to sldnoisedensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = sprintf('%.2f', get(handles.sldnoisedensity, 'Value'));
set(handles.lblnoisedensityval, 'String', value);


% --- Executes on button press in pbdegradeimg.
function pbdegradeimg_Callback(hObject, eventdata, handles)
% hObject    handle to pbdegradeimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
global comein;

%Enter only if image is opened first
if evalin('base', 'cmpdegimstatus') >= 1 & comein >= 1
    %Reading original image from base workspace
    originalimg = evalin('base', 'originalimg');
    LEN         = str2num(get(handles.txtlength, 'String'));
    THETA       = str2num(get(handles.txttheta, 'String'));

    %If noise is checked
    if get(handles.chknoise, 'Value')
        switch get(handles.popnoisetype, 'Value')
            case 1 %salt & pepper
                d = str2num(get(handles.lblnoisedensityval, 'String'));
                degradedimg = Degrade(originalimg, LEN, THETA, 'salt & pepper', d);
            case 2 %gaussian
                m = str2num(get(handles.lblmeanval, 'String'));
                v = str2num(get(handles.lblvarianceval, 'String'));
                degradedimg = Degrade(originalimg, LEN, THETA, 'gaussian', m, v);
            case 3 %poisson
                degradedimg = Degrade(originalimg, LEN, THETA, 'poisson');
            case 4 %speckle
                v = str2num(get(handles.lblvarianceval, 'String'));
                degradedimg = Degrade(originalimg, LEN, THETA, 'speckle', v);
        end
    else %noise is not checked
        degradedimg = Degrade(originalimg, LEN, THETA);
    end

    %Make the axisdegradedimg the current axes
    axes(handles.axisdegradedimg);
    imshow(real(degradedimg));

    %Estimating SNR
    R = str2num(sprintf('%.4f', 1/size(degradedimg, 2)));
    set(handles.txtsnr, 'String', R);
    set(handles.sldsnr, 'Value', R);

    %Storing the degraded image in the base workspace
    assignin('base','degradedimg',degradedimg);

    %Setting start to 2 signifying image can be saved now
    assignin('base', 'cmpdegimstatus', 2);
    assignin('base', 'cmpresimstatus', 1);

    %Hiding the frame
    set(handles.frmdegradedimg, 'Visible', 'off');
else
    uiwait(errordlg('Please open a file first.', 'Error', 'modal'));
end
set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% --- Executes during object creation, after setting all properties.
function slditerations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slditerations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slditerations_Callback(hObject, eventdata, handles)
% hObject    handle to slditerations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
str = sprintf('%.0f', get(handles.slditerations, 'Value'));
set(handles.txtiterations, 'String', str);


% --- Executes during object creation, after setting all properties.
function txtiterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtiterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function txtiterations_Callback(hObject, eventdata, handles)
% hObject    handle to txtiterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtiterations as text
%        str2double(get(hObject,'String')) returns contents of txtiterations as a double
str = str2num(get(handles.txtiterations,'String'));
if str<1 || str>1000
    uiwait(errordlg('Please enter no. of iterations in the range 1 to 1000', 'Invalid Iterations', 'modal'));

    %Resetting iterations
    str = sprintf('%.0f', get(handles.slditerations, 'Value'));
    set(handles.txtiterations, 'String', str);
else
    set(handles.slditerations,'Value', str);
end


% --- Executes during object creation, after setting all properties.
function sldsnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldsnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function sldsnr_Callback(hObject, eventdata, handles)
% hObject    handle to sldsnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
str = sprintf('%.4f', get(handles.sldsnr, 'Value'));
set(handles.txtsnr, 'String', str);


% --- Executes during object creation, after setting all properties.
function txtsnr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtsnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function txtsnr_Callback(hObject, eventdata, handles)
% hObject    handle to txtsnr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtsnr as text
%        str2double(get(hObject,'String')) returns contents of txtsnr as a double
str = str2num(get(handles.txtsnr,'String'));
if str<0.0001 || str>1
    uiwait(errordlg('Please enter Signal to Noise Ratio (SNR) in the range 0.0001 to 1', 'Invalid SNR', 'modal'));

    %Resetting iterations
    str = sprintf('%.4f', get(handles.sldsnr, 'Value'));
    set(handles.txtsnr, 'String', str);
else
    set(handles.sldsnr,'Value', str);
end


function [restoredimg] = restoreimage(hObject, eventdata, handles, filter)
%Reading the degraded image from the base workspace
degradedimg = evalin('base', 'degradedimg');
LEN         = str2num(get(handles.txtlength, 'String'));
THETA       = str2num(get(handles.txttheta, 'String'));

%Start the waitbar
handle = waitbar(0,'Please wait...');
switch filter
    case 1 %Inverse filter
        restoredimg = Inverse(degradedimg, LEN, THETA, handle);
        axes(handles.axisinverse);
        assignin('base','restoredinverse',restoredimg);
        set(handles.frminverse, 'Visible', 'off');
    case 2 %Wiener filter
        SNR = get(handles.sldsnr, 'Value');
        restoredimg = Wiener(degradedimg, LEN, THETA, SNR, handle);
        axes(handles.axiswiener);
        assignin('base','restoredwiener',restoredimg);
        set(handles.frmwiener, 'Visible', 'off');
    case 3 %Lucy-Richardson
        iterations = floor(get(handles.slditerations, 'Value'));
        restoredimg = Lucy(degradedimg, LEN, THETA, iterations, handle);
        axes(handles.axislucy);
        assignin('base','restoredlucy',restoredimg);
        set(handles.frmlucy, 'Visible', 'off');
end
%Close the waitbar
close(handle);

%Display restored image
imshow(real(restoredimg));


function dispcomparison(hObject, eventdata, handles, restoredimg, filter)
originalimg = evalin('base', 'originalimg');
[absdiff, snr, psnr, imfid, mse] = compare(originalimg, restoredimg);
absdiff  = sprintf('%.6f', real(absdiff));
snr      = sprintf('%.6f', real(snr));
psnr     = sprintf('%.6f', real(psnr));
imfid    = sprintf('%.6f', real(imfid));
mse      = sprintf('%.6f', real(mse));
switch filter
    case 1 %Inverse Filter
        set(handles.inverseaad, 'String', absdiff);
        set(handles.inversesnr, 'String', snr);
        set(handles.inversepsnr, 'String', psnr);
        set(handles.inverseif, 'String', imfid);
        set(handles.inversemse, 'String', mse);
    case 2 %Wiener Filter
        set(handles.wieneraad, 'String', absdiff);
        set(handles.wienersnr, 'String', snr);
        set(handles.wienerpsnr, 'String', psnr);
        set(handles.wienerif, 'String', imfid);
        set(handles.wienermse, 'String', mse);
    case 3 %Lucy - Richardson Filter
        set(handles.lucyaad, 'String', absdiff);
        set(handles.lucysnr, 'String', snr);
        set(handles.lucypsnr, 'String', psnr);
        set(handles.lucyif, 'String', imfid);
        set(handles.lucymse, 'String', mse);
end


% --- Executes on button press in pbinverse.
function pbinverse_Callback(hObject, eventdata, handles)
% hObject    handle to pbinverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
global comein;

%Enter only if image is opened first
if evalin('base', 'cmpresimstatus') >= 1 & comein >= 1
    restoredimg = restoreimage(hObject, eventdata, handles, 1);
    dispcomparison(hObject, eventdata, handles, restoredimg, 1);
else
    uiwait(errordlg('Please degrade a file first.', 'Error', 'modal'));
end

set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% --- Executes on button press in pbwiener.
function pbwiener_Callback(hObject, eventdata, handles)
% hObject    handle to pbwiener (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
global comein;

%Enter only if image is opened first
if evalin('base', 'cmpresimstatus') >= 1 & comein >= 1
    restoredimg = restoreimage(hObject, eventdata, handles, 2);
    dispcomparison(hObject, eventdata, handles, restoredimg, 2);
else
    uiwait(errordlg('Please degrade a file first.', 'Error', 'modal'));
end

set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% --- Executes on button press in pblucy.
function pblucy_Callback(hObject, eventdata, handles)
% hObject    handle to pblucy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
global comein;

%Enter only if image is opened first
if evalin('base', 'cmpresimstatus') >= 1 & comein >= 1
    restoredimg = restoreimage(hObject, eventdata, handles, 3);
    dispcomparison(hObject, eventdata, handles, restoredimg, 3);
else
    uiwait(errordlg('Please degrade a file first.', 'Error', 'modal'));
end

set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');


% --- Executes on button press in pbhelp.
function pbhelp_Callback(hObject, eventdata, handles)
% hObject    handle to pbhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.lblstatus, 'Foregroundcolor', 'Red');
set(handles.lblstatus, 'String', 'Status: Busy');
set(gcf,'pointer','watch');
web ([cd '\Help\Degrade.html'], '-browser');
set(gcf,'pointer','arrow');
set(handles.lblstatus, 'String', 'Status: Ready', 'Foregroundcolor', 'Black');
