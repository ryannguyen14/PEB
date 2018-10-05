function directionalTraction(varargin)
%% 
% Decomposes the stress output from TFM into radial and angular stresses
% Right now, assumes center of image is center of symmetry
% From 2D radial stress map, radialStressProfile takes angular average
% Written A. Pasha Tabatabai 180817
% Added method flag APT 180905
% Removed 3*r.vec term in interp_vec2grid input APT 180905
%%%%%%%%%%


load('/Users/ryannguyen/Desktop/PEB/Module2/task1/example1/Reg-FTTC_results_19-09-18.mat');

%Specify limits for colorbars on stress maps
max_stress=100;
min_stress=0;


%% Check to see if center of wound coordinates have been specified
% Must be in form [x,y]
if nargin==1
    midpts=varargin{1};
else 
    midpts=[];
end


%% Choose a method
% do you want to collect ALL stress values (method 1)
% or
% do you want to bias sampling of stresses in vertical direction (method 2)

method=1;%Use all stresses 
%method=2;%Mask image, vertically bias sampling (think hourglass)

%%

allParallel=[];
allPerp=[];
radialProfiles=[];
startFrame=1;
endFrame=38;
slopes=[];
for i=startFrame:endFrame
%     pnumberi='0';
%     if(i>=10)
%         pnumberi='';
%     end
    r=TFM_results(i);
    
    %The traction force measurements give a direction (in cartesian coordiantes) and a magnitude for
    %the stresses. The following code findTractionComponent breaks down
    %these components into a more useful polar coordinate system
    [vec2centerNorm ,vecPerpNorm,newRadialProfile] =findTractionComponent(r,min_stress,max_stress,i,TFM_settings,radialProfiles,method,midpts);
    
    
    radialProfiles{i}=newRadialProfile;
    x=newRadialProfile.DistFromCenterMicrons(newRadialProfile.DistFromCenterMicrons>50);
    y=newRadialProfile.sum(newRadialProfile.DistFromCenterMicrons>50);
    [~,idx]=max(y);
    x=x(1:idx);
    y=y(1:idx);
    
%     fitProfile=polyfit(x,y,1);
%     slopes=[slopes,fitProfile(1)];
%     allParallel=[allParallel;abs(vec2centerNorm)];
%     allPerp=[allPerp;vecPerpNorm];


end

% figure(3), plot(slopes)
% title('slope: Stress vs distance 50um to max');
% xlabel('Frame');
% ylabel('Pa / um');
% %saveas(gca,'slopeOfStressDistance.fig','fig');
% saveas(gca,'slopeOfStressDistance.png','png')

%mean(allParallel)
save('radialProfiles.mat','radialProfiles')
%figure(10), hist(allParallel)
%mean(allPerp)
%figure(11),hist(allPerp)
end