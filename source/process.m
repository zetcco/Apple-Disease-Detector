function varargout = process(varargin)
% PROCESS MATLAB code for process.fig
%      PROCESS, by itself, creates a new PROCESS or raises the existing
%      singleton*.
%
%      H = PROCESS returns the handle to a new PROCESS or the handle to
%      the existing singleton*.
%
%      PROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESS.M with the given input arguments.
%
%      PROCESS('Property','Value',...) creates a new PROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before process_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to process_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help process

% Last Modified by GUIDE v2.5 14-Dec-2021 02:45:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @process_OpeningFcn, ...
                   'gui_OutputFcn',  @process_OutputFcn, ...
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

global arrow1;

% --- Executes just before process is made visible.
function process_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to process (see VARARGIN)

% Choose default command line output for process
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes process wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = process_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    [file,path] = uigetfile('*.jpg');
    img = imread(strcat(path, file));
    imshow(img,'Parent', handles.axes1);
    [disease, black_disease_ratio, edge_4m, edge_8m, img_bw, img_red, img_green, img_blue, bin_red, bin_apple, bin_black_disease, imgsep, img_seg] = detector(strcat(path, file));
    imshow(img_green,'Parent', handles.axes3);
    imshow(img_red,'Parent', handles.axes4);
    imshow(bin_apple,'Parent', handles.axes8);
    imshow(bin_red,'Parent', handles.axes9);
    imshow(img_red,'Parent', handles.axes2);
    imshow(img_blue,'Parent', handles.axes5);
    imshow(imgsep,'Parent', handles.axes7);
    imshow(bin_black_disease,'Parent', handles.axes6);
    imshow(imgsep&bin_black_disease,'Parent', handles.axes15);
    imshow(img_seg,'Parent', handles.axes10);
    
    % Draw arrows
    annotation('textarrow',[0.085 0.11],[0.48 0.55], 'Color', 'red');
    annotation('textarrow',[0.085 0.11],[0.48 0.4], 'Color', 'red');
    annotation('textarrow',[0.19 0.26],[0.55 0.55], 'Color', 'red');
    annotation('textarrow',[0.19 0.26],[0.4 0.4], 'Color', 'red');
    annotation('textarrow',[0.33 0.37],[0.4 0.48], 'Color', 'red');
    annotation('textarrow',[0.33 0.37],[0.55 0.48], 'Color', 'red');
    
    flyspeck_arrow = annotation('textarrow',[0.87 0.89],[0.79 0.86]);
    applecod_arrow = annotation('textarrow',[0.87 0.89],[0.79 0.72]);
    no_disease_arrow = annotation('textarrow',[0.87 0.89],[0.17 0.24]);
    powedery_arrow = annotation('textarrow',[0.87 0.89],[0.17 0.10]);
    
    arrow_green_channel = [
        annotation('textarrow',[0.45 0.5],[0.48 0.71]),
        annotation('textarrow',[0.56 0.59],[0.79 0.86]),
        annotation('textarrow',[0.56 0.59],[0.79 0.72]),
        annotation('textarrow',[0.67 0.7],[0.86 0.79]),
        annotation('textarrow',[0.67 0.7],[0.72 0.79]),
        annotation('textarrow',[0.78 0.81],[0.79 0.79]),
        ];
    
    arrow_blue_channel = [
        annotation('textarrow',[0.56 0.69],[0.17 0.17]),
        annotation('textarrow',[0.45 0.5],[0.48 0.25]),
        annotation('textarrow',[0.78 0.81],[0.17 0.17]),
        ];
    
    % Set values
    set(handles.ratio, 'String', black_disease_ratio, 'ForegroundColor', 'black');
    set(handles.conn_4m, 'String', edge_4m, 'ForegroundColor', 'black');
    set(handles.conn_8m, 'String', edge_8m, 'ForegroundColor', 'black');
    
    if (strcmp(disease,'No disease'))
        set(handles.text6, 'ForegroundColor', 'black');
        set(handles.text7, 'ForegroundColor', 'black');
        set(handles.text8, 'ForegroundColor', 'red');
        set(handles.text9, 'ForegroundColor', 'black');
        no_disease_arrow.Color = 'red';
        for i = 1:length(arrow_blue_channel)
            arrow_blue_channel(i).Color = 'red';
        end
    elseif (strcmp(disease,'Powdery Mildew'))
        set(handles.text6, 'ForegroundColor', 'black');
        set(handles.text7, 'ForegroundColor', 'black');
        set(handles.text8, 'ForegroundColor', 'black');
        set(handles.text9, 'ForegroundColor', 'red');
        powedery_arrow.Color = 'red';
        for i = 1:length(arrow_blue_channel)
            arrow_blue_channel(i).Color = 'red';
        end
    elseif (strcmp(disease,'Fly Speck'))
        set(handles.text7, 'ForegroundColor', 'black');
        set(handles.text8, 'ForegroundColor', 'black');
        set(handles.text9, 'ForegroundColor', 'black');
        set(handles.text6, 'ForegroundColor', 'red');
        flyspeck_arrow.Color = 'red';
        for i = 1:length(arrow_green_channel)
            arrow_green_channel(i).Color = 'red';
        end
    elseif (strcmp(disease,'Apple Cod'))
        set(handles.text8, 'ForegroundColor', 'black');
        set(handles.text9, 'ForegroundColor', 'black');
        set(handles.text6, 'ForegroundColor', 'black');
        set(handles.text7, 'ForegroundColor', 'red');
        applecod_arrow.Color = 'red';
        for i = 1:length(arrow_green_channel)
            arrow_green_channel(i).Color = 'red';
        end
    end
