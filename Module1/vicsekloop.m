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
r0 = 0.75;        % Range of Vicsek influence
rc = 0.5;        % Diameter of cells
v0 = 0.1;        % Speed of cells
N = 50;         % Number of cells
L = 5;         % Size of the box
Nsteps = 1000;    % Number of steps for the simulation
Nplot = 5;     % Number of steps between plotting the state of the simulation
dt = 0.1;        % Simulation timestep
eta = 0.5;       % Value of eta for the simulation
beta =  30;     % Value of beta for the simulation

% Initialize phis for collection of the order parameter
phis = zeros(Nsteps,1);

% Initialize Positions and Velocities
rs = rand(N, 2) * L;
vs = randn(N, 2);
vnorm = sqrt(sum(vs'.^2))';
vs = vs .* v0 ./ [vnorm, vnorm];

%% Plot the Initial Conditions
figure();
vicsekplot(rs, vs, rc, L);
%%
% Loop over simulation

%Create arrays of eta and beta values
etas = 0.50:0.025:0.75;
num_etas = length(etas);
betas = [0.0,30];
num_betas = length(betas);

% create cell to store phi values for each eta and beta
phi_avg = cell(num_etas,num_betas);

for eta_index = 1:num_etas
    for beta_index = 1:num_betas
        for step = 1:Nsteps
            % Perform Integration
            vs = vicsekvelocities(N, v0, r0, rc, etas(eta_index), betas(beta_index), L, rs, vs);
            rs = rs + vs * dt;

            % Calculate the Order Parameter
            phis(step) = sqrt(sum(mean(vs).^2))/v0;

            % Plot cells and velocities
%             if mod(step, Nplot) == 0
%                vicsekplot(rs, vs, rc, L)
%                title(sprintf('eta %.2f,beta%1.1f, step=%d', eta, beta, step));
%                pause(0.02);
%             end
            phi_avg{eta_index,beta_index} = phis;
        end
    end 
end