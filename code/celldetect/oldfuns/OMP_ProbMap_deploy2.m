%%%%%%%%%%%%%%%%%%%%%%
function OMP_ProbMap_deploy2(probFile,presid,startballsz,dilatesz, kmax, paintFile, centroidFile)

load(probFile) % assume stored in cube
Prob = cube.data;

% create sphere template inside of bounding box
box_radius = ceil(max(startballsz)/2) + 1;
Dict = create_synth_dict(startballsz,box_radius);
Lbox = round(length(Dict)^(1/3));

Nmap = zeros(size(Prob));
newid = 1;
newtest = Prob;
Centroids = [];
Confidence = [];
for ktot = 1:kmax
    
    val = zeros(size(Dict,2),1);
    id = zeros(size(Dict,2),1);
    
    for j = 1:size(Dict,2)
       convout = convn_fft(newtest,reshape(Dict(:,j),Lbox,Lbox,Lbox));
       [val(j),id(j)] = max(convout(:)); % positive coefficients only
    end
    
    % find position in image with max correlation
    [~,which_atom] = max(val); 
    which_loc = id(which_atom); 
  
    X2 = compute3dvec(Dict(:,which_atom),which_loc,Lbox,size(newtest));
    xid = find(X2); 
    Nmap(xid) = newid;
    
    newid = newid+1;
    newtest = newtest.*(imdilate(X2,strel3d(dilatesz))<=0);
    ptest = val./sum(Dict);
    
    if ptest<presid
        break%return
    end
    
    [rr,cc,zz] = ind2sub(size(newtest),which_loc);
    
    if ~isempty(cube.xyzOffset)
        newC = cube.xyzOffset + [cc, rr, zz];
    else
        newC = [cc, rr, zz];
    end

    Centroids = [Centroids; [newC,ptest]]; 
    display(['Iter remaining = ', int2str(kmax-ktot), ...
             ' Correlation = ', num2str(ptest,3)])
         
end

save(centroidFile,'Centroids')
cube.setCutout(Nmap);
sprintf(paintFile)
save(paintFile,'cube','-v7.3')
