%% Function to mark original image with labelled dots for a set of tracks
% For visualizing a set of tracks to compare to the original data. Can be
% helpful to check whether tracking or track sorting is accurate, neighboring tracks behave
% as expected, etc. SLOW.
%
%
% INPUTS:
%
%   uturntif: filename/path to original data saved as a tif stack as a char
%
%   gifname: filename to save the produced gif under
%
%   trackset: array of indices for the tracks to be marked
%   
%   tracks: output by TracksForm: cell array, one cell for each track. Each track contains 6
%       columns, in order: frame (t), x pos, y pos, track ID, dx, dy
%
% OUTPUTS:
%
%   gif: a gif showing dots for each track in trackset overlaid on the
%       original images
% 
%
%Hailey Currie
%Summer 2025
%



function [gifname]=gifMark(uturntif,gifname,trackset,tracks)

%load in original images
uturn=tiffreadVolume(uturntif);

%iterate over each frame
for t=1:size(uturn,3)
    fig = figure('visible','off'); %do not view figure (would be much slower)
    imshow(uturn(:,:,t)); %load in original image
    hold on
    
    %iterate over each track position in frame t
    for ind=1:length(trackset) %index of tracks in trackset
        j=trackset(ind); %j is track ID
        frame=find(tracks{j,1}(:,1)==t-1);
        
        if ~(isempty(frame)) %if the track is present in frame t,
        
            x=tracks{j,1}(frame,2)*(1/0.7362924); %scaled for Poseidon 10x
            y=tracks{j,1}(frame,3)*(1/0.7362924); %scaled for Poseidon 10x
            scatter(x,y,9,'MarkerEdgeColor',[0 .5 .5],... 
              'MarkerFaceColor',[0 .7 .7]); %plot dot for each track
            jtxt=string(j);
            text(x, y, jtxt, 'Vert','bottom', 'Horiz','left', 'FontSize',7) %label each dot with index j
        end
    end 

    exportgraphics(gcf,gifname,'Append',true); %save each image
end
hold off