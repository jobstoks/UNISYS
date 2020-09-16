function [geom,Vq,hearts_exp]=UNISYS_Main(geom,beats,fieldnames_input,fieldnames_disp,reference,dev_opts)
% UNISYS main script, which plots UNISYS visualization of data that are
% entered. Job Stoks, Maastricht University, 2020. Contact:
% j.stoks@maastrichtuniversity.nl
%
% Inputs:
% geom: struct containing heart geometry. Should contain at least 1 field: vertices (n*3 matrix).
%       Other, optional fields of geom:
%           - faces (m*3 matrix). Contains information on which nodes are
%           connected to each other. Recommended for visualization, but not mandatory.
%           - verticesBasalIndFakeSide: array of vertices at the basal side of
%           the ventricles, which should be ignored.
%           - vertices_transrot: if the original vertices were already
%           rotated to an upright position, you don't need to do this again
%           - contains_base: enter 0 if the geometry does not contain any
%           basal nodes. If it does contain basal nodes, 
% beats: struct with k indices (beats(1), beats(2), etc) and some fields
%       (e.g. beats(1).actTime, beats(1).repTime). Some of these fields will
%       be visualized by UNISYS.
% fieldnames_input: cell-array of length L containing strings of the fieldnames in the
%       beats-struct to be visualized by UNISYS, e.g. {'actTime','repTime'}
% fieldnames_disp: cell-array of length L containing strings of the titles of the
%       plots, corresponding to fieldnames_input (e.g. {'Activation time (ms)', 'Recovery time (ms)'}
% reference: array of length k, or single value, containing a common reference
%       for the results in the beats-struct that should be displayed by UNISYS.
%       An example would be the first moment of depolarization, or body-surface Q.
% dev_opts: Optional struct containing many possible visualization options. Fields:
%       - Vq: Cell of length k (number of beats). If you have a pre-detmermined
%       or pre-calculated grid that should be visualized by UNISYS, it can
%       be entered here. This overrules the values in the beats-struct, and
%       will lead to a reverse transformation from UNISYS to the
%       corresponding heart (instead of the other way around).
%       - plot: set to 0 if you don't want to plot any data, but only get
%       the output (like Vq)
%       - filefolder_basalnodes (string): if basal nodes were previously defined already, 
%       this optional field should contain the path to the basalnodes-file (.csv).
%       Don't forget to also include filename_basalnodes.
%       - filename_basalnodes (string): if basal nodes were previously defined already, 
%       this optional field should contain the filename of the
%       basalnodes-file (.csv).
%       - clrmap: Struct containing the following optional fields with
%               visualization options and save options:
%               - numplotsperrow: number of UNISYS plots per row (so columns)
%               that should be visualized per figure.
%               - numrows: number of rows that should be shown per figure.
%               - steps: integer containing the width of bins in the
%               colormap, e.g. 10ms.
%               - map: type of colormap that should be used. String, e.g. 'hot' or 'cool'. If set to 'custom',
%                        see map_act_spec.
%               - map_spec: m-by-3 matrix containing color codes for which a custom color
%                        map is made. E.g. [1 1 1; 0 0 0; 1 0 0] will produce a color map with a gradient
%                        from white to black to red.
%               - flipud: should the color map be flipped upside down? If yes, set to 1.
%               - lims: k-by-2 matrix with k being the number of beats in the beats-struct.
%               Each row contains the minimum and maximum value to display for each beat.
%               - identical: only works if lims is not manually set. If set
%               to 1, all beats will have the same color limits.
%               - symmetrical: only works if lims is not manually set. If
%               set to 1, colormaps will be made symmetrical (so the start and
%               the end of the colormap will have the same color).
%               - isolines: boolean for isolines between different colors
%               on/off. Only works for hearts.
%               - alpha: boolean for visible edges ('put a net over the
%               heart'). Only works for heart, not for bullseye.
%               - save: struct inside dev_opts containing multiple save options:
%                   - savefile: if set to 1, files should be saved.
%                   - fig: save matlab .fig? If yes, set to 1.
%                   - png: save .png? If yes, set to 1.
%                   - savename: set filename for figure/png to save.
%                   If only a filename is specified but no full path,
%                   results will be saved to current folder.
%
%
%
% Optional outputs:
% geom: struct containing all new fields, such as
%       verticesBasalIndFakeSide and vertices_transrot. Contains all information
%       about translation and rotation of original vertices, left vs. right
%       and the basal nodes.
% Vq: Cell of length L (which is the number of fieldnames). Each of the cells
%       within (i.e. cell{1}, cell{2}, etc.) contains a new cell of length k
%       (number of beats). Each of those cells contain the 36000-by-1 array
%       where the UNISYS-projected color values are stored. In this way,
%       different subjects can be compared to each other.
% hearts_exp: same format as Vq. However, this output will contain the
%       exported hearts from UNISYS. Especially useful when dev_opts.Vq was
%       used as an input (see above), for reverse transformation.


% If reference is a single value, turn it into an array
if size(reference,1)==1 && size(reference,2)==1
    reference=repmat(reference,[length(beats) 1]);
end

% default numplotsperrow=3
if ~exist('dev_opts','var') || ~isfield(dev_opts,'numplotsperrow')
    dev_opts.numplotsperrow=1;
end

% %Remove values positioned at basal nodes
if isfield(geom,'contains_base')
contains_base=geom.contains_base;
else
contains_base=1;
end

if contains_base
    if ~isfield(geom,'verticesBasalIndFakeSide') || ~isfield(geom,'verticesBasalIndToKeepSide')
        if exist('dev_opts','var') && isfield(dev_opts,'filefolder_basalnodes') && isfield(dev_opts,'filename_basalnodes')
            geom=Bullseye_define_base(dev_opts.filename_basalnodes,dev_opts.filefolder_basalnodes,geom,1);
        else
            geom=Bullseye_define_base(geom);
        end
        if iscell(fieldnames_input)
            fieldname_local=fieldnames_input{:};
        else
            fieldname_local=fieldnames_input;
        end
        for lp_beat=1:length(beats)
            beats(lp_beat).(fieldname_local)(geom.verticesBasalIndFakeSide)=nan;
        end
    end
elseif contains_base==0
    geom.verticesBasalIndFakeSide=[];
    geom.verticesBasalIndToKeepSide=1:size(geom.vertices,1);
end

% Transform geometry to be perfectly upright, with apex on top
if ~isfield(geom,'vertices_transrot')
    geom=make_axis(geom);
end

% Save some coordinates of interest. The nearest vertex from the original
% heart will be used saved for each coordinate of interest.
coord_interest.vert_ind=[];
for i=1:size(geom.axis_points.original,1)
    diff=nan(size(geom.vertices_transrot,1),1);
    diff=sum(geom.vertices-geom.axis_points.original(i,:),2);
    [~, coord]=min(abs(diff));
    coord_interest.cartesian(i,:)=geom.vertices_transrot(coord,:);
    coord_interest.vert_ind=[coord_interest.vert_ind; coord];
    if isfield(geom.axis_points,'names')
        coord_interest.names=geom.axis_points.names;
    end
end

for beatnr=1:length(beats)
    if iscell(fieldnames_input)
        len_fieldnames_input=length(fieldnames_input);
    else
        len_fieldnames_input=1;
    end
    
    for j=1:len_fieldnames_input
        basalnodes_todelete=geom.verticesBasalIndFakeSide;
        if iscell(fieldnames_input)
            fieldname_local=fieldnames_input{j};
        else
            fieldname_local=fieldnames_input;
        end
        if ~isempty(beats(beatnr).(fieldname_local))
            vals_heart{beatnr,j}=beats(beatnr).(fieldname_local)-reference(beatnr);
            
            % Define grid to plot bullseye-results on
            [XY_grid_dense,segment_labels_bullseye]=define_XY_grid_dense(360,100,1);
            load('cmap_uyen');
        end
    end
    
    % Arrange all values to make bullseye plot
    for j=1:size(vals_heart,2)
        % Bullseye cannot take NaNs, so these values are deleted
        % Delete values which are NaNs
        vals{beatnr,j}=vals_heart{beatnr,j};
        vals{beatnr,j}(basalnodes_todelete)=[];
        othernodes_todelete{beatnr,j}=find(isnan(vals{beatnr,j})==1);
        vals{beatnr,j}(othernodes_todelete{beatnr,j})=[];
        vals_heart{beatnr,j}(basalnodes_todelete)=nan;
        
        % Delete vertices associated with NaN-values
        cart_coord{beatnr,j}=geom.vertices_transrot;
        cart_coord{beatnr,j}(basalnodes_todelete,:)=[];
        cart_coord{beatnr,j}(othernodes_todelete{beatnr,j},:)=[];
        cart_coord{beatnr,j}=[cart_coord{beatnr,j}; coord_interest.cartesian];
        
        % Transform carthesian coordinates to ellipsoid coordinates
        [theta{beatnr,j}, rho{beatnr,j}, z1{beatnr,j}] = cart2pol(cart_coord{beatnr,j}(:,1), cart_coord{beatnr,j}(:,2), cart_coord{beatnr,j}(:,3));
        
        % Transform theta (angle in polar plot) to the right angle (RV
        % on left side)
        theta{beatnr,j}=-theta{beatnr,j};
        theta{beatnr,j}=theta{beatnr,j}+.5*pi;
        ind=find(theta{beatnr,j}>pi);
        theta{beatnr,j}(ind)=-pi+(theta{beatnr,j}(ind)-pi);
        
        % Normalize height of the cone (z1) to be approx. 1 everywhere. In
        % the end, higher z1 will be base, and lower z1 will be apex.
        % Normalization is done through a moving average filter for each angle.
        winlength=50;
        if mod(winlength,2)==1
            winlength=winlength+1;
        end
        
        
        dist_to_origin{beatnr,j}=sqrt(z1{beatnr,j}.^2+rho{beatnr,j}.^2);
        
        % First sort values based on theta (angle)
        [theta_sorted,sorted_ind]=sortrows(theta{beatnr,j});
        z1_sorted=z1{beatnr,j}(sorted_ind);
        rho_sorted=rho{beatnr,j}(sorted_ind);
        dist_to_origin_sorted=dist_to_origin{beatnr,j}(sorted_ind);
        
        % Now concatenate first and last values, to make the moving
        % average work at the start and end of the circle
        theta_sorted=[theta_sorted(end-winlength+1:end); theta_sorted; theta_sorted(1:winlength)];
        z1_sorted=[z1_sorted(end-winlength+1:end); z1_sorted; z1_sorted(1:winlength)];
        rho_sorted=[rho_sorted(end-winlength+1:end); rho_sorted; rho_sorted(1:winlength)];
        dist_to_origin_sorted=[dist_to_origin_sorted(end-winlength+1:end); dist_to_origin_sorted; dist_to_origin_sorted(1:winlength)];
        
        % Define to what height normalization should take place
        rho_sorted_to_norm=ones(length(rho_sorted),1);
        z1_sorted_to_norm=ones(length(z1_sorted),1);
        dist_to_origin_sorted_to_norm=ones(length(dist_to_origin_sorted),1);
        
        k=winlength/2+1;
        for i=winlength/2+1:length(z1_sorted)-winlength/2
            z1_sorted_to_norm(k)=max(abs(z1_sorted(i-winlength/2:i+winlength/2)));
            rho_sorted_to_norm(k)=max(abs(rho_sorted(i-winlength/2:i+winlength/2)));
            dist_to_origin_sorted_to_norm(k)=max(abs(dist_to_origin_sorted(i-winlength/2:i+winlength/2)));
            k=k+1;
        end
        
        % Perform the normalization
        z1_sorted_to_norm(winlength+1:end-winlength)=movmean(z1_sorted_to_norm(winlength+1:end-winlength),winlength/2);
        rho_sorted_to_norm(winlength+1:end-winlength)=movmean(rho_sorted_to_norm(winlength+1:end-winlength),winlength/2);
        dist_to_origin_sorted_to_norm(winlength+1:end-winlength)=movmean(dist_to_origin_sorted_to_norm(winlength+1:end-winlength),winlength/2);
        
        z1_sorted_norm=z1_sorted./z1_sorted_to_norm;
        rho_sorted_norm=rho_sorted./rho_sorted_to_norm;
        dist_to_origin_sorted_norm=dist_to_origin_sorted./dist_to_origin_sorted_to_norm;
        
        z1_sorted_norm=z1_sorted_norm(winlength+1:end-winlength);
        rho_sorted_norm=rho_sorted_norm(winlength+1:end-winlength);
        dist_to_origin_sorted_norm=dist_to_origin_sorted_norm(winlength+1:end-winlength);
        
        z1_norm{beatnr,j}=nan(size(z1_sorted_norm));
        rho_norm{beatnr,j}=nan(size(rho_sorted_norm));
        dist_to_origin_norm{beatnr,j}=nan(size(dist_to_origin_sorted_norm));
        for i=1:length(z1{beatnr,j})
            z1_norm{beatnr,j}(sorted_ind(i))=z1_sorted_norm(i);
            rho_norm{beatnr,j}(sorted_ind(i))=rho_sorted_norm(i);
            dist_to_origin_norm{beatnr,j}(sorted_ind(i))=dist_to_origin_sorted_norm(i);
        end
        
        len_coord_interest=size(coord_interest.cartesian,1);
        coord_interest.polar(:,3)=z1_norm{beatnr,j}(end-len_coord_interest+1:end);
        coord_interest.polar(:,2)=rho_norm{beatnr,j}(end-len_coord_interest+1:end);
        coord_interest.polar(:,1)=theta{beatnr,j}(end-len_coord_interest+1:end);
        z1_norm{beatnr,j}=z1_norm{beatnr,j}(1:end-len_coord_interest);
        rho_norm{beatnr,j}=rho_norm{beatnr,j}(1:end-len_coord_interest);
        theta{beatnr,j}=theta{beatnr,j}(1:end-len_coord_interest);
        dist_to_origin_norm{beatnr,j}=dist_to_origin_norm{beatnr,j}(1:end-len_coord_interest);
        
        % Correct dimensions? If not: transpose
        if size(z1_norm{beatnr,j},2)>size(z1_norm{beatnr,j},1)
            z1_norm{beatnr,j}=z1_norm{beatnr,j}';
        end
        if size(rho_norm{beatnr,j},2)>size(rho_norm{beatnr,j},1)
            rho_norm{beatnr,j}=rho_norm{beatnr,j}';
        end
        if size(dist_to_origin_norm{beatnr,j},2)>size(dist_to_origin_norm{beatnr,j},1)
            rho_norm{beatnr,j}=rho_norm{beatnr,j}';
        end
        
        if size(z1_norm{beatnr,j},2)==size(z1_norm{beatnr,j},1)
            warning('Something went wrong in converting coordinates from z1_norm...')
        end
        if size(rho_norm{beatnr,j},2)==size(rho_norm{beatnr,j},1)
            warning('Something went wrong in converting coordinates from rho_norm...')
        end
        if size(dist_to_origin_norm{beatnr,j},2)==size(dist_to_origin_norm{beatnr,j},1)
            warning('Something went wrong in converting coordinates from dist_to_origin_norm...')
        end
        
        % Project values from cone onto 2D x,y circular plot. Only x and y will be used for bullseye plot, but z can be used for cone visualization
        z1_norm{beatnr,j}=abs(z1_norm{beatnr,j});
        [x{beatnr,j},y{beatnr,j},z{beatnr,j}] = pol2cart(theta{beatnr,j},dist_to_origin_norm{beatnr,j},dist_to_origin_norm{beatnr,j});
        
        if size(basalnodes_todelete,1)>size(basalnodes_todelete,2)
            basalnodes_todelete=basalnodes_todelete';
        end
        if size(othernodes_todelete{beatnr,j},1)>size(othernodes_todelete{beatnr,j},2)
            othernodes_todelete{beatnr,j}=othernodes_todelete{beatnr,j}';
        end
        
        nodes_todelete=[double(basalnodes_todelete)'; othernodes_todelete{beatnr,j}'];
        
        for i=1:size(coord_interest.vert_ind,1)
            num_nodestodelete=sum(nodes_todelete<coord_interest.vert_ind(i));
            coord_interest.vert_ind_forcone=coord_interest.vert_ind-num_nodestodelete;
        end
        
        [coord_interest.cart_norm(:,1), coord_interest.cart_norm(:,2), coord_interest.cart_norm(:,3)]=pol2cart(coord_interest.polar(:,1),coord_interest.polar(:,2),coord_interest.polar(:,2));
        
        % Normalize from 0..1
        X{beatnr,j} = x{beatnr,j}/max(abs(x{beatnr,j}));
        Y{beatnr,j} = y{beatnr,j}/max(abs(y{beatnr,j}));
        
    end
end


% Plot results
for j=1:size(vals,2)
    clear bullseye hearts
    for beatnr=1:length(beats)
        all_vals=[];
        
        % Define what to plot
        bullseye(beatnr).X=X{beatnr,j};
        bullseye(beatnr).Y=Y{beatnr,j};
        bullseye(beatnr).grid=XY_grid_dense;
        bullseye(beatnr).vals=vals{beatnr,j};
        
        % Titles
        if iscell(fieldnames_disp)
            bullseye(beatnr).title=[fieldnames_disp{j} ' Beat ' num2str(beatnr) ' Bullseye'];
            hearts(beatnr).title=[fieldnames_disp{j} ' Beat ' num2str(beatnr) ' Heart'];
        else
            bullseye(beatnr).title=[fieldnames_disp ' Beat ' num2str(beatnr) ' Bullseye'];
            hearts(beatnr).title=[fieldnames_disp ' Beat ' num2str(beatnr) ' Heart'];
        end
        
        hearts(beatnr).vals=vals_heart{beatnr,j};
        hearts(beatnr).geom=geom;
        
        all_vals=[all_vals;bullseye(beatnr).vals];
        
    end
    
    %Plot
    
    %     dev_opts.Vq=plot_BullsEye_And_Hearts(bullseye,hearts,dev_opts.numplotsperrow,dev_opts);
    %         bullseye(beatnr).coord_of_interest=coord_interest;
    %         dev_opts.Vq=segment_labels_bullseye;
    [Vq{j},hearts_exp{j}]=plot_BullsEye_And_Hearts(bullseye,hearts,dev_opts.numplotsperrow,dev_opts);
end
if exist('dev_opts','var') 
    if isfield(dev_opts,'plot') && dev_opts.plot==0
        close all
    end
end
end


