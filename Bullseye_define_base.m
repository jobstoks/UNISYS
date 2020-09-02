function geom=Bullseye_define_base(geom)

%% Script to determine which side of the heart is the 'fake' base, which side is left, and which side is right

%% Start by visualizing the heart
fig=figure;
trisurf(geom.faces,geom.vertices(:,1),geom.vertices(:,2),geom.vertices(:,3)); axis equal;
hold on;

%% BASE PLANE
%% Ask for three points that define the base plane
title('Define the basal plane');
msgbox('Define the basal plane. Select a point with the Data Cursor, then press space. Do this 3 times in a row to define the basal plane.');
h=datacursormode;
pause; set(gcf,'CurrentCharacter',char(1)); cursor_info = getCursorInfo(h); p1 = cursor_info.Position; scatter3(p1(1),p1(2),p1(3),200,'y','filled'); figure(fig);
pause; cursor_info = getCursorInfo(h); p2 = cursor_info.Position; scatter3(p2(1),p2(2),p2(3),200,'r','filled'); figure(fig);
pause; cursor_info = getCursorInfo(h); p3 = cursor_info.Position; scatter3(p3(1),p3(2),p3(3),200,'g','filled'); figure(fig);

%% Plot stuff and ask for additional input
normal = cross(p1 - p2, p1 - p3);
d = p1(1)*normal(1) + p1(2)*normal(2) + p1(3)*normal(3);
d = -d;
x = min(geom.vertices(:,1)):max(geom.vertices(:,1)); y = min(geom.vertices(:,2)):max(geom.vertices(:,2));
[X,Y] = meshgrid(x,y);
Z = (-d - (normal(1)*X) - (normal(2)*Y))/normal(3);
hold on;
mesh(X,Y,Z); zlim([min(geom.vertices(:,3)) max(geom.vertices(:,3))]);

% determine which vertices left vs. right of plane
B = p2-p1;
C = p3-p1;
X = geom.vertices - p1;
planeside = NaN(size(geom.vertices,1),1);
for i = 1:size(geom.vertices,1)
    planeside(i) = sign(det([B; C; X(i,:)]));
end
keepind1 = find(planeside>0);
keepind2 = find(planeside<0);
scatter3(geom.vertices(keepind1,1),geom.vertices(keepind1,2),geom.vertices(keepind1,3),'b');
scatter3(geom.vertices(keepind2,1),geom.vertices(keepind2,2),geom.vertices(keepind2,3),'r');
answer=questdlg('Which vertices are the non-base vertices (i.e., those to keep)?','ANSWER ME','Blue','Red','Blue');

%% Save to geom
geom.verticesBasalPlane = [p1; p2; p3];
if strcmpi(answer,'Red')
    geom.verticesBasalIndFakeSide = keepind1;
    geom.verticesBasalIndToKeepSide = keepind2;
else
    geom.verticesBasalIndFakeSide = keepind2;
    geom.verticesBasalIndToKeepSide = keepind1;
end
close
end
