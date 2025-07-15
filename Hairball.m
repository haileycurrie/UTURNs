%% Plot tracks/disps as a hairball
% Note subsets of disps may be fed in to compare a few tracks of
% interest or declutter the plot.
%
% INPUTS:
%
%   disps: tracks{:,1}(:,1:4) subtracting initial x y position, so that each track begins at
%       (0,0). (mainly for Hairball)
%       ex: disps(1:100)
% 
% OUTPUTS:
%
%    fig: figure object containing hairball plot of each input track as a
%       rainbow which begins blue (earliest frame) and ends red (latest
%       frame). Colors are scaled per-track, not global. ( :( )
%
%Hailey Currie
%Summer 2025
%

function fig=Hairball(disps)


fig(1)=figure
for i=1:length(disps) %loop over each cell in disps
    x=disps{i,1}(:,2);
    y=disps{i,1}(:,3);
    z=disps{i,1}(:,1); %determines color at each point based on frame number
    % Plot data: (surf trick from gnovice on stack overflow!)
    surf([x(:) x(:)], [y(:) y(:)], [z(:) z(:)], ...  % Reshape and replicate data
         'FaceColor', 'none', ...    % Don't bother filling faces with color
         'EdgeColor', 'interp', ...  % Use interpolated color for edges
         'LineWidth', 0.2);            % Make a thicker line
    hold on
    %yline(0)
    %xline(0)
end
view(2);   % Default 2-D view
colorbar;  % Add a colorbar
colormap('jet')

%for future reference, thanks gnovice: 
%https://stackoverflow.com/questions/45556001/how-to-create-a-color-gradient-using-a-third-variable-in-matlab/45556298