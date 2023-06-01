clear;
clc;
global gNumber;
load cities.mat

% Parameters
generationNumber = 200;
popSize = 100;
crossoverProbabilty = 0.9;
mutationProbabilty = 0.05;

[~, numberOfCities] = size(cities);
bestPathSoFar = Inf; 

% Calculating distances between cities according to created city locations.
distances = calculateDistanceEuclidean(cities);
% distances = calculateDistanceManhattan(cities);

% Generate population with random pathes.
pop = population(numberOfCities, popSize);
nextGeneration = zeros(popSize,numberOfCities);

%Keeping track of minimum pathes through every iteration.
minPathes = zeros(generationNumber,1);

% Genetic algorithm itself.
for  gN=1:generationNumber;

    % Calculate fitnesses for the pathes total distances.
    [fitnessValues, totalDistances, minPath, maxPath] = fitness(distances, pop);

    %tournamentSize = int32(popSize *0.2);
    tournamentSize=4;
    for k=1:popSize;
        % Choosing parents for crossover operation bu using tournament approach.
        tournamentPopDistances=zeros( tournamentSize,1);
        for i=1:tournamentSize;
            randomRow = randi(popSize);
            tournamentPopDistances(i,1) = totalDistances(randomRow,1);
        end

        % Selecting best element as a parent from the current tournament.
        parent1  = min(tournamentPopDistances);
        [parent1X,parent1Y] = find(totalDistances==parent1,1, 'first');
        parent1Path = pop(parent1X(1,1),:);


        for i=1:tournamentSize;
            randomRow = randi(popSize);
            tournamentPopDistances(i,1) = totalDistances(randomRow,1);
        end

        parent2  = min(tournamentPopDistances);
        [parent2X,parent2Y] = find(totalDistances==parent2,1, 'first');
        parent2Path = pop(parent2X(1,1),:);

        childPath = crossover(parent1Path, parent2Path, crossoverProbabilty);
        childPath = mutate(childPath, mutationProbabilty);

        nextGeneration(k,:) = childPath(1,:);
        
        minPathes(gN,1) = minPath; 
    end
    fprintf('Minimum path in %d. generation: %f \n', gN,minPath);
    
    gNumber = gN;
    % Assigning the created generation the current population.
    pop = nextGeneration;
    
    % Visualising the best path
    if minPath < bestPathSoFar;
        bestPathSoFar = minPath;
        visualizeGeneration(cities, pop, bestPathSoFar, totalDistances);
    end

end
figure 
plot(minPathes, 'MarkerFaceColor', 'blue','LineWidth',2);
title('Minimum Path Length for Each Generation');
set(gca,'ytick',500:100:5000); 
ylabel('Path Length');
xlabel('Generation Number');
grid on