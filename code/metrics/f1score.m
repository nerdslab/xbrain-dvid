function [f1, p, r] = f1score(TP,FP,FN,b)

if nargin<4
    b=1;
end

p = TP ./(TP + FP);
r = TP ./(TP + FN);
f1 = (1 + b^2)*p.*r./((b^2*p)+r);

end