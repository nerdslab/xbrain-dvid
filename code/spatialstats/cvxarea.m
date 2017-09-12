function out = cvxarea(BW)

which_id = find(BW);

[xx,yy,zz] = ind2sub(size(BW),which_id);
[~,V] = convhulln([xx,yy,zz]);

out =  V/length(which_id);

end

