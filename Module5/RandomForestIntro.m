%% Read in Data
clear;
clc;
% Change filepath to where you placed the csv files
filepath = '/Users/ryannguyen/Desktop/PEB/Module5/';

rng('shuffle') % Seed random number generator
pos = readtable([filepath,'positive.data.set.csv']); % Read in disruptive SNV data into table
neg = readtable([filepath,'negative.data.set.csv']); % Read in non-disruptive SNV data
k = size(pos,1);
k2 = size(neg,1);

% Take a random sample of the negative data so that we have a balanced data set
neg0 = datasample(neg, k, 'replace', false); 

%% Make composite data table (x) and true classification variable
x = [pos;neg0]; %Both positive and negative data appended to each other in one big friggin dataset
y = cell(size(x,1),1);
y(1:k) = {'pos'};
y((k+1):size(x,1))= {'neg'};

% Set the number of trees to be made in the bagging process
NumTrees=500;

%%### training and sampling data set
N=size(x,1); % Total number of SNV in balanced set
n=floor(N*0.8); % Let our training data be composed of 80% of our data
index_train=randsample(1:N,n,false); % Randomly select indices for training data
index_test=setdiff(1:N,index_train); % The test data will be composed of the rest

%% Assign data to test and train data variables
x_train=x(index_train,:);
y_train=y(index_train);
x_test=x(index_test,:);
y_test=y(index_test);



% Use TreeBagger to classify data based on the full set of features

rf_all = TreeBagger(NumTrees,x_train,y_train,'OOBPrediction','On','Method','classification');
y_pred_all=predict(rf_all,x_test);

% Calculate the performance of the classifier
succ_rate = mean(strcmp(y_test, y_pred_all)); % Use strcmp to compare the predicted to true classification
%sprintf('Using all features, we successfully classified %1.1f%% of SNVs in the test data', succ_rate*100)

% One Classifer
sprintf('Using all features we successfully classified %1.1f%% of SNVs in the test data', succ_rate*100)
%% Notes on Tables

% You can take a slice of a table the same way 
x_train_slice = x_test(:,[1,5,7,8]);

% You can convert the data from a table to an array/matrix with the
% following function
slice_data = table2array(x_train_slice);

%% Useful functions for decision trees

Error = oobError(rf_all,'Mode','individual'); % Look at the error of each individual tree
ind=404;
view(rf_all.Trees{ind},'Mode','graph') % Plot the tree at index ind
%% The perfect matlab figure
% Here is some source code that you can use to plot a nice figure
% and manipulate the figure features.


% Some figure parameters 
fnum        = 1;                                    % figure number...good way to keep track of figures with different sets of data
fontsize    = 18;                                   % size of the font on the axes and legend
%xscale      = 'log';                                % scale of the x-axis
%yscale      = 'log';                                % scale of the y-axis
%ymin        = -4;                                   % minimum values of y-axis
%ymax        = 4;                                    % maximum value of y-axis

figure(fnum)
%bar(feature_list,succ_list);                      % plot curve using line

% xlabel('Classifier Number (Corresponds to column number)','interpreter','latex');
% ylabel('Successful Classification Rate','interpreter','latex');
% % You can also add a title to your plot
% title('Single Classifier Success Rates','interpreter','latex');


%% Color Each Point Based on Successful Prediction 
% Initialize a blue map
colorMap = [zeros(size(x_test,1), 1), zeros(size(x_test,1), 1), ones(size(x_test,1),1)];
success = strcmp(y_test, y_pred_all);

for i = 1:size(x_test,1)
    %color successful predictions as blue and failures as red
    if success(i) == 1
        colorMap(i,:) = [0, 0, 1]; %blue
    else 
        colorMap(i,:) = [1, 0, 0]; %red
    end
    
end

%% Plot 

% We first plot positive SNV's  

%This identifies how many values are positive
pos_idx = sum(strcmp(y_test,'pos'));

% X- axis is classifer 8 and y-axis is classifier 7
x_axis = x_test(:,8);
y_axis = x_test(:,7);
%% f
scatter(x_axis{1:pos_idx,:},y_axis{1:pos_idx,:}, 25,colorMap(1:pos_idx,:),'o')
hold on;
scatter(x_axis{pos_idx+1:end,:},y_axis{pos_idx+1:end,:}, 25,colorMap(pos_idx+1:end,:),'x')

xlabel('Classifier 8','interpreter','latex');
ylabel('Classifier 7','interpreter','latex');
% % You can also add a title to your plot
title('Classification Results as a Function of All Classifiers','interpreter','latex');

% Legend
h = zeros(3, 1);
h(1) = plot(NaN,NaN,'ob');
h(2) = plot(NaN,NaN,'or');
h(3) = plot(NaN,NaN,'xb');
h(4) = plot(NaN,NaN,'xr');
legend(h, 'Pos, correct','Pos, incorrect','Neg, correct','Neg, incorrect','interpreter','latex','location','best');

ax = gca;                                       % get the axes object
ax.FontSize = fontsize;





