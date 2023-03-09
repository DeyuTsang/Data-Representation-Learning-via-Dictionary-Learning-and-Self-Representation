function [accuracy,xp,r]=computaccuracy(trainsample,classnum,train_label,testsample,test_label)
test_tol=size(testsample,2);
train_tol=size(trainsample,2);
pre_label=zeros(1,test_tol);

for i=1:test_tol
    xp = SolveHomotopy_CBM_std(trainsample, testsample(:,i),'lambda', 0.001);
    for j=1:classnum
        mmu=zeros(train_tol,1);
        ind=(j==train_label);
        mmu(ind)=xp(ind);
        r(j)=norm(testsample(:,i)-trainsample*mmu);
    end
    [temp,index]=min(r);
    pre_label(i)=index;
end
accuracy=sum(pre_label==test_label)/test_tol;