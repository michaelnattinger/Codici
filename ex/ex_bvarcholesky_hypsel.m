clear; close all; clc

% load data
xls = '../data/examplesr.xls';
sht = 'matlab';
[raw,sheet] = xlsread(xls,sht);
raw_id = sheet(1,2:end);
raw_date = sheet(2:end,1);
models = {'m1'};
p = 6;         % lag order for VAR
CI = 0.68;      % CI: 0.8 == 80% CI
nsim = 1000;   % draws of b in monte carlo
irhor = 60;    % impulse response horizon
prior = 'litterman';

% We will choose hyperparameters via maximum likelihood

for i=1:length(models) % define models and run estimation
switch models{i}
    case 'm1'
        names   = {'IP' 'RS' 'EMPL' 'CPI' 'ComPI' 'WUXIA'}; %include in var rank order if you use cholesky ordering
        tr.dem  = [6];          % demean
        tr.det  = [];           % detrend
        tr.ldet = [1 2 3 4 5];  % log detrend
        shock   = [1 2 3 4 5 6]; %shock these variables
    otherwise
        error('undefined model')
end
dstart = '1/1/1992'; % start and end dates
dend = '9/1/2020';
data = var_process_data(raw,raw_id,raw_date,names,p,dstart,dend,tr);
switch prior
    case 'flat'
data.Ydum = []; % no dummies = flat prior
data.Xdum = [];
    case 'litterman'
        hyp = maxlik_litterman(data,p);
        [data.Ydum,data.Xdum] = litterman_prior(hyp,data,p);
    otherwise
        error('prior incorrectly specified')     
end
chol_impres = var_chol(data,CI,irhor,nsim,shock); % simulation
%% Plotting
for ns=1:length(shock)
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
plot(chol_impres(:,j,ns,2),'b-')
hold on
plot(chol_impres(:,j,ns,1),'r--')
plot(chol_impres(:,j,ns,3),'r--')
plot(0*chol_impres(:,j,ns,3),'k-.')
hold off
title(names{j})
end
suptitle(['1 S.D. shock to ' names{shock(ns)}])
set(gcf,'Color',[1 1 1])
end
end