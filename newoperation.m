function Z = newoperation(A_hat,B_hat,Z0,lamb_hat,maxiter)
%% ||A-BZ||_2^F+\lambda||Z||_*
Z = Z0;
A = A_hat;
B = B_hat;
lamb = lamb_hat;

eps1 = 1.0e-8;

[Ub ,Sb, Vb] = svd(B,'econ');
% norm(B - Ub*Sb* Vb' , 'fro')
%Bdd = Vb * diag(1 ./ diag(Sb)) * Ub' ;
BA = B' *A;
BB = B' *B;
%BdA = Bdd * A;

iter = 0;
% J2 = norm(A - B*Z,'fro')^2 + lamb*sum(svd(Z));

[p,n]=size(Z);
[pp,nn]=size(Z*Z');
II = eps1*eye(nn);
        JJ = [];   
        for iter = 1:maxiter
      
            
            [Uc Sc] = eig(Z * Z' + II);
            %sc1 = diag(Sc);
            ssc = diag(Sc) .^0.5;
            C1c = Uc * diag( ssc ) * Uc' ;
            %Cc = Uc * diag( 1./ssc) * Uc' ; 
            

            G = BB*C1c + 0.5*lamb*eye(p,p);

            Zi = BA' / G' ;
            Z = C1c* Zi' ;
 
            J2 = norm(A - B*Z,'fro')^2 + lamb*sum(svd(Z));
            JJ =[JJ;J2];
%             fprintf('iter = %d,the cost = %.6f \n',iter,J2)
%             xyz=iter;
        end
        % plot(JJ,'-');

 