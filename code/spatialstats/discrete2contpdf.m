function Zg = discrete2contpdf(probx,pts,stacksz,porder)

[x0,y0,z0] = meshgrid(1:stacksz(2),1:stacksz(1),1:stacksz(3));

polymodel = polyfitn([pts(1,:)', pts(2,:)', pts(3,:)'],log(probx),porder);
zg = polyvaln(polymodel,[x0(:),y0(:),z0(:)]);
Zg = reshape(zg,stacksz(1),stacksz(2),stacksz(3));

Zg = exp(Zg);
Zg = Zg./(sum(Zg(:)));

end
