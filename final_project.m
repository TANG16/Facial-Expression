function varargout = final_project(varargin)
% FINAL_PROJECT MATLAB code for final_project.fig
%      FINAL_PROJECT, by itself, creates a new FINAL_PROJECT or raises the existing
%      singleton*.
%
%      H = FINAL_PROJECT returns the handle to a new FINAL_PROJECT or the handle to
%      the existing singleton*.
%
%      FINAL_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_PROJECT.M with the given input arguments.
%
%      FINAL_PROJECT('Property','Value',...) creates a new FINAL_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_project

% Last Modified by GUIDE v2.5 03-May-2015 08:32:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_project_OpeningFcn, ...
                   'gui_OutputFcn',  @final_project_OutputFcn, ...
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


% --- Executes just before final_project is made visible.
function final_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_project (see VARARGIN)

% Choose default command line output for final_project
handles.output = hObject;

axes(handles.axes1);
imshow('blank.jpg');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final_project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t12 f nm str1
[f,p]=uigetfile('*.tiff','Select the image');
str=[p f];
nm=f(4:5);
str1=p(end-7:end-1);
I=imread(str);

axes(handles.axes1);
imshow(I);

I=imresize(I,[256 256]);
s=size(I);
load colormaps.mat

[row,column]=size(I);

segment(row,column,double(I));

load I_segment;

% Filter the image
for i=1:2
    for j=1:2
        [G,GABOUT]=gaborfilter(I_segment(:,:,i,j),0.05,0.025,0,0);
        clear I;
        R=real(GABOUT);
        I=imag(GABOUT);
        M=abs(GABOUT);
        P=angle(GABOUT);

        save M;
        save P;

        clear GABOUT;

        k1(i,j)=127.5/max(max(abs(R)));
        %save k1(i,j);
        %image(uint8(k1(i,j)*R+127.5));
        %title('Gabor Filter');
        %subplot(2,2,2);

        k2(i,j)=127.5/max(max(abs(I)));
        k3(i,j)=255/max(max(M));
        k4(i,j)=127.5/(2*pi);
        k4(i,j)=atan2(max(max(I)),max(max(R)));
    end
end
    fr=0;
ha(:,:,1)=[k1 k2 k3 k4];
    for qq=1:2
        for gg=1:8
            fr=fr+1;
    t12(1,fr)=ha(qq,gg,1);
        end
    end


% --- Executes on button press in c_db.
function c_db_Callback(hObject, eventdata, handles)
% hObject    handle to c_db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'string','Database Creation ..!!!');
pause(0.2);
cdir=pwd;
for kkk=1:5
% Load the images from 
T=[];
data_train=[];
temp=0;

close all;
        %str= int2str(z);
        %str=strcat('\',str,'.jpg');
        if(kkk==1)
        TrainDatabasePath=[cdir '\Anger'];
        Count_z=30;
        elseif(kkk==2)
            TrainDatabasePath=[cdir '\Disgust'];
            Count_z=29;
            elseif(kkk==3)
                TrainDatabasePath=[cdir '\Happy'];
                Count_z=30;
                elseif(kkk==4)
                    TrainDatabasePath=[cdir '\Neutral'];
                    Count_z=30;
                    elseif(kkk==5)
                        TrainDatabasePath=[cdir '\Sad'];
                        Count_z=26;
        end

for z=1:Count_z
                    
        
        str1=sprintf('\\u(%d).tiff',z);
        str=[TrainDatabasePath str1];

I=imread(str);
%I=rgb2gray(double(I));

I=imresize(I,[256 256]);
s=size(I);
% if(~isempty(s(3)))
% I=rgb2gray(I);
% end
%figure;
%imshow(I);
%I=rgb2gray(I);
load colormaps.mat

% Show the grayscale image
%colormap(grayscale);
%figure;
%imshow(I);

[row,column]=size(I);

segment(row,column,double(I));

load I_segment;

% Filter the image
for i=1:2
    for j=1:2
        [G,GABOUT]=gaborfilter(I_segment(:,:,i,j),0.05,0.025,0,0);
        clear I;
        R=real(GABOUT);
        I=imag(GABOUT);
        M=abs(GABOUT);
        P=angle(GABOUT);

        save M;
        save P;

        clear GABOUT;

        k1(i,j)=127.5/max(max(abs(R)));
        %save k1(i,j);
        %image(uint8(k1(i,j)*R+127.5));
        %title('Gabor Filter');
        %subplot(2,2,2);

        k2(i,j)=127.5/max(max(abs(I)));
        %image(uint8(k2(i,j)*I+127.5));
        %title('Gabor Kernel');

        % Show the kernels
        %colormap(redgreen);


        %subplot(2,2,3);
        %image(uint8(127.5*real(G)+127.5));
        %title('Gabor Magnitudes');
        %subplot(2,2,4);
        %image(uint8(127.5*imag(G)+127.5));
        %title('Gabor Phases');

        % Show the magnitudes
        %figure;
        %colormap(grayscale);
        k3(i,j)=255/max(max(M));
        %image(uint8(k3(i,j)*M));


        % Show the phases
       % figure;
        %colormap(redgreen);
        k4(i,j)=127.5/(2*pi);
        k4(i,j)=atan2(max(max(I)),max(max(R)));
       % image(uint8(k4(i,j)*P+127.5));
    end
end
    
ha(:,:,z)=[k1 k2 k3 k4];
save ha;
clear t11;
%disp(M);
%disp(P);
    T=[T temp];
end;

%rescale();
load ha;
for ss1=1:Count_z
    fr=0;
    for qq=1:2
        for gg=1:8
            fr=fr+1;
    t11(ss1,fr)=ha(qq,gg,ss1);
        end
    end
end


train_dataset{1,kkk}=t11;


end
%set(handles.edit2,'string','Database Creation completed..!!!');
classes={'anger' 'disgust' 'happy' 'neutral' ' sad'};
save('train_data.mat','train_dataset','classes')


pause(0.2);




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clr.
function clr_Callback(hObject, eventdata, handles)
% hObject    handle to clr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit2,'string',' ');

