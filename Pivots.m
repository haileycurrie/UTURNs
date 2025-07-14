%% Function to isolate pivots in different forms
% INPUTS:
% form: for pivots +/- df frames, enter number df. For pivots with
%       equitemporal tails, enter 'temporal'. for equidistant tails, enter
%       'distance'

function [pivots,IDrow,fpivot]=Pivots(tracks,disps,form,stimswitch)

%initialize empty cell array for just the pivots
pivots=cell(length(tracks),1);
if isnumeric(form)==1
    df=form;
    for ind=1:length(tracks)
        j=ind;
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2)));
        int=(max(xmin-df,0)); %account for tracks that enter fov w/in dr frames of the pivot
        if int==0
            int=1;
        end
        x=disps{j,1}(int:xmin+df,2);
        y=disps{j,1}(int:xmin+df,3)-disps{j,1}(int,3);
        z=tracks{j,1}(int:xmin+df,1);
        ID=disps{j,1}(1,4)*ones(length(x),1);
        %define the pivot track
        pivottrack=[x y z ID];
        %enter the pivot track into the pivots cell array
        pivots(j,1)={pivottrack};

        %remove tracks that enter the fov within df frames of the pivot
        if length(pivots{j,1}(:,:))<(2*df)
            pivots(j,:)=[];
            pivots=pivots(~cellfun('isempty',pivots));
        end
    end

    IDrow=zeros(1,length(pivots));
    for j=1:length(pivots)
        IDrow(1,j)=pivots{j,1}(1,4);
    end
    fpivot=0;
    IDrow=0;

elseif form=='distance'

    %non-symmetric bounds based on x position at switch time
    
    fpivot=zeros(length(tracks),1);
    %initialize empty cell array for just the pivots
    pivots=cell(length(tracks),1);

    for ind=1:length(tracks)
        j=ind;
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2))); %index at the pivot
        fpivot(j,1)=tracks{j,1}(xmin,1);
        %xpiv=min(disps{j,1}(:,2));%x at the pivot
        stimswitchdispsindex=find(disps{j,1}(:,1)==stimswitch);
        if isempty(stimswitchdispsindex)==1
            [~,nearest]=min(abs(disps{j,1}(:,1)-stimswitch));
            stimswitchdispsindex=nearest;
        end
        xswitch=disps{j,1}(stimswitchdispsindex,2); %x at time of stim switch

        [~,fend]=min(abs(disps{j,1}(xmin:end,2)-xswitch));

        x=disps{j,1}(stimswitchdispsindex:xmin+fend-1,2)-disps{j,1}(stimswitchdispsindex,2);
        y=disps{j,1}(stimswitchdispsindex:xmin+fend-1,3)-disps{j,1}(stimswitchdispsindex,3);
        z=tracks{j,1}(stimswitchdispsindex:xmin+fend-1,1);
        ID=disps{j,1}(1,4)*ones(length(x),1);
        %define the pivot track
        pivottrack=[z x y ID];
        %enter the pivot track into the pivots cell array
        pivots(j,1)={pivottrack};

    end

    IDrow=[];


elseif form=='temporal'
    %change df for each track st df = f(pivot)-stimswitch
    %initialize empty cell array for just the pivots
    pivots=cell(length(tracks),1);
    fpivot=zeros(length(tracks),1);
    for ind=1:length(tracks)
        j=ind;
        stimswitchindex=find(disps{j,1}(:,1)==stimswitch);
        %stimswitchtracksindex=find(tracks{j,1}(:,1)==stimswitch);
        xmin=find(disps{j,1}(:,2)==min(disps{j,1}(:,2)));
        fpivot(j)=tracks{j,1}(xmin,1);
        df=fpivot(j)-stimswitchindex;
        int=(max(xmin-df,1)); %account for tracks that enter fov w/in df frames of the pivot
        int2=(min(xmin+df,length(disps{j,1}))); %account for tracks that end before xmin+df
        x=disps{j,1}(int:int2,2)-disps{j,1}(int,2);
        y=disps{j,1}(int:int2,3)-disps{j,1}(int,3);
        z=tracks{j,1}(int:int2,1);
        ID=disps{j,1}(1,4)*ones(length(x),1);
        %define the pivot track
        pivottrack=[z x y ID];
        %enter the pivot track into the pivots cell array
        pivots(j,1)={pivottrack};

        %remove tracks that enter the fov within df frames of the pivot
        % if length(pivots{j,1}(:,:))<(2*df)
        %     pivots(j,:)=[];
        %     pivots=pivots(~cellfun('isempty',pivots));
        % end
    end

    IDrow=zeros(1,length(pivots));
    % for j=1:length(pivots)
    %     IDrow(1,j)=pivots{j,1}(1,4);
    % end
end
