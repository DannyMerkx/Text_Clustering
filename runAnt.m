function [total_dist,path] = runAnt (data,pheromones,id,JD,n_clust,q0,alpha,beta)

% have the ant create a TSP route
[path,distance]= pickClust (data,pheromones,id,JD,q0,alpha,beta);

% calc total distance travelled by the ant
total_dist= sum (1-distance);
