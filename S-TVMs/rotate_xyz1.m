function vertices=rotate_xyz1(vertices,ind)
% rotate along z-axis to let points 'p1', 'p3' have the same x-axis value
angle=fzero(@(x)(fun_zx(x,vertices(ind(1),:),vertices(ind(3),:))),0);
vertices=([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]*vertices')';      
% rotate along x-axis to let points 'p1', 'p3' have the same z-axis value
angle=fzero(@(x)(fun_x1(x,vertices(ind(1),:),vertices(ind(3),:))),0);
vertices=([1 0 0;0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)]*vertices')';
% rotate along y-axis to let points 'p1', 'p2' have the same z-axis value
angle=fzero(@(x)(fun_y1(x,vertices(ind(1),:),vertices(ind(2),:))),0);
vertices=([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]*vertices')';
% 
% rotate along z-axis to let points 'p1', 'p2' have the same x-axis value
angle=fzero(@(x)(fun_zx(x,vertices(ind(1),:),vertices(ind(2),:))),0);
vertices=([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]*vertices')';   

end














