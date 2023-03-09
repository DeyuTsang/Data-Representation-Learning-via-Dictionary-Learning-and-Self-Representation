clear all
clc
close all

database=[pwd '\ORL'];%ʹ�õ�������
train_samplesize=5;%ÿ��ѵ��������
address=[database '\s'];
rows=112;
cols=92;
ClassNum=40;
tol_num=10;
image_fmt='.bmp';

%------------------------PCA��ά
train=1:train_samplesize;
test=train_samplesize+1:tol_num;

train_num=length(train);
test_num=length(test);

train_tol=train_num*ClassNum;
test_tol=test_num*ClassNum;

[train_sample,train_label]=readsample(address,ClassNum,train,rows,cols,image_fmt);
[test_sample,test_label]=readsample(address,ClassNum,test,rows,cols,image_fmt);

for pro_dim=40:10:90
    %PCA��ά
    [Pro_Matrix,Mean_Image]=my_pca(train_sample,pro_dim);
    train_project=Pro_Matrix'*train_sample;
    test_project=Pro_Matrix'*test_sample;
    
    %��λ��
    train_norm=normc(train_project);
    test_norm=normc(test_project);
    
    accuracy=computaccuracy(train_norm,ClassNum,train_label,test_norm,test_label);
    fprintf('ͶӰά��Ϊ��%d\n',pro_dim);
    fprintf('ÿ��ѵ����������Ϊ��%d\n',train_samplesize);
    fprintf(2,'ʶ����Ϊ��%3.2f%%\n\n',accuracy*100);
end

