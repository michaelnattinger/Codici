function sr_impres = var_signres(data,CI,irhor,nsimacc,SR)
X = [data.Xdum data.Xdata];
Y = [data.Ydum data.Ydata];
b_ols = X\Y;
r_ols = data.Ydata - data.Xdata*b_ols;
Sigma = r_ols'*r_ols/(length(data.Ydata(:,1))- length(data.Xdata(1,:)));
sr_impres = NaN(irhor+1,size(Y,2),nsimacc);
lc = chol(Sigma)';
i=1;
while i<nsimacc+1
    draw = RandOrthMat(size(Y,2));
    draw = lc*draw;
    candidate = draw_ir(b_ols(1:end-1,:),irhor,draw(:,end));
    % check sign restrictions
    acc = 1;
    for ch =1:length(SR(:,1))
        if sum(candidate(:,SR(ch,1)))*sign(SR(ch,2)) < 0; acc = 0; end
    end
    if acc
        sr_impres(:,:,i) = candidate;
        i=i+1;
    end
end
sr_impres = sort(sr_impres,3);
ind = [0.5-CI*0.5 0.5 0.5+CI*0.5];
ind = round(ind*nsimacc);
sr_impres = squeeze(sr_impres(:,:,ind));

