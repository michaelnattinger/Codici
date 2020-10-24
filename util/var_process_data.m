function data = var_process_data(raw,raw_id,raw_date,names,p,dstart,dend,tr)
% Processes data for a VAR - no dummy obs for now
i_start = find(strcmp(dstart,raw_date));
i_end = find(strcmp(dend,raw_date));
raw = raw(i_start:i_end,:);
ny=length(names);
bal = NaN(length(raw(:,1)),ny);
for i=1:ny
    bal(:,i) = raw(:,strcmp(raw_id,names{i}));
end
[T,~] = size(bal);
ttr = [ones(T,1) (1:T)'];
% det
lindet = bal - ttr*(ttr\bal);
% demean
demean = bal - mean(bal);
% log det
logdet = 100*(log(bal) - ttr*(ttr\log(bal)));

data.bal(:,tr.dem) = demean(:,tr.dem);
data.bal(:,tr.det) = lindet(:,tr.det);
data.bal(:,tr.ldet) = logdet(:,tr.ldet);

data.Ydata = data.bal(p+1:end,:);
data.Xdata = ones(T-p,ny*p+1);
for i=0:p-1
    data.Xdata(:,i*ny+1:(i+1)*ny) = data.bal(p-i:end-1-i,:);
end
