function [velVec2centerNorm ,velVecPerpNorm,newRadialProfile] =  findTractionComponent(r,min_stress,max_stress,i,TFM_settings,radialProfiles,method, midpts)
%% 
% Decomposes the stress output from TFM into radial and angular stresses
% Right now, assumes center of image is center of symmetry
% From 2D radial stress map, radialStressProfile takes angular average
% Written A. Pasha Tabatabai 180817
%%%%%%%%%%
ht=r.grid_mat(end,end,2);
wd=r.grid_mat(end,end,1);

% Added APT 180918
if isempty(midpts) %if center coordinates have not been specified, use middle of image
    midy=floor(ht/(2));
    midx=floor(wd/(2));
else
    midx=midpts(1);
    midy=midpts(2);
end




pnumberi='0';
if(i>=10)
   pnumberi='';
end


% I notice the 3*r.vec from adapted versions, but not sure what it does
% APT removed 3*r.vec 180905
%[newgrid, forcevec, i_max, j_max]=interp_vec2grid(r.pos + 3*r.vec,r.traction, 8);
[newgrid, forcevec, i_max, j_max]=interp_vec2grid(r.pos,r.traction, 8);

fnorm1=(forcevec(:,:,1).^2+forcevec(:,:,2).^2).^.5;

%% Check Entire force vector

figure(1)
pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
hold on
colorbar;
colormap('jet');
%added by Michael Murrell on 6/1/14
quiver(r.pos(:,1),r.pos(:,2),r.traction(:,1),r.traction(:,2),'w');
%plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
hold off;

if ~exist('heatmapsAPT','dir')
    mkdir('heatmapsAPT')
end

str_name1=['heatmapsAPT' filesep 'heat_'  pnumberi int2str(i) '.tif'];
str_name2=['heatmapsAPT' filesep 'heat_'  pnumberi int2str(i) '.fig'];
 saveas(gca,str_name1);

%
%     %% Check Just X force
%     figure(2)
%     pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
%     hold on
%     colorbar;
%     colormap('jet');
%     %added by Michael Murrell on 6/1/14
%     quiver(r.pos(:,1),r.pos(:,2),r.traction(:,1),zeros(size(r.traction(:,1))),'w');
%     %plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
%     set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
%     hold off;
%
%
%
%     %% Check Just Y force
%     figure(3)
%     pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
%     hold on
%     colorbar;
%     colormap('jet');
%     %added by Michael Murrell on 6/1/14
%     quiver(r.pos(:,1),r.pos(:,2),zeros(size(r.traction(:,1))),r.traction(:,2),'w');
%     %plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
%     set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
%     hold off;

vec2center=zeros(size(r.pos));

for kk=1:size(vec2center,1)
    vec2center(kk,1)= -r.pos(kk,1)+midx; %%% Check if correct - correct
    vec2center(kk,2)= -r.pos(kk,2)+midy;
end

vec2centerNorm=(vec2center(:,1).^2+vec2center(:,2).^2).^(.5);
unitVec2center(:,1)=vec2center(:,1)./vec2centerNorm;
unitVec2center(:,2)=vec2center(:,2)./vec2centerNorm;

%% Find unit vectors perpendicular to center vector
%alpha = angle between center vector and x-axis
%     alpha=atan2(unitVec2center(:,2),unitVec2center(:,1));
%     unitVecPerpendicular=zeros(size(r.pos));
%     unitVecPerpendicular(:,1)=cos(pi/2 - alpha);
%     unitVecPerpendicular(:,2)=sin(pi/2 - alpha);
unitVecPerpendicular(:,1)=-unitVec2center(:,2);
unitVecPerpendicular(:,2)=unitVec2center(:,1);

%%

velVector=r.traction;
velVectorNorm=(velVector(:,1).^2+velVector(:,2).^2).^(.5);
cosTheta=dot(vec2center,velVector,2)./(vec2centerNorm.*velVectorNorm);
Theta=acos(cosTheta);

%% Test: am I correctly orienting xy positions towards center? Yes
%
%     figure(4)
%     pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
%     hold on
%     colorbar;
%     colormap('jet');
%     %added by Michael Murrell on 6/1/14
%     quiver(r.pos(:,1),r.pos(:,2),p(:,1),p(:,2),'w');
%
%     %plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
%     set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
%     hold off;

%% Test: Is radial unit vector correct?: yes, chose inwards

%     figure(1)
%     pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
%     hold on
%     colorbar;
%     colormap('jet');
%     %added by Michael Murrell on 6/1/14
%     quiver(r.pos(:,1),r.pos(:,2),unitVec2center(:,1),unitVec2center(:,2),'w');
%
%     %plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
%     set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
%     hold off;

