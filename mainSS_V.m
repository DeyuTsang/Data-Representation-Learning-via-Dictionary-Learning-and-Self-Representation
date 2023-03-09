close all;clear;clc;
datasets = 'ORL_75';
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
fip=  fopen(['D:\工作\sparse coding 2\newresults\SS_V_' datasets '.txt'],  'a+');
for lambda= [1]    
for i=1
for ini_Z                 = 80
    for h= [30]
         
[ Z,D,A,rankZ,D0]             = SS_V(normfea,lambda,eta,gamma,h,maxiter,dictsize,ini_Z);
proX                  = D*A;
lrrX                  = normfea*Z;
switch SYtype
    case 1
        %% =======================Sparse Representation Classification===================================%%
%         norm_accuracy=computaccuracy(normfea(:,trainind),ClassNum,gnd(trainind)',normfea(:,testind),gnd(testind)');
        ouracc=computaccuracy(normc(proX(:,trainind)),ClassNum,gnd(trainind)',normc(proX(:,testind)),gnd(testind)');
        lrr_acc = computaccuracy(normc(lrrX(:,trainind)),ClassNum,gnd(trainind)',normc(lrrX(:,testind)),gnd(testind)');
        fprintf('lambda = %.2f,  gamma = %.2f  , pro_accuracy= %.8f,lrr_acc = %.8f\r\n ', lambda,gamma,ouracc,lrr_acc);
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
fprintf( fip,'%s,shiyan = %d, lambda = %.8f,h = %d, init_Z =%d,rankZ= %d,pro_accuracy= %.8f,lrr_acc = %.8f \r\n  ',datestr(now,31),SYtype,lambda,h,ini_Z,rankZ,ouracc,lrr_acc);
      save(['D:\工作\sparse coding 2\newresults\','V',datasets,'l',num2str(lambda),'h',num2str(h),'i',num2str(i),'.mat']);
    end
end   
end
end
 fclose(fip);