axes(handles.axes1);
imshow('blank.jpg');


% --- Executes on button press in Run_algo.
function Run_algo_Callback(hObject, eventdata, handles)
% hObject    handle to Run_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t12  nm str1
load  train_data.mat;

class1=train_dataset{1,1};
class2=train_dataset{1,2};
class3=train_dataset{1,3};
class4=train_dataset{1,4};
class5=train_dataset{1,5};

c1_test=class1(20:end,:);


tot_train= [class1;class2;class3;class4;class5];

new_class_train=[ones(1,size(class1,1)) ones(1,size(class2,1))*2 ones(1,size(class3,1))*3 ones(1,size(class4,1))*4 ones(1,size(class5,1))*5];
[itrfin]=multisvm(tot_train,new_class_train,t12);
val=num2str(itrfin);

if(itrfin==4)

    if(((nm(1)=='N' && nm(2)=='E')||(strcmp('Neutral',str1))))
            vv=sprintf('this image belongs to ::NEUTRAL:: class');
    else
            vv=sprintf('Unrecognised image');
    end
end
    



if (itrfin==1)
    vv=sprintf('this image belongs to ::ANGER:: class');
elseif(itrfin==2)
    vv=sprintf('this image belongs to ::DISGUST:: class');
    elseif(itrfin==3)
        vv=sprintf('this image belongs to ::HAPPY:: class');
    elseif(itrfin==5)
                vv=sprintf('this image belongs to ::SAD:: class');
    
end

set(handles.edit2,'String',vv);


% --- Executes on button press in comp_an.
function comp_an_Callback(hObject, eventdata, handles)
% hObject    handle to comp_an (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load  train_data.mat;

class1=train_dataset{1,1};
class2=train_dataset{1,2};
class3=train_dataset{1,3};
class4=train_dataset{1,4};
class5=train_dataset{1,5};

c1_test=class1(20:end,:);

c2_test=class2(20:end,:);
c3_test=class3(20:end,:);
c4_test=class4(20:end,:);
c5_test=class5(20:end,:);

tot_train= [class1;class2;class3;class4;class5];
tot_test=[c1_test;c2_test;c3_test;c4_test;c5_test]; 

%new_class=[1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5];
new_class_test=[ones(1,size(c1_test,1)) ones(1,size(c2_test,1))*2 ones(1,size(c3_test,1))*3 ones(1,size(c4_test,1))*4 ones(1,size(c5_test,1))*5];
new_class_train=[ones(1,size(class1,1)) ones(1,size(class2,1))*2 ones(1,size(class3,1))*3 ones(1,size(class4,1))*4 ones(1,size(class5,1))*5];
[itrfin]=multisvm(tot_train,new_class_train,tot_test);


test_class=new_class_test;
test_class=test_class';

f=test_class~=itrfin;

correct=size(find(f==0),1);
incorrect=size(find(f==1),1);

percent=(correct/(correct+incorrect))*100;

%[confusionMatrix,order] = confusionmat(test_class,itrfin); % confusion matrix creation

[confusionMatrix,order] = confusion_matrix(test_class,itrfin,classes); % confusion matrix creation


val=sprintf('Overall recogniton rate is : %f',percent);
set(handles.edit2,'string',val);
