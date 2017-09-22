% database creation code using gabor filter
clear all;
clc;
close all;
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

classes={'anger' 'disgust' 'happy' 'neutral' ' sad'};

save('train_data.mat','train_dataset','classes')



