function hyp = maxlik_litterman(data,p)
obj = @(x) obfun(x,data,p);
x0 = [1;2;1;1];
hh = fmincon(obj,x0,[-1 0 0 0; 0 -1 0 0; 0 0 -1 0;0 0 0 -1;eye(4)],[0;0;0;0;100*ones(4,1)]);
hyp.lam1 = hh(1);
hyp.lam2 = hh(2);
hyp.lam3 = hh(3);
hyp.lam4 = hh(4);
end

function nlml = obfun(H,d,lag)
hy.lam1 = H(1);
hy.lam2 = H(2);
hy.lam3 = H(3);
hy.lam4 = H(4);
[d.Ydum,d.Xdum] = litterman_prior(hy,d,lag);
nlml = negmarglik(d);
end