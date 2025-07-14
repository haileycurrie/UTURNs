%% Format tracks from the trackmate output .xml into cell arrays
% function to 
% 1. filter tracks that are too short to analyze
% 2. zero the tracks data to common origin (output disps),
% 3. calculate and save (unscaled) velocities into tracks.
%
% INPUTS:
% 
%   mindur: minimum duration, in frames, of the tracks to analyze
%
%   stimstart: frame number when (forward) stim starts, used to truncate out
%       the control period. Use 0 for no control.
% 
% OUTPUTS:
%
%   tracks: cell array, one cell for each track. Each track contains 6
%       columns, in order: frame (t), x pos, y pos, track ID, dx, dy
%
%   disps: tracks{:,1}(:,1:4) subtracting initial x y position, so that each track begins at
%       (0,0). (mainly for Hairball)
%
%
%Hailey Currie
%Summer 2025
%
function [tracks, disps]=TracksForm(filename,mindur,stimstart)

%import tracks (must add FIJI to path to use this fxn)
tracks=importTrackMateTracks(filename);

%before removing any tracks, ID tag them in their last column and crop the
%control period out
for i=1:length(tracks)
    tracks{i,1}(:,4)=i; 
    tracks{i,1}=tracks{i,1}((stimstart+1):end,:); %crop pre-stim control (comment this out to include control in analysis)
end

%remove tracks less than the minimum duration (see note in readme)
I=find(cellfun(@length,tracks)>mindur);
tracks=tracks(I);


%create disps: set initial (x,y)=(0,0) for each track (a la hairball)
disps=tracks;
for i=1:size(tracks,1) %iterate over each track in the cell array
    %subtract first value in x from x positions in column 2
    disps{i,1}(:,2)=disps{i,1}(:,2)-disps{i,1}(1,2);
    %subtract first value in y from y positions in column 3
    disps{i,1}(:,3)=disps{i,1}(:,3)-disps{i,1}(1,3);
    
    %calculate frame-frame x and y displacements (velocity in px/frame)
    for f=2:length(disps{i,1}(:,1)) %iterate over frames of track i
        %calculate steps in x and y in column 5 and 6 ("velocity" in px/frame)
        tracks{i,1}(1,5)=0;
        tracks{i,1}(f,5)=disps{i,1}(f,2)-disps{i,1}(f-1,2);
        tracks{i,1}(1,6)=0;
        tracks{i,1}(f,6)=disps{i,1}(f,3)-disps{i,1}(f-1,3);
        
        % %smooth velocity by averaging over past 3 frames
        % tracks{i,1}(1:4,7)=0;
        % if f>4
        % tracks{i,1}(f,7)=mean(tracks{i,1}(f-3:f,6));
        % end
    end
end



