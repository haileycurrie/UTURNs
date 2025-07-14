function [tracks, disps]=TracksForm(filename,mindur,stimstart)
%function to zero the tracks data to common origin (output disps),
%calculate and tabulate velocities into tracks.
%INPUT:
% mindur: minimum duration, in frames, of the tracks to analyze
% stimstart: frame number when (forward) stim starts, used to truncate out
% the control period
%OUTPUT:
% tracks: cell array, one cell for each track. Each track contains 7
% columns, in order: frame (t), x pos, y pos, track ID, dx, dy, smoothed dy
%
% disps: tracks{:,1}(:,1:4) subtracting initial x y position, so that each track begins at
% (0,0). (mainly for Hairball)

%import tracks
tracks=importTrackMateTracks(filename);

%before removing any tracks, ID tag them in their last column and crop the
%control period out
for i=1:length(tracks)
    tracks{i,1}(:,4)=i; %ID tag, to connect with shape parameters?
    tracks{i,1}=tracks{i,1}((stimstart+1):end,:); %crop pre-stim control
end

%remove tracks less than the minimum duration
I=find(cellfun(@length,tracks)>mindur);
tracks=tracks(I);




%set origin at 0
disps=tracks;
for i=1:size(tracks,1)
    %subtract first value in x from column 2
    disps{i,1}(:,2)=disps{i,1}(:,2)-disps{i,1}(1,2);
    %subtract first value in y from column 3
    disps{i,1}(:,3)=disps{i,1}(:,3)-disps{i,1}(1,3);
    %iterate over frames of track i
    for f=2:length(disps{i,1}(:,1))
        %calculate steps in x and y in column 5 and 6 ("velocity" in px/frame)
        tracks{i,1}(1,5)=0;
        tracks{i,1}(f,5)=disps{i,1}(f,2)-disps{i,1}(f-1,2);
        tracks{i,1}(1,6)=0;
        tracks{i,1}(f,6)=disps{i,1}(f,3)-disps{i,1}(f-1,3);
        %smooth velocity by averaging over past 3 frames
        tracks{i,1}(1:4,7)=0;
        if f>4
        tracks{i,1}(f,7)=mean(tracks{i,1}(f-3:f,6));
        end
    end
end



