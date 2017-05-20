% these settings will run the ACO with ACS, minmax and elitist settings for
% 3 differend parameters of alpha and beta.
alpha=[1,1,3];
beta =[1,3,1];
minmaxSystem=[0,1,0];
eliteSystem=[0,0,1];
count = 0;
for j=1:3;
    for i=1:3      
        count=count+1
        [Progress{count},BestProgress{count},clustering{count}] = main(minmaxSystem(j),eliteSystem(j), alpha(i),beta(i))
    end
end


% this is used for generating the purity and F1 measure.
a{1}=1:510;
a{2}=511:896;
a{3}=897:1313;
a{4}=1314:1824;
a{5}=1825:2225;
for c=1:9
    for j =1:5
        for i=1:5
            n(j,i)=sum(clusters{c}(a{j})==i);
        end
    end

    purity(c)= 1/size(data,1)*sum(max(n));

    for i=1:5
        precision(i) = max(n(:,i))/sum(n(:,i)); 
    end
    avg_precision(c) = mean(precision);
    for i=1:5
        recall(i) = max(n(:,i))/sum(n(i,:));
    end
    avg_recall(c) = mean(recall);
    
    bestScore(c)= max(BestProgress{c});
    F1(c)= 2*((avg_precision(c)*avg_recall(c))/(avg_precision(c)+avg_recall(c)));
end

for i=1:5
    eva{i} = evalclusters(data,'kmeans','DaviesBouldin','klist',[5]); 
end

for c=1:5
    for j =1:5
        for i=1:5
            n2(j,i)=sum(eva{c}.OptimalY(a{j})==i);
        end
    end
    purity2(c)= 1/size(data,1)*sum(max(n2));

    for i=1:5
        precision2(i) = max(n2(:,i))/sum(n2(:,i)); 
    end
    avg_precision2(c) = mean(precision2);
for i=1:5
    recall2(i) = max(n2(:,i))/sum(n2(i,:));
end
    avg_recall2(c) = mean(recall2);

    F12(c)= 2*((avg_precision2(c)*avg_recall2(c))/(avg_precision2(c)+avg_recall2(c)));
end
