%% Script to determine which side of the heart is the 'fake' base, which side is left, and which side is right
function [geom]=make_axis(geom,saveFile,loadFile)
%% Start by visualizing the heart

if exist('loadFile','var')
    if ~isempty(loadFile)
        load(loadFile);
    end
else
    fig=figure;
    if isfield(geom,'faces')
    hplot=trisurf(geom.faces,geom.vertices(:,1),geom.vertices(:,2),geom.vertices(:,3)); axis equal; %just to visualize something
    else
    hplot=scatter3(geom.vertices(:,1),geom.vertices(:,2),geom.vertices(:,3),10,geom.vertices(:,3),'filled'); axis equal; %just to visualize something   
    colormap('jet')
    end
    xlabel('x'),ylabel('y'),zlabel('z');
    hold on;
    
    % Ask for the apical point of the LV/RV division plane
    title('Define the LV/RV division plane');
    msgbox('First select the most apical point of LV/RV division plane with the data cursor. Then press space');
    h=datacursormode;
    pause; set(gcf,'CurrentCharacter',char(1)); cursor_info = getCursorInfo(h); p1 = cursor_info.Position; scatter3(p1(1),p1(2),p1(3),200,'y','filled'); figure(fig);
    
    %Ask for the 2 remaining (basal) points of the LV/RV division plane
    msgbox('Now select the second and third (basal) points of the LV/RV division plane. Press space after selection of each point.');
    pause; cursor_info = getCursorInfo(h); p2a = cursor_info.Position; scatter3(p2a(1),p2a(2),p2a(3),200,'r','filled'); figure(fig);
    pause; cursor_info = getCursorInfo(h); p2b = cursor_info.Position; scatter3(p2b(1),p2b(2),p2b(3),200,'r','filled'); figure(fig);   
    
    %Define and plot the division plane
    normal = cross(p1 - p2a, p1 - p2b);
    d = p1(1)*normal(1) + p1(2)*normal(2) + p1(3)*normal(3);
    d = -d;
    x = min(geom.vertices(:,1)):max(geom.vertices(:,1)); y = min(geom.vertices(:,2)):max(geom.vertices(:,2));
    [X,Y] = meshgrid(x,y);
    Z = (-d - (normal(1)*X) - (normal(2)*Y))/normal(3);
    hold on;
    b=mesh(X,Y,Z); zlim([min(geom.vertices(:,3)) max(geom.vertices(:,3))]);
    
    
    % determine which vertices left vs. right of plane
    B = p2a-p1;
    C = p2b-p1;
    X = geom.vertices - p1;
    planeside = NaN(size(geom.vertices,1),1);
    for i = 1:size(geom.vertices,1)
        planeside(i) = sign(det([B; C; X(i,:)]));
    end
    keepind1 = find(planeside>0); keepind1 = intersect(keepind1, geom.verticesBasalIndToKeepSide);
    keepind2 = find(planeside<0); keepind2 = intersect(keepind2, geom.verticesBasalIndToKeepSide);
    scatter3(geom.vertices(keepind1,1),geom.vertices(keepind1,2),geom.vertices(keepind1,3),'filled','b');
    scatter3(geom.vertices(keepind2,1),geom.vertices(keepind2,2),geom.vertices(keepind2,3),'filled','r');
    answer=questdlg('Which vertices are of the LV?','ANSWER ME','Blue','Red','Blue');
    
    % Save to geom
    geom.verticesLVvsRVPlane = [p1; p2a; p2b];
    if strcmpi(answer,'Red')
        geom.verticesLVInd = keepind2;
        geom.verticesRVInd = keepind1;
    else
        geom.verticesLVInd = keepind1;
        geom.verticesRVInd = keepind2;
    end
    
    find_p2a_basalnodes=ismember(p2a,geom.vertices(geom.verticesBasalIndFakeSide,:),'rows');
    if find_p2a_basalnodes
        dist=sqrt((p2a(1)-geom.vertices(geom.verticesBasalIndToKeepSide,1)).^2+(p2a(2)-geom.vertices(geom.verticesBasalIndToKeepSide,2)).^2+(p2a(3)-geom.vertices(geom.verticesBasalIndToKeepSide,3)).^2);
        [~,ind]=min(dist);
        p2a=geom.vertices(geom.verticesBasalIndToKeepSide(ind),:);
    end
    
    find_p2b_basalnodes=ismember(p2b,geom.vertices(geom.verticesBasalIndFakeSide,:),'rows');
    if find_p2b_basalnodes
        dist=sqrt((p2b(1)-geom.vertices(geom.verticesBasalIndToKeepSide,1)).^2+(p2b(2)-geom.vertices(geom.verticesBasalIndToKeepSide,2)).^2+(p2b(3)-geom.vertices(geom.verticesBasalIndToKeepSide,3)).^2);
        [~,ind]=min(dist);
        p2b=geom.vertices(geom.verticesBasalIndToKeepSide(ind),:);
    end
    
    % Final visualization
    close
    if isfield(geom,'faces')
    trisurf(geom.faces,geom.vertices(:,1),geom.vertices(:,2),geom.vertices(:,3)); axis equal; %just to visualize something
    else
    scatter3(geom.vertices(:,1),geom.vertices(:,2),geom.vertices(:,3),10,geom.vertices(:,3),'filled'); axis equal; %just to visualize something   
    colormap('jet')
    end
    hold on;
    scatter3(geom.vertices(geom.verticesRVInd,1),geom.vertices(geom.verticesRVInd,2),geom.vertices(geom.verticesRVInd,3),'b','filled');
    scatter3(geom.vertices(geom.verticesLVInd,1),geom.vertices(geom.verticesLVInd,2),geom.vertices(geom.verticesLVInd,3),'r','filled');
    scatter3(geom.vertices(geom.verticesBasalIndFakeSide,1),geom.vertices(geom.verticesBasalIndFakeSide,2),geom.vertices(geom.verticesBasalIndFakeSide,3),'k','filled');
    legend('Heart','RV','LV','Base')
    
