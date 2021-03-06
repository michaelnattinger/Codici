function impres = var_chol(data,CI,irhor,nsim,shock)
Y=[data.Ydata; data.Ydum];
X=[data.Xdata; data.Xdum];
[ny,nx] = size(Y'*X);
Ttot = length(Y(:,1));
bols = X\Y;
Sl = (Y - X*bols)'*(Y - X*bols);
v=ny+10;
% prior on IW
Sst = zeros(ny);
Tpre = floor(length(data.Ydata(:,1))/2);
for i=1:ny
    Sst(i,i) = v*std(data.Ydata(2:Tpre,i)-data.Ydata(1:Tpre-1,i)*(data.Ydata(1:Tpre-1,i)\data.Ydata(2:Tpre,i)))^2; 
end
impres = NaN(irhor+1,ny,length(shock),nsim);
% begin monte carlo
for tt=1:nsim
% draw sig from IW(Ttot -nx+v,S*+S)
sig = iwishrnd(Sl+Sst,Ttot -nx+v);
bdr = mvnrnd(bols(:),kron(sig,inv(X'*X)));
bdr = reshape(bdr,nx,ny);
rdr = Y-X*bdr;
sdr = (rdr'*rdr)/(Ttot - nx);
lcdr = chol(sdr)';
for i=1:length(shock)
    impres(:,:,i,tt) = draw_ir(bdr(1:end-1,:),irhor,lcdr(:,shock(i)));
end
end
ind = round(nsim*[0.5 - 0.5*CI 0.5 0.5+0.5*CI]);
impres = sort(impres,4);
impres = impres(:,:,:,ind);
end