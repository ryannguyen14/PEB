%makeFilm("test", 10, 20, 30)
function []=makeFilm(filename ,frames ,t ,h )
%filename is the name of the .gif that is generated
%t is the temperature of the Ising model, which below we rescale according
%to Onsager's exact solution, T_c=2/log(1+2^.5) 
%frames is the length of the .gif to be made


%lattice = -1 * ones(64); %start from a lattice of +1
lattice = 2*randi(2,64)-3;

betaJ = log(1+2^.5)/(2*t);
betaH = h * log(1+2^.5)/(2*t);
sweepsPerPrint = 10; %number of sweeps per frame. 

%fig1 = figure;%Uncomment this to view movie live in a figure
%imshow((l+1)/2);%Uncomment this to view movie live
disp("Making lattice ...")
%axis tight manual % %Uncomment this to view movie live this ensures that getframe() returns a consistent size
lattice = IsingUpdate(lattice,betaJ,betaH,1);%equilibrate the model, might need to adjust '100'
disp("Now writing to gif")
for n = 1:frames
    % Draw plot
    lattice = IsingUpdate(lattice,betaJ,betaH,sweepsPerPrint);
%     imshow((lattice+1)/2);%Uncomment this to view movie live
%     drawnow;%Uncomment this to view movie live  
    % Write to the GIF File 
    if n == 1 
        imwrite(255*(lattice + 1)/2+1,filename,'gif', 'Loopcount',inf); 
    else 
        imwrite(255*(lattice + 1)/2+1,filename,'gif','WriteMode','append'); 
    end 
    disp("Next frame")
end
