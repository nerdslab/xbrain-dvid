
function X = compute3dvec(vec,which_loc,Lbox,stacksz)

tmp = placeatom(vec,Lbox,which_loc,stacksz);
tmp(1:Lbox,:,:)=[];
tmp(:,1:Lbox,:)=[];
tmp(:,:,1:Lbox)=[];
tmp(end-Lbox+1:end,:,:)=[];
tmp(:,end-Lbox+1:end,:)=[];
tmp(:,:,end-Lbox+1:end)=[];
X = tmp;
 return   
end
