function c=anticlock(xy)
S=0; n=size(xy,1); x=xy(:,1); y=xy(:,2);
for i=1:size(xy,1)-1
    S=S+(-0.5*(y(i+1)+y(i)) * (x(i+1)-x(i)));
end
S=S+(-0.5*(y(1)+y(n)) * (x(1)-x(n)));
if S>0
    c=1;
else
    c=2;
end
end

