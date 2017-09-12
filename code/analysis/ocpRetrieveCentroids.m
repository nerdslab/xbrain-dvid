fileout = 'xbrain_centroids_S1_proj_test1_07302015.csv';
annoToken = 'S1_proj_test1';
step = 100; %number of annotations to 
oo = OCP;
oo.setAnnoToken(annoToken)
q = OCPQuery;
q.setType(eOCPQueryType.RAMONIdList);
q.validate
id = oo.query(q);
q.setType(eOCPQueryType.RAMONMetaOnly);

cen = [];
step = 100;
for i = 1:step:length(id)
    i
    endId = min(i + step-1, length(id));
    q.setId(id(i:1:endId));
    c = oo.query(q);
    for j = 1:length(c)
        cen(end+1,:) = [c{j}.id,str2num(c{j}.dynamicMetadata('centroid'))];
    end
end

csvwrite(fileout,cen)