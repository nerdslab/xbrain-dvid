function plotconncomp(idx,stacksz)

tmp = zeros(stacksz);
tmp(idx)=1;
visualize3d(tmp,'b',0.4)

end