function Dict = create_synth_dict(radii,box_radius)

Lbox = box_radius*2 +1;
Dict = zeros(Lbox^3,length(radii));
cvox = (Lbox-1)/2 + 1;

for i=1:length(radii)
   tmp =zeros(Lbox,Lbox,Lbox);
   tmp(cvox,cvox,cvox)=1;
   spheremat = strel3d(radii(i));
   Dict(:,i) = reshape(imdilate(tmp,spheremat),Lbox^3,1);
   Dict(:,i) = Dict(:,i)./norm(Dict(:,i));
end

end