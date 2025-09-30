%% Function to mark original image with blue/red dots for a down/up tracks
% For visualizing up/down tracks overlaid on original images. Colored dots
% for tracks and quiver/lines showing frame-frame velocity.
% More optimized than gifMark (thanks chatGPT), but still SLOW.
%
%
% INPUTS:
%
%   uturntif: filename/path to original data saved as a tif stack as a char
%
%   gifname: filename to save the produced gif under
%
%   ups: output by (__) list of indices corresponding to up turns
%
%   downs: output by (___) list of indices corresponding to down turns
%   
%   tracks: output by TracksForm: cell array, one cell for each track. Each track contains 6
%       columns, in order: frame (t), x pos, y pos, track ID, dx, dy
%
% OUTPUTS:
%
%   gif: a gif showing red dots for each up track and blue dots for each down track
%       overlaid on theoriginal images
% 
%
%Hailey Currie
%Summer 2025
%

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