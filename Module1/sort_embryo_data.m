function sorted_data = sort_embryo_data_2018(data, orientation, delta)
%% Sort Embryo Data
% 
% INPUTS:
% -- data:          data cell from .csv file of positions from zebrafish experiments
% -- orientation:   str of particular orientation for tailbud
% -- delta:         duration between experimental observation points
% 
% OUTPUT:
% -- sorted data:   struct containing position & velocity data from
%                   experiments

Nrows = length(data{1});
pos = zeros(Nrows,3);

% initialize all rows of data cell (bare data, unprocessed)
pos(:,1) = data{1};  
pos(:,2) = data{2};  
pos(:,3) = data{3};  
t = data{4};
tvals = unique(t);
NT = length(tvals);

% for cell tracks, make track id numbers start at 0
iid = data{5}-min(data{5})+1;
idvals = unique(iid);
NID = length(idvals);

% initialize position arrays
x = nan(NT,NID);
y = nan(NT,NID);
z = nan(NT,NID);

% initialize velocity arrays using ghost points
vx = nan(NT-1,NID);
vy = nan(NT-1,NID);
vz = nan(NT-1,NID);

% get positions
for ii=1:NT
    % get indices of this time point
    ttmp = tvals(ii);
    tinds = (t == ttmp);
    
    % get cell positions for cells present at this time point
    idtmp = iid(tinds);
    postmp = pos(tinds,:);
    NIDtmp = length(idtmp);
    for jj = 1:NIDtmp
        posi = find(idvals == idtmp(jj));
        x(ii,posi) = postmp(jj,1);
        y(ii,posi) = postmp(jj,2);
        z(ii,posi) = postmp(jj,3);
    end
end

% get velocities
for cc=1:NID
    % get valid values
    inds = ~isnan(x(:,cc));
    xtmp = x(inds,cc);
    ytmp = y(inds,cc);
    ztmp = z(inds,cc);
    ttmp = tvals(inds);
    
    % use 2pt derivative to get vx,vy,vz
    dx = xtmp(2:end)-xtmp(1:end-1);
    dy = ytmp(2:end)-ytmp(1:end-1);
    dz = ztmp(2:end)-ztmp(1:end-1);
    dt = delta*(ttmp(2:end)-ttmp(1:end-1));
        
    vxtmp = dx./dt;
    vytmp = dy./dt;
    vztmp = dz./dt;
    
    % loop over time values
    tmpti = 1;
    locs = find(inds);
    startt = locs(2);
    for tt = startt:NT
        if inds(tt)
            vx(locs(tmpti),cc) = vxtmp(tmpti);
            vy(locs(tmpti),cc) = vytmp(tmpti);
            vz(locs(tmpti),cc) = vztmp(tmpti);
            tmpti = tmpti + 1;
        end
    end
end

% output value of lmin based on input orientation
if strcmp(orientation, 'XY')
    lmin = min(nanmin(y))+50;         % X and Y
elseif strcmp(orientation, 'X-Y')
    lmin = max(nanmax(y))-50;         % X and -Y
elseif strcmp(orientation, 'YX')
    lmin = min(nanmin(x))+50;         % Y and X
elseif strcmp(orientation, 'Y-X')
    lmin = max(nanmax(x))-50;         % Y and -X
end

% get center of mass velocity of anterior region of psm
vpsmx = zeros(NT-1,1);
vpsmy = zeros(NT-1,1);
vpsmz = zeros(NT-1,1);

for tt = 1:NT-1
    % determine indices of all cells in anterior psm
    if strcmp(orientation, 'XY')
        il = find(y(tt,:) <= lmin);          % X and Y
    elseif strcmp(orientation, 'X-Y')
        il = find(y(tt,:) >= lmin);          % X and -Y
    elseif strcmp(orientation, 'YX')
        il = find(x(tt,:) <= lmin);          % Y and X
    elseif strcmp(orientation, 'Y-X')
        il = find(y(tt,:) >= lmin);          % Y and -X
    end
    
    % get velocities of all anterior psm cells
    psm_vx = vx(tt,il);
    psm_vy = vy(tt,il);
    psm_vz = vz(tt,il);
    
    vpsmx(tt) = nanmean(psm_vx);
    vpsmy(tt) = nanmean(psm_vy);
    vpsmz(tt) = nanmean(psm_vz);
end

% output sorted data
sorted_data = struct('x',x);
sorted_data.y = y;
sorted_data.z = z;
sorted_data.vx = vx;
sorted_data.vy = vy;
sorted_data.vz = vz;
sorted_data.t = tvals;
sorted_data.lmin = lmin;
sorted_data.vpsmx = vpsmx;
sorted_data.vpsmy = vpsmy;
sorted_data.vpsmz = vpsmz;

end