function ventricle_2D3D_sensitivity(mypath,beat_nr,ind_time,inds_ref,fieldname,times, num_trials)
close all;
GeomBeats = load(mypath);
geom=GeomBeats.GeomBeats.geom; beats=GeomBeats.GeomBeats.beats;

depTiming = beats(beat_nr).(fieldname); 
minPots = 0; maxPots=255;
if size(depTiming,2) > 1
    depTiming = depTiming(:,ind_time);
end
m=min(depTiming); M=max(depTiming);
depTiming = (maxPots-minPots)/(M-m) * (depTiming-m) + minPots;
% depTiming = nan(size(geom.Heart.vertices,1),1);

ventricleBullseye=struct; ventricle2D=struct; ventricle3D=struct; 

%%%%%%%%%%%%%%%%% initialization
%%
faces = geom.Heart.faces; vertices = geom.Heart.vertices;
% resample landmarks
lines_nr=zeros(size(faces,1)*3,2);
for i=1:size(faces)
    lines_nr(3*i-2,:)=[faces(i,1),faces(i,2)]; lines_nr(3*i-1,:)=[faces(i,1),faces(i,3)]; lines_nr(3*i,:)=[faces(i,2),faces(i,3)];
end
lines_nr=sort(lines_nr,2); [lines_unique,~]=unique(lines_nr,'rows');
edges = nan(size(lines_unique,1),1);
for i=1:size(lines_unique,1)
    l = lines_unique(i,:);
    edges(i) = norm(vertices(l(1),:)-vertices(l(2),:));
end
mean_edge_length = mean(edges);
perturbed_landmarks_matrix = perturb_ventricle_landmarks(vertices, inds_ref, mean_edge_length, times,num_trials);

