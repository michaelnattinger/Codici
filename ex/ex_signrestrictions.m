clear; close all; clc

% load data
xls = '../data/examplesr.xls';
sht = 'matlab';
[raw,sheet] = xlsread(xls,sht);
raw_id = sheet(1,2:end);
raw_date = sheet(2:end,1);
models = {'m1' 'm2' 'm3' 'm4'};
p = 3;         % lag order for VAR
CI = 0.8;      % CI: 0.8 == 80% CI
nsimacc = 500; % number of accepted simulations to calculate
irhor = 60;    % impulse response horizon

for i=1:length(models) % define models and run estimation
switch models{i}
    case 'm1'
        names   = {'IP' 'RS' 'EMPL' 'CPI' 'ComPI' 'WUXIA'}; %include in var rank order if you use cholesky ordering
        tr.dem  = [6];          % demean
        tr.det  = [];           % detrend
        tr.ldet = [1 2 3 4 5];  % log detrend
        SR = [3 -1;4 -1; 6 1 ]; % signs restricted: restrict variable k to be positive by including a row of SR as SR(ii,:) = [k,1] for some row ii
    case 'm2'
        names   = {'IP' 'RS' 'EMPL' 'CPI' 'ComPI' 'WUXIA'}; 
        tr.dem  = [6];
        tr.det  = [];
        tr.ldet = [1 2 3 4 5];
        SR = [4 -1; 6 1 ];
    case 'm3'
        names   = {'IP' 'RS' 'EMPL' 'CPI' 'ComPI' 'WUXIA'}; 
        tr.dem  = [6];
        tr.det  = [];
        tr.ldet = [1 2 3 4 5];
        SR = [3 -1; 6 1 ];
    case 'm4'
        names   = {'IP' 'RS' 'EMPL' 'CPI' 'ComPI' 'WUXIA'}; 
        tr.dem  = [6];
        tr.det  = [];
        tr.ldet = [1 2 3 4 5];
        SR = [3 -1; 4 -1];
    otherwise
        error('undefined model')
end
dstart = '1/1/1992'; % start and end dates
dend = '9/1/2020';
data = var_process_data(raw,raw_id,raw_date,names,p,dstart,dend,tr);
data.Ydum = []; % no dummies = flat prior
data.Xdum = [];
sr_impres = var_signres(data,CI,irhor,nsimacc,SR); % simulates sign restrictions
%% Plotting
figure()
ny = length(names);
if ny>9
    nr = 3;
    nc = ceil(ny/nr);
elseif ny>6
    nr=3;
    nc=3;
elseif ny>4
    nr=3;
    nc=2;
elseif ny>2
    nr=2;
    nc=2;
else
    nr=1;
    nc=2;
end
for j=1:ny
subplot(nr,nc,j)
plot(sr_impres(:,j,2),'b-')
hold on
plot(sr_impres(:,j,1),'r--')
plot(sr_impres(:,j,3),'r--')
plot(0*sr_impres(:,j,3),'k-.')
hold off
title(names{j})
end
spttl = '';
for cc=1:size(SR,1)
    if SR(cc,2)>0; sgn='+';else; sgn='-';end
    spttl = [spttl names{SR(cc,1)} ' (' sgn '), '];
end
suptitle(['Sign restrictions: ' spttl])
set(gcf,'Color',[1 1 1])
end