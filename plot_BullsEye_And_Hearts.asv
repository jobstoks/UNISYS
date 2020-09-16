function [Vq_exp,hearts]=plot_BullsEye_And_Hearts(bullseye,hearts,numplotsperrow,dev_opts)
% UNISYS plotting script. Job Stoks and Uyen C. Nguyen, Maastricht University, 2020.
% Contact: j.stoks@maastrichtuniversity.nl
% This script is called from UNISYS_Main.m.
%
% Inputs:
%    bullseye: struct with k indices (bullseye(1), bullseye(2), etc)
%    containing the following fields for each index:
%       - X: Array of length N (=number of vertices in original heart, excluding basal nodes and NaNs)
%           containing x-coordinates of input values in UNISYS representation
%       - Y: Array of length N (=number of vertices in original heart, excluding basal nodes and NaNs)
%           containing y-coordinates of input values in UNISYS representation
%       - grid: M-by-2 matrix containing X- and Y-values of the UNISYS grid that values should be projected on.
%       - vals: Array of length N (=number of vertices in original heart, excluding basal nodes and NaNs)
%           containing values that should be color-coded through UNISYS.
%       - title: String, containing the title of the bullseye plot.
%    hearts: struct with k indices (hearts(1), hearts(2), etc) containing
%       the following fields for each index:
%       - vals: Array of length K (=number of vertices in original heart)
%           containing values that should be color-coded through UNISYS.
%       - geom: Heart geometry. See UNISYS_main.
%       - title: String, containing the title of the bullseye plot.
%    numplotsperrow: number of UNISYS bullseyes to be displayed in each row.
% dev_opts: Optional struct containing many possible visualization options. Fields:
%       - Vq: Cell of length k (number of beats). If you have a pre-detmermined
%       or pre-calculated grid that should be visualized by UNISYS, it can
%       be entered here. This overrules the values in the beats-struct, and
%       will lead to a reverse transformation from UNISYS to the
%       corresponding heart (instead of the other way around).
%       - plot: set to 0 if you don't want to plot any data, but only get
%       the output (like Vq)
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
% Outputs:
% Vq_exp: Cell of length k (number of beats). Each of those cells contain
%       the 36000-by-1 array where the UNISYS-projected color values are stored.
%       In this way, different subjects can be compared to each other.
% hearts same format as Vq. However, this output will contain the
%       exported hearts from UNISYS. Especially useful when dev_opts.Vq was
%       used as an input (see above), for reverse transformation.
%



default_symmetrical=0;
alvals=[];
for i=1:length(bullseye)
    alvals=[alvals; bullseye(i).vals];
end
default_steps=(max(alvals)-min(alvals))/25;
default_map='durrermap';
default_isolines=0;
default_alpha=0;
default_flipud=0;
default_map_spec=[];
default_title_Bullseye='Bullseye';
default_title_Hearts='Heart';
default_savefile=0;
default_numrows=3;
default_plot=1;

%If Vq (the values on the grid) are defined as an input: work from
%grid, and translate back to the heart.
if exist('dev_opts','var') && isfield(dev_opts,'Vq')
    
    %If Vq is not a cell: turn it into a cell array with length of beats
    Vq_all=dev_opts.Vq;
    if ~iscell(Vq_all)
        Vq_all=repmat({Vq_all},[length(bullseye) 1]);
    end
    
    %Distance from original points to grid points
    distance=nan(length(bullseye(1).X),size(bullseye(1).grid,1));
    for i=1:length(bullseye(1).X)
        distance(i,:)=sqrt((bullseye(1).X(i)-bullseye(1).grid(:,1)).^2+(bullseye(1).Y(i)-bullseye(1).grid(:,2)).^2);
    end
    [~,ind]=min(distance,[],2);
    
    for beatnr=1:length(bullseye)
        %Pick nearest value from grid to project on heart vertices
        bullseye(beatnr).vals=Vq_all{beatnr}(ind);
        hearts(beatnr).vals(hearts(beatnr).geom.verticesBasalIndToKeepSide)=Vq_all{beatnr}(ind);
    end
end

