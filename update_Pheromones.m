function [pheromones] = update_Pheromones (pheromones,decay,score,path,minmax,eliteSystem,bestPath, bestScore)
    
    %rewards depend on the score of the tour. Since the tour lenght is not
    %only dependent on the ants performance but also on the amount of
    %visited nodes, we normalise for number of nodes. We do not want to
    %punish the ants for the size of the database
    score= score/size(path,2);
    
    % if minmax system define the upper bound using the global best score
    if ~isempty(minmax)
        bestScore= bestScore/size(path,2);
        minmax(2)= 1/bestScore;
    end
    % define the reward using the local best score
    reward=(1-decay)* (1/score);
    % apply decay to all edges
    pheromones= pheromones*decay;
    %apply the reward to the edges in the local best solution
for i=1:size(path,2)-1
    pheromones(path(i),path(i+1))= pheromones(path(i),path(i+1))+reward;
    pheromones(path(i+1),path(i))= pheromones(path(i+1),path(i))+reward;
end
% apply decay to the path between the first and last node in the tour
pheromones(path(1),path(end))=pheromones(path(1),path(end))+reward;
pheromones(path(end),path(1))=pheromones(path(end),path(1))+reward;
% if elite system apply reward to the edges of the global best solution
if eliteSystem
    for i=1:size(bestPath,2)-1
        pheromones(bestPath(i),bestPath(i+1))= pheromones(bestPath(i),bestPath(i+1))+reward;
        pheromones(bestPath(i+1),bestPath(i))= pheromones(bestPath(i+1),bestPath(i))+reward;
    end
    pheromones(bestPath(1),bestPath(end))=pheromones(bestPath(1),bestPath(end))+reward;
    pheromones(bestPath(end),bestPath(1))=pheromones(bestPath(end),bestPath(1))+reward;
end
% if minmax system reset pheromones to the min value or max value if needed
if ~isempty(minmax)
    pheromones(pheromones<minmax(1))=minmax(1);
    pheromones(pheromones>minmax(2))=minmax(2);
end
    