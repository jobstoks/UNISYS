 function [faces, t,z, vertices_openLine] = findOpeningTrodeSaveFaces(vertices, faces, inds,angle1,angle2)

[t,~,~] = cart2pol(vertices(:,1),vertices(:,2),vertices(:,3)); 
t(t<0) = 2*pi+t(t<0);


%%%%%%%%%%%%%%%%% delete upper and lower faces
z_min = min(vertices(:,3)); z_max = max(vertices(:,3));
h = z_max - z_min;
angle1 = 90-angle1; angle2 = 90-angle2;
inds_upper = find(vertices(:,3) >= z_max - 0.2*h);
for i=1:size(faces,1)
    if numel(intersect(faces(i,:), inds_upper))==3
        A = vertices(faces(i, 1), :); B = vertices(faces(i, 2), :); C = vertices(faces(i, 3), :);
        AB = B - A; AC = C - A; n = cross(AB, AC); z_axis = [0; 0; 1];
        cos_theta = abs(dot(n, z_axis)) / (norm(n) * norm(z_axis));
        theta_rad = acos(cos_theta);       % 直接取锐角
        theta_deg = rad2deg(theta_rad);

        if theta_deg < angle1 && n(2) < 0
            faces(i,:)=nan;
        end
    end
end

% delete the connections through abdomen
inds_lower = find(vertices(:,3) <= z_min + 0.2*h);
for i=1:size(faces,1)
    if numel(intersect(faces(i,:), inds_lower))==3
        A = vertices(faces(i, 1), :); B = vertices(faces(i, 2), :); C = vertices(faces(i, 3), :);
        AB = B - A; AC = C - A; n = cross(AB, AC);
        cos_theta = n(3) / norm(n);
        if cos_theta < 0
            theta_rad = pi - acos(cos_theta);  % 补角
        else
            theta_rad = acos(cos_theta);       % 直接取锐角
        end
        theta_deg = rad2deg(theta_rad);

        if theta_deg < angle2
            faces(i,:)=nan;
        end
    end
end


% figure('color','w');
% % original geometry
% subplot(1,2,1)
% trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor',[0.1,0.1,0.1],'FaceColor','white','FaceAlpha',1,'EdgeAlpha',1); hold on
% scatter3(vertices(inds,1),vertices(inds,2),vertices(inds,3),50,'r','filled');
% % plot3([min(vertices(:,1)), max(vertices(:,1))], [max(vertices(:,2)), max(vertices(:,2))], [max(vertices(inds_Yback,3)), max(vertices(inds_Yback,3))],'r-','LineWidth',2); hold on
% % plot3([min(vertices(:,1)), max(vertices(:,1))], [min(vertices(:,2)), min(vertices(:,2))], [max(vertices(inds_Ychest,3)), max(vertices(inds_Ychest,3))],'b-','LineWidth',2); hold on
% axis equal; hold off
% title('original torso&heart position')
% xlabel('x'); ylabel('y'); zlabel('z');
% % axis off

% opening line
vertices_openLine = (vertices(inds(1),:) + vertices(inds(2),:))/2;
% subplot(1,2,2)
% trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor',[0.1,0.1,0.1],'FaceColor','#7DC2F3','FaceAlpha',1,'EdgeAlpha',0); hold on; 
% scatter3(vertices(:,1),vertices(:,2),vertices(:,3), 15,'ko', 'filled'); hold on
% scatter3(vertices_openLine(1),vertices_openLine(2),vertices_openLine(3),50,'r','filled');
% axis equal; axis off; box('off');
% title('Centralization of torso&heart')
% hold off


% rotate to let the angle of opening line become 0
angle = -mean(t(inds));
vertices = ([cos(angle ) -sin(angle ) 0; sin(angle ) cos(angle ) 0; 0 0 1]*vertices')';
[t,~,z] = cart2pol(vertices(:,1),vertices(:,2),vertices(:,3)); 
t(t<0) = 2*pi+t(t<0);

% generate Faces
for index = 1:size(faces,1)
    if ~isnan(faces(index,1))
        FaceIndex = faces(index,:);
        angle1 = t(FaceIndex(1)); angle2 = t(FaceIndex(2)); angle3 = t(FaceIndex(3));
        sign1 = abs(angle1-angle2)>pi/2; sign2 = abs(angle3-angle2)>pi/2; sign3 = abs(angle1-angle3)>pi/2;
        if any([sign1,sign2,sign3])
            faces(index,:) = NaN;
        end
    end
end
t = round(1/(max(t)-min(t))*(t-min(t))-0.5,2); %t=t+0.5;
z = round(1/(max(z)-min(z))*(z-min(z))-0.5,2); %z=z+0.5;

faces(isnan(faces(:,1)),:)=[];
end
