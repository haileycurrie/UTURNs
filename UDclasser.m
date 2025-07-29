%% Function to classify up/down turns
% Calssifying ups/downs based on the sign of the difference in the areas
% under the curves before and after the pivot point.
%
%
% INPUTS:
%
%   pivots: output by Pivots.m: disps array truncated to the pivot rows: cell array, one cell 
%       for each track. Each track contains 4 columns, in order: frame (t), 
%       x pos, y pos, track ID.
% 
%   trackset: array of indices of tracks to classify. Usually, all tracks. 
%       ex: 1:length(tracks)
%
%   plt: choose whether to plot the split curves. plt=1 to plot, anything else not to.   
%
% OUTPUTS:
%
%   ups: a list of track indices classified as up
%
%   downs: a list of track indices classified as down
%
%   fig: a tiled layout plot of each split track in trackset
% 
%
%Hailey Currie
%Summer 2025
%

function [ups, downs]=UDclasser(pivots,trackset,plt)

%trackset=1:length(tracks);
%plt=0


if plt==1
    fig=figure;
    d=ceil(sqrt(length(trackset))); %tile layout dimensions (round up)
    tiledlayout(d,d);
end

%initialize arrays to store data
dcurve=zeros(length(pivots),1);
ups=[];
downs=[];

for j=trackset %iterate over each track
    if size(pivots{j,1},1)>3 %there must be at least 3 points in pivots to proceed.
    
        % split the data into pre/post pivot
        xmin=find(pivots{j,1}(:,2)==min(pivots{j,1}(:,2))); %find index of minimum x
        ymin=find(pivots{j,1}(:,3)==min(pivots{j,1}(:,3))); %find index of minimum y
        yminv=pivots{j,1}(ymin,3); %take minimum y value (at ymin index)
        xs1=pivots{j,1}(1:xmin,2); %first set of x's preceed the xmin index
        xs2=pivots{j,1}(xmin:end,2); %second set of x's follow the xmin index
        
        %translate the curves so that any with negative yminv sit at or
        %above 0 for integration reasons later, preserving relative dy's
        ys1=pivots{j,1}(1:xmin,3)+abs(yminv); %first set of y's preceed the xmin index,
        ys2=pivots{j,1}(xmin:end,3)+abs(yminv); %second set of y's follow the xmin index
        
        points1=[xs1';ys1'];
        points2=[xs2';ys2'];
        curve1=cscvn(points1);
        curve2=cscvn(points2);

    %PLOT: optional, plot the first half of the curve blue and the second
    %half gold
    if plt==1
        nexttile
        fnplt(curve1); hold on, 
        plot(points1(1,:),points1(2,:),'o'), 
        fnplt(curve2); 
        plot(points2(1,:),points2(2,:),'o'),
        yline(pivots{j,1}(xmin,3)+abs(yminv));
        yline(min(ys1),'blue');
        yline(min(ys2),'color',[0.9290 0.6940 0.1250]);
        lab=string(j);
        title(lab)
        %axis equal
        hold off
    end

    %Calculate 0 shift for higher curve (whichever has the higher ymin)
    if min(ys1)>min(ys2)
        w=[abs(pivots{j,1}(xmin,2)-pivots{j,1}(1,2));0];
    elseif min(ys1)<min(ys2)
        w=[0;abs(pivots{j,1}(xmin,2)-pivots{j,1}(end,2))];
    end
    shift=(abs(min(ys1)-min(ys2))*w); %add area of a rectangle to account for difference in y height
    
    %INTEGRATE
    %Area Under Curve of pre-turn
    indefint1=fnint(curve1); %indefinite
    fin1=fnval(indefint1,curve1.breaks(end));
    in1=fnval(indefint1,curve1.breaks(1));
    AUC1=fin1-in1+shift(1,1);
    
    %area under curve post-turn
    indefint2=fnint(curve2); %indefinite
    fin2=fnval(indefint2,curve2.breaks(end));
    in2=fnval(indefint2,curve2.breaks(1));
    AUC2=fin2-in2+shift(2,1);
    
    %difference
    dcurve(j,1)=AUC2(2,1)-AUC1(2,1); %if dcurve is +, up turn, -, down turn
    
    %add index to appropriate list
    if sign(dcurve(j,1))==1
        ups(end+1)=j;
    else
        downs(end+1)=j;
    end
    end
end
