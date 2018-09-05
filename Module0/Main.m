clear;
clc; 

cd /Users/ryannguyen/Desktop/PEB/Module0

fileList = dir('*.csv'); 
datax_1 = csvread(fileList(1).name);
datax_2 = csvread(fileList(2).name);
datax_3 = csvread(fileList(3).name);
datay_1 = csvread(fileList(4).name);
datay_2 = csvread(fileList(5).name);
datay_3 = csvread(fileList(6).name);

time = datax_1(:,1);

x(:,:,1) = datax_1(:,2:end);
x(:,:,2) = datax_2(:,2:end);
x(:,:,3) = datax_3(:,2:end);

y(:,:,1) = datay_1(:,2:end);
y(:,:,2) = datay_2(:,2:end);
y(:,:,3) = datay_3(:,2:end);

%inds = round(logspace(time));
N_t = length(time); 

