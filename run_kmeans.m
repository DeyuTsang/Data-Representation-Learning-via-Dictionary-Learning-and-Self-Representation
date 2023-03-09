function [centroids, labels] = run_kmeans(X, k, max_iter)
% �ú���ʵ��Kmeans����
% ���������
%                   XΪ������������dxN
%                   kΪ�������ĸ���
%                   max_iterΪkemans������������Ĵ���
% ���������
%                   centroidsΪ�������� dxk
%                   labelsΪ�����������

%% ����K-means++�㷨��ʼ����������
  centroids = X(:,1+round(rand*(size(X,2)-1)));
  labels = ones(1,size(X,2));
  for i = 2:k
        D = X-centroids(:,labels);
        D = cumsum(sqrt(dot(D,D,1)));
        if D(end) == 0, centroids(:,i:k) = X(:,ones(1,k-i+1)); return; end
        centroids(:,i) = X(:,find(rand < D/D(end),1));
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'));
  end
  
%% ��׼Kmeans�㷨
  for iter = 1:max_iter
        for i = 1:k, l = labels==i; centroids(:,i) = sum(X(:,l),2)/sum(l); end
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'),[],1);
  end
  
end


