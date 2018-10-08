clear;
clc; 
hold off;

cd '/Users/ryannguyen/Desktop/PEB/Module2/task2/'
addpath('/Users/ryannguyen/Desktop/PEB/Module2/code_APT/')

%%
for num = 1:1%length(dir('example*'))
    %% change directories into proper example directory
    example = strcat('example',num2str(num));
    cd(example);
    matfile = dir('Reg*'); 
    load(matfile.name);
    
    
    %% Load in File 

    N_frames = length(TFM_results); 

    %% Run modified directionTraction script

    directionalTraction([],strcat(matfile.name),100);

    %% Stress Analysis as a Function of Radial Distance From Center Over Time
    load('radialProfiles.mat')

    distance_force_cell = cell(1,length(radialProfiles{1}.sum));
    
    % This script analyzes the Stress Over Time for each radial cross
    % section of the object. The radialProfiles gives the Average Stress
    % felt for each radial cross section. This script analyzes how this
    % stress changes over time
    
    % i represents the distance from the center in microns. We loop over
    % each radial cross section from the center
    for i = 1:length(radialProfiles{1}.sum)
        temp_distance_force_array = 1:N_frames;
        
        %j represents each of the radial Profiles. We then find the stress
        % exerted by each 
        for j = 1:length(radialProfiles)
            temp_distance_force_array(j) = radialProfiles{j}.sum(i);
        end 
        distance_force_cell{i} = temp_distance_force_array;
    end

    
    %% Plots for Force as a Function of Radial Distance Over Time
    fontsize   = 25;
    legend_strs = cell(1,length(distance_force_cell));
    
    figure(8), hold on, box on;
    for k = 1:length(distance_force_cell)
        legend_strs{k} = strcat('$',num2str(k),' \textnormal{ }\mu m$ from center');
        plot(1:N_frames,distance_force_cell{k},'linewidth',4);
        hold on;
    end 
    
    
    % Perfect Figure Adujustments
    xlabel('Frame Number','interpreter','latex');
    ylabel('Stress Sum at Radial Distance (Pa)','interpreter','latex');
    title('Stress Sum at Radial Distances Over Time','interpreter','latex');
    legend(legend_strs,'interpreter','latex','location','best');
    ax = gca;                                       % get the axes object
    ax.FontSize = fontsize;                         % set the font size on the figure

    % Make the figure bigger so that way saved file doesn't look like crap
    x0 = 10;
    y0 = 10;
    width = 1300;
    height = 1000;
    set(gcf,'units','points','position',[x0,y0,width,height]);
    
    % save file in example directory
    saveas(gcf,'Stress_Distance.png')
    clf
    hold off;
    
    %% 3D plotting of Stress Evolution Over Time
    clf

    fontsize = 25;
    N = 1:length(radialProfiles{1}.sum);

    figure(9)
    for t = 1:N_frames 
        plot3(radialProfiles{t}.DistFromCenterMicrons(N),t*ones(size(N)), radialProfiles{t}.sum(N),'-o','linewidth',2)
        grid on;
        hold on;
    end
    title('Stress Sum at Radial Distances Over Time','interpreter','latex');

    % Standard Figure Labels
    xlabel("Distance From Center $(\mu m)$", 'interpreter', 'latex')
    ylabel("Frame Number")
    zlabel("Average Radial Stress (Pa)",'interpreter', 'latex')

    ax = gca;                                       % get the axes object
    ax.FontSize = fontsize;                         % set the font size on the figure

    % Make the figure bigger so that way saved file doesn't look like crap
    x0 = 10;
    y0 = 10;
    width = 1300;
    height = 1000;
    set(gcf,'units','points','position',[x0,y0,width,height]);

    % save file in example directory
    saveas(gcf,'Stress_Distance_3D.png')
    hold off;
    
    %% Total Work Done on Substrate
    energy_array = zeros(N_frames,1);

    for l = 1:N_frames
        energy_array(l) = TFM_results(l).energy;
    end
    
    % Perfect Figure Adujustments
    figure(10), hold on, box on;
    plot(1:N_frames, energy_array,'linewidth',4)
    xlabel('Frame Number','interpreter','latex');
    ylabel('Total Energy (pJ)','interpreter','latex');
    title('Total Energy During Experiment','interpreter','latex');
    ax = gca;                                       % get the axes object
    ax.FontSize = fontsize - 8;                         % set the font size on the figure
    
    %save file in directory in example directory
    saveas(gcf,'Stress_Total.png')
    hold off;
    clf
    cd ..
end