%     msgbox('Lastly, select RV lateral wall and press space');
%     pause; cursor_info = getCursorInfo(h); p3 = cursor_info.Position; scatter3(p3(1),p3(2),p3(3),200,'g','filled'); figure(fig);
    
    %% Define heart axis
    
    p2=(p2a+p2b)/2;
    range_vert=[max(geom.vertices(:,1))-min(geom.vertices(:,1)) max(geom.vertices(:,2))-min(geom.vertices(:,2)) max(geom.vertices(:,3))-min(geom.vertices(:,3))];
    max_range_vert=max(range_vert);
    
    % Calculate formula of y and z, in terms of x
    fy_x(2)=(p2(2)-p1(2))/(p2(1)-p1(1));
    fy_x(1)=-p1(1)*fy_x(2)+p1(2);
   
    fz_x(2)=(p2(3)-p1(3))/(p2(1)-p1(1));
    fz_x(1)=-p1(1)*fz_x(2)+p1(3);
    
    % Calculate points to plot line in between.
    diff_x_plot_2=abs(p1(1)-p2(1));

    if p1(1)>p2(1)
        plot_pt_1(1)=p2(1)-max_range_vert/2;
        plot_pt_2(1)=p1(1)+max_range_vert/2;
    elseif p2(1)>p1(1)
        plot_pt_1(1)=p1(1)-max_range_vert/2;
        plot_pt_2(1)=p2(1)+max_range_vert/2;
    end
    
    plot_pt_1(2)=fy_x(1)+plot_pt_1(1)*fy_x(2);
    plot_pt_1(3)=fz_x(1)+plot_pt_1(1)*fz_x(2);
    
    plot_pt_2(2)=fy_x(1)+plot_pt_2(1)*fy_x(2);
    plot_pt_2(3)=fz_x(1)+plot_pt_2(1)*fz_x(2);
    
    %Plot line to indicate heart axis
    hold on, line([plot_pt_1(1);plot_pt_2(1)],[plot_pt_1(2);plot_pt_2(2)],[plot_pt_1(3);plot_pt_2(3)],'Color','r','LineWidth',2)
    legend('Heart','RV','LV','Base','Heart axis (through septum)')
    
    %% Calculate RV lateral point
    pmid=(p1+p2)/2;
%     hold on, scatter3(pmid(1),pmid(2),pmid(3),'filled','g')

    normal=cross(p1-p2a,p1-p2b);

    if norm(normal-mean(geom.vertices(geom.verticesRVInd,:)))>norm(normal-mean(geom.vertices(geom.verticesLVInd,:)))
        normal=-normal;
    end

     max_range = max([max(geom.vertices(:,1))-min(geom.vertices(:,1)) max(geom.vertices(:,2))-min(geom.vertices(:,2)) max(geom.vertices(:,3))-min(geom.vertices(:,3))]); 
   
    scaling=max_range/norm(normal);
    normal_scaled=pmid+normal*scaling;
    p3=normal_scaled;
    
    delete(b)
    hold on, line([pmid(1) normal_scaled(1)],[pmid(2) normal_scaled(2)],[pmid(3) normal_scaled(3)],'Color','g','Linewidth',3)
    legend('Heart','RV','LV','Base','Heart axis (through septum)','Line through right lateral side')
    
    numsteps=1e3;
    
