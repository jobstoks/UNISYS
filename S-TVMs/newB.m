function xy=newB(xy,xy3,inds,c,s,v)
d=[];r=[];
if size(xy3,2)==3
    for i=1:size(inds,1)-1 % inds
        d=[d;sqrt(sqrt((xy3(inds(i),1)-xy3(inds(i+1),1))^2+(xy3(inds(i),2)-xy3(inds(i+1),2))^2+(xy3(inds(i),3)-xy3(inds(i+1),3))^2))];
        r=cumsum(d)./sum(d);
    end
else
    for i=1:size(inds,1)-1 % inds
        d=[d;sqrt(sqrt((xy3(inds(i),1)-xy3(inds(i+1),1))^2+(xy3(inds(i),2)-xy3(inds(i+1),2))^2))];
        r=cumsum(d)./sum(d);
    end
end
if strcmp(s,'+') && strcmp(c,'x')%s='+', '-' , c='x', 'y'
    xy(inds(2:end),1)=xy(inds(1),1)+r.*(xy(inds(end),1)-xy(inds(1),1)); xy(inds(2:end),2)=v;
end
if strcmp(s,'-') && strcmp(c,'x')%s='+', '-' , c='x', 'y'
    xy(inds(2:end),1)=xy(inds(1),1)-r.*(xy(inds(1),1)-xy(inds(end),1)); xy(inds(2:end),2)=v;
end
if strcmp(s,'+') && strcmp(c,'y')%s='+', '-' , c='x', 'y'
    xy(inds(2:end),2)=xy(inds(1),2)+r.*(xy(inds(end),2)-xy(inds(1),2)); xy(inds(2:end),1)=v;
end
if strcmp(s,'-') && strcmp(c,'y')%s='+', '-' , c='x', 'y'
    xy(inds(2:end),2)=xy(inds(1),2)-r.*(xy(inds(1),2)-xy(inds(end),2)); xy(inds(2:end),1)=v;
end
end