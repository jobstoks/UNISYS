function s = area(a,b,c)
if length(a)==2
    ab=[b-a 0];
    bc=[c-b 0];    
else
    ab=b-a;
    bc=c-b;
end
z=cross(ab,bc);
s=1/2*norm(z);
end