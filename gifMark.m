function [gifname]=gifMark(uturntif,gifname,trackset,tracks)
% function to mark a set of cells on the gif

%Mark Tracked Cells on Overlay
uturn=tiffreadVolume(uturntif);

for t=1:size(uturn,3)
    fig = figure('visible','off');
    imshow(uturn(:,:,t));
    hold on
    for ind=1:length(trackset)
        j=trackset(ind);
        frame=find(tracks{j,1}(:,1)==t-1);
        if ~(isempty(frame))
        x=tracks{j,1}(frame,2)*(1/0.7362924);
        y=tracks{j,1}(frame,3)*(1/0.7362924);
        scatter(x,y,9,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7]);
        jtxt=string(j);
        text(x, y, jtxt, 'Vert','bottom', 'Horiz','left', 'FontSize',7)
        end
    end 
    exportgraphics(gcf,gifname,'Append',true);
end
hold off