function [Progress,BestProgress,clustering]= main(minmaxSystem,eliteSystem, alpha,beta)

% number of ants
nAnts = 4;
n_clust=5;
minmaxSystem=0;
elitist=0;

alpha=3;
beta=1;

data=import_data();

pheromones= ones (size(data,1),size(data,1));

id=1:size(data,1);
% jaccard gives 1-jaccard coeff, but we want just the coeff where higher
% nrs are a better score. 
JD = 1-squareform(pdist(data,'cosine'));

if minmaxSystem ==1
    minmax=0.1;
else
    minmax=[];
end

q0=0.5;
decay =0.95;

bestScore=999999;
Progress=[];
BestProgress=[];
nIterations=100;

for j=1:nIterations

    parfor i=1:nAnts
        [score(i),path{i}] = runAnt (data,pheromones,id,JD,n_clust,q0,alpha,beta);
    end
    
    [localscore,bestIndex]=max(score);     
    
    if localscore <= bestScore
        bestScore=localscore;
        bestPath=path{bestIndex};
    end
    pheromones= update_Pheromones(pheromones,decay,localscore,path{bestIndex},minmax,elitist,bestPath, bestScore);
    Progress=[Progress,localscore];
    BestProgress=[BestProgress,bestScore];
end

%create clusters from the TSP solution
pheromones(pheromones<mean(mean(pheromones)))=0;
G=graph(pheromones);

while unique(conncomp(G))<5
  z=pheromones~=0;
  [minval,minidx]=min(pheromones(z));
  [x,y]= find(pheromones==minval);
  i=randi(size(x,1),1,1);
  pheromones(x(i),y(i))=0;
  pheromones(y(i),x(i))=0;
  G=graph(pheromones);
end
clustering = conncomp(G);