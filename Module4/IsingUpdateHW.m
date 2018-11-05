function l = IsingUpdate(l,betaJ,h,nSweeps)
%l an Ising lattice of +-1s, beta the inverse temperature, h the magnetic
%field, nSweeps the number of sweeps to be performed



N=length(l);

for t = 1:N^2*nSweeps% the number of spins to be attempted.  A 'sweep' is N^2 attempts at single spin flips.
    x = randi(N);%the x,y position of the spin which might flip
    y = randi(N);
    current = l(x,y);%the spin value, +-1
    neighbors = l(x-1,y) + l(x+1,y) + l(x,y+1) + l(x,y-1);%The sum of the four neighboring spins
    betaDeltaE = (1/(2*betaJ)) * neighbors - h * current;%The difference in energy between states with the current spin flipped and not
    if (betaDeltaE < 0) %Implements the metrolpolis probability.  This if statement should resolve 'true' if the spin should be flipped and false otherwise
        l(x,y) = betaDeltaE; %If move is accepted flip the spin at (x,y)

    end
end