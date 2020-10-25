function [Ydum,Xdum] = litterman_prior(hyp,data,p)
% generates dummy variables for minnesota prior
[~,ny] = size(data.Ydata);
sn = std(data.bal);
mn = mean(data.bal);
% First batch: own first lag dummies
Ydum = eye(ny).*(hyp.lam1 * sn);
Xdum = [eye(ny).*(hyp.lam1 * sn) zeros(ny,(p-1)*ny + 1)];
% Second batch: own other lag dummies
if p>1
    for pp=2:p
        Ydum = [Ydum; zeros(ny)];
        Xdum = [Xdum; zeros(ny,ny*(pp-1)) eye(ny).*(hyp.lam1 * sn)*pp.^(hyp.lam2) zeros(ny,(p-pp)*ny+1) ];
    end
end
% Third batch: Own-persistence lag
Ydum = [Ydum; eye(ny).*(hyp.lam3 * mn)];
Xdum = [Xdum; kron(eye(ny).*(hyp.lam3 * mn),ones(1,p)) zeros(ny,1)];
% Fourth batch: Co-persistence lags
Ydum = [Ydum; (hyp.lam4 * mn)];
Xdum = [Xdum; kron((hyp.lam4 * mn),ones(1,p)) hyp.lam4];
end