%% Main template for 2018 ASSIGNMENT 1 PT 1

clear;
close all;
clc;
cd /Users/ryannguyen/Desktop/PEB/Module1
% output a message saying where you are in the code
fprintf('Beginning maint pt1 script...\n');

% code in a string for the location of the data file for this assignment

dataloc = '/Users/ryannguyen/Desktop/PEB/Module1/data';
savef = [dataloc '/saved_data.mat'];
%%
deltas = [2.87; 2.5; 3.13; 2.77; 2.67; 2.62];
orientations = {'XY', 'X-Y','Y-X','XY','XY','XY'};
domains = {'DM','PZ','PSM'};

NFISH = 6;
NDOM = 3;

%% Process data
fprintf('processing data...\n');

% run code to sort data, put into struct
if (~exist(savef,'file'))
    processed_data = import_embryo_data(dataloc,savef,deltas,orientations,domains);    
else
    processed_data = matfile(savef);
end

% extract data from struct

% position data for cells (NFISH x NDOM cell of arrays)
x = processed_data.x;
y = processed_data.y;
z = processed_data.z;

% velocity data for cells (NFISH x NDOM cell of arrays)
vx = processed_data.vx;
vy = processed_data.vy;
vz = processed_data.vz;

% velocity of the center of mass of tail bud (NFISH x 1 cell of arrays)
vpsmx = processed_data.vpsmx;
vpsmy = processed_data.vpsmy;
vpsmz = processed_data.vpsmz;

% time indices of cell position data during experiment (NFISH x 1 cell of
% arrays)
tinds = processed_data.t_all;

%% Calculate and plot polarization here
fprintf('calculating and plotting polarization...\n');

%array to store all polarization calculations for each domain in each fish
polarization_array = cell(NFISH,NDOM); 
for fish = 1:NFISH
    %center of mass velocities; calculated out here to avoid recalculating
    %for each domain
    vcomx = vpsmx{fish};
    vcomy = vpsmy{fish};
    vcomz = vpsmz{fish};
    
    for dom = 1:NDOM 
        % position data
        xtmp = x{fish,dom};
        ytmp = y{fish,dom};
        ztmp = z{fish,dom};
        
        %velocities data
        vxtmp = vx{fish,dom};
        vytmp = vy{fish,dom};
        vztmp = vz{fish,dom};

        %subtract off center of mass velocity 
        vxtmp = vxtmp - vcomx; 
        vytmp = vytmp - vcomy;
        vztmp = vztmp - vcomz;

        %calculate polarization as a function of time 
        NT = length(tinds{fish,1});
        polarization = zeros(NT - 1,1);
        
        for tt = 1:NT-1
            %Calculate norm of each vector 
            scal_norm = vxtmp(tt,:).^2 + vytmp(tt,:).^2 + vztmp(tt,:).^2;
            vxtmp = vxtmp./sqrt(scal_norm);
            vytmp = vytmp./sqrt(scal_norm);
            vztmp = vztmp./sqrt(scal_norm);

            % Mean of unit vectors
            vxmean = nanmean(vxtmp(tt,:)); 
            vymean = nanmean(vytmp(tt,:));
            vzmean = nanmean(vztmp(tt,:));    

            %polarization at time t
            polarization(tt) = sqrt(vxmean^2 + vymean^2 + vzmean^2);

        end
        polarization_array{fish,dom} = polarization; 
    end
    
end 

%% Write polarization array to polarizations.mat 
% I couldn't find a way to save cell files into csv's without screwing up 
% the data format

save polarizations.mat polarization_array

%% Plot Polarization of DM domain for each fish 
figure([1]), hold on, box on;
plot(polarization_array{1,1});
hold on;
plot(polarization_array{2,1});
hold on;
plot(polarization_array{3,1});

% label axes, and format using LaTeX to get a nice font and equation formatting
xlabel(['Time (minutes)'],'interpreter','latex');
ylabel(['Polarization Value'],'interpreter','latex');
title('DM Polarization For Each Fish over Time','interpreter','latex');

% create legend
legend({['Fish 1'], ['Fish 2'],['Fish 3']},'interpreter','latex','location','best');
% create axis object for this figure using ?get current axis? (gca) function:
ax = gca;
ax.FontSize = 20;
ax.XScale = 'lin'; % optinoal, default is ?lin? for linear scale
ax.YScale = 'lin'; % optional, default is ?lin? for linear scale


%% Plot Polarization of PZ domain for each fish
figure([2]), hold on, box on;
plot(polarization_array{1,2});
hold on;
plot(polarization_array{2,2});
hold on;
plot(polarization_array{3,2});
hold off;

% label axes, and format using LaTeX to get a nice font and equation formatting
xlabel(['Time (minutes)'],'interpreter','latex');
ylabel(['Polarization Value'],'interpreter','latex');
title('PZ Polarization For Each Fish over Time','interpreter','latex');

