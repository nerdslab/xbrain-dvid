function clearAnno(oo)

q = OCPQuery;
q.setType(eOCPQueryType.RAMONIdList);
idsAll = oo.query(q);

for i=1:length(idsAll)
    oo.deleteAnnotation(idsAll(i))
end

end