allvals_separated=cell(max([length(hearts) length(bullseye)]),1);
allvals=[];
for i=1:length(bullseye)
    if size(bullseye(i).vals,2)>size(bullseye(i).vals,1)
        bullseye(i).vals=bullseye(i).vals';
    end
    allvals=[allvals; bullseye(i).vals];
    allvals_separated{i}=bullseye(i).vals;
end
for i=1:length(hearts)
    if size(hearts(i).vals,2)>size(hearts(i).vals,1)
        hearts(i).vals=hearts(i).vals';
    end
    allvals=[allvals; hearts(i).vals];
    allvals_separated{i}=[allvals_separated{i};hearts(i).vals];
end
default_lims_unidentical_nonsymmetrical=nan(max([length(hearts) length(bullseye)]),2);
default_lims_unidentical_symmetrical=default_lims_unidentical_nonsymmetrical;
for i=1:length(allvals_separated)
    default_lims_unidentical_nonsymmetrical(i,1)=min(allvals_separated{i});
    default_lims_unidentical_nonsymmetrical(i,2)=max(allvals_separated{i});
    default_lims_unidentical_symmetrical(i,2)=max(abs([min(allvals_separated{i}) max(allvals_separated{i})]));
end
default_lims_unidentical_symmetrical(:,1)=-default_lims_unidentical_symmetrical(:,2);
default_lims_identical_nonsymmetrical=repmat([min(allvals) max(allvals)],[max([length(hearts) length(bullseye)]) 1]);
maxabs=max(abs([min(allvals) max(allvals)]));
default_lims_identical_symmetrical=repmat([-maxabs maxabs],[max([length(hearts) length(bullseye)]) 1]);


%Read dev_opts input field for possible visualization options
if nargin==4 && exist('dev_opts','var')
    if isfield(dev_opts,'plot')
        doPlot=dev_opts.plot;
    else
        doPlot=default_plot;
    end
    if isfield(dev_opts,'clrmap')
        if isfield(dev_opts.clrmap,'steps')
            steps=dev_opts.clrmap.steps;
        else
            steps=default_steps;
        end
        if isfield(dev_opts.clrmap,'map')
            map=dev_opts.clrmap.map;
            if strcmp(map,'custom') && isfield(dev_opts.clrmap,'map_spec')
                map_spec=dev_opts.clrmap.map_spec;
            else
                map_spec=default_map_spec;
            end
        else
            map=default_map;
            map_spec=default_map_spec;
        end
        if isfield(dev_opts.clrmap,'isolines') && dev_opts.clrmap.isolines==1
            isolines=1;
        else
            isolines=default_isolines;
        end
        if isfield(dev_opts.clrmap,'alpha')
            alpha=dev_opts.clrmap.alpha;
        else
            alpha=default_alpha;
        end
        if isfield(dev_opts.clrmap,'symmetrical')
            symmetrical=dev_opts.clrmap.symmetrical;
        else
            symmetrical=default_symmetrical;
        end
        if isfield(dev_opts.clrmap,'lims')
            lims=dev_opts.clrmap.lims;
            if size(lims,1)==2 && size(lims,2)~=2
                lims=lims';
            end
            maxlength=max([length(hearts) length(bullseye)]);
            if size(lims,1)~=maxlength
                lims=repmat(lims(1,:),[maxlength 1]);
            end
        elseif isfield(dev_opts.clrmap,'identical')
            if dev_opts.clrmap.identical && ~symmetrical
                lims=default_lims_identical_nonsymmetrical;
            elseif dev_opts.clrmap.identical && symmetrical
                lims=default_lims_identical_symmetrical;
            elseif ~dev_opts.clrmap.identical && symmetrical
                lims=default_lims_unidentical_symmetrical;
            elseif ~dev_opts.clrmap.identical && ~symmetrical
                lims=default_lims_unidentical_nonsymmetrical;
            end
        else
            lims=default_lims_unidentical_nonsymmetrical;
        end
        if isfield(dev_opts.clrmap,'flipud')
            if dev_opts.clrmap.flipud==1
                flipud_var=1;
            else
                flipud_var=default_flipud;
            end
        else
            flipud_var=default_flipud;
        end
        if isfield(dev_opts,'save')
            if isfield(dev_opts.save,'savefile')
                if dev_opts.save.savefile==1
                    savefile=1;
                    if isfield(dev_opts.save,'savename')
                        savename=dev_opts.save.savename;
                    else
                        warning('No savename was specified, even though the files should be saved. Files will be stored in current folder under name ''Bullseye_Results''.');
                        savename='Bullseye_Results';
                    end
                    if isfield(dev_opts.save,'png')
                        if dev_opts.save.png==1
                            savepng=1;
                        elseif dev_opts.save.png==0
                            savepng=0;
                        end
                    end
                    if isfield(dev_opts.save,'fig')
                        if dev_opts.save.fig==1
                            save_fig=1;
                        elseif dev_opts.save.fig==0
                            save_fig=0;
                        end
                    end
                elseif dev_opts.save.savefile==0
                    savefile=0;
                end
            else
                savefile=0;
            end
        else
            savefile=0;
        end
    else
        symmetrical=default_symmetrical;
        steps=default_steps;
        map=default_map;
        isolines=default_isolines;
        alpha=default_alpha;
        lims=default_lims_unidentical_nonsymmetrical;
        flipud_var=default_flipud;
        map_spec=default_map_spec;
        savefile=default_savefile;
    end
    if isfield(dev_opts,'numrows')
        numrows=dev_opts.numrows;
    else
        numrows=default_numrows;
    end
    if isfield(dev_opts,'referenceObj')
        referenceObj=dev_opts.referenceObj;
    else
        referenceObj=[];
    end
    
