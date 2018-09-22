%% Clear system
clear
clc

%% Loop to perform Vicsek Simulation
%{
Purpose: This loop performs a Vicsek simulation

Functions used:
    vicsekplot(rs, vs, rc, L) in vicsekplot.m:
         Plots disks and velocities

    vs=vicsekvelocities(N, v0, r0, rc, eta, beta, L, rs, vs) in vicsekvilocities.m:
        Calculate updated velocities according to a Vicsek model

Inputs: 
    r0            Range of Vicsek influence for averaging nearby velocities
    rc            Diameter of cells
    v0            Speed of cells
    N             Number of cells
    L             Size of the box
    Nsteps        Number of steps for the simulation
    Nplot         Number of steps between plotting the state of the simulation
    dt            Simulation timestep
    eta           Value of eta, the noise parameter, for the simulation
    beta          Value of beta, the relative strength of repulsion, for the simulation

Outputs:
    phis     The mean order parameter as a function of time in the simulation

%}

% Define Simulation Parameters
r0 = ;        % Range of Vicsek influence
rc = ;        % Diameter of cells
v0 = ;        % Speed of cells
N = ;         % Number of cells
L = ;         % Size of the box
Nsteps = ;    % Number of steps for the simulation
Nplot = ;     % Number of steps between plotting the state of the simulation
dt = ;        % Simulation timestep
eta = ;       % Value of eta for the simulation
beta =  ;     % Value of beta for the simulation

% Initialize phis for collection of the order parameter
phis = ;

% Initialize Positions and Velocities
rs = rand(N, 2) * L;
vs = randn(N, 2);
vnorm = sqrt(sum(vs'.^2))';
vs = vs .* v0 ./ [vnorm, vnorm];

% Plot the Initial Conditions
figure();
vicsekplot(rs, vs, rc, L);


% Loop over simulation
for step = 1:Nsteps
    % Perform Integration
    vs = ;
    rs = rs + vs * dt;
    
    % Calculate the Order Parameter
    phis(step) = ;
    
    % Plot cells and velocities
    if mod(step, Nplot) == 0
        vicsekplot(rs, vs, rc, L)
        title(sprintf('eta %.2f,beta%1.1f, step=%d', eta, beta, step));
        pause(0.02);
    end
end