function vertices=rotate_xyz(vertices,ind)
% rotate along y-axis to let vertices 'p1', 'p2' have the same x-axis value
angle=fzero(@(x)(fun_yx(x,vertices(ind(1),:),vertices(ind(2),:))),0);
vertices=([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]*vertices')';
% rotate along x-axis to let vertices 'p1', 'p2' have the same y-axis value
angle=fzero(@(x)(fun_xy(x,vertices(ind(1),:),vertices(ind(2),:))),0);
vertices=([1 0 0;0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)]*vertices')';
% rotate along z-axis to let p1 x=0
[thetas,~,~]=cart2pol(vertices(:,1),vertices(:,2),vertices(:,3));
theta=-(pi/2+thetas(ind(1)));
vertices=([cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1]*vertices')';

% rotate along x-axis to let vertices 'p2', 'p3' have the same z-axis value
angle=fzero(@(x)(fun_x1(x,vertices(ind(2),:),vertices(ind(3),:))),0);
vertices=([1 0 0;0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)]*vertices')';


% let apical on bottom
if vertices(ind(1),3) > vertices(ind(2),3)
    angle=pi;
    vertices=([1 0 0;0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)]*vertices')';
end  

end














