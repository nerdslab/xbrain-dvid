function X = placeatom(vec,Lbox,which_loc,stacksz)

tmp = zeros(stacksz);
tmp(which_loc)=1;
tmp = padarray(tmp,[Lbox,Lbox,Lbox]);
whichloc2 = find(tmp);
[center_loc(1),center_loc(2),center_loc(3)] = ind2sub(size(tmp),whichloc2);
        tmp(center_loc(1)-round(Lbox/2)+1:center_loc(1)+round(Lbox/2)-1,...
        center_loc(2)-round(Lbox/2)+1:center_loc(2)+round(Lbox/2)-1,...
        center_loc(3)-round(Lbox/2)+1:center_loc(3)+round(Lbox/2)-1) = ...
        reshape(vec,Lbox,Lbox,Lbox);    
X = tmp;
end