%% Test: Is angular unit vector correct? yes, chose counterclockwise
%
%     figure(2)
%     pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
%     hold on
%     colorbar;
%     colormap('jet');
%     %added by Michael Murrell on 6/1/14
%     quiver(r.pos(:,1),r.pos(:,2),unitVecPerpendicular(:,1),unitVecPerpendicular(:,2),'w');
%
%     %plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
%     set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
%     hold off;
%


%% Radial force: Looks good
%velVec2centerNorm=abs(vec2centerNorm.*velVectorNorm.*cosTheta);
%velVec2centerNorm=abs(unitVec2center.*velVectorNorm.*cosTheta);
velVec2centerNorm=abs(1.*velVectorNorm.*cosTheta);
velVec2centerComponents(:,1)=unitVec2center(:,1).*velVec2centerNorm;
velVec2centerComponents(:,2)=unitVec2center(:,2).*velVec2centerNorm;

%% Added APT 180817

%for the integrated workshop-ignore this. this is leftover from other stuff
[newRadialProfile]=radialStressProfile(r,velVec2centerNorm,midy,midx,pnumberi,i,TFM_settings,method);



%%
%vectorScale=10;
vs=500;

%Plot only radial magnitude for heatmap
%APT removes 3*r.vec 180905
%[newgrid, forcevec, i_max, j_max]=interp_vec2grid(r.pos + 3*r.vec,velVec2centerComponents, 8);
[newgrid, forcevec, i_max, j_max]=interp_vec2grid(r.pos,velVec2centerComponents, 8);
fnorm1=(forcevec(:,:,1).^2+forcevec(:,:,2).^2).^.5;

figure(5)
pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
hold on
colorbar;
colormap('jet');
%added by Michael Murrell on 6/1/14
%quiver(r.pos(:,1),r.pos(:,2),vs.*velVec2centerComponents(:,1),vs.*velVec2centerComponents(:,2),'w');

%plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
hold off;

if ~exist('heatmaps_radialAPT','dir')
    mkdir('heatmaps_radialAPT')
end

str_name1=['heatmaps_radialAPT' filesep 'heat_'  pnumberi int2str(i) '.tif'];
str_name2=['heatmaps_radialAPT' filesep 'heat_'  pnumberi int2str(i) '.fig'];
 saveas(gca,str_name1);


%% Angular force
%velVecPerpNorm=abs(vec2centerNorm.*velVectorNorm.*sin(Theta));
%velVecPerpNorm=abs(unitVecPerpendicular.*velVectorNorm.*sin(Theta));
velVecPerpNorm=abs(1.*velVectorNorm.*sin(Theta));
velVecPerpComponents(:,1)=unitVecPerpendicular(:,1).*velVecPerpNorm;
velVecPerpComponents(:,2)=unitVecPerpendicular(:,2).*velVecPerpNorm;
%Plot only angular magnitude for heatmap
%APT removes 3*r.vec 180905
%[newgrid, forcevec, i_max, j_max]=interp_vec2grid(r.pos + 3*r.vec,velVecPerpComponents, 8);
[newgrid, forcevec, i_max, j_max]=interp_vec2grid(r.pos,velVecPerpComponents, 8);

fnorm1=(forcevec(:,:,1).^2+forcevec(:,:,2).^2).^.5;


figure(7)
pcolor(newgrid(:,:,1),newgrid(:,:,2),fnorm1), caxis([min_stress max_stress]), shading interp, axis equal tight;
hold on
colorbar;
colormap('jet');
%added by Michael Murrell on 6/1/14
%quiver(r.pos(:,1),r.pos(:,2),vs.*velVecPerpComponents(:,1),vs.*velVecPerpComponents(:,2),'w');

%plot(edge{i}(:,2),edge{i}(:,1),'w','LineWidth',1)
set(gca, 'DataAspectRatio', [1,1,50],'YDir','reverse','Visible','off');%,'ylim',[r.grid_mat(1,1,2),r.grid_mat(end,end,2)],'xlim',[r.grid_mat(1,1,1),r.grid_mat(end,end,1)])
hold off;

if ~exist('heatmaps_perpAPT','dir')
    mkdir('heatmaps_perpAPT')
end

str_name1=['heatmaps_perpAPT' filesep 'heat_'  pnumberi int2str(i) '.tif'];
str_name2=['heatmaps_perpAPT' filesep 'heat_'  pnumberi int2str(i) '.fig'];
 saveas(gca,str_name1);



end