function out = convn_fft(a,b)
% A is larger input
% B is template

sz_a = size(a);
sz_b = size(b);
pow2 = nextpow2(sz_a+sz_b);

c = single(fftn(a,2.^pow2));
c = c.*single(fftn(b,2.^pow2));
c = ifftn(c);

if 0 %original
A = fftn(a,2.^pow2);
B = fftn(b,2.^pow2);
C = A.*B;
c2 = ifftn(C);
end

for i=1:3;
    idx{i} = ceil((sz_b(i)-1)/2)+(1:sz_a(i));
end

out = c(idx{1},idx{2},idx{3});
    

end