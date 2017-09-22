clc
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


fprintf('\nrecogniton rate is : %f\n',percent);

