function [ finalMatrix ] = make_predictions1(sM, sD, inputMovies, k, n)
%MAKE_PREDICTIONS Accept a matrix containing vector representations of
%input movies, and return a list of n movie predictions chosen from k best
%matching map units. 
% Making predictions by taking all movies from the BMUs and picking the
% best ones. 

% Combining input movies into one vector
combinedInput = sum(inputMovies);

% Clamping inputs - no value should be greater than 1
gtOne = find(combinedInput>1);
for i=1:length(gtOne)
    combinedInput(gtOne(i)) = 1;
end;

% Finding the top k BMUs for the combined input.
BMUs = som_bmus(sM, combinedInput, [1:k]);

[V,I] = som_divide(sM, sD);

% inputVector = sD.data(find(ismember(sD.labels(:,2), '42')),:);
% sum0 = 0;
% sum1 = 0;
% for i=1:3771
%     if(isempty(inputVector(i)))
%         i
%     elseif(inputVector(i)==1)
%         sum1=sum1+1;
%     elseif(inputVector(i)==0)
%         sum0=sum0+1;
%     end;
% end;
% sum0+sum1


resultMatrix = zeros(n, 2);
temp=1;
%perBin = ceil(n/k) + 2;
% moreMovies = 0;
%I{BMUs(1)}

% '2' contains the movie ID in sD.labels
for i=1:k
    movieBin = I{BMUs(i)};
    numberOfMovies = length(movieBin);      
    distanceMatrix = zeros(numberOfMovies,2);
    for j=1:numberOfMovies
        movieID = movieBin(j);
        distanceMatrix(j,1) = movieID;
        inputVector = sD.data(movieID,:);
        distanceMatrix(j,2) = som_eucdist2(combinedInput, inputVector);
    end;
    %Sort distance matrix on the basis of distance
    distanceMatrix = sortrows(distanceMatrix,2);
    resultMatrix(temp:temp+numberOfMovies-1,1:2) = distanceMatrix(1:numberOfMovies,1:2);
    temp=temp+numberOfMovies;
end;

resultMatrix = sortrows(resultMatrix,2);
numberOfResults = length(resultMatrix);
if(numberOfResults > n)
    resultMatrix = resultMatrix(1:n,:);
end;
finalMatrix = resultMatrix;
return;
end

