function impres = draw_ir(B,irhor,shock)
%Draw impulse response for SVAR
ny = size(B,2);
impres = NaN(irhor+1,length(shock));
impres(1,:) = shock;
tempx = zeros(1,size(B,1));
tempx(1:ny) = shock(:);
for tt = 1:irhor
    impres(tt+1,:) = tempx*B;
    tempx(ny+1:end) = tempx(1:end-ny);
    tempx(1:ny) = impres(tt+1,:);
end

