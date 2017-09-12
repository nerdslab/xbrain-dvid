function dist=KLDiv(h1,h2)
%This routine evaluates the Kullback-Leibler (KL) distance between histograms. 
%             Input:      h1, h2 - histograms
%             Output:    d ? the distance between the histograms.
%             Method:    KL is defined as: 
%             Note, KL is not symmetric, so compute both sides.
%             Take care not to divide by zero or log zero: disregard entries of the sum      for which with H2(i) == 0.

temp = sum(h1 .* log(h1 ./ h2));
temp( isinf(temp) ) = 0; % this resloves where h1(i) == 0 
d1 = sum(temp);

temp = sum(h2 .* log(h2 ./ h1)); % other direction of compare since it's not symetric
temp( isinf(temp) ) = 0;
d2 = sum(temp);

dist = d1 + d2;

end
