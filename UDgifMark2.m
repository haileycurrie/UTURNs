function [gifname] = UDgifMark2(uturntif, gifname, ups, downs, tracks)

uturn = tiffreadVolume(uturntif);

% Prepare GIF writing parameters
delayTime = 0.1;  % seconds per frame
firstFrame = true;

fig = figure('visible','off');
axis off

for t = 2:size(uturn,3)
    clf;  % Clear axes instead of opening a new figure

    imshow(uturn(:,:,t), []);
    hold on

    % Plot 'ups'
    for k = 1:length(ups)
        ind = ups(k);
        frame = find(tracks{ind,1}(:,1) == t-1, 1);
        if ~isempty(frame)
            x = tracks{ind,1}(frame,2)*(1/0.6762);%(1/0.7362924) for 10x poseidon
            y = tracks{ind,1}(frame,3)*(1/0.6762);%(1/0.645) for 10 ORCA ER (1/0.7362924)
            u = tracks{ind,1}(frame,5);
            v = tracks{ind,1}(frame,6);
            scatter(x, y, 20, 'b', 'filled');
            quiver(x, y, u, v, 3, 'b');
            %text(x, y, num2str(ind), 'Vert','bottom', 'Horiz','left', 'FontSize',5);
        end
    end

    % Plot 'downs'
    for k = 1:length(downs)
        ind = downs(k);
        frame = find(tracks{ind,1}(:,1) == t-1, 1);
        if ~isempty(frame)
            x = tracks{ind,1}(frame,2)*(1/0.6762);
            y = tracks{ind,1}(frame,3)*(1/0.6762);
            u = tracks{ind,1}(frame,5);
            v = tracks{ind,1}(frame,6);
            scatter(x, y, 20, 'r', 'filled');
            quiver(x, y, u, v, 3, 'r');
            %text(x, y, num2str(ind), 'Vert','bottom', 'Horiz','left', 'FontSize',5);
        end
    end

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