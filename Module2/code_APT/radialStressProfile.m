function [newRadialProfile]=radialStressProfile(r,force,midy,midx,pnumberi,i,TFM_settings,method)
%%
% Decomposes the stress output from TFM into radial and angular stresses
% Right now, assumes center of image is center of symmetry
% From 2D radial stress map, radialStressProfile takes angular average
% Written A. Pasha Tabatabai 180817
%%%%%%%%%%

maxDistance=midx;
maxDistanceMicrons=maxDistance*TFM_settings.micrometer_per_pix;
profileSums = zeros(1, maxDistance);
profileCounts = zeros(1, maxDistance);



switch method
    case 1 %% if you want to consider entire image
        maxDistance=midx;
        maxDistanceMicrons=maxDistance*TFM_settings.micrometer_per_pix;
        profileSums = zeros(1, maxDistance);
        profileCounts = zeros(1, maxDistance);
        for kk=1:size(force,1)
            
            thisDistance=round(sqrt((r.pos(kk,1)-midx)^2+(r.pos(kk,2)-midy)^2));
            if thisDistance<=maxDistance
                profileSums(thisDistance) = profileSums(thisDistance) + force(kk);
                profileCounts(thisDistance) = profileCounts(thisDistance) + 1;
            end
        end
        
    case 2 %% if you want to consider vertically biased image sample (think hourglass)
        maxDistance=midy;
        maxDistanceMicrons=maxDistance*TFM_settings.micrometer_per_pix;
        profileSums = zeros(1, maxDistance);
        profileCounts = zeros(1, maxDistance);
        
        %test=zeros(size(r.pos));
        for kk=1:size(force,1)
            
            inRegion=0;
            factor=0.5;
            if abs(r.pos(kk,1)-midx)<factor*abs(r.pos(kk,2)-midy)
                inRegion=1;
                
            end
            
            
            thisDistance=round(sqrt((r.pos(kk,1)-midx)^2+(r.pos(kk,2)-midy)^2));
            if thisDistance<=maxDistance && inRegion
                profileSums(thisDistance) = profileSums(thisDistance) + force(kk);
                profileCounts(thisDistance) = profileCounts(thisDistance) + 1;
                %test(kk,:)=1; %APT confirmed selecting correct image area
            end
        end
        
    otherwise
        disp('You have incorrectly specified a value for method')
end
%keyboard

%averageRadialProfile = profileSums ./ profileCounts;
dbin=10;
bins=1:dbin:(0.8*maxDistance);
newRadialProfile.sum=zeros(size(bins));
newRadialProfile.std=zeros(size(bins));
for kk=1:length(bins)
    newRadialProfile.sum(kk)=nansum(profileSums(bins(kk):(bins(kk)+dbin)))/nansum(profileCounts(bins(kk):(bins(kk)+dbin)));
    newRadialProfile.std(kk)=nanstd(profileSums(bins(kk):(bins(kk)+dbin)))/nansum(profileCounts(bins(kk):(bins(kk)+dbin)));
end
newRadialProfile.DistFromCenterMicrons=bins.*TFM_settings.micrometer_per_pix;
figure(6),errorbar(newRadialProfile.DistFromCenterMicrons, newRadialProfile.sum,newRadialProfile.std, '.k');
legend(['frame' int2str(i)],'location','northwest')
title('Average Radial Profile');
xlabel('Distance from center um');
ylabel('Average Radial Stress Pa');
xlim([0,maxDistanceMicrons])
ylim([0,50]) %% Arbitary cutoff- change this if needed
%llmFig('lw',1)
if ~exist('radialAvgStressAPT','dir')
    mkdir('radialAvgStressAPT')
end

str_name1=['radialAvgStressAPT' filesep 'heat_'  pnumberi int2str(i) '.tif'];
saveas(gca,str_name1);


end