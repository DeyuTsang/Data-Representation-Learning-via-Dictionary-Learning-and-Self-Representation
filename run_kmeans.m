function [centroids, labels] = run_kmeans(X, k, max_iter)
% 该函数实现Kmeans聚类
% 输入参数：
%                   X为输入样本集，dxN
%                   k为聚类中心个数
%                   max_iter为kemans聚类的最大迭代的次数
% 输出参数：
%                   centroids为聚类中心 dxk
%                   labels为样本的类别标记

%% 采用K-means++算法初始化聚类中心
  centroids = X(:,1+round(rand*(size(X,2)-1)));
  labels = ones(1,size(X,2));
  for i = 2:k
        D = X-centroids(:,labels);
        D = cumsum(sqrt(dot(D,D,1)));
        if D(end) == 0, centroids(:,i:k) = X(:,ones(1,k-i+1)); return; end
        centroids(:,i) = X(:,find(rand < D/D(end),1));
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'));
  end
  
%% 标准Kmeans算法
  for iter = 1:max_iter
        for i = 1:k, l = labels==i; centroids(:,i) = sum(X(:,l),2)/sum(l); end
        [~,labels] = max(bsxfun(@minus,2*real(centroids'*X),dot(centroids,centroids,1).'),[],1);
  end
  
end


