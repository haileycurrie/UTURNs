%% Function to classify up/down turns
% Classifying ups/downs based on the sign of the cumulative change in angle
% over the course of the turn.
%
% INPUTS:
%
%   pivots: output by Pivots.m: disps array truncated to the pivot rows: cell array, one cell 
%       for each track. Each track contains 4 columns, in order: frame (t), 
%       x pos, y pos, track ID.
% 
%   trackset: array of indices of tracks to classify. Usually, all tracks. 
%       ex: 1:length(tracks)   
%
% OUTPUTS:
%
%   ups: a list of track indices classified as up
%
%   downs: a list of track indices classified as down
% 
%
%Hailey Currie
%Halloween 2025
%

function [cws, ccws,pivots] = classifyTurns(pivots, trackset)

%first, calculate angle steps for each point in pivots:
for i=1:length(pivots) 
    dx=pivots{i}(2:end,2)-pivots{i}(1:end-1,2);
    dy=pivots{i}(2:end,3)-pivots{i}(1:end-1,3);
    a=[];
    theta=[];
    a(1)=0;
    theta(1)=atan2d(dy(1),dx(1));
    for j=2:length(pivots{i})-2
        u=[dx(j),dy(j),0];
        v=[dx(j+1),dy(j+1),0];
        theta(j)=vecangle360(v,u);
        a(j)=vecangle360(v,u)-theta(j-1);
    end
    pivots{i}=[pivots{i},[0;atan2d(pivots{i}(2,2),pivots{i}(2,3));a';0]];
end

cws = []; % Initialize ups array
ccws = []; % Initialize downs array
    for i = trackset
        if size(pivots{j,1},1)>3 %there must be at least 3 points in pivots to proceed.
            dAngle=sum(pivots{i}(:,5));
            
            
            cumulativeChange = sum(diff(pivots{i}(:, 1))); % Calculate cumulative change in angle
        if cumulativeChange > 0
            cws = [cws; i]; % Classify as up
        elseif cumulativeChange < 0
            ccws = [ccws; i]; % Classify as down
        end
    end
end