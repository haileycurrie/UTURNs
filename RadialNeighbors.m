function [neighbors]=RadialNeighbors(cellint,r,tracks)
% Inefficient function to find initial euclidean nearest neighbors of a cell within some radius
% INPUTS:
% 
% cellint: track ID of the cell of interest
% r: radius in pixels to search for neighbors
% tracks: formatted tracks from TracksForm or importTrackMateTracks
%

%change frame indexing to start at 1 instead of 0
pos=tracks;
for i=1:size(tracks,1)
    pos{i,1}(:,1)=pos{i,1}(:,1)+1;
end

%initialize neighbors to include the cell of interest first
neighbors=[cellint];

%find xyt position of cell of interest
X=pos{cellint,1}(1,2);
Y=pos{cellint,1}(1,3);
T=pos{cellint,1}(1,1); %first frame of the track of cell of interest: Flexible in case track started after first frame

%search for nearest neighbors one by one
for k=1:length(tracks) %loop over every cell to find cells w/in r
    a2=(abs(X-tracks{k,1}(T,2)))^2; %x component distance sqrd
    b2=(abs(Y-tracks{k,1}(T,3)))^2; %y component distance sqrd
    R=sqrt(a2+b2);%net distance betwen cells sqrd
    if (0<R) & (R<r) %screen for self term, radius of intrxn
        neighbors(end+1)=k; %add cell index to list of neighbors
    end
end
     