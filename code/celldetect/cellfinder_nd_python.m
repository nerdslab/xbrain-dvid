%%%%%%%%%%%%%%%%%%%%%%
function cellfinder_nd_python(probFile,outFile, presid,startballsz,dilatesz, kmax) %, paintFile, centroidFile, server, token, channel, doUpload)

cube.xyzOffset = [0,0,0];% TODO

if isstr(probFile)
    load(probFile)
    Prob = data; % known
else
    Prob = single(probFile); %cube.data;
end

presid = single(presid);
startballsz = single(startballsz);
dilatesz = single(dilatesz);
kmax = single(kmax);
% create sphere template inside of bounding box
box_radius = ceil(max(startballsz)/2) + 1;
Dict = create_synth_dict(startballsz,box_radius);
Lbox = round(length(Dict)^(1/3));

Nmap = zeros(size(Prob));
newid = 1;
newtest = single(Prob); % extra precision isn't important here
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
    if val == 0 % corner case
        break
    end
    [~,which_atom] = max(val);
    which_loc = id(which_atom);
    
    X2 = compute3dvec(Dict(:,which_atom),which_loc,Lbox,size(newtest));
    xid = find(X2);
    newtest = newtest.*(imdilate(X2,strel3d(dilatesz))<=0);
    ptest = val./sum(Dict);
    
    if ptest<presid
        break%return
    end
    
    % fixing bug - don't set this value until after
    Nmap(xid) = newid;
    newid = newid+1;
    
    [rr,cc,zz] = ind2sub(size(newtest),which_loc);
    
    if ~isempty(cube.xyzOffset)
        newC = cube.xyzOffset + [cc, rr, zz] - [1, 1, 1]; %TODO
    else
        newC = [cc, rr, zz];
    end
    
    Centroids = [Centroids; [newC,ptest]];
    display(['Iter remaining = ', int2str(kmax-ktot), ...
        ' Correlation = ', num2str(ptest,3)])    
end

data = Nmap;
save(outFile, 'data')

%TODO centroids

%cube.setCutout(Nmap)
%% Need to integrate upload code so that things all happen in parallel
% this isn't the only way to do this, but probably the simplest

%save(centroidFile,'Centroids')
%sprintf(paintFile)
%save(paintFile,'cube','-v7.3')
