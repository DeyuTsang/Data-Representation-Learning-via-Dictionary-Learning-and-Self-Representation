function rankZ =  compute_rank(Z_values)
sorted           = sort(abs(Z_values),'descend');
m = length(sorted);
sN1 = 1.0e-10;
sGap = 8;
rankZ = m;
for i = m-2:-1:1
    d1 = sorted(i)-sorted(i+1);
    d2 = sorted(i+1)-sorted(i+2);
    if d2 < 1e-16
        sGap = 1e+14;
    elseif d2<1e-12
        sGap = 1e+10;
    elseif d2 < 1e-8
        sGap = 1e+5;
    elseif d2 < 1e-4
        sGap = 1e+2;
    elseif d2 < 1e-2
        sGap = 8;
    end
%      fprintf('%d  d1/d2=%.3e d1=%.2e   d2=%.2e \n',i,d1/d2, d1,d2)
    if d1 > d2*sGap && d1 > 1.0e-4
        rankZ = i ;
        break;
    end
end


