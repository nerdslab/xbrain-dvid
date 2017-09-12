function borderz = maskborder(Mask,maskdilatesz)

borderz = zeros(size(Mask));
[N1,N2] = size(Mask(:,:,1));

for i=1:size(borderz,3)
    m2 = zeros(N1,N2);
    whichm = find(Mask(:,:,i)==1);
    m2(whichm==1)=1;
    m2 = imdilate(m2,ones(maskdilatesz,maskdilatesz));
    borderz(:,:,i) = Mask(:,:,1)-m2;
end

end