%     vert_t=geom.vertices-mean(geom.vertices);
%     p2_t=p2-mean(geom.vertices);
%     p3_t=p3-mean(geom.vertices);
    
    dist_p2=nan(numsteps,size(geom.vertices,1));
    
    
   
    if ~isfield(geom,'contains_base') || geom.contains_base==1
        p2_s=nan(numsteps,3);
        for i=1:numsteps
            p2_s(i,:)=(p2-pmid)*(5*(i/numsteps));
            dist_p2(i,:)=sqrt((geom.vertices(:,1)-(pmid(1)+p2_s(i,1))).^2+(geom.vertices(:,2)-(pmid(2)+p2_s(i,2))).^2+(geom.vertices(:,3)-(pmid(3)+p2_s(i,3))).^2);
        end
        [~,col_p2]=find(dist_p2==min(min(dist_p2)));
        p2=geom.vertices(col_p2,:);
    end
    
    dist_p3=nan(numsteps,size(geom.vertices,1));
    p3_s=nan(numsteps,3);
    for i=1:numsteps
        p3_s(i,:)=(p3-pmid)*(5*(i/numsteps));
        dist_p3(i,:)=sqrt((geom.vertices(:,1)-(pmid(1)+p3_s(i,1))).^2+(geom.vertices(:,2)-(pmid(2)+p3_s(i,2))).^2+(geom.vertices(:,3)-(pmid(3)+p3_s(i,3))).^2);
    end
    [~,col_p3]=find(dist_p3==min(min(dist_p3)));
    p3=geom.vertices(col_p3,:);

    %% Finally: Rotation! Make the axis completely vertical (along the z-axis), through the origin.
    
    % First translate all points of the heart so that the axis crosses 0
    vert_t=geom.vertices-p1;
    p1_r=[0 0 0];
    
    % Determine angle of heart-axis with z axis (so xy-plane) and rotate
    angle_xyplane=.5*pi-atan(fy_x(2));
    rm_z=[cos(angle_xyplane) -sin(angle_xyplane) 0; sin(angle_xyplane) cos(angle_xyplane) 0; 0 0 1];
    vert_t_r_z=rm_z*(vert_t'); p1_r=rm_z*p1_r'; p2_r=rm_z*(p2'-p1'); p2a_r=rm_z*(p2a'-p1'); p2b_r=rm_z*(p2b'-p1'); p3_r=rm_z*(p3'-p1');
    
    figure, subplot(1,4,1)
    if isfield(geom,'faces')
        trisurf(geom.faces,vert_t_r_z(1,:),vert_t_r_z(2,:),vert_t_r_z(3,:))
    else
        scatter3(vert_t_r_z(1,:),vert_t_r_z(2,:),vert_t_r_z(3,:),10,vert_t_r_z(3,:),'filled'); axis equal; %just to visualize something
        colormap('jet')
    end
        
        
    axis equal
    xlabel('x'),ylabel('y'), zlabel('z')
    hold on,scatter3(p1_r(1),p1_r(2),p1_r(3),50,'filled','r')
    hold on,scatter3(p2_r(1),p2_r(2),p2_r(3),50,'filled','b')
    hold on,scatter3(p3_r(1),p3_r(2),p3_r(3),50,'filled','g')
    
    % Determine angle of heart-axis with x axis (so yz-plane) and rotate
    fz_y(2)=p2_r(3)/p2_r(2); fz_y(1)=0;
    angle_yzplane=1.5*pi-atan(fz_y(2));
    rm_x=[1 0 0;0 cos(angle_yzplane) -sin(angle_yzplane); 0 sin(angle_yzplane) cos(angle_yzplane)];
    vert_t_r_xz=rm_x*vert_t_r_z; 
    p1_r=rm_x*p1_r; p2_r=rm_x*p2_r; p2a_r=rm_x*p2a_r; p2b_r=rm_x*p2b_r; p3_r=rm_x*p3_r; 
    
    subplot(1,4,2), 
    
    if isfield(geom,'faces')
        trisurf(geom.faces,vert_t_r_xz(1,:),vert_t_r_xz(2,:),vert_t_r_xz(3,:))
    else
        scatter3(vert_t_r_xz(1,:),vert_t_r_xz(2,:),vert_t_r_xz(3,:),10,vert_t_r_xz(3,:),'filled'); axis equal; %just to visualize something
        colormap('jet')
    end

    axis equal
    xlabel('x'),ylabel('y'), zlabel('z')
    hold on,scatter3(p1_r(1),p1_r(2),p1_r(3),50,'filled','r')
    hold on,scatter3(p2_r(1),p2_r(2),p2_r(3),50,'filled','b')
    hold on,scatter3(p3_r(1),p3_r(2),p3_r(3),50,'filled','g')
    
    % Determine angle of heart-axis with y axis (so xz-plane) and rotate
    fz_x(2)=p2_r(3)/p2_r(1); fz_x(1)=0;
    angle_xzplane=1.5*pi-atan(fz_x(2));
    rm_y=[cos(angle_xzplane) 0 sin(angle_xzplane); 0 1 0; -sin(angle_xzplane) 0 cos(angle_xzplane)];
    vert_t_r_xyz=rm_y*vert_t_r_xz; p1_r=rm_y*p1_r; p2_r=rm_y*p2_r; p2a_r=rm_y*p2a_r; p2b_r=rm_y*p2b_r; p3_r=rm_y*p3_r;
    
    subplot(1,4,3)
    if isfield(geom,'faces')
        trisurf(geom.faces,vert_t_r_xyz(1,:),vert_t_r_xyz(2,:),vert_t_r_xyz(3,:))
    else
        scatter3(vert_t_r_xyz(1,:),vert_t_r_xyz(2,:),vert_t_r_xyz(3,:),10,vert_t_r_xyz(3,:),'filled'); axis equal; %just to visualize something
        colormap('jet')
    end
    axis equal
    xlabel('x'),ylabel('y'), zlabel('z')
    hold on,scatter3(p1_r(1),p1_r(2),p1_r(3),50,'filled','r')
    hold on,scatter3(p2_r(1),p2_r(2),p2_r(3),50,'filled','b')
    hold on,scatter3(p3_r(1),p3_r(2),p3_r(3),50,'filled','g')
    
    % Lastly, rotate around z-axis (so in xy-plane) once more to get LV
    % lateral to the right side
    fy_x2(2)=p3_r(2)/p3_r(1); fy_x2(1)=0; %
    angle_xyplane2=1.5*pi-atan(fy_x2(2));
    rm_z=[cos(angle_xyplane2) -sin(angle_xyplane2) 0; sin(angle_xyplane2) cos(angle_xyplane2) 0; 0 0 1];
    vert_t_r_xyz2=rm_z*vert_t_r_xyz; p1_r=rm_z*p1_r; p2_r=rm_z*p2_r; p2a_r=rm_z*p2a_r; p2b_r=rm_z*p2b_r; p3_r=rm_z*p3_r;
    
    subplot(1,4,4)
    if isfield(geom,'faces')
        trisurf(geom.faces,vert_t_r_xyz2(1,:),vert_t_r_xyz2(2,:),vert_t_r_xyz2(3,:))
    else
        scatter3(vert_t_r_xyz2(1,:),vert_t_r_xyz2(2,:),vert_t_r_xyz2(3,:),10,vert_t_r_xyz2(3,:),'filled'); axis equal; %just to visualize something
        colormap('jet')
    end
        
    axis equal
    xlabel('x'),ylabel('y'), zlabel('z')
    hold on,scatter3(p1_r(1),p1_r(2),p1_r(3),50,'filled','r')
    hold on,scatter3(p2_r(1),p2_r(2),p2_r(3),50,'filled','b')
    hold on,scatter3(p3_r(1),p3_r(2),p3_r(3),50,'filled','g')
    
%     if p2_r(3)<p1_r(3)
%         fz_y(2)=p2_r(3)/p2_r(2); fz_y(1)=0;
%         angle_yzplane=1.5*pi-atan(fz_y(2));
%         rm_x=[1 0 0;0 cos(angle_yzplane) -sin(angle_yzplane); 0 sin(angle_yzplane) cos(angle_yzplane)];
%         vert_t_r_xyz2=rm_x*vert_t_r_xyz2;
%         p1_r=rm_x*p1_r; p2_r=rm_x*p2_r; p2a_r=rm_x*p2a_r; p2b_r=rm_x*p2b_r; p3_r=rm_x*p3_r;
%         
%         figure, subplot(1,2,1), trisurf(geom.faces,vert_t_r_xyz2(1,:),vert_t_r_xyz2(2,:),vert_t_r_xyz2(3,:))
%         axis equal
%         xlabel('x'),ylabel('y'), zlabel('z')
%         hold on,scatter3(p1_r(1),p1_r(2),p1_r(3),50,'filled','r')
%         hold on,scatter3(p2_r(1),p2_r(2),p2_r(3),50,'filled','b')
%         hold on,scatter3(p3_r(1),p3_r(2),p3_r(3),50,'filled','g')
%     end
    
    if mean(vert_t_r_xyz2(3,:))<0
        fz_y(2)=p2_r(3)/p2_r(2); fz_y(1)=0;
        angle_yzplane=1.5*pi-atan(fz_y(2));
        rm_x=[1 0 0;0 cos(angle_yzplane) -sin(angle_yzplane); 0 sin(angle_yzplane) cos(angle_yzplane)];
        vert_t_r_xyz2=rm_x*vert_t_r_xyz2;
        p1_r=rm_x*p1_r; p2_r=rm_x*p2_r; p2a_r=rm_x*p2a_r; p2b_r=rm_x*p2b_r; p3_r=rm_x*p3_r;
        
        subplot(1,2,2)
        
        if isfield(geom,'faces')
            trisurf(geom.faces,vert_t_r_xyz2(1,:),vert_t_r_xyz2(2,:),vert_t_r_xyz2(3,:))
        else
            scatter3(vert_t_r_xyz2(1,:),vert_t_r_xyz2(2,:),vert_t_r_xyz2(3,:),10,vert_t_r_xyz2(3,:),'filled'); axis equal; %just to visualize something
            colormap('jet')
        end
        
        axis equal
        xlabel('x'),ylabel('y'), zlabel('z')
        hold on,scatter3(p1_r(1),p1_r(2),p1_r(3),50,'filled','r')
        hold on,scatter3(p2_r(1),p2_r(2),p2_r(3),50,'filled','b')
        hold on,scatter3(p3_r(1),p3_r(2),p3_r(3),50,'filled','g')
    end
    
    
    vert_t_r_xyz2=vert_t_r_xyz2';
    
    [lowest_z,ind_low_z]=min(vert_t_r_xyz2(:,3));
%     vert_t_r_xyz2(:,3)=vert_t_r_xyz2(:,3)-lowest_z;
     p2_r(3)=p2_r(3)-lowest_z; p2a_r(3)=p2a_r(3)-lowest_z; p2b_r(3)=p2b_r(3)-lowest_z; p3_r(3)=p3_r(3)-lowest_z; 
     apex=vert_t_r_xyz2(ind_low_z,:);
    
    figure    
    if isfield(geom,'faces')
        trisurf(geom.faces,vert_t_r_xyz2(:,1),vert_t_r_xyz2(:,2),vert_t_r_xyz2(:,3))
    else
        scatter3(vert_t_r_xyz2(:,1),vert_t_r_xyz2(:,2),vert_t_r_xyz2(:,3),10,vert_t_r_xyz2(:,3),'filled'); axis equal; %just to visualize something
        colormap('jet')
    end
    
    hold on
    xlabel('x'),ylabel('y'),zlabel('z');
    title('Translated and rotated geometry')
    plot3(0,0,-lowest_z,'or','MarkerFaceColor','k','MarkerSize',10), hold on
    plot3(p2_r(1),p2_r(2),p2_r(3),'or','MarkerFaceColor','b','MarkerSize',10)
    plot3(p3_r(1),p3_r(2),p3_r(3),'or','MarkerFaceColor','g','MarkerSize',10)
    plot3(apex(1),apex(2),apex(3),'ok','MarkerFaceColor','y','MarkerSize',10)
    legend('Surface','Apical point of septum','Basal point of septum','Right lateral side','Apex')
    axis equal
    
    % Save to geom
    geom.axis_points.original = [p1; p2; p2a; p2b; p3;geom.vertices(ind_low_z,:)];
    geom.axis_points.translated_rotated = [0 0 0; p2_r'; p2a_r'; p2b_r'; p3_r'; apex];
    geom.axis_points.names{1}='Apical clicked point';
    geom.axis_points.names{2}='Point between 3 and 4 (calculated)';
    geom.axis_points.names{3}='First basal clicked point';
    geom.axis_points.names{4}='Second basal clicked point';
    geom.axis_points.names{5}='Right lateral point (calculated)';
    geom.axis_points.names{6}='Apex (calculated)';
    geom.axis_formula= [fy_x;fz_y;fz_x;fy_x2 ];
    geom.vertices_transrot=vert_t_r_xyz2;
    
    if exist('saveFile','var')
        if ~isempty(saveFile)
%             geom.axis_points.original = [p1; p2];
%             geom.axis_points.translated_rotated = [0 0 0; p2_r'];
%             geom.axis_formula= [fy_x;fz_x];
%             geom.vertices_transrot=vert_t_r_xz;
            save(saveFile,'geom');
        end
    end
end

end
