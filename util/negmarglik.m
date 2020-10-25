function nlml = negmarglik(data)
%Returns the negative of (something proportional to) the (log) marginal
%likelihood
Y=[data.Ydata; data.Ydum];
X=[data.Xdata; data.Xdum];
[ny,nx] = size(Y'*X);
Ttot = length(Y(:,1));
bols = X\Y;
Sl = (Y - X*bols)'*(Y - X*bols);
v=ny+10;
Sst = zeros(ny);
Tpre = floor(length(data.Ydata(:,1))/2);
for i=1:ny
    Sst(i,i) = v*std(data.Ydata(2:Tpre,i)-data.Ydata(1:Tpre-1,i)*(data.Ydata(1:Tpre-1,i)\data.Ydata(2:Tpre,i)))^2; 
end
nlml = -1*((-ny/2)*log(det(X'*X))-((Ttot-nx)/2)*log(det(Sl+Sst)) + (ny/2)*log(det(data.Xdum'*data.Xdum)) + ((Ttot-nx)/2)*log(det(Sst)));
end

