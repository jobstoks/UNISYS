function geom=Define_BasalNodes_Manual(filename_load,loadfolder,geom,doPlot)

if exist(fullfile(loadfolder,filename_load),'file')
    basalnodes=csvread(fullfile(loadfolder,filename_load),1);
    
    if round(basalnodes(:,1))~=basalnodes(:,1)
        basalnodes=[basalnodes(:,5) basalnodes(:,1:4)];
    end
    
    basalnodes(:,1)=basalnodes(:,1)+1;
    
    
    %Find basal nodes by finding the nearest neighbors of the .csv file to the nodes of the
    %whole heart
    ptCloud_basalnodes=pointCloud(basalnodes(:,2:4));
    ptCloud_orig=pointCloud(geom.vertices);
    geom.vertices_temp=geom.vertices;
    attempt_1=find(ismember(geom.vertices,basalnodes(:,2:4),'rows')==1);
    
    
    for i=1:size(basalnodes,1)
        [NN_ind(i),NN_dist(i)]=findNearestNeighbors(ptCloud_orig,[ptCloud_basalnodes.Location(i,1) ptCloud_basalnodes.Location(i,2) ptCloud_basalnodes.Location(i,3)],1,'Sort',true);
        geom.vertices_temp(NN_ind(i),:)=[-inf -inf -inf];
        ptCloud_orig=pointCloud(geom.vertices_temp);
    end
    attempt_2=NN_ind;
    
    if length(attempt_1)>length(attempt_2)
        geom.verticesBasalIndFakeSide=find(ismember(geom.vertices,basalnodes(:,2:4),'rows')==1);
        geom.verticesBasalIndToKeepSide=find(ismember(geom.vertices,basalnodes(:,2:4),'rows')==0);
    else
        geom.verticesBasalIndFakeSide=NN_ind;
        geom.verticesBasalIndToKeepSide=find(ismember(1:size(geom.vertices,1),NN_ind)==0);
    end
    
    if doPlot
        figure
        if isfield(geom,'faces')
         trisurf(geom.faces, geom.vertices(:,1), geom.vertices(:,2), geom.vertices(:,3),'FaceColor',[.63 .7 .49],'FaceAlpha',0.7);
        end
        hold on,scatter3(geom.vertices(:,1),geom.vertices(:,2),geom.vertices(:,3),'MarkerFaceColor',[0 .5 0],'MarkerEdgeColor','k');
        hold on,scatter3(geom.vertices(geom.verticesBasalIndFakeSide,1),geom.vertices(geom.verticesBasalIndFakeSide,2),geom.vertices(geom.verticesBasalIndFakeSide,3),'MarkerFaceColor','r','MarkerEdgeColor','k');
        hold on,scatter3(basalnodes(:,2),basalnodes(:,3),basalnodes(:,4))
        title(strrep(filename_load,'_','-'))
        legend('Heart','Nodes to keep','Detected basal nodes','Original basal nodes');
        % hold on,scatter3(basalnodes(:,2),basalnodes(:,3),basalnodes(:,4),'MarkerFaceColor','r','MarkerEdgeColor','k')
        axis equal
    end
else
    error('File could not be found!')
end
end
