classdef UNISYS_GUI < handle
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure
        vis
        intAct
        data
        vars_exclude
    end
    
    methods
        
        % Create UIFigure and components
        function Create(self_UNISYS)
            
            % Create UIFigure
            self_UNISYS.UIFigure = figure;
            self_UNISYS.UIFigure.Units = 'normalized';
            self_UNISYS.UIFigure.Position = [0 0 1 1];
            self_UNISYS.UIFigure.Color = [1 1 1];
            self_UNISYS.UIFigure.Name = 'UNISYS_GUI';
            self_UNISYS.UIFigure.CloseRequestFcn=[];
            
            
            % Create Load-button
            self_UNISYS.intAct.Step1Button = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [.025 .7 0.05 0.15],...
                'CallBack', {@self_UNISYS.LoadButtonPushed,self_UNISYS},...
                'String', 'Load data',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Create Geometry-button
            self_UNISYS.intAct.Geometry = uicontrol(self_UNISYS.UIFigure, ...
                'Style','popup',...
                'Units','normalized',...
                'Position', [.1 .8 0.1 0.05],...
                'CallBack', {@self_UNISYS.GeometryButtonPushed,self_UNISYS},...
                'String', {'','geom.Heart','geom.Body','else:'},...
                'BackgroundColor','white');
            
            % Create " if else is selected"-text
            self_UNISYS.intAct.txt_Geom_disp = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[.1 .75 0.1 0.05],...
                'String','If ''else'' is selected above: enter variable here and click draw button: ',...
                'BackgroundColor',[.8 .8 .8]);
            
            % Create text field for 'else' option to display geometry
            self_UNISYS.intAct.textfield_else = uicontrol('Style','Edit',...
                'Units','Normalized',...
                'Position',[.1 .7 0.1 0.05]...
                );

            % Create "draw"-button
            self_UNISYS.intAct.DrawButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [.1 .65 0.1 0.05],...
                'CallBack', {@self_UNISYS.DrawButtonPushed,self_UNISYS},...
                'String', 'Draw',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Create "Geometry to display"-text
            self_UNISYS.intAct.txt_Geom_disp = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[.1 .85 0.1 0.05],...
                'String','Geometry to display',...
                'BackgroundColor',[.8 .8 .8]);
            
            
            % Create "No Geometry to display"-text if no geometry is
            % selected yet
            self_UNISYS.intAct.txt_No_Geom_disp = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[.2 .9 0.3 0.05],...
                'String','No geometry to display',...
                'FontSize',18,...
                'BackgroundColor','white');
            
            % Create Load-button
            self_UNISYS.intAct.Step1Button = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [.025 .7 0.05 0.15],...
                'CallBack', {@self_UNISYS.LoadButtonPushed,self_UNISYS},...
                'String', 'Load data',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Create close-button
            self_UNISYS.intAct.CloseButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [.8 .1 0.1 0.1],...
                'CallBack', @self_UNISYS.CloseButtonPushed,...
                'String', 'Close GUI');
        end
        
        % Button pushed function: Load
        function self_UNISYS=LoadButtonPushed(self_UNISYS, ~, varargin)
            [filename, savefolder] = uigetfile('*.mat','Select a file to load');
            self_UNISYS.UIFigure.Pointer='watch';
            drawnow;
            load(fullfile(savefolder,filename));
            self_UNISYS.UIFigure.Pointer='arrow';
            drawnow;
            putInSelf
        end
        
        % Button selected function: Make geometry
        function self_UNISYS=GeometryButtonPushed(self_UNISYS, ~, varargin)
            
            if ~isempty(self_UNISYS.vars_exclude)
                getFromSelf
            end
            
            try
                delete(ax_geom)
            end
            try
                if eval(['isfield(' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} ',''vertices'')']) && eval(['isfield(' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} ',''faces'')'])
                    ax_geom=axes('Units','normalized','Position',[.2 .6 0.3 0.3]);
                    eval(['trisurf(' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.faces,' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,1),' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,2),' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,3))'])
                    axis equal
                elseif eval(['isfield(' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} ',''vertices'')']) && eval(['~isfield(' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} ',''faces'')'])
                    ax_geom=axes('Units','normalized','Position',[.2 .6 0.3 0.3]);
                    eval(['scatter3(' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,1),' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,2),' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,3)),100,' varargin{1,1}.Source.String{varargin{1,1}.Source.Value} '.vertices(:,3))'])
                    axis equal
                else
                    disp()
                end
                self_UNISYS.intAct.txt_No_Geom_disp.String='Geometry';
            end
            
            putInSelf
        end
        
        % Create draw-button        
        function DrawButtonPushed(self_UNISYS, ~, varargin)
            getFromSelf
            varnames=who;
            var_todraw=self_UNISYS.intAct.textfield_else.String;
            
            %Check if text is 'else'
            if strcmp(self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value},'else:')
                
                %Check if variable exists
                varnr_todraw=find(strcmp(varnames,var_todraw));
                if varnr_todraw~=0 & ~isempty(varnr_todraw)
                    try
                        delete(ax_geom)
                    end
                    ax_geom=axes('Units','normalized','Position',[.2 .6 0.3 0.3]);
                    if isstruct(eval(var_todraw)) %If this variable is a struct
                        if isfield(eval(var_todraw),'faces') && isfield(eval(var_todraw),'vertices') %Check if 'faces' field exists together with vertices field
                            eval(['trisurf(' var_todraw '.faces,', var_todraw '.vertices(:,1),' var_todraw '.vertices(:,2),' var_todraw '.vertices(:,3))']);
                        elseif isfield(eval(var_todraw),'faces') && isfield(eval(var_todraw),'vertex') %Check if 'faces' field exists together with vertex field
                            eval(['trisurf(' var_todraw '.faces,', var_todraw '.vertex(:,1),' var_todraw '.vertex(:,2),' var_todraw '.vertex(:,3))']);
                        elseif isfield(eval(var_todraw),'faces') && isfield(eval(var_todraw),'nodes') %Check if 'faces' field exists together with nodes field
                            eval(['trisurf(' var_todraw '.faces,', var_todraw '.nodes(:,1),' var_todraw '.nodes(:,2),' var_todraw '.nodes(:,3))']);
                        elseif isfield(eval(var_todraw),'vertices') %Check if 'vertices' field exists
                            eval(['scatter3(' var_todraw '.vertices(:,1),' var_todraw '.vertices(:,2),' var_todraw '.vertices(:,3),50,' var_todraw '.vertices(:,3),''filled'')']);
                        elseif isfield(eval(var_todraw),'vertex') %Check if 'vertex' field exists
                            eval(['scatter3(' var_todraw '.vertex(:,1),' var_todraw '.vertex(:,2),' var_todraw '.vertex(:,3),50,' var_todraw '.vertex(:,3),''filled'')']);
                        elseif isfield(eval(var_todraw),'nodes') %Check if 'nodes' field exists
                            eval(['scatter3(' var_todraw '.nodes(:,1),' var_todraw '.nodes(:,2),' var_todraw '.nodes(:,3),50,' var_todraw '.nodes(:,3),''filled'')']);
                        end
                    else
                        eval(['scatter3(' var_todraw '(:,1),' var_todraw '(:,2),' var_todraw '(:,3),50,' var_todraw '(:,3),''filled'')']);
                    end
                    axis equal
                    colormap(jet)
                    self_UNISYS.intAct.DrawButton.BackgroundColor=[.3 .8 .8];
                    self_UNISYS.intAct.txt_No_Geom_disp.String='Geometry';
                else
                    % Display message saying that this variable doesn't exist
                    self_UNISYS.intAct.DrawButton.BackgroundColor=[1 0 0];
                    errordlg('That variable name does not exist','Error','non-modal')
                end
            end
            putInSelf
        end
        
        % Create Beats-button        
        function BeatsButtonPushed(self, ~, varargin)
            close force
        end
        
        % Create close-button        
        function CloseButtonPushed(self, ~, varargin)
            close force
        end
        
        function resetAll(self_UNISYS,~,~)
            clear self_UNISYS.data
        end
        
        % Construct self
        function self_UNISYS = UNISYS_GUI
            % Create and configure components
            self_UNISYS.Create();
        end
        
        % Code that executes before app deletion
        function delete(self_UNISYS)
            
            % Delete UIFigure when app is deleted
            delete(self_UNISYS.UIFigure)
        end
    end
end

