function [path,distance] = pickClust (data,pheromones,id,JD,q0,alpha,beta)
%inv alpha and beta parameters as dist and phero will range between 0 and 1
beta=inv(beta);
alpha=inv(alpha);
     
% pick a random start point
[y,idx]= datasample(data,1);
% keep track of the ant's path
path= id(idx);
% keep track of the distance traveled
distance=[];
    
for i =1:size(data,1)-1     
    % get the Jaccard coefficient between current point and all other
    % unvisited points. points on the visited path are not to be considered
    % and therefore removed(ditto for the pheromone vector).
    dist=JD(idx,setdiff(id,path));
    % normalise distance
    if (sum(dist)>0)
        dist= dist/max(dist); 
    end
    % get the pheromone matrix for the current point
    phero=pheromones(idx,setdiff(id,path));
    % normalise pheromones
    if (sum(pheromones(idx,:))>0)
        phero = phero/max(phero);
    end
    %pheromones+distance to a datapoint is the probability the ant will travel 
    % to that point. A point is chosen using the cumsum and a random nr
    prob= (dist.^beta).*(phero.^alpha);
    clust_prob =cumsum(prob/sum(prob));
    clust_prob2=dist.*phero;
    % set random nr between 0 and 1
    q= rand;
     % select next point
     posId=(setdiff (id,path));     
     if q>q0
        [a,b]=max(clust_prob2);
        idx=posId(b);
     elseif q<=q0
        randomnr= rand;
        for j =1:size(clust_prob,2)
            if randomnr <= clust_prob(j)
                 % next point is set to be the new idx for the next iteration
               idx = posId(j);
               break
            end
        end
     end
    % add the chosen point to the path and distance traveled.
    path= [path, idx];
    distance=[distance, JD(path(end-1),path(end))];      
end

% add distance between last and first element in the path. In the TSP
% problem a complete tour ends up at the starting point
distance = [distance, JD(path(1),path(end))];
