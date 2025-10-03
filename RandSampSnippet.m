% %Random sampling, scaled
% for i=1:length(disps)
%     disps{i,1}(:,2:3)=disps{i,1}(:,2:3)*(0.7364);
%     %disps{i,1}(:,5:6)=disps{i,1}(:,5:6)*(0.7364*24);
% end

sample=randi([1,14816],1,50);
figure
tiledlayout(5,10);
for i=sample
    hold off
    nexttile;
    hold on
    viscircles([0,0],30);
    surf([disps{i,1}(:,2) disps{i,1}(:,2)],[disps{i,1}(:,3) disps{i,1}(:,3)],[disps{i,1}(:,1) disps{i,1}(:,1)], ...  % Reshape and replicate data
             'FaceColor', 'none', ...    % Don't bother filling faces with color
             'EdgeColor', 'interp', ...  % Use interpolated color for edges
             'LineWidth', 0.2);
    view(2);
    xlim([-45,45]);
    ylim([-45,45]);
    title(string(disps{i,1}(1,4)));
end
