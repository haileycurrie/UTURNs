% Prior trajectory vs UD Classification Hypothesis
% for i=1:length(disps)
%     disps{i,1}(:,2:3)=disps{i,1}(:,2:3)*(0.7364);
%     %disps{i,1}(:,5:6)=disps{i,1}(:,5:6)*(0.7364*24);
% end


% tiledlayout(5,5)
% for i=2000:2024
%     hold off
%     nexttile
%     hold on
%     viscircles([0,0],30)
%     surf([disps{i,1}(:,2) disps{i,1}(:,2)],[disps{i,1}(:,3) disps{i,1}(:,3)],[disps{i,1}(:,1) disps{i,1}(:,1)], ...  % Reshape and replicate data
%              'FaceColor', 'none', ...    % Don't bother filling faces with color
%              'EdgeColor', 'interp', ...  % Use interpolated color for edges
%              'LineWidth', 0.2);
%     view(2)
%     xlim([-45,45])
%     ylim([-45,45])
%     title(string(disps{i,1}(1,4)))
% end



%% sign of dy from stim start to pivot
%for each disps: take the initial y and the y at index xmin, take the
%difference. Add the track ID to a list (pos, neg). Compare pos/neg to
%up/down

posList=[]; negList=[];

for j=1:length(tracks)
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2))); %index at the pivot
        initialY = disps{j,1}(1,3); % initial y value
        pivotY = disps{j,1}(xmin,3); % y value at pivot
        
        dy = pivotY - initialY; % difference in y
        
        if dy > 0
            posList(end+1) = tracks{j}(1,4); % add to positive list
        else
            negList(end+1) = tracks{j}(1,4); % add to negative list
        end
end

up_pos=intersect(ups,posList);
down_neg=intersect(downs,negList);
agreement_rate_0p=(length(up_pos)+length(down_neg))/length(disps)

%% sign of dy from fpivot-k to pivot
agreement_rate_kp=[];
posList=[]; negList=[];
for k=1:24
    posList=[]; negList=[];
    for j=1:length(tracks)
            xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2))); %index at the pivot
            fpivot=disps{j,1}(xmin,1); %frame at the pivot
            priorf=find(disps{j,1}(:,1)==fpivot-k); %index k frames before pivot
            if isempty(priorf)
                [~,nearest]=(find(min(abs(disps{j,1}(1:xmin,1)-(fpivot-k)))));%index of next nearest extant frame
                priorf=nearest;
            end
            prior = disps{j,1}(priorf,3); % initial y value
            pivotY = disps{j,1}(xmin,3); % y value at pivot
            
            dy = pivotY - prior; % difference in y
            
            if dy > 0
                posList(end+1) = tracks{j}(1,4); % add to positive list
            else
                negList(end+1) = tracks{j}(1,4); % add to negative list
            end
    end
    
    up_pos=intersect(ups,posList);
    down_neg=intersect(downs,negList);
    agreement_rate_kp(k)=(length(up_pos)+length(down_neg))/length(disps);
    
end
xax=1:k;
figure
plot(xax,agreement_rate_kp)
yline(agreement_rate)
title('Agreement Rate of Sign(dy) vs k Frames Prior to Pivot')
xlabel('k')
ylabel('Fractional Agreement')