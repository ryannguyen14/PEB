clear;
clc; 

cd '/Users/ryannguyen/Desktop/PEB/Module2/task1/'

addpath('/Users/ryannguyen/Desktop/PEB/Module2/code_APT/')

load('example1/Reg-FTTC_results_19-09-18.mat')

N_frames = length(TFM_results); 

%% Total Work Done on Substrate
energy_array = zeros(N_frames,1);

for i = 1:N_frames
    energy_array(i) = TFM_results(i).energy;
end

%% Run directionTraction script
directionalTraction

%% Force Analysis as a Function of Radial Distance From Center
load('radialProfiles.mat')

distance_force_cell = cell(1,length(radialProfiles{1}.sum));

for j = 1:length(radialProfiles{1}.sum)
    temp_distance_force_array = 1:length(radialProfiles{j}.sum);
    for k = 1:length(radialProfiles)
        temp_distance_force_array(k) = radialProfiles{k}.sum(j);
    end 
    distance_force_cell{j} = temp_distance_force_array;
end
%% Plots for Force as a Function of Radial Distance Over Time
for l = 1:38
    plot(1:38,distance_force_cell{l})
    hold on;
end 
