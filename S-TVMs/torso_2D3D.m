function torso_2D3D(mypath,beat_nr,ind_time,inds_ref,interpolate,varargin)
GeomBeats = load(mypath); 
geom=GeomBeats.GeomBeats.geom; beats=GeomBeats.GeomBeats.beats;

bodyPots = beats(beat_nr).bodyPots;
minPots=0; maxPots=255;
bodyPots = (maxPots-minPots)/(max(max(bodyPots))-min(min(bodyPots))) * (bodyPots-min(min(bodyPots))) + minPots;
alpha = varargin{1}; beta = varargin{2}; delta = varargin{3};

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Step 2: find the opening electrode (on the torso back, in the middle area)
%%
inds=inds_ref([1,4]);
vertices0=geom.Body.vertices-mean(geom.Body.vertices);
if ~isnan(inds_ref(2))
    vertices0=rotate_xyz1(vertices0,inds_ref);
end

[Faces, t0,z0,~] = findOpeningTrodeSaveFaces(vertices0, geom.Body.faces, inds, alpha, beta);
% if some electrodes are deleted
if numel(unique(Faces(:))) < size(vertices0,1)
    map2=[(1:numel(unique(Faces(:))))',unique(Faces(:))];
    F_l = Faces;
    for i=1:3
        [~,iloc]=ismember(F_l(:,i),unique(Faces(:)));
        F_l(:,i)=map2(iloc,1);
    end
    vertices = vertices0(unique(Faces(:)),:); bodyPots=bodyPots(unique(Faces(:)),:);
    t = t0(unique(Faces(:))); z = z0(unique(Faces(:)));
    Faces = F_l;
else
    map2=[(1:numel(unique(Faces(:))))',unique(Faces(:))];
    t=t0; z=z0; vertices=vertices0;
end

% figure; hold on;
% trimesh(geom.Body.faces,geom.Body.vertices(:,1),geom.Body.vertices(:,2),geom.Body.vertices(:,3),'EdgeColor','k','EdgeAlpha',1,'FaceColor','white','FaceAlpha',1); hold on
% scatter3(geom.Body.vertices(inds_ref(~isnan(inds_ref)),1),geom.Body.vertices(inds_ref(~isnan(inds_ref)),2),geom.Body.vertices(inds_ref(~isnan(inds_ref)),3),80,'filled','mo'); hold on
% axis equal; axis off; hold off;view(-180,10)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Step 3: find the boundary vertices (in counterclockwise direction), let the lower right corner vertex be the first
%% find the boundary
Faces(isnan(Faces(:,1)),:)=[];
map = []; map(:,1) = 1:size(sort(unique(Faces(:))),1); map(:,2) = sort(unique(Faces(:)))'; 
[~, Faces] = newIndex(map, vertices, Faces);
t = t(map(:,2)); z=z(map(:,2));
vertices = vertices(map(:,2),:);

[~,ind_max] = max(t); 
[~,lines_nr_unique,lines_boun_order,~]=boundaryOrder(Faces,ind_max,[t,z]);

figure;
trimesh(geom.Body.faces,vertices0(:,1),vertices0(:,2),vertices0(:,3),'EdgeColor','none','EdgeAlpha',1,'FaceColor',[.8 .8 .8],'FaceAlpha',1); hold on
trimesh(Faces,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor','k','EdgeAlpha',1,'FaceColor','white','FaceAlpha',1); hold on
axis equal; axis off; hold off;

% determine the right vertices and lines
bv=0.1; 
ind_boun_r = t(lines_boun_order(:,1))>0.5-bv;
matches = arrayfun(@(i) numel(intersect(lines_boun_order(i, :), lines_boun_order(ind_boun_r, 1))) == 2, 1:size(lines_boun_order, 1));
lines_boun_r = lines_boun_order(matches, :);
if ~all(lines_boun_r(2:end,1) == lines_boun_r(1:end-1,2))
    [~,ia] = setdiff(lines_boun_r(:,1), lines_boun_r(:,2));
    lines_boun_r = [lines_boun_r(ia:end,:);lines_boun_r(1:ia-1,:)];
else
    if z(lines_boun_r(1,1)) > z(lines_boun_r(2,1))
        lines_boun_r=flip(flip(lines_boun_r,2),1);
    end
end
vertices_boun_r = [lines_boun_r(:,1);lines_boun_r(end,2)];
% generate the angles with x-axis
vectors_r = [t(vertices_boun_r(2:end))-t(vertices_boun_r(1:end-1)), z(vertices_boun_r(2:end))-z(vertices_boun_r(1:end-1))];
theta_r=nan(size(vectors_r,1),1);
for i=1:size(vectors_r,1)
    theta_r(i) = abs(rad2deg(acos(dot(vectors_r(i,:), [1,0])/ norm(vectors_r(i,:)))));
end
inds_bigger_r = find(theta_r>delta & theta_r<100); ind_RB = vertices_boun_r(inds_bigger_r(1)); ind_RU = vertices_boun_r(inds_bigger_r(end)+1); 

% determine the left vertices and lines
ind_boun_l = t(lines_boun_order(:,1))<-(0.5-bv);
matches = arrayfun(@(i) numel(intersect(lines_boun_order(i, :), lines_boun_order(ind_boun_l, 1))) == 2, 1:size(lines_boun_order, 1));
lines_boun_l = lines_boun_order(matches, :);
if ~all(lines_boun_l(2:end) == lines_boun_l(1:end-1))
    [~,ia] = setdiff(lines_boun_l(:,1), lines_boun_l(:,2));
    lines_boun_l = [lines_boun_l(ia:end,:);lines_boun_l(1:ia-1,:)];
else
    if z(lines_boun_l(1,1)) < z(lines_boun_l(2,1))
        lines_boun_l=flip(flip(lines_boun_l,2),1);
    end
end
vertices_boun_l = [lines_boun_l(:,1);lines_boun_l(end,2)];
% generate the angles with x-axis
vectors_l = [t(vertices_boun_l(2:end))-t(vertices_boun_l(1:end-1)), z(vertices_boun_l(2:end))-z(vertices_boun_l(1:end-1))];
theta_l=nan(size(vectors_l,1),1);
for i=1:size(vectors_l,1)
    theta_l(i) = abs(rad2deg(acos(dot(vectors_l(i,:), [-1,0])/ norm(vectors_l(i,:)))));
end
inds_bigger_l = find(theta_l>delta & theta_l<100); ind_LU = vertices_boun_l(inds_bigger_l(1)); ind_LB = vertices_boun_l(inds_bigger_l(end)+1); 

% select the four corner vertices (based on the angle to the X-axis)
ind = find(lines_boun_order(:,1)==ind_RB);
lines_boun_order = [lines_boun_order(ind:end,:);lines_boun_order(1:ind-1,:)];

% let ind_RB be the first in lines_boun_order
ind = find(lines_boun_order(:,1)==ind_RB);
lines_boun_order = [lines_boun_order(ind:end,:);lines_boun_order(1:ind-1,:)];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Step 4: using TEM to generate the square plot
%% uniform Laplace weights
% assign the boundary vertices
xy=[t,z]*2; xyz=vertices;
xy(ind_RB,:)=[1,-1]; xy(ind_RU,:)=[1,1]; xy(ind_LU,:)=[-1,1]; xy(ind_LB,:)=[-1,-1];
xy=newB(xy,xyz,lines_boun_order(1:find(lines_boun_order(:,1)==ind_RU),1),'y','+',1);
xy=newB(xy,xyz,lines_boun_order(find(lines_boun_order(:,1)==ind_RU):find(lines_boun_order(:,1)==ind_LU),1),'x','-',1);
xy=newB(xy,xyz,lines_boun_order(find(lines_boun_order(:,1)==ind_LU):find(lines_boun_order(:,1)==ind_LB),1),'y','-',-1);
xy=newB(xy,xyz,lines_boun_order(find(lines_boun_order(:,1)==ind_LB):end,1),'x','+',-1);
% compute the inner vertices
[xys2, ~] = TEM(lines_nr_unique, lines_boun_order, Faces, vertices, xy, 'median');
xys = [t,z]*2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Step 5: thin plate spline interpolation
%% interpolation
inds_nan = find(isnan(bodyPots(:, 1))); inds_used=setdiff(1:size(bodyPots,1), inds_nan);
indss=setdiff(1:size(xyz,1),inds_used);
bodyPots_interpolated = bodyPots;
if strcmp(interpolate,'tps3D')
    % TPS interpolation
    vm3D=TPS3D([xyz(inds_used,1),xyz(inds_used,2),xyz(inds_used,3)]',bodyPots(inds_used,ind_time)',xyz(:,1),xyz(:,2),xyz(:,3),0);
    bodyPots_interpolated(:,ind_time)=vm3D;
else
    if strcmp(interpolate,'kriging')
        knownLocations = [xyz(inds_used,1),xyz(inds_used,2),xyz(inds_used,3)];
        unknownLocations = [xyz(indss,1),xyz(indss,2),xyz(indss,3)];
        w = krigingWeights(knownLocations,unknownLocations);
        InterpSignal = krigingInterpolation(w,knownLocations,unknownLocations,bodyPots(inds_used,ind_time));
        bodyPots_interpolated(indss,ind_time) =InterpSignal;
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Step 6: convert to 3D (from the square-format)
azi = xys2(:,1); 

P1=vertices(inds_ref(1),:); P2=vertices(inds_ref(4),:);
xy1 = P1(1:2); xy2 = P2(1:2);
theta1 = atan2(xy1(2), xy1(1)); theta2 = atan2(xy2(2), xy2(1));
k = abs(theta1 - theta2);
% k=0.2;

inds = find(xys2(:,1)<=0.5); azi(inds) = (xys2(inds,1)+1.5)*pi - k/3*(2*xys2(inds,1)-1);
inds = find(xys2(:,1)>=0.5 & xys2(:,1)<=1); azi(inds) = (xys2(inds,1)-0.5)*pi-2*(xys2(inds,1)-0.5)*k;
% n is used to control the wide/narrow of the torso
xlength = max(vertices(:,1)) - min(vertices(:,1)); ylength = max(vertices(:,2)) - min(vertices(:,2));
n = ylength/xlength; % n=0.65; 
a = sqrt(2/(n^2+1));
x_elli = azi; y_elli = azi; z_elli = xys2(:,2);
inds = find(azi<=pi/2 | azi>=3*pi/2); x_elli(inds) = n*a./sqrt(n^2+tan(azi(inds)).^2);
inds = find(azi<=3*pi/2 & azi>=pi/2); x_elli(inds) = -n*a./sqrt(n^2+tan(azi(inds)).^2);
inds = find(azi<=pi & azi>=0); y_elli(inds) = abs(x_elli(inds).*tan(azi(inds)));
inds = find(azi<=2*pi & azi>=pi); y_elli(inds) = -abs(x_elli(inds).*tan(azi(inds)));
xyz_elli2 = [x_elli, y_elli, 1.5*z_elli];

Fs = [];
for i=1:size(geom.Body.faces,1)
    f = geom.Body.faces(i,:); [~,~,ib] = intersect(f, map2(:,2));
    if numel(ib)==3
        n = cross(xyz_elli2(map2(ib(1),1),:)-xyz_elli2(map2(ib(2),1),:), xyz_elli2(map2(ib(1),1),:)-xyz_elli2(map2(ib(3),1),:));
        dot_product = dot(n, [0, 0, 1]); theta = acos(abs(dot_product / norm(n))); theta_deg = rad2deg(theta);
        if size(intersect(f, vertices_boun_l),1)+size(intersect(f, vertices_boun_r),1) ==3 && theta_deg>20
            Fs = [Fs;f];
        end
    end
end
Fs = [Fs;Faces];

inds_upper = find(xyz_elli2(:,3)==1.5); inds_below = find(xyz_elli2(:,3)==-1.5); inds_boun = [vertices_boun_l;vertices_boun_r];


%%
fig1 = figure;
% subplot(2,3,1)
trimesh(geom.Body.faces,vertices0(:,1),vertices0(:,2),vertices0(:,3),'EdgeColor','none','EdgeAlpha',1,'FaceColor',[.8 .8 .8],'FaceAlpha',1); hold on
trimesh(Fs,vertices(:,1),vertices(:,2),vertices(:,3),'EdgeColor','k','EdgeAlpha',1,'FaceColor','white','FaceAlpha',1); hold on
scatter3(vertices(lines_boun_order(:,1),1),vertices(lines_boun_order(:,1),2),vertices(lines_boun_order(:,1),3),80,'filled','mo'); hold on
scatter3(vertices(ind_RB,1),vertices(ind_RB,2),vertices(ind_RB,3),200,'filled','o','MarkerFaceColor',[.1 .1 .1]); hold on
scatter3(vertices(ind_RU,1),vertices(ind_RU,2),vertices(ind_RU,3),200,'filled','o','MarkerFaceColor',[.3 .3 .3]); hold on
scatter3(vertices(ind_LU,1),vertices(ind_LU,2),vertices(ind_LU,3),200,'filled','o','MarkerFaceColor',[.8 .8 .8]); hold on
scatter3(vertices(ind_LB,1),vertices(ind_LB,2),vertices(ind_LB,3),200,'filled','o','MarkerFaceColor',[.7 .7 .7]); hold on
axis equal; axis off; hold off;

fig2 = figure;
% subplot(2,3,2)
trimesh(Faces,xys2(:,1),xys2(:,2),zeros(size(z)),'EdgeColor','k','EdgeAlpha',0.5,'FaceColor','white','FaceAlpha',1); hold on
scatter(xys2(lines_boun_order(:,1),1),xys2(lines_boun_order(:,1),2),150,'filled','mo'); hold on
scatter(xys2(ind_RB,1),xys2(ind_RB,2),200,'filled','o','MarkerFaceColor',[.1 .1 .1]); hold on
scatter(xys2(ind_RU,1),xys2(ind_RU,2),200,'filled','o','MarkerFaceColor',[.3 .3 .3]); hold on
scatter(xys2(ind_LU,1),xys2(ind_LU,2),200,'filled','o','MarkerFaceColor',[.8 .8 .8]); hold on
scatter(xys2(ind_LB,1),xys2(ind_LB,2),200,'filled','o','MarkerFaceColor',[.7 .7 .7]); hold on
view(0,90); axis equal; axis off; hold off;

fig3 = figure;
% subplot(2,3,3)
trisurf(Fs, xyz_elli2(:,1), xyz_elli2(:,2), xyz_elli2(:,3), 'FaceColor','w', 'FaceAlpha',1,'EdgeAlpha',1); hold on
scatter3(xyz_elli2(lines_boun_order(:,1),1),xyz_elli2(lines_boun_order(:,1),2),xyz_elli2(lines_boun_order(:,1),3), 100, 'filled','mo')
trisurf(delaunay(xyz_elli2(inds_upper,1),xyz_elli2(inds_upper,2)),xyz_elli2(inds_upper,1),xyz_elli2(inds_upper,2),xyz_elli2(inds_upper,3),'FaceColor',[.8 .8 .8], 'EdgeAlpha',0); hold on
trisurf(delaunay(xyz_elli2(inds_below,1),xyz_elli2(inds_below,2)),xyz_elli2(inds_below,1),xyz_elli2(inds_below,2),xyz_elli2(inds_below,3),'FaceColor',[.8 .8 .8], 'EdgeAlpha',0); hold on
axis equal; axis off; hold off;

fig4 = figure;
% subplot(2,3,4)
trimesh(Faces,t,z,zeros(size(z)),'EdgeColor',[.1 .1 .1],'EdgeAlpha',1,'FaceColor','white','FaceAlpha',1,'LineWidth',0.1); hold on
scatter(t(lines_boun_order(:,1)),z(lines_boun_order(:,1)),80,'filled','mo'); hold on
scatter(t(ind_RB),z(ind_RB),150,'filled','o','MarkerFaceColor',[.1 .1 .1]); hold on
scatter(t(ind_RU),z(ind_RU),150,'filled','o','MarkerFaceColor',[.3 .3 .3]); hold on
scatter(t(ind_LU),z(ind_LU),150,'filled','o','MarkerFaceColor',[.5 .5 .5]); hold on
scatter(t(ind_LB),z(ind_LB),150,'filled','o','MarkerFaceColor',[.7 .7 .7]); hold on
% set(gca, 'FontSize', 25, 'FontWeight', 'bold');
view(0,90); axis equal; axis on; hold off; grid off;
xlim([-0.5, 0.5]); ylim([-0.5, 0.5]); 
% trisurf(geom.Body.faces, vertices0(:,1), vertices0(:,2), vertices0(:,3), 'FaceColor',[.8 .8 .8], 'FaceAlpha',1,'EdgeAlpha',0); hold on
% trisurf(Fs, vertices(:,1), vertices(:,2), vertices(:,3), bodyPots_interpolated(:,ind_time),'FaceColor','interp', 'FaceAlpha',1,'EdgeAlpha',0); hold on
% colormap(jet); clim([minPots, maxPots])
% axis equal; axis off; hold off;

fig5 = figure;
% subplot(2,3,5)
trisurf(Faces,xys2(:,1),xys2(:,2),zeros(size(z)), bodyPots_interpolated(:,ind_time), 'FaceAlpha',1,'EdgeAlpha',0,'FaceColor','interp'); hold on
colormap(jet); clim([minPots, maxPots])
view(0,90); axis equal; axis off; hold off;
xlabel('x'); ylabel('y'); zlabel('z');

fig6 = figure;
% subplot(2,3,6)
trisurf(geom.Body.faces, xyz_elli2(:,1), xyz_elli2(:,2), xyz_elli2(:,3), 'FaceColor',[.8 .8 .8], 'FaceAlpha',1,'EdgeAlpha',0); hold on
trisurf(Fs, xyz_elli2(:,1), xyz_elli2(:,2), xyz_elli2(:,3), bodyPots_interpolated(:,ind_time),'FaceColor','interp', 'FaceAlpha',1,'EdgeAlpha',0); hold on
trisurf(delaunay(xyz_elli2(inds_upper,1),xyz_elli2(inds_upper,2)),xyz_elli2(inds_upper,1),xyz_elli2(inds_upper,2),xyz_elli2(inds_upper,3),'FaceColor',[.8 .8 .8], 'EdgeAlpha',0); hold on
trisurf(delaunay(xyz_elli2(inds_below,1),xyz_elli2(inds_below,2)),xyz_elli2(inds_below,1),xyz_elli2(inds_below,2),xyz_elli2(inds_below,3),'FaceColor',[.8 .8 .8], 'EdgeAlpha',0); hold on
colormap(jet); clim([minPots, maxPots])
axis equal; axis off; hold off;


body2D.vertices = xys2; body2D.faces = Faces;  %body.cornersInd = [ind_RB, ind_RU, ind_LU, ind_LB];
body3D.vertices = xyz_elli2; body3D.faces = Fs; 


% save images and mat file
timestamp = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
timestamp_str = strrep(string(timestamp), ' ', '_');  
timestamp_str = strrep(timestamp_str, ':', '-');    

parentDir = fileparts(mypath);    
figsFolder = fullfile(parentDir, 'results');  
if ~exist(figsFolder, 'dir')  
    mkdir(figsFolder);        
end

saveas(fig1, fullfile(figsFolder, strcat('torso3D_ori_',timestamp_str,'.png')));
saveas(fig2, fullfile(figsFolder, strcat('torso2D_',timestamp_str,'.png')));
saveas(fig3, fullfile(figsFolder, strcat('torso3D_uni_',timestamp_str,'.png')));
saveas(fig4, fullfile(figsFolder, strcat('torso3D_oriPots_',timestamp_str,'.png')));
saveas(fig5, fullfile(figsFolder, strcat('torso2DPots_',timestamp_str,'.png')));
saveas(fig6, fullfile(figsFolder, strcat('torso3D_uniPots_',timestamp_str,'.png')));
save(fullfile(figsFolder, 'torso2D_results.mat'), 'body2D', 'body3D','map2')

end