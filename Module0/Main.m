clear;
clc; 

cd /Users/ryannguyen/Desktop/PEB/Module0
%% 
fileList = dir('*.csv'); 
datax_1 = csvread(fileList(1).name);
datax_2 = csvread(fileList(2).name);
datax_3 = csvread(fileList(3).name);
datay_1 = csvread(fileList(4).name);
datay_2 = csvread(fileList(5).name);
datay_3 = csvread(fileList(6).name);

%%
time = datax_1(:,1);

x(:,:,1) = datax_1(:,2:end);
x(:,:,2) = datax_2(:,2:end);
x(:,:,3) = datax_3(:,2:end);

y(:,:,1) = datay_1(:,2:end);
y(:,:,2) = datay_2(:,2:end);
y(:,:,3) = datay_3(:,2:end);
%%
N_t = length(time); 
inds = unique(round(logspace(0, log(N_t)/log(10), 200)));
delta_t = time(inds(2:end)); %- time(inds(1:end-1));

N_deltat = length(delta_t);
MSD = zeros(N_deltat, 3);
%%
for i = 1:length(inds) 
    ind = inds(i);
    dxs = x(1:end-ind,:,:) - x(1+ind:end,:,:); 
    dys = y(1:end-ind,:,:) - y(1+ind:end,:,:);

    MSD(i,:) = mean(mean(dxs.^2,2),1) + mean(mean(dys.^2,2),1);
end 
%%

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