function fig=Hairball(tracks, disps)


fig(1)=figure
for i=1:length(disps)
    x=disps{i,1}(:,2);
    y=disps{i,1}(:,3);
    z=disps{i,1}(:,1);
    % Plot data:
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