else
    symmetrical=default_symmetrical;
    steps=default_steps;
    map=default_map;
    isolines=default_isolines;
    alpha=default_alpha;
    lims=default_lims_unidentical_nonsymmetrical;
    flipud_var=default_flipud;
    map_spec=default_map_spec;
    savefile=default_savefile;
    doPlot=default_plot;
end

if ~exist('numplotsperrow','var')
    numplotsperrow=2;
end

maxlength=max([length(bullseye) length(hearts)]);
% numrows=ceil(maxlength/numplotsperrow);
numplotsperrow=numplotsperrow*2;

if doPlot
figure
end

set(gcf,'color','w');
id_plot=1;
loop=0;
for numplot=1:maxlength
    
    if numplot<=length(bullseye)
        if doPlot
            subtightplot(numrows,numplotsperrow,id_plot)
        end
        %If Vq (the values on the grid) are defined as an input: work from
        %grid, and translate back to the heart.
        if exist('Vq_all','var')
            Vq=Vq_all{numplot};
        else
            Vq = griddata(bullseye(numplot).X,...
                bullseye(numplot).Y,...
                bullseye(numplot).vals,...
                bullseye(numplot).grid(:,1),...
                bullseye(numplot).grid(:,2),...
                'natural');
        end
        Vq_exp{numplot}=Vq;
        
        if doPlot
            % making triangles connecting vertices
            tri = delaunay(bullseye(numplot).grid(:,1),bullseye(numplot).grid(:,2));
            p = patch('Faces',tri,'Vertices',bullseye(numplot).grid);
            box off; axis equal; axis off
            set(p,'FaceColor','Interp','FaceVertexCData',Vq);
            set(p,'EdgeColor','none');
            
            
            clrbar_vals= set_clrs(numplot,lims,flipud_var,steps,map,map_spec,symmetrical);
            if isolines==1
                isocell{1}=bullseye(numplot).grid(:,1);
                isocell{2}=bullseye(numplot).grid(:,2);
                isocell{3}=zeros(size(bullseye(numplot).grid,1),1);
                
                %             for lp_isolines=1:length(clrbar_vals)
                %                 IsoLine(isocell,Vq,[clrbar_vals(lp_isolines) clrbar_vals(lp_isolines)],[.2 .2 .2],.1);
                %             end
            end
            
            hold on
            R=1; %radius
            S=3;   % 'slice' nr
            N=8;   % segment nr (rows)
            sect_width = 2*pi/N;
            offset_angle= 0:sect_width:2*pi-sect_width;
            r = linspace(0,R,S+1);
            w = 0:.01:2*pi;
            % Circle lines
            for n=2:length(r)
                plot(real(r(n)*exp(j*w)),imag(r(n)*exp(j*w)),'k-');
            end
            % Perpendicular straight lines
            for n=1:length(offset_angle)
                plot(real([0 R]*exp(j*offset_angle(n))),imag([0 R]*exp(j*offset_angle(n))),'k-');
            end
            
            if isfield(bullseye(end),'coord_of_interest') && isfield(bullseye(end).coord_of_interest,'cart_norm') && ~isempty(bullseye(end).coord_of_interest.cart_norm) 
                plot([bullseye(end).coord_of_interest.cart_norm(1,1) bullseye(end).coord_of_interest.cart_norm(3,1)],[bullseye(end).coord_of_interest.cart_norm(1,2) bullseye(end).coord_of_interest.cart_norm(3,2)],'k--','LineWidth',3)
                plot([bullseye(end).coord_of_interest.cart_norm(1,1) bullseye(end).coord_of_interest.cart_norm(4,1)],[bullseye(end).coord_of_interest.cart_norm(1,2) bullseye(end).coord_of_interest.cart_norm(4,2)],'k--','LineWidth',3)
                %             scatter(bullseye(end).coord_of_interest.cart_norm(6,1),bullseye(end).coord_of_interest.cart_norm(6,2),50,'filled','k')
                
                dist_to_side=1-(bullseye(end).coord_of_interest.cart_norm(6,1).^2+bullseye(end).coord_of_interest.cart_norm(6,2).^2);                               
            end
            
            if numplot<=length(hearts)
                if min(hearts(numplot).vals(~isnan(hearts(numplot).vals)))~=min(bullseye(numplot).vals(~isnan(bullseye(numplot).vals))) || max(hearts(numplot).vals(~isnan(hearts(numplot).vals)))~=max(bullseye(numplot).vals(~isnan(bullseye(numplot).vals)))
                    warning('The corresponding heart has a different color value range!')
                end
            end
            
            if isfield(bullseye(numplot),'title')
                title(bullseye(numplot).title)
            else
                title(default_title_Bullseye)
            end
        end
        id_plot=id_plot+1;
    end
    
    if numplot<=length(hearts)
        if doPlot
            subtightplot(numrows,numplotsperrow,id_plot);
        end
        if isfield(hearts,'faces')
            faces_val=nan(size(hearts(numplot).geom.faces,1),1);
            for i=1:length(faces_val)
                faces_val(i)=mode([hearts(numplot).vals(hearts(numplot).geom.faces(i,1)) hearts(numplot).vals(hearts(numplot).geom.faces(i,2)) hearts(numplot).vals(hearts(numplot).geom.faces(i,3))]);
            end
            hearts(numplot).faces_vals=faces_val;
        end
        if doPlot
            if isfield(hearts,'faces')
                trisurf(hearts(numplot).geom.faces,hearts(numplot).geom.vertices(:,1),hearts(numplot).geom.vertices(:,2),hearts(numplot).geom.vertices(:,3),hearts(numplot).faces_vals,'EdgeAlpha',alpha,'EdgeColor',[.4 .4 .4],'FaceColor','flat');
            else
                scatter3(hearts(numplot).geom.vertices(:,1),hearts(numplot).geom.vertices(:,2),hearts(numplot).geom.vertices(:,3),10,hearts(numplot).vals,'filled')
            end
            
            
            box off; axis equal;  axis off
            %         colormap(clrmap);
            %         colorbar('eastoutside');
            %         if isfield(hearts(numplot),'clr_lims')
            %             caxis(hearts(numplot).clr_lims);
            %         else
            %             caxis([min(hearts(numplot).vals) max(hearts(numplot).vals)])
            %         end
            clrbar_vals= set_clrs(numplot,lims,flipud_var,steps,map,map_spec,symmetrical);
            
            if isfield(bullseye(end),'coord_of_interest') && isfield(bullseye(end).coord_of_interest,'cartesian') && ~isempty(bullseye(end).coord_of_interest.cartesian)
                %             for i=[1 3 4 6]
                %                 hold on, scatter3(hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(i),1),hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(i),2),hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(i),3),200,'filled','k')
                %             end
                
                %             plot3([hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(1),1) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(3),1) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(4),1) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(1),1)],...
                %                 [hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(1),2) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(3),2) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(4),2) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(1),2)],...
                %                 [hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(1),3) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(3),3) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(4),3) hearts(end).geom.vertices(bullseye(end).coord_of_interest.vert_ind(1),3)],'LineWidth',3,'Color','k')
            end
            
            if isolines==1 && isfield(hearts,'faces')
                clear isocell
                isocell{1}=hearts(numplot).geom.faces;
                isocell{2}=hearts(numplot).geom.vertices;
                
                for lp_isolines=1:length(clrbar_vals)
                    IsoLine(isocell,hearts(numplot).vals,[clrbar_vals(lp_isolines) clrbar_vals(lp_isolines)],[.2 .2 .2],.1);
                end
            end
            
            if isfield(hearts(numplot),'title')
                title(hearts(numplot).title)
            else
                title(default_title_Heart)
            end
            id_plot=id_plot+1;
        end
    end
    
    if id_plot>numrows*numplotsperrow
        if doPlot
            loop=loop+1;
            if savefile
                if save_fig
                    savename_local=strcat(savename,'_',num2str(loop));
                    if iscell(savename_local)
                        savename_local=savename_local{:};
                    end
                    savefig(savename_local);
                end
                if savepng
                    savename_local=strcat(savename,'_',num2str(loop),'.png');
                    if iscell(savename_local)
                        savename_local=savename_local{:};
                    end
                    saveas(gcf,savename_local)
                end
            end
            
            if numplot<length(bullseye)
                figure
                id_plot=1;
            end
        end
    end