% create legend
legend({['Fish 1'], ['Fish 2'],['Fish 3']},'interpreter','latex','location','best');
% create axis object for this figure using ?get current axis? (gca) function:
ax = gca;
ax.FontSize = 20;
ax.XScale = 'lin'; % optinoal, default is ?lin? for linear scale
ax.YScale = 'lin'; % optional, default is ?lin? for linear scale

%% Plot Polarization of PSM domain for each fish
figure([3]), hold on, box on;
plot(polarization_array{1,3});
hold on;
plot(polarization_array{2,3});
hold on;
plot(polarization_array{3,3});

% label axes, and format using LaTeX to get a nice font and equation formatting
xlabel(['Time (minutes)'],'interpreter','latex');
ylabel(['Polarization Value'],'interpreter','latex');
title('PSM Polarization For Each Fish over Time','interpreter','latex');

% create legend
legend({['Fish 1'], ['Fish 2'],['Fish 3']},'interpreter','latex','location','best');
% create axis object for this figure using ?get current axis? (gca) function:
ax = gca;
ax.FontSize = 20;
ax.XScale = 'lin'; % optinoal, default is ?lin? for linear scale
ax.YScale = 'lin'; % optional, default is ?lin? for linear scale


%% Calculate and plot MSD here
fprintf('calculating and plotting MSD...\n');

% initialize a cell to store all MSD's for each fish and each dom
MSD_array = cell(NFISH, NDOM);

for fish = 1:NFISH
    for dom = 1: NDOM
        %initialize MSD for each fish and each dom
        MSD = zeros(length(tinds{fish}),1);
        
        %initialize x, y, z coordinates
        xtmp_msd = x{fish,dom};
        ytmp_msd = y{fish,dom};
        ztmp_msd = z{fish,dom};
        
        for ind = 1:length(tinds{fish}) 
            % calculate dxs dys and dzs for each time point
            dxs = xtmp_msd(1:end-ind,:) - xtmp_msd(1+ind:end,:);
            dys = ytmp_msd(1:end-ind,:) - ytmp_msd(1+ind:end,:);
            dzs = ztmp_msd(1:end-ind,:) - ztmp_msd(1+ind:end,:);
            
            %calculate MSD
            MSD(ind,:) = mean(nanmean(dxs.^2,2),1) + mean(nanmean(dys.^2,2),1) + mean(nanmean(dzs.^2,2),1);
        end
        %store MSD for fish and dom in cell
        MSD_array{fish,dom} = MSD;
    end
end
%% Plot MSD's 

%% Plot MSD of DM domain for each fish
figure([4]), hold on, box on;
plot(MSD_array{1,1});
hold on;
plot(MSD_array{2,1});
hold on;
plot(MSD_array{3,1});
hold off;

% label axes, and format using LaTeX to get a nice font and equation formatting
xlabel(['$\Delta$t (minutes)'],'interpreter','latex');
ylabel(['MSD Value'],'interpreter','latex');
title('DM MSD For Each Fish over Time','interpreter','latex');

% create legend
legend({['Fish 1'], ['Fish 2'],['Fish 3']},'interpreter','latex','location','best');
% create axis object for this figure using ?get current axis? (gca) function:
ax = gca;
ax.FontSize = 20;
ax.XScale = 'log'; % optinoal, default is ?lin? for linear scale
ax.YScale = 'log'; % optional, default is ?lin? for linear scale
%% Plot MSD of PZ domain for each fish
figure([5]), hold on, box on;
plot(MSD_array{1,2});
hold on;
plot(MSD_array{2,2});
hold on;
plot(MSD_array{3,2});
hold off;

% label axes, and format using LaTeX to get a nice font and equation formatting
xlabel(['$\Delta$t (minutes)'],'interpreter','latex');
ylabel(['MSD Value'],'interpreter','latex');
title('PZ MSD For Each Fish over Time','interpreter','latex');

% create legend
legend({['Fish 1'], ['Fish 2'],['Fish 3']},'interpreter','latex','location','best');
% create axis object for this figure using ?get current axis? (gca) function:
ax = gca;
ax.FontSize = 20;
ax.XScale = 'log'; % optinoal, default is ?lin? for linear scale
ax.YScale = 'log'; % optional, default is ?lin? for linear scale

%% Plot MSD of PSM domain for each fish
figure([6]), hold on, box on;
plot(MSD_array{1,3});
hold on;
plot(MSD_array{2,3});
hold on;
plot(MSD_array{3,3});
hold off;

% label axes, and format using LaTeX to get a nice font and equation formatting
xlabel(['$\Delta$t (minutes)'],'interpreter','latex');
ylabel(['MSD Value'],'interpreter','latex');
title('PSM MSD For Each Fish over Time','interpreter','latex');

% create legend
legend({['Fish 1'], ['Fish 2'],['Fish 3']},'interpreter','latex','location','best');
% create axis object for this figure using ?get current axis? (gca) function:
ax = gca;
ax.FontSize = 20;
ax.XScale = 'log'; % optinoal, default is ?lin? for linear scale
ax.YScale = 'log'; % optional, default is ?lin? for linear scale
%% End of script
fprintf('Ending maint pt1 script.\n');