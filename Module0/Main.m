clear;
clc; 

cd /Users/ryannguyen/Desktop/PEB/Module0
%% Section 1: Reading in Data 
% This reads in all of the data from the csv files given and assigns them 
% to the tensors x and y   

%% 1.1 Reading in Information from CSV's. 

% This looks for all csv files in the current working directory and stores
% them in the variable fileList. This data is then extracted and stored 
% in the variables dataN_#, where N denotes the direction of travel (x or y)
% and # denotes a number corresponding to a packing fraction (1: phi = 0.2, 
% 2: phi = 0.5, 3: phi = 0.8)

fileList = dir('*.csv'); 
datax_1 = csvread(fileList(1).name);
datax_2 = csvread(fileList(2).name);
datax_3 = csvread(fileList(3).name);
datay_1 = csvread(fileList(4).name);
datay_2 = csvread(fileList(5).name);
datay_3 = csvread(fileList(6).name);

% This section reads in the times where data is recorded and stores it in 
% the variable time

time = datax_1(:,1);

% This extracts position data and stores them in the 3D tensors x and y,
% where the third dimension corresponds to each of the three packing
% fractions. 

x(:,:,1) = datax_1(:,2:end);
x(:,:,2) = datax_2(:,2:end);
x(:,:,3) = datax_3(:,2:end);

y(:,:,1) = datay_1(:,2:end);
y(:,:,2) = datay_2(:,2:end);
y(:,:,3) = datay_3(:,2:end);
%% Section 2: Calculate the MSD 
% This sections calculates all of the values of delta_t which are then 
% used to calculate the MSD. 

%% 2.1: Delta_t Calculation 
% This calculates the number of time elements N_t using the 
% length function. 200 evenly Log spaced elements are then calculated from \
% 1 to N_T. Unique values are then extracted from this list and stored in 
% the variable inds. Delta t values are then calculated and then stored 
% in delta_t. 

N_t = size(time,1); %length(time); 
inds = unique(round(logspace(0, log(N_t)/log(10), 200)));
delta_t = time(inds(1:end)); 

%% 2.2: MSD Initialization 
% Now, we are able to calculate MSD as a function of delta_t for each
% packing fraction First, the number of elements in delta_t, denoted 
% N_delta_t, are calculated and used to create a zero matrix which 
% dimensions are N_deltat x 3. 

N_deltat = length(delta_t);
MSD = zeros(N_deltat, 3);

%% 2.3: MSD Calculation 
% We now iterate through each delta_t and calculate the dx's and dy's 
% for each. We then take a mean with respect to time and particles for x 
% and y. We sum those up to get the MSD for that particular delta_t. 

for i = 1:length(inds) 
    ind = inds(i);
    dxs = x(1:end-ind,:,:) - x(1+ind:end,:,:); 
    dys = y(1:end-ind,:,:) - y(1+ind:end,:,:);

    MSD(i,:) = mean(mean(dxs.^2,2),1) + mean(mean(dys.^2,2),1);
end 

%% Section 3: Plotting 
% This sections plots MSD as a function of time on a loglog scale. 

%% 3.1: Plotting for Each Packing Fraction 
% Plotting MSD for each Packing Fraction 
loglog(inds,MSD(:,1));
hold on;
loglog(inds,MSD(:,2));
hold on;     
loglog(inds,MSD(:,3));
xlabel('Time (sec)','fontsize',18); 
ylabel('MSD (microns^2)','fontsize',18);
title('Mean Squared Displacement at Different Packing Fractions','fontsize',16);
lgd = legend('phi = 0.2','phi = 0.5', 'phi = 0.8', 'Location','northwest');
lgd.FontSize = 12;