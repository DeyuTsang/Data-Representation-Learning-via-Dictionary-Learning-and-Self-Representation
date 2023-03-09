close all;clear;clc;
datasets = 'binaryalpha70_fea';

load('binaryalpha_75')

load(datasets);
%% ===========================================
% load fea
ClassNum              = length(unique(gnd));
normfea               = normc(fea');
% normfea               = mapminmax(normfea,0,1);
% lambda                = 0.1;
eta                   = 0.8;
gamma                 = 1;    
maxiter               = 100;
dictsize              = 160;
SYtype                = 1;
fip=  fopen(['newresults2023\SS_V_' datasets '.txt'],  'a+');
for lambda= [15]    
for i=1:5
for ini_Z                 = 300
    for h= [80:-10:30]
         
[ Z,D,A,rankZ,D0]             = SS_V(normfea,lambda,eta,gamma,h,maxiter,dictsize,ini_Z);
proX                  = D*A;
lrrX                  = normfea*Z;
switch SYtype
    case 1
        %% =======================Sparse Representation Classification===================================%%
%         norm_accuracy=computaccuracy(normfea(:,trainind),ClassNum,gnd(trainind)',normfea(:,testind),gnd(testind)');
        [RI,acc,Precisions,Recalls,F1]=computaccuracy(normc(proX(:,trainind)),ClassNum,gnd(trainind)',normc(proX(:,testind)),gnd(testind)');
        [lRI,lacc,lPrecisions,lRecalls,lF1] = computaccuracy(normc(lrrX(:,trainind)),ClassNum,gnd(trainind)',normc(lrrX(:,testind)),gnd(testind)');
fprintf( fip,'%s,shiyan = %d, lambda = %.8f,h = %d, init_Z =%d,rankZ= %d,pro_acc= %.8f,pro_RI= %.8f,pro_Precisions= %.8f,pro_Recalls= %.8f,pro_F1= %.8f \r\n  ',datestr(now,31),SYtype,lambda,h,ini_Z,rankZ,acc,RI,Precisions,Recalls,F1);
fprintf( fip,'%s,shiyan = %d, lambda = %.8f,h = %d, init_Z =%d,rankZ= %d,Z_acc= %.8f,Z_RI= %.8f,Z_Precisions= %.8f,Z_Recalls= %.8f,Z_F1= %.8f \r\n  ',datestr(now,31),SYtype,lambda,h,ini_Z,rankZ,lacc,lRI,lPrecisions,lRecalls,lF1);
    case 2
        %% ===========================字典效果对比================================================= %%
        D = mapminmax(D',0,1)';
        subplot(1,2,1);show(D');
        params.data      = normfea;
        params.dictsize  = dictsize;
        params.iternum   = 50;
        params.memusage  = 'high';
        params.Tdata     = h;
        [D2,~,~]         = ksvd(params,'');
        D2 = mapminmax(D2',0,1)';
        subplot(1,2,2);show(D2');
end
% fprintf( fip,'%s,shiyan = %d, lambda = %.8f,h = %d, init_Z =%d,rankZ= %d,pro_acc= %.8f,pro_RI= %.8f,pro_Precisions= %.8f,pro_Recalls= %.8f,pro_F1= %.8f \r\n  ',datestr(now,31),SYtype,lambda,h,ini_Z,rankZ,acc,RI,Precisions,Recalls,F1);
% fprintf( fip,'%s,shiyan = %d, lambda = %.8f,h = %d, init_Z =%d,rankZ= %d,Z_acc= %.8f,Z_RI= %.8f,Z_Precisions= %.8f,Z_Recalls= %.8f,Z_F1= %.8f \r\n  ',datestr(now,31),SYtype,lambda,h,ini_Z,rankZ,lacc,lRI,lPrecisions,lRecalls,lF1);
save(['newresults2023\','V',datasets,'l',num2str(lambda),'h',num2str(h),'i',num2str(i),'.mat']);
    end
end   
end
end
 fclose(fip);
