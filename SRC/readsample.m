function [sample,label]=readsample(address,ClassNum,data,rows,cols,image_fmt)
%�������������ȡ������
%���룺
%address��Ҫ��ȡ��������·��
%ClassNum������Ҫ���������������
%data����������
%rows����������
%cols����������
%image_fmt��ͼƬ��ʽ

%�����
%sample����������ÿ��Ϊһ��������ÿ��Ϊһ������
%label��������ǩ

allsamples=[];
label=[];
ImageSize=rows*cols;
for i=1:ClassNum
    for j=data
        a=double(imread(strcat(address,num2str(i),'_',num2str(j),image_fmt)));
        a=imresize(a,[rows cols]);
        b=reshape(a,ImageSize,1);
        allsamples=[allsamples,b];
        label=[label,i];
    end
end
sample=allsamples;