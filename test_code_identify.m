
clear all;
load  train_data.mat;

class1=train_dataset{1,1};
class2=train_dataset{1,2};
class3=train_dataset{1,3};
class4=train_dataset{1,4};
class5=train_dataset{1,5};

c1_test=class1(5:6,:);
c2_test=class2(5:6,:);
c3_test=class3(5:6,:);
c4_test=class4(5:6,:);
c5_test=class5(5:6,:);

tot_train= [class1;class2;class3;class4;class5];
tot_test=[c1_test;c2_test;c3_test;c4_test;c5_test];

new_class=[1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5 5 5];


%%

% Load the images from 
T=[];
data_train=[];
temp=0;

        
        [f,p]=uigetfile('*.jpg','load the test image to check');
    path1=[p f];
        I=imread(path1);

I=imresize(I,[256 256]); 
I=rgb2gray(I);
load colormaps.mat
[row,column]=size(I);
segment(row,column,I);

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

        clear GABOUT;

        k1(i,j)=127.5/max(max(abs(R)));
        k2(i,j)=127.5/max(max(abs(I)));
        k3(i,j)=255/max(max(M));
        k4(i,j)=127.5/(2*pi);
        k4(i,j)=atan2(max(max(I)),max(max(R)));
       
    end
end
    
ta1(:,:,1)=[k1 k2 k3 k4];



fr=0;
    for qq=1:2
        for gg=1:8
            fr=fr+1;
    t11(1,fr)=ta1(qq,gg,1);
        end
    end
    
    test=t11;

[itrfin]=multisvm(tot_train,new_class,test);

if (itrfin==1)
    fprintf('\n\nthis image belongs to ::ANGER:: class\n\n\n');
elseif(itrfin==2)
    fprintf('\n\nthis image belongs to ::DISGUST:: class\n\n\n');
    elseif(itrfin==3)
        fprintf('\n\nthis image belongs to ::HAPPY:: class\n\n\n');
        elseif(itrfin==4)
            fprintf('\n\nthis image belongs to ::NEUTRAL:: class\n\n\n');
            elseif(itrfin==5)
                fprintf('\n\nthis image belongs to ::SAD:: class\n\n\n');
    
end