for mmm = 1:num_trials
    inds_ref = perturbed_landmarks_matrix(mmm,:);

    % figure;
    % trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor','k','FaceColor','w','EdgeAlpha',0.5); hold on
    % scatter3(vertices(inds_ref,1),vertices(inds_ref,2),vertices(inds_ref,3),35,'filled','mo'); hold on
    % axis equal; hold off; axis off;
    % xlabel('x'); ylabel('y'); zlabel('z');


    % standardized position and orientation
    vertices_mean = mean(vertices(inds_ref(1:3),:));
    vertices = vertices-vertices_mean;
    % vertices=rotate_xyz(vertices,inds_ref);
    if numel(inds_ref)==4
        p1 = vertices(inds_ref(2),:); p2 = vertices(inds_ref(3),:); p3 = vertices(inds_ref(4),:);
        B = p2-p1; C = p3-p1; X = vertices-p1;
        planeside = NaN(size(geom.Heart.vertices,1),1);
        for i = 1:size(geom.Heart.vertices,1)
            planeside(i) = sign(det([B; C; X(i,:)]));
        end
        keepind1 = find(planeside<0); keepind2 = find(planeside>=0);
        verticesBasalIndToKeepSide = unique(keepind1);
        % verticesBasalIndToKeepSide = [verticesBasalIndToKeepSide;260;55;235];
        % verticesBasalIndToKeepSide = setdiff(verticesBasalIndToKeepSide, 1129);

        vertices_withoutBasal = vertices(verticesBasalIndToKeepSide,:);
        map=[(1:size(verticesBasalIndToKeepSide,1))',verticesBasalIndToKeepSide];
        [~, faces_withoutBasal] = newIndex(map, vertices, geom.Heart.faces);

        % delete extra faces
        lines_unique = boundaryVerticesAndallLines(faces_withoutBasal);
        G = graph(lines_unique(:,1), lines_unique(:,2));
        components = conncomp(G);
        numComponents = max(components);
        boundaryGroups = accumarray(components(:), (1:numel(components))', [], @(x){x});
        try
            N = cellfun(@numel, boundaryGroups);
        catch ME
            continue
        end
        [~, I] = sort(N, 'descend');
        if numel(I)>1
            verticesBasalIndToKeepSide = map(boundaryGroups{I(1)},2);
            verticesBasalIndFakeSide = setdiff(1:size(geom.Heart.vertices,1), verticesBasalIndToKeepSide);
            map=[(1:size(verticesBasalIndToKeepSide,1))',verticesBasalIndToKeepSide];
            [~, faces_withoutBasal] = newIndex(map, vertices, geom.Heart.faces);
            vertices_withoutBasal = vertices(verticesBasalIndToKeepSide,:);
        end

        % fig1 = figure;
        % % figure; subplot(1,2,1)
        % trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor','k','FaceColor',[.5 .5 .5],'EdgeAlpha',0.5); hold on
        % trisurf(faces_withoutBasal,vertices_withoutBasal(:,1),vertices_withoutBasal(:,2),vertices_withoutBasal(:,3),'EdgeColor','k','FaceColor','w','EdgeAlpha',0.5); hold on
        % axis equal; hold off; axis off;view(-100,-10);
        % xlabel('x'); ylabel('y'); zlabel('z');

        % fig5 = figure;
        % trimesh(faces,vertices(:,1),vertices(:,2),vertices(:,3),'FaceColor',[.5 .5 .5],'EdgeAlpha',0); hold on
        % trimesh(faces_withoutBasal,vertices_withoutBasal(:,1),vertices_withoutBasal(:,2),vertices_withoutBasal(:,3),depTiming(verticesBasalIndToKeepSide),'FaceColor','interp','FaceAlpha',1,'EdgeAlpha',0); hold on
        % colormap(clp); clim([minPots, maxPots]); %colorbar
        % axis equal; axis off; hold off
        % xlabel('x'); ylabel('y'); zlabel('z');
    else
        verticesBasalIndToKeepSide = (1:size(vertices,1))';
        vertices_withoutBasal = vertices(verticesBasalIndToKeepSide,:);
        map=[(1:size(verticesBasalIndToKeepSide,1))',verticesBasalIndToKeepSide];
        [~, faces_withoutBasal] = newIndex(map, vertices, geom.Heart.faces);

        % fig1 = figure;
        % % figure; subplot(1,2,1)
        % trisurf(faces,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor','k','FaceColor',[.5 .5 .5],'EdgeAlpha',0.5); hold on
        % trisurf(faces_withoutBasal,vertices_withoutBasal(:,1),vertices_withoutBasal(:,2),vertices_withoutBasal(:,3),'EdgeColor','k','FaceColor','w','EdgeAlpha',0.5); hold on
        % scatter3(vertices(inds_ref,1),vertices(inds_ref,2),vertices(inds_ref,3),100,'filled','mo'); hold on
        % axis equal; hold off; axis off;view(-35,45)
        % xlabel('x'); ylabel('y'); zlabel('z');

        % fig5 = figure;
        % trimesh(faces,vertices(:,1),vertices(:,2),vertices(:,3),depTiming(verticesBasalIndToKeepSide),'FaceColor','interp','FaceAlpha',1,'EdgeAlpha',0); hold on
        % colormap(clp); clim([minPots, maxPots]); %colorbar
        % axis equal; axis off; hold off
        % xlabel('x'); ylabel('y'); zlabel('z');
    end



    %%
    %%%%%%%%%%%%%%%% generate the updated boundary vertices
    lines_nr=zeros(size(faces_withoutBasal,1)*3,2);
    for i=1:size(faces_withoutBasal)
        lines_nr(3*i-2,:)=[faces_withoutBasal(i,1),faces_withoutBasal(i,2)]; lines_nr(3*i-1,:)=[faces_withoutBasal(i,1),faces_withoutBasal(i,3)]; lines_nr(3*i,:)=[faces_withoutBasal(i,2),faces_withoutBasal(i,3)];
    end
    lines_nr=sort(lines_nr,2); [~,ia]=unique(lines_nr,'rows');
    lines_boun_withoutOrder=setdiff(lines_nr(ia,:),lines_nr(setdiff(1:size(lines_nr,1),ia),:),'rows');
    vertices_boundary = unique(lines_boun_withoutOrder(:));

    [~,ind_closestToRef1_withoutBasal] = min(sum((vertices_withoutBasal-vertices(inds_ref(1),:)).^2,2));
    [~,ind_closestToRef2_withoutBasal] = min(sum((vertices_withoutBasal(vertices_boundary,:)-vertices(inds_ref(2),:)).^2,2));
    [~,ind_closestToRef3_withoutBasal] = min(sum((vertices_withoutBasal(vertices_boundary,:)-vertices(inds_ref(3),:)).^2,2));
    ind_closestToRef_withoutBasal = [ind_closestToRef1_withoutBasal, vertices_boundary(ind_closestToRef2_withoutBasal), vertices_boundary(ind_closestToRef3_withoutBasal)];

    %%
    %%%%%%%%%%%%%%%% generate the bullseye plot
    %%
    % generate the boundary lines
    [~,lines_unique,lines_boun_order,~]=boundaryOrder(faces_withoutBasal,ind_closestToRef_withoutBasal(2),vertices_withoutBasal);

    % aassign the boundary vertices positions and compute the inner vertices
    xy2 = vertices_withoutBasal(:,1:2);
    inds3 = find(lines_boun_order(:,1)==ind_closestToRef_withoutBasal(3));
    theta = -pi/2:pi/(inds3-1):pi/2;
    try
        xy2(lines_boun_order(1:inds3,1),:)=[cos(theta)',sin(theta)'];
    catch ME
        continue
    end
    theta = pi/2:pi/(size(lines_boun_order,1)-inds3):3*pi/2;
    xy2(lines_boun_order(inds3:end,1),:)=[cos(theta)',sin(theta)'];
    % 1st TEM
    try
        [xys2, G] = TEM(lines_unique, lines_boun_order, faces_withoutBasal, vertices_withoutBasal, xy2, 'median');
    catch ME
        continue
    end


    %%
    %%%%%%%%%%%%%%%%%% START to generate the shortest path
    %%
    % determine the connected faces and scatter points
    xys2_n = xys2;
    xa=xys2_n(ind_closestToRef_withoutBasal(1),1); ya=xys2_n(ind_closestToRef_withoutBasal(1),2);
    F = faces_withoutBasal; Fs = []; xy = xys2_n; x1=0; y1=0;
    ind2=2; y2_v = -1; [~,id] = min(sum((xys2-[0,-0.3]).^2,2));
    if ya>0
        P1 = shortestpath(G,ind_closestToRef_withoutBasal(1),id); P2 = shortestpath(G,id,ind_closestToRef_withoutBasal(ind2));
        P = [P1,P2(2:end)];
    else
        P = shortestpath(G,ind_closestToRef_withoutBasal(1),ind_closestToRef_withoutBasal(ind2));
    end
    for i=1:size(faces_withoutBasal,1)
        f=faces_withoutBasal(i,:);
        if ~isempty(intersect(f,P)) %min(size(intersect(f,P)))>=1%
            F(i,:) = nan; Fs = [Fs;f];
        end
    end
    F(isnan(F(:,1)),:)=[]; S=unique(Fs(:));

    %%%%%%%% rotate and translate
    x2=0; y2=y2_v;
    a=norm([x1-xa,y1-ya]); b=norm([x2-xa,y2-ya]); c=norm([x1-x2,y1-y2]);
    alpha=abs(acos((b^2+c^2-a^2)/(2*b*c)));
    % rotate alpha along point (0,1) for all points on path P
    xys=xys2_n(S,:);
    xx= (xys(:,1) - x2).*cos(alpha) - (xys(:,2) - y2).*sin(alpha) + x2;
    yy= (xys(:,1) - x2).*sin(alpha) + (xys(:,2) - y2).*cos(alpha) + y2;
    % stretch towards point (0,1) for all points on path P
    yy=(yy+1)/(1+yy(S==ind_closestToRef_withoutBasal(1)))-1;
    xy(S,1)=xx; xy(S,2)=yy;

    %%
    %%%%%%%%%%%%%%%% second TEM
    %%
    vs=unique(F(:)); map2=[(1:size(vs,1))',vs];
    F_l = F;
    for i=1:3
        [~,iloc]=ismember(F_l(:,i),vs);
        F_l(:,i)=map2(iloc,1);
    end
    [~,lines,Lines]=boundaryOrder(F_l,map2(map2(:,2)==ind_closestToRef_withoutBasal(3),1),xy(map2(:,2),:));
    B=unique(Lines(:));
    % compute the new 2D positions
    try
        [xys2_n, ~] = TEM(lines, Lines, F_l, vertices_withoutBasal(map2(:,2),:), xy(map2(:,2),:), 'median');
    catch ME
        continue
    end
    xym = xy; xym(map2(:,2),:) = xys2_n;
    % minor adjustment
    ind_closestToRef_withoutBasal_new = ind_closestToRef_withoutBasal;
    [~,ind_closestToRef_withoutBasal_new(1)] = min(sum((xym-[0,0]).^2,2)); xym(ind_closestToRef_withoutBasal_new(1),:)=[0,0];
    theta = cart2pol(xym(lines_boun_order(:,1),1), xym(lines_boun_order(:,1),2));
    [xym(lines_boun_order(:,1),1), xym(lines_boun_order(:,1),2)] = pol2cart(theta, 1);

    fig2 = figure;
    % % subplot(1,2,2)
    subplot(1,3,1)
    trisurf(faces_withoutBasal,xym(:,1), xym(:,2),zeros(size(xym,1),1),'EdgeColor','k','FaceColor','w', 'EdgeAlpha', 0.2); hold on
    view(0,90); axis equal; axis off; hold off
    %
    % fig6 = figure;
    % trimesh(faces_withoutBasal,xym(:,1), xym(:,2),zeros(size(xym,1),1),depTiming(verticesBasalIndToKeepSide),'FaceColor','interp','FaceAlpha',1,'EdgeAlpha',0); hold on
    % view(0,90);colormap(clp); clim([minPots, maxPots]); %colorbar
    % axis equal; axis off; hold off
    % xlabel('x'); ylabel('y'); zlabel('z');


    %%
    %%%%%%%%%%%%%%%% 2D rectangular plot
    %%
    xys2_re = xym;
    [theta, rho] = cart2pol(xys2_re(:,1), xys2_re(:,2));
    theta = theta+pi;
    indAngle1 = find(theta<=pi/2); indAngle2 = find(theta>pi/2 & theta<=3*pi/2); indAngle3 = find(theta>3*pi/2);
    theta(indAngle1) = theta(indAngle1)+pi/2; theta(indAngle2) = theta(indAngle2)+pi/2; theta(indAngle3) = theta(indAngle3)-3*pi/2;
    theta = (theta-min(theta))/(max(theta)-min(theta));
    xys2_re(:,1)=theta; xys2_re(:,2)=rho;
    faces_withoutBasal_xys2_re = faces_withoutBasal;
    for i=1:size(faces_withoutBasal,1)
        f=faces_withoutBasal(i,:);
        diff1 = abs(xys2_re(f(1),1)-xys2_re(f(2),1)); diff2 = abs(xys2_re(f(1),1)-xys2_re(f(3),1)); diff3 = abs(xys2_re(f(2),1)-xys2_re(f(3),1));
        if any([diff1>0.5, diff2>0.5, diff3>0.5])
            faces_withoutBasal_xys2_re(i,:)=nan;
        end
    end
    faces_withoutBasal_xys2_re(isnan(faces_withoutBasal_xys2_re(:,1)),:)=[];

    % figure;
    % trisurf(faces_withoutBasal_xys2_re,xys2_re(:,1),xys2_re(:,2),zeros(size(xys2,1),1),'EdgeColor','k','EdgeAlpha',0.2,'FaceColor','white','FaceAlpha',1); hold on
    % view(0,90); axis equal; axis off; hold off

    %%
    %%%%%%%%%%%%%%%% 2D square plot
    %%
    xys2_sq = xys2_re;
    [~,~,boun_square]=boundaryOrder(faces_withoutBasal_xys2_re,ind_closestToRef_withoutBasal_new(2),xys2_re);
    [~,ind_bl] = min(sum((xys2_sq(boun_square(:,1),:)-[0,0]).^2,2)); xys2_sq(boun_square(ind_bl,1),:)=[0,0];
    [~,ind_ul] = min(sum((xys2_sq(boun_square(:,1),:)-[0,1]).^2,2)); xys2_sq(boun_square(ind_ul,1),:)=[0,1];
    [~,ind_br] = min(sum((xys2_sq(boun_square(:,1),:)-[1,0]).^2,2)); xys2_sq(boun_square(ind_br,1),:)=[1,0];
    [~,ind_ur] = min(sum((xys2_sq(boun_square(:,1),:)-[1,1]).^2,2)); xys2_sq(boun_square(ind_ur,1),:)=[1,1];

    [~,~,boun_square]=boundaryOrder(faces_withoutBasal_xys2_re,boun_square(ind_bl,1),xys2_re);
    [~,ind_bl] = min(sum((xys2_sq(boun_square(:,1),:)-[0,0]).^2,2));
    [~,ind_ul] = min(sum((xys2_sq(boun_square(:,1),:)-[0,1]).^2,2));
    [~,ind_br] = min(sum((xys2_sq(boun_square(:,1),:)-[1,0]).^2,2));
    [~,ind_ur] = min(sum((xys2_sq(boun_square(:,1),:)-[1,1]).^2,2));
    xys2_sq(boun_square(1:ind_br,1),2) = 0;
    xys2_sq(boun_square(ind_br:ind_ur,1),1) = 1;
    xys2_sq(boun_square(ind_ul:end,1),1) = 0;
    xys2_sq(:,2)=xys2_sq(:,2);

    % fig3 = figure;
    subplot(1,3,2)
    trisurf(faces_withoutBasal_xys2_re,xys2_sq(:,1),xys2_sq(:,2),zeros(size(xys2,1),1),'EdgeColor','k','EdgeAlpha',0.2,'FaceColor','white','FaceAlpha',1); hold on
    view(0,90); axis equal; axis off; hold off

    % fig7 = figure;
    % trimesh(faces_withoutBasal_xys2_re,xys2_sq(:,1),xys2_sq(:,2),zeros(size(xys2,1),1),depTiming(verticesBasalIndToKeepSide),'FaceColor','interp','FaceAlpha',1,'EdgeAlpha',0); hold on
    % view(0,90);colormap(clp); clim([minPots, maxPots]); %colorbar
    % axis equal; axis off; hold off
    % xlabel('x'); ylabel('y'); zlabel('z');


    %%
    %%%%%%%%%%%%%%%% 3D

    %%
    a = 1; % depth
    r = xys2(:,1).^2 + xys2(:,2).^2; % 点到圆心的距离
    z3 = a * r; % 计算碗状z坐标
    xy3 = [xys2(:,1), xys2(:,2), z3]; xy3 = round(xy3-mean(xy3),4);
    xy3_lead = xy3; xy3_lead = xy3_lead+0.07*xy3_lead;

    % fig4 = figure;
    subplot(1,3,3)
    trisurf(faces_withoutBasal,xy3(:,1),xy3(:,2),xy3(:,3),'EdgeColor','k','FaceColor','w','EdgeAlpha',0.5); hold on
    axis equal; hold off; xlabel('x'); ylabel('y'); zlabel('z'); axis off

    % fig8 = figure;
    % trimesh(faces_withoutBasal,xy3(:,1),xy3(:,2),xy3(:,3),depTiming(verticesBasalIndToKeepSide),'FaceColor','interp','FaceAlpha',1,'EdgeAlpha',0); hold on
    % colormap(clp); clim([minPots, maxPots]);
    % axis equal; axis off; hold off
    % xlabel('x'); ylabel('y'); zlabel('z');


    %% distortion analysis
    areas_o3 = nan(size(faces_withoutBasal, 1), 1); areas_s2 = areas_o3; areas_r3 = areas_o3;

    anglesM_o3 = nan(size(faces_withoutBasal, 1), 1); anglesM_s2 = anglesM_o3; anglesM_r3 = anglesM_o3;
    anglesm_o3 = nan(size(faces_withoutBasal, 1), 1); anglesm_s2 = anglesm_o3; anglesm_r3 = anglesm_o3;
    anglesMe_o3 = nan(size(faces_withoutBasal, 1), 1); anglesMe_s2 = anglesMe_o3; anglesMe_r3 = anglesMe_o3;
    anglesMe_o3 = nan(size(faces_withoutBasal, 1), 3); anglesMe_s2 = anglesMe_o3; anglesMe_r3 = anglesMe_o3;

    edges_o3 = nan(size(lines_unique,1),1); edges_r3 = edges_o3; edges_s2 = edges_o3;

    tolerance=1e-10; mv=5; Mv=95;
    % original VS 3D (areas, angles)
    for i=1:size(faces_withoutBasal, 1)
        f = faces_withoutBasal(i,:);
        a1_o3 = vertices_withoutBasal(f(1),:); a2_o3 = vertices_withoutBasal(f(2),:); a3_o3 = vertices_withoutBasal(f(3),:);
        a1_s2 = xys2_sq(f(1),:); a2_s2 = xys2_sq(f(2),:); a3_s2 = xys2_sq(f(3),:);
        a1_r3 = xy3(f(1),:); a2_r3 = xy3(f(2),:); a3_r3 = xy3(f(3),:);
        M = [a1_s2, 1; a2_s2, 1; a3_s2, 1];
        isTriangle = abs(det(M)) > tolerance;
        if isTriangle
            % compute the areas
            areas_o3(i) = area_defined(a1_o3, a2_o3, a3_o3); areas_s2(i) = area_defined(a1_s2, a2_s2, a3_s2); areas_r3(i) = area_defined(a1_r3, a2_r3, a3_r3);

            % compute the angles
            a = norm(a2_o3 - a3_o3); b = norm(a1_o3 - a3_o3); c = norm(a1_o3 - a2_o3);
            angle_A = acosd((b^2 + c^2 - a^2) / (2 * b * c)); angle_B = acosd((a^2 + c^2 - b^2) / (2 * a * c)); angle_C = acosd((a^2 + b^2 - c^2) / (2 * a * b));
            anglesm_o3(i) = min([angle_A, angle_B, angle_C]); anglesM_o3(i) = max([angle_A, angle_B, angle_C]); anglesMe_o3(i,:) = median([angle_A, angle_B, angle_C]);

            a = norm(a2_s2 - a3_s2); b = norm(a1_s2 - a3_s2); c = norm(a1_s2 - a2_s2);
            angle_A = acosd((b^2 + c^2 - a^2) / (2 * b * c)); angle_B = acosd((a^2 + c^2 - b^2) / (2 * a * c)); angle_C = acosd((a^2 + b^2 - c^2) / (2 * a * b));
            anglesm_s2(i) = min([angle_A, angle_B, angle_C]); anglesM_s2(i) = max([angle_A, angle_B, angle_C]); anglesMe_s2(i,:) = median([angle_A, angle_B, angle_C]);

            a = norm(a2_r3 - a3_r3); b = norm(a1_r3 - a3_r3); c = norm(a1_r3 - a2_r3);
            angle_A = acosd((b^2 + c^2 - a^2) / (2 * b * c)); angle_B = acosd((a^2 + c^2 - b^2) / (2 * a * c)); angle_C = acosd((a^2 + b^2 - c^2) / (2 * a * b));
            anglesm_r3(i) = min([angle_A, angle_B, angle_C]); anglesM_r3(i) = max([angle_A, angle_B, angle_C]); anglesMe_r3(i,:) = median([angle_A, angle_B, angle_C]);

        end
    end
    metrics = struct;
    metrics.areas_o3=areas_o3; metrics.areas_s2=areas_s2; metrics.areas_r3=areas_r3;
    inds = unique([find(~isnan(areas_o3));find(~isnan(areas_s2));find(~isnan(areas_r3))]);
    areas_o3 = areas_o3(inds); areas_s2 = areas_s2(inds); areas_r3 = areas_r3(inds);
    inds1 = [isoutlier(areas_o3,"percentiles",[mv,Mv]) | isoutlier(areas_s2,"percentiles",[mv,Mv]) | isoutlier(areas_r3,"percentiles",[mv,Mv])];
    areas_o3 = areas_o3(~inds1); areas_s2 = areas_s2(~inds1); areas_r3 = areas_r3(~inds1);
    areas_o3 = areas_o3./mean(areas_o3); areas_s2 = areas_s2./mean(areas_s2); areas_r3 = areas_r3./mean(areas_r3);

    metrics.anglesMe_o3=anglesMe_o3; metrics.anglesMe_s2=anglesMe_s2; metrics.anglesMe_r3=anglesMe_r3;
    anglesMe_o3 = anglesMe_o3(inds); anglesMe_s2 = anglesMe_s2(inds); anglesMe_r3 = anglesMe_r3(inds);
    inds1 = [isoutlier(anglesMe_o3,"percentiles",[mv,Mv]) | isoutlier(anglesMe_s2,"percentiles",[mv,Mv]) | isoutlier(anglesMe_r3,"percentiles",[mv,Mv])];
    anglesMe_o3 = anglesMe_o3(~inds1); anglesMe_s2 = anglesMe_s2(~inds1); anglesMe_r3 = anglesMe_r3(~inds1);


    % edges
    for i=1:size(lines_unique,1)
        l = lines_unique(i,:);
        edges_o3(i) = norm(vertices_withoutBasal(l(1),:)-vertices_withoutBasal(l(2),:));
        edges_s2(i) = norm(xys2_sq(l(1),:)-xys2_sq(l(2),:));
        edges_r3(i) = norm(xy3(l(1),:)-xy3(l(2),:));
    end
    metrics.edges_o3=edges_o3; metrics.edges_s2=edges_s2; metrics.edges_r3=edges_r3;
    inds1 = [isoutlier(edges_o3,"percentiles",[mv,Mv]) | isoutlier(edges_s2,"percentiles",[mv,Mv]) | isoutlier(edges_r3,"percentiles",[mv,Mv])];
    edges_o3 = edges_o3(~inds1); edges_s2 = edges_s2(~inds1); edges_r3 = edges_r3(~inds1);
    edges_o3 = edges_o3./mean(edges_o3); edges_s2 = edges_s2./mean(edges_s2); edges_r3 = edges_r3./mean(edges_r3);

    %%%%%%%%%%%%%%%%%%%%%%%% differences
    areas_diff_s2 = areas_o3./areas_s2; areas_diff_r3 = areas_o3./areas_r3;
    angles_diff_s2 = anglesMe_o3./anglesMe_s2; angles_diff_r3 = anglesMe_o3./anglesMe_r3;
    edges_diff_s2 = edges_o3./edges_s2; edges_diff_r3 = edges_o3./edges_r3;
    distortion=struct;
    distortion.areas_diff_s2 = areas_diff_s2; distortion.areas_diff_r3 = areas_diff_r3;
    distortion.angles_diff_s2 = angles_diff_s2; distortion.angles_diff_r3 = angles_diff_r3;
    distortion.edges_diff_s2 = edges_diff_s2; distortion.edges_diff_r3 = edges_diff_r3;

    %%
    ventricleOri.vertices = vertices; ventricleOri.faces = faces;
    ventricleBullseye.vertices = xym; ventricleBullseye.faces = faces_withoutBasal;
    ventricle2D.vertices = xys2_sq; ventricle2D.faces = faces_withoutBasal_xys2_re;
    ventricle3D.vertices = xy3; ventricle3D.faces = faces_withoutBasal;

    % save images and mat file
    parentDir = fileparts(mypath);
    figsFolder = fullfile(parentDir, 'results');
    if ~exist(figsFolder, 'dir')
        mkdir(figsFolder);
    end
    %
    save(fullfile(figsFolder, strcat('ventricle',num2str(times),'/ventricle_results_',num2str(mmm),'.mat')),'ventricleOri','map','ventricleBullseye', 'ventricle2D', 'ventricle3D','distortion','metrics','inds_ref','verticesBasalIndToKeepSide')%%
    % close all;
end
end