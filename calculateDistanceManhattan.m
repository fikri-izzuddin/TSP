function [ distances ] = calculateDistance( cities )
%calculateDistance Generates the distances matrix of given cities.

    [row, col] = size(cities);
    distances = zeros(col);

    for i=1:col;
        for j=1:col; 
            distances(i,j)= distances(i,j)+ abs(cities(1,i) - cities(2, i)) + abs(cities(1,j) - cities(2,j));
        end
    end
end

