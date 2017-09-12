function idx = whichborder(stacksz)

Border = zeros(stacksz);

Border(1,:,:) = 1;
Border(end:end,:,:) = 1;

Border(:,1,:) = 1;
Border(:,end,:) = 1;

Border(:,:,1) = 1;
Border(:,:,end) = 1;

idx = find(Border);

end