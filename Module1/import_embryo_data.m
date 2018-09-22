function processed_data = import_embryo_data(dataloc,savef,deltas,orientations,domains)
%% FUNCTION TO PROCESS ZEBRAFISH MICROSCOPY DATA FOR 2018 IW ASSIGNMENT 1
% 
% INPUTS:
% -- dataloc:           str, directory where data files are located
% -- savef:             str, path to save file (for easy future access)
% -- deltas:            array of delta values for each experiment
% -- orientations:      cell array of orientation strs for each experiment
% -- domains:           cell array of names of each domain in zebrafish
% 
% OUTPUTS:
% -- processed_data:    struct of position and velocity data for each
%                       experiment, in cell array form

% make sure dataloc does NOT end in /
if strcmp(dataloc(end),'/')
    dataloc = dataloc(1:end-1);
end

% number of fish
NFISH = length(orientations);

% number of domains per fish
NDOM = length(domains);

%% declare cells for output

% cells for the whole fish
x_all = cell(NFISH,1);      vx_all = cell(NFISH,1);
y_all = cell(NFISH,1);      vy_all = cell(NFISH,1);
z_all = cell(NFISH,1);      vz_all = cell(NFISH,1);
t_all = cell(NFISH,1);
lmin_all = zeros(NFISH,1);

% cells for each domain
x = cell(NFISH,NDOM);   vx = cell(NFISH,NDOM);
y = cell(NFISH,NDOM);   vy = cell(NFISH,NDOM);
z = cell(NFISH,NDOM);   vz = cell(NFISH,NDOM);
t = cell(NFISH,NDOM);
lmin = zeros(NFISH,NDOM);

% anterior psm velocity
vpsmx = cell(NFISH,1);
vpsmy = cell(NFISH,1);
vpsmz = cell(NFISH,1);

%% Process data

for ff = 1:NFISH
    fprintf('processing fish %d with orientation %s...\n',ff,orientations{ff});

    % READ IN DATA FOR ENTIRE FISH (NOT SEGMENTED INTO DOMAINS)

    % create a file string
    all_str = [dataloc '/Fish' num2str(ff) '_All_Pos.csv']; 
    
    % open the file into MATLAB
    fid = fopen(all_str); 
    
    % read in data from the file
    all_data = textscan(fid,'%f,%f,%f,um,Spot,Position,%f,%f,%f,','HeaderLines',4);
    
    % close the file
    fclose(fid); 
    
    % get delta value for this fish
    delta = deltas(ff);
    
    % get orientation values for this fish
    or = orientations{ff};
    
    % sort embryo input data for all
    sorted_data = sort_embryo_data(all_data, or, delta);
    
    % save data to cells for outputting
    x_all{ff} = sorted_data.x;
    y_all{ff} = sorted_data.y;
    z_all{ff} = sorted_data.z;       
    
    vx_all{ff} = sorted_data.vx;
    vy_all{ff} = sorted_data.vy;
    vz_all{ff} = sorted_data.vx;
    
    t_all{ff} = sorted_data.t;
    lmin_all(ff) = sorted_data.lmin;
    
    vpsmx{ff} = sorted_data.vpsmx;
    vpsmy{ff} = sorted_data.vpsmy;
    vpsmz{ff} = sorted_data.vpsmz;
    for dd = 1:NDOM
        domain = domains{dd};
        fprintf('** processing domain %s\n',domain);
        
        % create a file string
        dom_str = [dataloc '/Fish' num2str(ff) '_' domain '_Pos.csv'];
        
        % open the file into MATLAB
        fid = fopen(dom_str); 

        % read in data from the file
        dom_data = textscan(fid,'%f,%f,%f,um,Spot,Position,%f,%f,%f,','HeaderLines',4);

        % close the file
        fclose(fid); 

        % sort embryo input data for all
        sorted_data = sort_embryo_data(dom_data, or, delta);
        
        % save data to cells for outputting
        x{ff,dd} = sorted_data.x;
        y{ff,dd} = sorted_data.y;
        z{ff,dd} = sorted_data.z;
        t{ff,dd} = sorted_data.t;

        vx{ff,dd} = sorted_data.vx;
        vy{ff,dd} = sorted_data.vy;
        vz{ff,dd} = sorted_data.vx;

        lmin(ff,dd) = sorted_data.lmin;
    end
end

%% Save data to output
processed_data.x_all = x_all;
processed_data.y_all = y_all;
processed_data.z_all = z_all;
processed_data.t_all = t_all;

processed_data.vx_all = vx_all;
processed_data.vy_all = vy_all;
processed_data.vz_all = vz_all;
processed_data.lmin_all = lmin_all;

processed_data.x = x;
processed_data.y = y;
processed_data.z = z;
processed_data.t = t;

processed_data.vx = vx;
processed_data.vy = vy;
processed_data.vz = vz;
processed_data.lmin = lmin;

processed_data.vpsmx = vpsmx;
processed_data.vpsmy = vpsmy;
processed_data.vpsmz = vpsmz;

save(savef,'x_all','y_all','z_all','vx_all','vy_all','vz_all','t_all',...
    'x','y','z','t','vx','vy','vz','lmin','lmin_all','vpsmx','vpsmy','vpsmz');
end