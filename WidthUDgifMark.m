function [gifname] = WidthUDgifMark(uturntif, gifname, ups, downs, tracks, dcurve, widths)

uturn = tiffreadVolume(uturntif);

%create colormap for width
cmap=brewermap(100,'YlOrRd');
%scaling=linspace(min(dcurve),max(dcurve),11); %diverging map (to use,
%scaling=linspace(0,max(abs(dcurve)),100);
scaling=linspace(0,1000,100);


% Prepare GIF writing parameters
delayTime = 0.1;  % seconds per frame
firstFrame = true;

fig = figure('visible','off');
axis off

for t = [1,32]
    clf;  % Clear axes instead of opening a new figure

    imshow(uturn(:,:,t), []);
    hold on

    % Plot 'ups'
    for k = 1:length(ups)
        ind = ups(k);
        frame = find(tracks{ind,1}(:,1) == t-1, 1);
        if ~isempty(frame)
            x = tracks{ind,1}(frame,2)*(1/0.7362924);
            y = tracks{ind,1}(frame,3)*(1/0.7362924);
            %scatter(x, y, 40, 'b', 'filled');
            [~,colr]=(min(abs(scaling-abs(widths{k,1}(1,8)))));
            scatter(x, y, 20, cmap(colr,:), 'filled');
            %text(x, y, num2str(ind), 'Vert','bottom', 'Horiz','left', 'FontSize',5);
        end
    end

    % % Plot 'downs'
    % for k = 1:length(downs)
    %     ind = downs(k);
    %     frame = find(tracks{ind,1}(:,1) == t-1, 1);
    %     if ~isempty(frame)
    %         x = tracks{ind,1}(frame,2)*(1/0.7362924);
    %         y = tracks{ind,1}(frame,3)*(1/0.7362924);
    %         %scatter(x, y, 40, 'r', 'filled');
    %         [~,colr]=(min(abs(scaling-abs(widths{k,1}(1,8)))));
    %         scatter(x, y, 20, cmap(colr,:), 'filled');
    %         %text(x, y, num2str(ind), 'Vert','bottom', 'Horiz','left', 'FontSize',5);
    %     end
    % end

    drawnow;
    frame = getframe(gca); % Capture the axis only (faster than gcf)
    im = frame2im(frame);
    [A, map] = rgb2ind(im, 256);

    if firstFrame
        imwrite(A, map, gifname, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
        firstFrame = false;
    else
        imwrite(A, map, gifname, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end

close(fig);