end

end

%% functions used in this script
function clrbar_vals= set_clrs(numplot,lims,flipud_var,steps,map,map_spec,symmetrical)
%Define colormap and how to display it exactly
maxval_disp=ceil(max(lims(numplot,:))/steps)*steps;
minval_disp=floor(min(lims(numplot,:))/steps)*steps;
range=maxval_disp-minval_disp;
arraylength_req= round(range/steps)+1;
stepsize_req= range/(arraylength_req-1);
if ~strcmp(map,'custom')
    if ~symmetrical
        clrmap=eval(strcat(map,'(arraylength_req)'));
    elseif symmetrical
        clrmap=eval(strcat('[',map,'(arraylength_req);flipud(',map,'(arraylength_req))]'));
    end
else
    
    clrarray=map_spec;
    stepsize_old=range/(size(clrarray,1)-1);
    
    if stepsize_req~=stepsize_old
        for lp_clr=1:3
            clrmap(:,lp_clr)=interp1q((minval_disp:stepsize_old:maxval_disp)',clrarray(:,lp_clr),(minval_disp:stepsize_req:maxval_disp)');
        end
    else
        clrmap=clrarray;
    end
end
if flipud_var==1
    clrmap=flipud(clrmap);
end
if symmetrical
    clrmap=[clrmap;flipud(clrmap)];
end

set(gca,'CLim',[minval_disp maxval_disp]);
colormap(gca,clrmap);
clrbar{numplot}=colorbar('eastoutside');
caxis([minval_disp maxval_disp])

set(clrbar{numplot},'YLim',[minval_disp maxval_disp]);
clrbar_vals= minval_disp:steps:maxval_disp;
if length(clrbar_vals)>5
    if range<6
        stepsize_here=range/5;
        clrbar_vals_disp=round(minval_disp:stepsize_here:maxval_disp,3);
    else
        stepsize_here=range/5;
        clrbar_vals_disp=round(minval_disp:stepsize_here:maxval_disp);
    end
else
    clrbar_vals_disp=clrbar_vals;
end

set(clrbar{numplot},'YTick',clrbar_vals_disp);
end
