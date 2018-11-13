%makeFilm("test", 10, 20, 30)
function []=makeFilm(filename ,frames ,t ,h )
%filename is the name of the .gif that is generated
%t is the temperature of the Ising model, which below we rescale according
%to Onsager's exact solution, T_c=2/log(1+2^.5) 
%frames is the length of the .gif to be made

%Modification to automate for Part 2 
if contains(filename, 'normal')
    lattice = 2*randi(2,256)-3;
elseif contains(filename, 'all1')
    lattice = ones(256); %start from a lattice of +1
else 
     lattice = -1 * ones(256);
end
    
 %start from a lattice of +1%
%lattice = 2*randi(2,256)-3;

betaJ = log(1+2^.5)/(2*t);
betaH = h * log(1+2^.5)/(2*t);
sweepsPerPrint = 1; %number of sweeps per frame. 

%fig1 = figure;%Uncomment this to view movie live in a figure
%imshow((l+1)/2);%Uncomment this to view movie live
disp("Making lattice ...")
%axis tight manual % %Uncomment this to view movie live this ensures that getframe() returns a consistent size

%For Part 3 only
lattice = ones(256);

lattice = IsingUpdate(lattice,betaJ,betaH,1);%equilibrate the model, might need to adjust '100'

for n = 1:frames
    % Draw plot
    lattice = IsingUpdate(lattice,betaJ,betaH,sweepsPerPrint);
    mean_lattice1(n) = mean(reshape(lattice,[],1)); 
%     imshow((lattice+1)/2);%Uncomment this to view movie live
%     drawnow;%Uncomment this to view movie live  
    % Write to the GIF File 
%     if n == 1 
%         imwrite(255*(lattice + 1)/2+1,filename,'gif', 'Loopcount',inf); 
%     else 
%         imwrite(255*(lattice + 1)/2+1,filename,'gif','WriteMode','append'); 
%     end 
   % disp("Next frame")
end

% For putting on second initial condition for Part 3
lattice = -1 * ones(256); 

lattice = IsingUpdate(lattice,betaJ,betaH,1);%equilibrate the model, might need to adjust '100'

for n = 1:frames
    % Draw plot
    lattice = IsingUpdate(lattice,betaJ,betaH,sweepsPerPrint);
    mean_lattice2(n) = mean(reshape(lattice,[],1)); 
%     imshow((lattice+1)/2);%Uncomment this to view movie live
%     drawnow;%Uncomment this to view movie live  
    % Write to the GIF File 
%     if n == 1 
%         imwrite(255*(lattice + 1)/2+1,filename,'gif', 'Loopcount',inf); 
%     else 
%         imwrite(255*(lattice + 1)/2+1,filename,'gif','WriteMode','append'); 
%     end 
   % disp("Next frame")
end

% create a figure handle. Once this is called, anything that is plotted
% below will be put onto this figure UNTIL a new figure handle is created.
% 
% hold on lets you plot multiple curves on this figure. Using hold off will
% turn off this feature.
% 
% box on puts a box around the figure
clf
fontsize    = 18;
figure(1), hold on, box on;

% plot your data. There are a ton of options for plotting, like line width,
% line style, markersize, etc, so checkout help plot or doc plot to learn more.
% 
% Most likely, you will use the first argument after the data,
% which here is a string 'ro' or '-b'. This is an option to set what the
% data should look like. In the string, a line means "plot a line", a
% letter means "color the data" and symbol means "use this as a marker".
% Your options for each is outlined in the plot function documentation and
% help screen.
plot([1:frames],mean_lattice1 ,'-b','linewidth',2);                      % plot curve using line
plot([1:frames],mean_lattice2 ,'-r','linewidth',2); 
% label your axes. Here, we can use LaTeX formatting with the option pair
% 'interpreter','latex', which gives us a professional-looking font and the ability to typeset equations!
xlabel('Number of Sweeps','interpreter','latex');
ylabel('Mean Spin Value','interpreter','latex');

% You can also add a title to your plot
title(strcat('Mean Spin Value of Lattice Over Time, t =  ', int2str(t)),'interpreter','latex');

ax = gca;                                       % get the axes object
ax.FontSize = fontsize;                         % set the font size on the figure
% add a legend. A legend takes in a cell array of strings, 
% where the length of the array needs to match the number of plotted
% curves. We can tell the legend to use LaTeX formatting, and we can also 
% say that it should pick the best spot for the legend using the option
% pair 'location','best'
legend_strs = {'+1 Lattice', '-1 Lattice'};
legend(legend_strs,'interpreter','latex','location','best');
savefig(strcat('T=',num2str(t),'.fig'))
disp("Done")
