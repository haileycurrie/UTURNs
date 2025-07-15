%% Function to isolate pivots by different methods
% I'm still deciding what the best way to classify up vs down turns for our
% purposes will be. The first step is to truncate the tracks to consider
% only the "turn," or the "pivot", region, since tracks tend to get
% squirrely once order is regained after stim change/ after the turn is
% executed. See readme for further thoughts.
%
% Steps:
% 1: Identify the "apex" of the turn as the most extreme x position
%   achieved during the turn. (For this code, rotate the video or track data st 
%   this is a /minimum/ x)
%
% 2: EITHER
%   a. truncate the track +/- df frames from this apex so that the pivots
%   are equitemporally distributed about the apex
%
%   b. trunctate the track +/- ~dx pixels from this apex by taking the
%   position of the cell at some frame /prior/ to the apex and finding the
%   point with the nearest x value /after/ the apex so that the pivots are
%   ~equidistantly distributed about the apex (see readme)
%
%   Because cell speed isn't necessarily constant, especially at time of
%   stim switch/pivot, these aren't necessarily going to produce the same
%   plots for the same initial frame.
%
% INPUTS:
%
%   tracks: output by TracksForm: cell array, one cell for each track. Each track contains 6
%       columns, in order: frame (t), x pos, y pos, track ID, dx, dy
%
%   disps: output by TracksForm: tracks{:,1}(:,1:4) subtracting initial x y position, so that each track begins at
%       (0,0).
%
%   form: choice of method. For a., enter df as an integer to select the
%       range of frames to include in the pivot. For b., enter 'distance'
%       including the '' symbols.
%       
%   prior: for method a., enter any integer (ignored). For method b., if
%       form='distance', enter the number of frames before the pivot point
%       to set define the distance by.
% 
% OUTPUTS:
%
%   pivots: disps array truncated to the pivot rows: cell array, one cell 
%       for each track. Each track contains 4 columns, in order: frame (t), 
%       x pos, y pos, track ID.
% 
%
%Hailey Currie
%Summer 2025
%


function [pivots]=Pivots(tracks,disps,form,prior)

%initialize empty cell array for just the pivots
pivots=cell(length(tracks),1);

if isnumeric(form)==1 
    df=form;
    
    for j=1:length(tracks) %iterate over each track
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2))); %identify index of each minimum x (frame +1)
        
        %if track begins w/in df frames of the pivot, then take the first
        %frame of the track instead of xmin-df
        int=(max(xmin-df,0)); 
        if int==0
            int=1;
        end

        %isolate pivots rows (xmin+/- df) from disps
        x=disps{j,1}(int:xmin+df,2); 
        y=disps{j,1}(int:xmin+df,3)-disps{j,1}(int,3);
        z=tracks{j,1}(int:xmin+df,1);
        ID=disps{j,1}(1,4)*ones(length(x),1);
        %define the pivot track
        pivottrack=[x y z ID];
        %enter the pivot track into the pivots cell array
        pivots(j,1)={pivottrack};

        %remove tracks that enter the fov within df frames of the pivot
        if length(pivots{j,1}(:,:))<(2*df)
            pivots(j,:)=[];
            pivots=pivots(~cellfun('isempty',pivots));
        end
    end

elseif form=='distance'

    %non-symmetric bounds based on x position at prior time

    for j=1:length(tracks)
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2))); %index at the pivot
        
        priorframe=find(disps{j,1}(:,1)==prior); %find index of prior frame (may differ from prior+1 when track begins after t=0, etc)
        
        %if the prior frame is before the track begins, or that frame is
        %skipped during tracking, take the nearest preceeding frame that does exist
        if isempty(priorframe)==1  
            [~,nearest]=min(abs(disps{j,1}(:,1)-prior));
            priorframe=nearest;
        end

        xprior=disps{j,1}(priorframe,2); %x at time of prior frame

        [~,fend]=min(abs(disps{j,1}(xmin:end,2)-xprior)); %find the frame after the pivot that is nearest in x position to xprior

        %isolate pivot rows (xprior +/- dx) from disps
        x=disps{j,1}(priorframe:xmin+fend-1,2)-disps{j,1}(priorframe,2); %second term sets initial position to 0
        y=disps{j,1}(priorframe:xmin+fend-1,3)-disps{j,1}(priorframe,3); %second term sets initial position to 0
        z=tracks{j,1}(priorframe:xmin+fend-1,1);
        ID=disps{j,1}(1,4)*ones(length(x),1);
        %define the pivot track
        pivottrack=[z x y ID];
        %enter the pivot track into the pivots cell array
        pivots(j,1)={pivottrack};

    end

end
