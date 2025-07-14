function [fig]=TilePlot(CropOpt,df,trackset,tracks,disps)
%function to plot tiled layout of a set of tracks/neighbors/pivots
%
%INPUTS:
% CropOpt: 'Y' or 'N'. For full tracks, CropOpt='N' (short for No Crop),
% for pivots only, CropOpt='Y' for Yes Crop the track.
% 
% df: number of frames on either side of minimum x to plot for the pivot
%
% trackset: array of indices of tracks to plot. For example, a neighbors
% array
%
% disps: disps output of TracksForm.m

if CropOpt=='N'
    %Plot a set of neighbors
    fig=figure
    d=ceil(sqrt(length(trackset))); %tile layout dimensions (round up)
    tiledlayout(d,d,"TileSpacing", "compact");
    
    
    for ind=1:length(trackset)
        nexttile
        j=trackset(ind);
        x=disps{j,1}(:,2);
        y=disps{j,1}(:,3);
        z=tracks{j,1}(:,1);
        surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', 2);
        
        lab=string(j);
        title(lab)
        view(2);   % Default 2-D view
        colorbar;  % Add a colorbar
        colormap('jet')
        
        yline(0)
        xline(0)
    end
elseif CropOpt=='Y'

    %Plot only pivot point
    
    fig=figure
    d=ceil(sqrt(length(trackset))); %tile layout dimensions (round up)
    tiledlayout(d,d);
    
    
    for ind=1:length(trackset)
        nexttile
        j=trackset(ind);
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2)));
        int=(max(xmin-df,0));
        if int==0
           int=1;
        end
        x=disps{j,1}(int:xmin+df,2)-disps{j,1}(int,2);
        y=disps{j,1}(int:xmin+df,3)-disps{j,1}(int,3);
        z=tracks{j,1}(int:xmin+df,1);
        surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
                 'FaceColor', 'none', ...    % Don't bother filling faces with color
                 'EdgeColor', 'interp', ...  % Use interpolated color for edges
                 'LineWidth', 2);
        
        lab=string(j);
        title(lab)
        view(2);   % Default 2-D view
        colorbar;  % Add a colorbar
        colormap('jet')
        %ylim([-20 20])
        %xlim([-10 10])
        axis equal
    end
else 
    disp('CropOpt options are str(Y) or str(N) only')
end