function [lines,lines_unique,lines_boun_order,lines_boun_withoutOrder]=boundaryOrder(fn,ind0_new1,xy)
lines_nr=zeros(size(fn,1)*3,2);
for i=1:size(fn)
    lines_nr(3*i-2,:)=[fn(i,1),fn(i,2)]; lines_nr(3*i-1,:)=[fn(i,1),fn(i,3)]; lines_nr(3*i,:)=[fn(i,2),fn(i,3)];
end
lines_nr=sort(lines_nr,2); [lines_unique,ia]=unique(lines_nr,'rows');
lines=lines_nr(setdiff(1:size(lines_nr,1),ia),:);
lines_boun_withoutOrder=setdiff(lines_nr(ia,:),lines_nr(setdiff(1:size(lines_nr,1),ia),:),'rows');

lines_boun_order=[];
if ~isempty(find(lines_boun_withoutOrder(:,1)==ind0_new1(1), 1))
    inds=find(lines_boun_withoutOrder(:,1)==ind0_new1(1));
    lines_boun_order(1,:)=lines_boun_withoutOrder(inds(1),:);
else
    inds=find(lines_boun_withoutOrder(:,2)==ind0_new1);
    lines_boun_order(1,:)=flip(lines_boun_withoutOrder(inds(1),:));
end
for n=1:size(lines_boun_withoutOrder,1)-1
    for i=1:size(lines_boun_withoutOrder,1)
        if ~isempty(intersect(lines_boun_withoutOrder(i,:),lines_boun_order(n,2))) && isempty(intersect(lines_boun_withoutOrder(i,:),lines_boun_order(n,1)))
            lines_boun_order(n+1,:)=[lines_boun_order(n,2),setdiff(lines_boun_withoutOrder(i,:),lines_boun_order(n,2))];
        end
    end
end


if anticlock(xy(lines_boun_order(:,1),:))==2
    lines_boun_order=flip(flip(lines_boun_order,2),1);
end

end