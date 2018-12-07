function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 07-Dec-2018 14:52:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- From https://uk.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center
function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off

function h = arcGenerator(x,y,r,start, stop)
hold on
th = start:pi/50:stop;
xunit = r * cosd(th) + x;
yunit = r * sind(th) + y;
h = rot90(cat(1, xunit, yunit));
hold off


function remove_plots(x)
arrayfun(@(y) delete(y), x)


function o = rotate(centre, verts, theta)
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
c = centre - verts;
c = c * R;
o = centre + c;

function i = intersect(a, h, k, r)
x = h * (((a - h)/(sqrt(k^2 + h^2))) + 1);
y = k * ((a - h)/(sqrt(k^2 + h^2)));
x = x + r(1);
y = y + r(2);
i = [x y];

function theta = calcAngle(a, b)
theta = 90 - rad2deg(atan2(b(2) - a(2), b(1) - a(1)));

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rect = getrect(handles.axes1);

% Set up rotation matrix
prompt = {'Enter a value of rotation \theta (in degrees)'};
title = 'Theta Value';
definput = {'0'};
opts.Interpreter = 'tex';
theta = inputdlg(prompt,title,[1 60],definput,opts);
theta = str2double(theta{:,1});

% Set up coords
verts = [rect(1), rect(2); rect(1) + rect(3), rect(2); rect(1) + rect(3), rect(2) + rect(4); rect(1), rect(2) + rect(4)];
a = rect(3) / 2;
b = rect(4) / 2;
h = ((a - b) * (a + b + sqrt(a ^ 2 + 6 * a * b + b ^ 2)))/(a - b + sqrt(a ^ 2 + 6 * a * b + b ^ 2));
root = [rect(1) + (rect(3) / 2), rect(2) + (rect(4) / 2)];
k = ((a - b) * (a + 3 * b + sqrt(a ^ 2 + 6 * a * b + b ^ 2)))/(4 * b);

% Do the rotation
verts = rotate(root, verts, theta);
sc1_loc = rotate(root, [root(1) + h, root(2)], theta);
sc2_loc = rotate(root, [root(1) - h, root(2)], theta);
bc1_loc = rotate(root, [root(1), root(2) + k], theta);
bc2_loc = rotate(root, [root(1), root(2) - k], theta);


% Draw the basic shapes
r = impoly(handles.axes1, verts);
sc1 = circle(sc1_loc(1), sc1_loc(2), a - h);
sc2 = circle(sc2_loc(1), sc2_loc(2), a - h);
bc1 = circle(bc1_loc(1), bc1_loc(2), b + k);
% bc2 = circle(bc2_loc(1), bc2_loc(2), b + k);
i = intersect(a,h,k,root);
inter1 = [i(1), i(2)];
inter2 = [i(1), i(2) -  2 * abs(i(2) - root(2))];
inter3 = [i(1) -  2 * abs(i(1) - root(1)), i(2)];
inter4 = [i(1) -  2 * abs(i(1) - root(1)), i(2) -  2 * abs(i(2) - root(2))];
inter1_rot = rotate(root, [i(1), i(2)], theta);
inter2_rot = rotate(root, [i(1), i(2) -  2 * abs(i(2) - root(2))], theta);
inter3_rot = rotate(root, [i(1) -  2 * abs(i(1) - root(1)), i(2)], theta);
inter4_rot = rotate(root, [i(1) -  2 * abs(i(1) - root(1)), i(2) -  2 * abs(i(2) - root(2))], theta);
hold on;
%plot(inter1(1), inter1(2), 'g.');
plot(inter2(1), inter2(2), 'g.');
%plot(inter3(1), inter3(2), 'g.');
plot(inter4(1), inter4(2), 'g.');


sc2ang1 = calcAngle(sc2_loc, inter1);
sc2ang2 = calcAngle(sc2_loc, inter2);

bc1ang1 = calcAngle(bc1_loc, inter1);
bc1ang2 = calcAngle(bc1_loc, inter3);

sc1 = rotate(sc1_loc, arcGenerator(sc1_loc(1), sc1_loc(2), a - h, sc2ang1, sc2ang2), 90);
sc2 = rotate(sc2_loc, arcGenerator(sc2_loc(1), sc2_loc(2), a - h, sc2ang1, sc2ang2), -90);

hold on;
plot(sc1(:, 1), sc1(:, 2), 'r-', 'LineWidth', 2);
plot(sc2(:, 1), sc2(:, 2), 'r-', 'LineWidth', 2);
plot(bc1(:, 1), bc1(:, 2), 'r-', 'LineWidth', 2);
% id = addNewPositionCallback(r,@(p) delete([sc1, sc2, bc1, bc2]));
% id2 = addNewPositionCallback(r,@(p) redraw(rect, theta, handles));

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1)
