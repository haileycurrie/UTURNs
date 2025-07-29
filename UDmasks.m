%% Function to mask the label image into up and down stacks.
% For visualizing up/down tracks based on labe. Colored dots
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

function [out]=UDmasks(filename,tracks,ups,downs)

labels=tiffreadVolume(filename);

%% convert ups and downs track indices to label tags
upvalues=zeros(1,length(ups));
for i=1:length(ups)
    upvalues(i)=tracks{ups(i)}(1,4);
end

downvalues=zeros(1,length(downs));
for j=1:length(downs)
    downvalues(j)=tracks{downs(j)}(1,4);
end

%% up masks

for i=1:size(labels,3)
    uplabels=labels(:,:,i);
    upmask=ismember(uplabels, upvalues);
    uplabels=labels(:,:,i).*upmask;
    uplabels=uint32(uplabels);
    %write tiff to stack
    lab="uplabels"+string(filename)+string(i);
    tup=Tiff(string(lab),"w");
    setTag(tup,"Photometric",Tiff.Photometric.MinIsBlack)
    setTag(tup,"ImageLength",size(labels,1))
    setTag(tup,"ImageWidth",size(labels,2))
    setTag(tup,"BitsPerSample",32)
    write(tup,uplabels(:,:,1));
end
    close(tup)

    %% down masks
for i=1:size(labels,3)
    downlabels=labels(:,:,i);
    downmask=ismember(downlabels, downvalues);
    downlabels=labels(:,:,i).*downmask;
    downlabels=uint32(downlabels);
    %write tiff to stack
    lab="downlabels"+string(filename)+string(i);
    tdown=Tiff(string(lab),"w");
    setTag(tdown,"Photometric",Tiff.Photometric.MinIsBlack)
    setTag(tdown,"ImageLength",size(labels,1))
    setTag(tdown,"ImageWidth",size(labels,2))
    setTag(tdown,"BitsPerSample",32)
    write(tdown,downlabels(:,:,1));
end
    close(tdown)

    out="finished";
