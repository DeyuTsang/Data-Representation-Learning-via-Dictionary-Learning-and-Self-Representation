function [ Z,D,A,rankZ,D0] = SS_V( X,lambda,eta,gamma,h,maxiter,dictsize,ini_Z)
%the objective function is
%min_Z,D,A ||X-XZ||^2_F+lambda||Z||_*+eta*||X-DA||^2_F+gamma||XZ-DA||^2_F
%s.t.||A(:,j)||_0<=h,||D(:.j)||_2=1
%X--------------d*n input data matrix,d is dimension and n is the number of
%               data
%lambda---------parameter of ||.||_*
%eta------------parameter of ||X-DA||^2_F
%gamma----------parameter of ||XZ-DA||^2_F

%% initialize

[dx,n]           = size(X);

% Initial D,A
[Idx, D0] = kmeans(X',dictsize,'replicate',100);
 D0 = normcols(D0');
% load Yale_75D0
 DTD0 = D0'*D0;
 A = omp(D0,X,DTD0,h);
 AA = full(A);
 D1 = X*AA'*pinv(AA*AA');
 D  = normcols(D1);

% Initial Z
[U0,S0, V0] = svd(X,'econ');
Z0 = V0(:,1:ini_Z) * V0(:,1:ini_Z)' ;
Z = Z0;


tempobj          = 0;
j1=[];
aaa=[];
for Iter  = 1:maxiter
%% update Z
tempZ            = Z;
tempD            = D;
tempA            = A;
XTX              = X'*X;
Z                = newoperation((X+gamma*D*A)/(1+gamma),X,Z,lambda/(1+gamma),maxiter);
J1_temp          = norm(X-X*tempZ,'fro')^2+lambda*sum(svd(tempZ))+gamma*norm(X*tempZ-D*A,'fro')^2; 
J1               = norm(X-X*Z,'fro')^2+lambda*sum(svd(Z))+gamma*norm(X*Z-D*A,'fro')^2; 
j1 = [j1;J1];
if J1_temp<J1
    fprintf('J1_temp=%.8f<J1=%.8f \n',J1_temp,J1);
end

%% update D,A
dataX            = (eta*X+gamma*X*Z)/(eta+gamma);
% params.initdict  = D;
% params.iternum   = 30;
% params.memusage  = 'high';
% params.Tdata     = h;
% params.data      = dataX;
% [D,A,~]          = ksvd(params,'');
DTD              = D'*D;
A                = omp(D,dataX,DTD,h);
AA               = full(A);
    
D1               = dataX*AA'*pinv(AA*AA');
D                = normcols(D1);

% J3_temp               = eta*norm(X-tempD*tempA,'fro')^2+gamma*norm(X*Z-tempD*tempA,'fro')^2;
J3               = eta*norm(X-D*A,'fro')^2+gamma*norm(X*Z-D*A,'fro')^2;
% j3 = [j3;J3];
%% 
[U1,S1,V1]       = svd(Z,'econ');
rankZ            =  compute_rank(diag(S1));
% if rankZ <15
%     break;
% end
obj              =  norm(X-X*Z,'fro')^2+lambda*sum(svd(Z))+eta*norm(X-D*A,'fro')^2+gamma*norm(X*Z-D*A,'fro')^2;
tempobj          =  norm(X-X*tempZ,'fro')^2+lambda*sum(svd(tempZ))+eta*norm(X-tempD*tempA,'fro')^2+gamma*norm(X*tempZ-tempD*tempA,'fro')^2;

aaa = [aaa;obj];
% tempobj          =  norm(X-X*tempZ,'fro')^2+lambda*sum(svd(tempZ))+eta*norm(X-tempD*tempA,'fro')^2+gamma*norm(X*tempZ-tempD*tempA,'fro')^2;
if tempobj<obj
    fprintf('tempobj = %e < obj = %e \n',tempobj,obj);
end
 fprintf('Iter = %d,  obj = %.8f,  rankZ = %d \n',Iter,obj,rankZ);
end
end




function r = So(tau, X)
    % shrinkage operator
    r = sign(X) .* max(abs(X) - tau, 0);
end
function r = Do(tau, X)
    % shrinkage operator for singular values
    [U, S, V] = svd(X);
    r = U*So(tau, S)*V';
end