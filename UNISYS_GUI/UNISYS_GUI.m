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
           
            self_UNISYS.intAct.textwidth=.1;
            self_UNISYS.intAct.textheight=.05;
            self_UNISYS.intAct.inputwidth=.1;
            self_UNISYS.intAct.inputheight=.05;  
            
            self_UNISYS.intAct.textbackground_light=[.95 .95 .95];
            self_UNISYS.intAct.textbackground_dark=[.2 .2 .2];
            self_UNISYS.intAct.red_color=[1 .4 .4];
            self_UNISYS.intAct.green_color=[.4 1 .4];
            self_UNISYS.intAct.blue_color=[.4 .8 1];
            self_UNISYS.intAct.orange_color=[1 .8 .4];
            
            self_UNISYS.intAct.xmargin=.05;
            if isfield(self_UNISYS.intAct,'xmargin')
                numcolumns=7;
                self_UNISYS.intAct.xgap=(1-2*self_UNISYS.intAct.xmargin-numcolumns*self_UNISYS.intAct.inputwidth)/(numcolumns-1);
                self_UNISYS.intAct.xspacing=self_UNISYS.intAct.xgap+self_UNISYS.intAct.inputwidth;
            else               
                self_UNISYS.intAct.xspacing=.125;
            end
            
            self_UNISYS.intAct.column1x=self_UNISYS.intAct.xmargin;
            self_UNISYS.intAct.column2x=self_UNISYS.intAct.column1x+self_UNISYS.intAct.xspacing;
            self_UNISYS.intAct.column3x=self_UNISYS.intAct.column1x+2*self_UNISYS.intAct.xspacing;
            self_UNISYS.intAct.column4x=self_UNISYS.intAct.column1x+3*self_UNISYS.intAct.xspacing;
            self_UNISYS.intAct.column5x=self_UNISYS.intAct.column1x+4*self_UNISYS.intAct.xspacing;
            self_UNISYS.intAct.column55x=self_UNISYS.intAct.column1x+4*self_UNISYS.intAct.xspacing+self_UNISYS.intAct.inputwidth/2;
            self_UNISYS.intAct.column6x=self_UNISYS.intAct.column1x+5*self_UNISYS.intAct.xspacing;
            self_UNISYS.intAct.column7x=self_UNISYS.intAct.column1x+6*self_UNISYS.intAct.xspacing;
            self_UNISYS.intAct.column75x=self_UNISYS.intAct.column1x+6*self_UNISYS.intAct.xspacing+self_UNISYS.intAct.inputwidth/2;
            
            self_UNISYS.intAct.ymargin=.05;
            if isfield(self_UNISYS.intAct,'ymargin')
                numrows=8;
                self_UNISYS.intAct.ygap=(1-2*self_UNISYS.intAct.ymargin-numrows*self_UNISYS.intAct.inputheight)/(numrows-1);
                self_UNISYS.intAct.yspacing=self_UNISYS.intAct.ygap+self_UNISYS.intAct.inputheight;
            else
                self_UNISYS.intAct.yspacing=.125;
            end
            
            self_UNISYS.intAct.row1y=self_UNISYS.intAct.ymargin;
            self_UNISYS.intAct.row2y=self_UNISYS.intAct.row1y+self_UNISYS.intAct.yspacing;
            self_UNISYS.intAct.row3y=self_UNISYS.intAct.row1y+2*self_UNISYS.intAct.yspacing;
            self_UNISYS.intAct.row4y=self_UNISYS.intAct.row1y+3*self_UNISYS.intAct.yspacing;
            self_UNISYS.intAct.row5y=self_UNISYS.intAct.row1y+4*self_UNISYS.intAct.yspacing;
            self_UNISYS.intAct.row6y=self_UNISYS.intAct.row1y+5*self_UNISYS.intAct.yspacing;
            self_UNISYS.intAct.row7y=self_UNISYS.intAct.row1y+6*self_UNISYS.intAct.yspacing;
            self_UNISYS.intAct.row8y=self_UNISYS.intAct.row1y+7*self_UNISYS.intAct.yspacing;          
            
            % Create Load-button
            self_UNISYS.intAct.LoadButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column1x self_UNISYS.intAct.row8y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.LoadButtonPushed,self_UNISYS},...
                'String', 'Load data',...
                'FontSize',16,...
                'BackgroundColor',[.3 .8 .8]);
            
            % Create "Geometry to display"-text
            self_UNISYS.intAct.txt_Geom_disp = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row7y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Geometry to display',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
                        
            % Create Geometry-dropdownlist
            self_UNISYS.intAct.Geometry = uicontrol(self_UNISYS.UIFigure, ...
                'Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column1x self_UNISYS.intAct.row7y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.GeometryButtonPushed,self_UNISYS},...
                'String', {'','geom.Heart','geom.Body','else:'},...
                'BackgroundColor','white');
            
            % Create "No Geometry to display"-text if no geometry is
            % selected yet
            self_UNISYS.intAct.txt_No_Geom_disp = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[.2 .9 0.3 0.05],...
                'String','No geometry to display',...
                'FontSize',18,...
                'BackgroundColor','white');
            
            
            % Create "Beats-variable to visualize"-text
            self_UNISYS.intAct.txt_beats = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Beats-variable to visualize',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create Beats-dropdownlist
            self_UNISYS.intAct.Beats = uicontrol(self_UNISYS.UIFigure, ...
                'Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column1x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.BeatsButtonPushed,self_UNISYS},...
                'String', {'','beats','else:'},...
                'BackgroundColor','white');
            
            % Create "Text to display"-text
            self_UNISYS.intAct.txt_fieldnames_disp = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row1y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Text to display',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "Fieldnames to display"-textfield for input
            self_UNISYS.intAct.input_fieldnames_disp = uicontrol('style','Edit',...
                'string','AT (ms)',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'backgroundcolor','w',...
                'Tag','EditField');
            
%             % Create "Reference"-text
%             self_UNISYS.intAct.txt_reference = uicontrol('Style','text',...
%                 'Units','normalized',...
%                 'Position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
%                 'String','Reference value',...
%                 'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
%             % Create "Reference"-bullet
%             self_UNISYS.intAct.txt_reference_bullet = uicontrol('style','text',...
%                                 'Units','normalized',...
%                                 'position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
%                                 'string',regexprep('(.*)',[char(183),' $1'])); 
                            
            % Select basalnodes
            self_UNISYS.intAct.val_reference_buttonleft = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column2x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.ReferenceButtonLeftPushed,self_UNISYS},...
                'String', 'Single reference',...
                'BackgroundColor',self_UNISYS.intAct.blue_color);
            
            % Select basalnodes
            self_UNISYS.intAct.val_reference_buttonright = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column2x+self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.ReferenceButtonRightPushed,self_UNISYS},...
                'String', 'Reference variable',...
                'BackgroundColor',self_UNISYS.intAct.red_color);           
            
            % Create "Plot"-text
            self_UNISYS.intAct.txt_plot = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row3y self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot UNISYS?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "Plot"-dropdown menu
            self_UNISYS.intAct.val_plot = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column2x self_UNISYS.intAct.row3y-self_UNISYS.intAct.inputheight self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Yes','No'},...
                'BackgroundColor','white');
            
            % Contains base val
            self_UNISYS.intAct.val_Containsbase = uicontrol(self_UNISYS.UIFigure, ...
                'Style','checkbox',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column2x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.ContainsbaseCheckbox,self_UNISYS},...
                'String', 'Contains base',...
                'BackgroundColor','white');
            
            % Select basalnodes
            self_UNISYS.intAct.BasalNodesButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column1x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight*2],...
                'CallBack', {@self_UNISYS.BasalNodesButton,self_UNISYS},...
                'String', 'Load manually defined basal nodes',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Draw red rectangle for save options
            axes('Units','normalized','Position',[self_UNISYS.intAct.column3x-self_UNISYS.intAct.xgap/2 self_UNISYS.intAct.ymargin/2 self_UNISYS.intAct.inputwidth+self_UNISYS.intAct.xgap self_UNISYS.intAct.ymargin/2+self_UNISYS.intAct.ygap/2+4*self_UNISYS.intAct.yspacing]);
            rectangle('Position', [1 1 1 1], 'FaceColor',self_UNISYS.intAct.red_color);
            axis off, box off
            
            % Draw green text for basic options
            self_UNISYS.intAct.txt_basic_options = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row5y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Required information',...
                'ForegroundColor',self_UNISYS.intAct.green_color ,...
                'FontSize',16,...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Draw red text for save options
            self_UNISYS.intAct.txt_save_options = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column3x self_UNISYS.intAct.row5y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Save options',...
                'ForegroundColor',self_UNISYS.intAct.red_color ,...
                'FontSize',16,...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Draw blue text for save options
            self_UNISYS.intAct.txt_dev_opts_options = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column4x self_UNISYS.intAct.row5y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot options',...
                'ForegroundColor',self_UNISYS.intAct.orange_color ,...
                'FontSize',16,...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Draw orange text for save options
            self_UNISYS.intAct.txt_dev_opts_blue_options = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row7y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot options',...
                'ForegroundColor',self_UNISYS.intAct.blue_color ,...
                'FontSize',16,...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Create "Save"-text
            self_UNISYS.intAct.txt_save = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column3x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Save results (.fig/.png)?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "save"-textfield for input
            self_UNISYS.intAct.val_save = uicontrol('Style','popup',...
                'Units','normalized',...
                'CallBack', {@self_UNISYS.SaveButtonPushed,self_UNISYS},...
                'Position', [self_UNISYS.intAct.column3x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Yes','No'},...
                'BackgroundColor','white');
            
            % Create "save fig"-checkbox for input
            self_UNISYS.intAct.val_savefig = uicontrol('Style','checkbox',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column3x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Save results in .fig'},...
                'BackgroundColor','white');

            % Create "save png"-checkbox for input
            self_UNISYS.intAct.val_savepng = uicontrol('Style','checkbox',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column3x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Save results in .png'},...
                'BackgroundColor','white');
            
            % Create "Savename"-text
            self_UNISYS.intAct.txt_savename = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column3x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Savename',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "savename"-textfield for input
            self_UNISYS.intAct.val_savename = uicontrol('style','Edit',...
                'string','Results_UNISYS',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column3x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'backgroundcolor','w',...
                'Tag','EditField');
            
            % Select folder to save results
            self_UNISYS.intAct.SavefolderButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column3x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.SaveFolderButtonPushed,self_UNISYS},...
                'String', 'Specify folder to save results in',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Draw blue rectangle for dev_opts plot options
            axes('Units','normalized','Position',[self_UNISYS.intAct.column6x-self_UNISYS.intAct.xgap/2 self_UNISYS.intAct.row5y-self_UNISYS.intAct.ygap/2 self_UNISYS.intAct.xspacing*2 self_UNISYS.intAct.yspacing*2+self_UNISYS.intAct.ygap]);
            rectangle('Position', [1 1 1 1], 'FaceColor',self_UNISYS.intAct.blue_color);
            axis off, box off
            
            % Draw green rectangle for basic options
            axes('Units','normalized','Position',[self_UNISYS.intAct.xmargin/2 self_UNISYS.intAct.ymargin/2 self_UNISYS.intAct.xmargin/2+self_UNISYS.intAct.xspacing-self_UNISYS.intAct.xgap/2 self_UNISYS.intAct.ymargin+self_UNISYS.intAct.yspacing*7.5]);
            rectangle('Position', [1 1 1 1], 'FaceColor',self_UNISYS.intAct.green_color);
            axis off, box off
            
            % Draw green rectangle for some plot options
            axes('Units','normalized','Position',[self_UNISYS.intAct.column2x-self_UNISYS.intAct.xgap/2 self_UNISYS.intAct.ymargin/2 self_UNISYS.intAct.xmargin/2+self_UNISYS.intAct.xspacing-self_UNISYS.intAct.xgap/2 self_UNISYS.intAct.ymargin/2+self_UNISYS.intAct.yspacing*4+self_UNISYS.intAct.ygap/2]);
            rectangle('Position', [1 1 1 1], 'FaceColor',self_UNISYS.intAct.green_color);
            axis off, box off
            
            % Create "Plot hearts?"-text
            self_UNISYS.intAct.plot_txt_heart = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row6y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot Hearts?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "Plot hearts?"-dropdown menu
            self_UNISYS.intAct.plot_val_heart = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row6y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Yes','No'},...
                'BackgroundColor','white');
            
            % Create "Plot bullseyes?"-text
            self_UNISYS.intAct.plot_txt_bullseye = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column7x self_UNISYS.intAct.row6y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot Bullseyes?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "Plot bullseyes?"-dropdown menu
            self_UNISYS.intAct.plot_val_bullseye = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column7x self_UNISYS.intAct.row6y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Yes','No'},...
                'BackgroundColor','white');
            
            % Create "Plot colorbar for hearts?"-text
            self_UNISYS.intAct.plot_txt_clrbar_heart = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row5y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot colorbar for hearts?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "Plot colorbar for hearts?"-dropdown menu
            self_UNISYS.intAct.plot_val_clrbar_heart = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row5y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Yes','No','Only for the last heart'},...
                'BackgroundColor','white');
            
            % Create "Plot colorbar for bullseyes?"-text
            self_UNISYS.intAct.plot_txt_clrbar_bullseye = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column7x self_UNISYS.intAct.row5y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Plot colorbar for bullseyes?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "Plot colorbar for bullseyes?"-dropdown menu
            self_UNISYS.intAct.plot_val_clrbar_bullseye = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column7x self_UNISYS.intAct.row5y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Yes','No','Only for the last bullseye'},...
                'BackgroundColor','white');
            
            % Draw orange rectangle for dev_opts plot options
            axes('Units','normalized','Position',[self_UNISYS.intAct.column4x-self_UNISYS.intAct.xgap/2 self_UNISYS.intAct.row2y-self_UNISYS.intAct.ygap/2 self_UNISYS.intAct.xspacing*4 self_UNISYS.intAct.yspacing*3+self_UNISYS.intAct.ygap/2]);
            rectangle('Position', [1 1 1 1], 'FaceColor',self_UNISYS.intAct.orange_color);
            axis off, box off
            
            % Create "numrows"-text
            self_UNISYS.intAct.clrmap_txt_numplotsperrow = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column4x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Number of rows to display',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "numrows"-val
            self_UNISYS.intAct.clrmap_val_numplotsperrow = uicontrol('style','Edit',...
                'string','1',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column4x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'backgroundcolor','w',...
                'Tag','EditField');
            
            % Create "numplotsperrow"-text
            self_UNISYS.intAct.clrmap_txt_numrows = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column5x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Number of columns to display',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "numplotsperrow"-val
            self_UNISYS.intAct.clrmap_val_numrows = uicontrol('style','Edit',...
                'string','1',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column5x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'backgroundcolor','w',...
                'Tag','EditField');
            
            % Create "colormap"-text
            self_UNISYS.intAct.clrmap_txt_map = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row4y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Colormap',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "colormap"-val
            self_UNISYS.intAct.clrmap_val_map = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column6x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'String', {'durrermap','custom','jet','hot','cool','bone','copper','parula','hsv','spring','summer','autumn','winter','gray','pink','lines','colorcube','prism','flag','white'},...
                'BackgroundColor','white');
            
            % Create "flipud"-text
            self_UNISYS.intAct.clrmap_txt_flipud = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column4x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Flip colormap upside down?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "flipud"-val
            self_UNISYS.intAct.clrmap_val_flipud = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column4x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'String', {'No','Yes'},...
                'BackgroundColor','white');
            
            % Create "lims"-text
            self_UNISYS.intAct.clrmap_txt_lims = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column5x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Colormap limits',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "lower"-text for lims
            self_UNISYS.intAct.clrmap_txt_lims_lower = uicontrol('Style','text',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column5x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth/2 self_UNISYS.intAct.textheight/2],...
                'String','Lower',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "higher"-text for lims
            self_UNISYS.intAct.clrmap_txt_lims_higher = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column55x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth/2 self_UNISYS.intAct.textheight/2],...
                'String','Higher',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create lower "lims"-val
            self_UNISYS.intAct.clrmap_val_lims_lower = uicontrol('style','Edit',...
                'Units','normalized',...
                'string','',...
                'Position', [self_UNISYS.intAct.column5x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'backgroundcolor','w',...
                'Tag','EditField');
            % Create higher "lims"-val
            self_UNISYS.intAct.clrmap_val_lims_higher = uicontrol('style','Edit',...
                'Units','normalized',...
                'string','',...
                'Position',[self_UNISYS.intAct.column55x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'backgroundcolor','w',...
                'Tag','EditField');
            
            % Create "identical"-text
            self_UNISYS.intAct.clrmap_txt_identical = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Identical colormaps for different hearts/bullseyes?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "identical"-val
            self_UNISYS.intAct.clrmap_val_identical = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column6x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'String', {'No','Yes'},...
                'BackgroundColor','white');
            
            % Create "symmetrical"-text
            self_UNISYS.intAct.clrmap_txt_symmetrical = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column7x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Symmetrical colormaps?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "symmetrical"-val
            self_UNISYS.intAct.clrmap_val_symmetrical = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column7x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'String', {'No','Yes'},...
                'BackgroundColor','white');
            
            % Create "isolines"-text
            self_UNISYS.intAct.clrmap_txt_isolines = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column4x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Draw isolines on heart?',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "isolines"-val
            self_UNISYS.intAct.clrmap_val_isolines = uicontrol('Style','popup',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column4x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.GeometryButtonPushed,self_UNISYS},...
                'String', {'No','Yes'},...
                'BackgroundColor','white');
            
            % Create "alpha"-text
            self_UNISYS.intAct.clrmap_txt_alpha = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column5x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Alpha value (transparency of net on heart)',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "alpha"-val
            self_UNISYS.intAct.clrmap_val_alpha = uicontrol('style','Edit',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column5x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.GeometryButtonPushed,self_UNISYS},...
                'String', {''},...
                'BackgroundColor','white');
            
            % Create "steps"-text
            self_UNISYS.intAct.clrmap_txt_steps = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column6x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Stepsize',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "steps"-val
            self_UNISYS.intAct.clrmap_val_steps = uicontrol('style','Edit',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column6x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
                'String', {''},...
                'BackgroundColor','white');
            
            % Create "custom"-text
            self_UNISYS.intAct.clrmap_txt_custom = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column7x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Custom colormap',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "click"-text for custom colormap
            self_UNISYS.intAct.clrmap_txt_click = uicontrol('Style','text',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column7x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth/2 self_UNISYS.intAct.textheight/2],...
                'String','Click',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
%             % Create "or specify"-text for custom colormap
%             self_UNISYS.intAct.clrmap_txt_or_specify = uicontrol('Style','text',...
%                 'Units','normalized',...
%                 'Position', [self_UNISYS.intAct.column7x .275 0.05 0.025],...
%                 'String','Or specify',...
%                 'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "or load"-text for custom colormap
            self_UNISYS.intAct.clrmap_txt_or_load = uicontrol('Style','text',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column75x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth/2 self_UNISYS.intAct.textheight/2],...
                'String','Or load',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
%             % Create "custom or specify"-val
%             self_UNISYS.intAct.clrmap_val_custom_specify = uicontrol('Style','Edit',...
%                 'Units','normalized',...
%                 'Position', [self_UNISYS.intAct.column75x .225 0.05 0.05],...
%                 'CallBack', {@self_UNISYS.draw_heart_with_clrbar,self_UNISYS},...
%                 'BackgroundColor','white');
            
            % Create "custom click"-button
            self_UNISYS.intAct.LoadButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column7x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.SpecifyColorButtonPushed,self_UNISYS},...
                'String', 'Specify colormap',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Create "custom load"-button
            self_UNISYS.intAct.LoadButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column75x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth/2 self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.LoadColorButtonPushed,self_UNISYS},...
                'String', 'Load colormap',...
                'BackgroundColor',[.3 .8 .8]);
            
            % Create save options-button
            self_UNISYS.intAct.CloseButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column5x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight*2],...
                'CallBack', @self_UNISYS.SaveSettingsButtonPushed,...
                'String', 'Save settings',...
                'FontSize',16,...
                'ForegroundColor',[1 1 1],...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Create plot-button
            self_UNISYS.intAct.PlotButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column4x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight*2],...
                'CallBack', @self_UNISYS.PlotButtonPushed,...
                'String', 'Plot UNISYS',...
                'FontSize',16,...
                'ForegroundColor',[1 1 1],...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Create plot-button
            self_UNISYS.intAct.PlotButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column6x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight*2],...
                'CallBack', @self_UNISYS.LoadSettingsButtonPushed,...
                'String', 'Load settings',...
                'FontSize',16,...
                'ForegroundColor',[1 1 1],...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
            
            % Create close-button
            self_UNISYS.intAct.CloseButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column7x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight*2],...
                'CallBack', @self_UNISYS.CloseButtonPushed,...
                'String', 'Close GUI',...
                'FontSize',16,...
                'ForegroundColor',[1 1 1],...
                'BackgroundColor',self_UNISYS.intAct.textbackground_dark);
        end
        
        % Button pushed function: Load
        function self_UNISYS=LoadButtonPushed(self_UNISYS, ~, varargin)
            [filename, savefolder] = uigetfile('*.mat','Select a file to load');
            if filename~=0
                self_UNISYS.UIFigure.Pointer='watch';
                drawnow;
                load(fullfile(savefolder,filename));
                self_UNISYS.UIFigure.Pointer='arrow';
                drawnow;
                varnames=who;
                self_UNISYS.intAct.list_varnames_beats.String=varnames;
            end
            putInSelf
        end
        
        function self_UNISYS=BasalNodesButton(self_UNISYS, ~, varargin)
            getFromSelf
            [filename_basalnodes, savefolder_basalnodes] = uigetfile('*.csv','Select a basalnodes-file to load');
            PutInSelf
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
                delete(self_UNISYS.intAct.txt_draw)
            end
            
            try
                delete(self_UNISYS.intAct.list_varnames_draw)
            end
            
            try
                delete(self_UNISYS.intAct.txt_fieldnames)
            end
            
            try
                delete(self_UNISYS.intAct.list_fieldnames_draw)
            end
            
            try
                if strcmp(self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value},'else:') % If "else" is selected: display other options
                    
                    % Create "Geometry to visualize"-text
                    self_UNISYS.intAct.txt_draw = uicontrol('Style','text',...
                        'Units','normalized',...
                        'Position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row6y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                        'String','Select other geometry to visualize',...
                        'BackgroundColor',self_UNISYS.intAct.textbackground_light);
                    
                    % Variable names for geom
                    self_UNISYS.intAct.list_varnames_draw = uicontrol('style','list',...
                        'Units','normalized',...
                        'position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row6y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                        'CallBack', {@self_UNISYS.GeomVariableSelected,self_UNISYS},...
                        'min',0,'max',2,...
                        'string',{''});
                    
                    % List only variable names that are either [doubles with
                    % 2 dimensions of which one has size 3] or [structs]
                    vars=whos;
                    doubles=find(strcmp({varnames.class},'double'));
                    i=1;
                    good_doubles=[];
                    for lp_doubles=1:length(doubles)
                        if length(vars(doubles(lp_doubles)).size)==2 && (vars(doubles(lp_doubles)).size(1)==3 || vars(doubles(lp_doubles)).size(2)==3)
                            good_doubles(i)=doubles(lp_doubles);
                            i=i+1;
                        end
                    end
                    
                    structs=find(strcmp({varnames.class},'struct'));
                    geoms=find(strcmp({varnames.class},'geometryCH'));
                    ind_good_doubles_or_structs=[good_doubles structs geoms]';
                    varnames={vars(ind_good_doubles_or_structs).name};
                    self_UNISYS.intAct.list_varnames_draw.String=varnames;
                    
                    putInSelf
                else %If one of the predefined options (so not 'else') is selected
                    
                    GeomVariableSelected(self_UNISYS)
                end
            end
        end
        
        function self_UNISYS=ReferenceButtonLeftPushed(self_UNISYS, ~, varargin)
            self_UNISYS.intAct.val_reference_buttonleft.BackgroundColor=self_UNISYS.intAct.blue_color;
            self_UNISYS.intAct.val_reference_buttonright.BackgroundColor=self_UNISYS.intAct.red_color;
            
            try
                delete(self_UNISYS.intAct.val_reference);
            end
            
            % Create "reference"-textfield for input
            self_UNISYS.intAct.val_reference = uicontrol('style','Edit',...
                'string','0',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'backgroundcolor','w',...
                'Tag','EditField');
            
            reference=self_UNISYS.intAct.val_reference;
            putInSelf
        end

        function self_UNISYS=ReferenceButtonRightPushed(self_UNISYS, ~, varargin)
            self_UNISYS.intAct.val_reference_buttonleft.BackgroundColor=self_UNISYS.intAct.red_color;
            self_UNISYS.intAct.val_reference_buttonright.BackgroundColor=self_UNISYS.intAct.blue_color;
            
            try
                delete(self_UNISYS.intAct.val_reference);
            end
            
            % Variable names for reference
            self_UNISYS.intAct.list_reference_varnames_draw = uicontrol('style','list',...
                'Units','normalized',...
                'position',[self_UNISYS.intAct.column2x self_UNISYS.intAct.row4y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'min',0,'max',2,...
                'string',{''});
            
            getFromSelf
            % List only variable names that are either [doubles with
            % 2 dimensions of which one has size 3] or [structs]
            vars=whos;
            doubles=find(strcmp({vars.class},'double'));
            tables=find(strcmp({vars.class},'table'));
            structs=find(strcmp({vars.class},'struct'));
            i=1;
            good_doubles=[];
            for lp_doubles=1:length(doubles)
                if length(vars(doubles(lp_doubles)).size)==2 && (vars(doubles(lp_doubles)).size(1)==length(beats) || vars(doubles(lp_doubles)).size(2)==length(beats))
                    good_doubles(i)=doubles(lp_doubles);
                    i=i+1;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            varnames={vars(good_doubles).name};
            self_UNISYS.intAct.list_varnames_draw.String=varnames;
            
            reference=self_UNISYS.intAct.list_reference_varnames_draw;
            putInSelf
        end
        
        % If a different geom variable is selected
        function GeomVariableSelected(self_UNISYS, ~, varargin)
            
            try
                delete(self_UNISYS.intAct.list_fieldnames_draw);
            end
            getFromSelf
            varnames=who;
            
            if strcmp(self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value},'else:')
                var_todraw=self_UNISYS.intAct.list_varnames_draw.String{self_UNISYS.intAct.list_varnames_draw.Value};
                
                %Check if variable exists
                varnr_todraw=find(strcmp(varnames,var_todraw));
            else
                var_todraw=self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value};
                varnr_todraw=1;
            end
            
            try
                if varnr_todraw~=0 & ~isempty(varnr_todraw)
                    try
                        delete(ax_geom) %Delete existing axes
                    end
                    clear varfieldname
                    
                    ax_geom=axes('Units','normalized','Position',[.2 .6 0.3 0.3]); %Create axes
                end
                
                if isfield(self_UNISYS.intAct,'val_reference')
                    if ~isnan(str2double(self_UNISYS.intAct.val_reference.String))
                        ref=str2double(self_UNISYS.intAct.val_reference.String);
                    else
                        ref=eval(ref);
                    end
                elseif isfield(self_UNISYS.intAct,'list_reference_varnames_draw')
                    if ~isnan(str2double(eval(self_UNISYS.intAct.val_reference.String{self_UNISYS.intAct.val_reference.Value})))
                        ref=eval(str2double(eval(self_UNISYS.intAct.val_reference.String{self_UNISYS.intAct.val_reference.Value})));
                    end
                else
                    ref=0;
                end
                
                if isstruct(eval(var_todraw)) %If this variable is a struct
                    if isfield(eval(var_todraw),'faces') && isfield(eval(var_todraw),'vertices') %Check if 'faces' field exists together with vertices field
                        eval(['trisurf(' var_todraw '.faces,', var_todraw '.vertices(:,1),' var_todraw '.vertices(:,2),' var_todraw '.vertices(:,3),''FaceColor'',''interp'')']);
                        fieldname_geom='vertices';
                    elseif isfield(eval(var_todraw),'faces') && isfield(eval(var_todraw),'vertex') %Check if 'faces' field exists together with vertex field
                        eval(['trisurf(' var_todraw '.faces,', var_todraw '.vertex(:,1),' var_todraw '.vertex(:,2),' var_todraw '.vertex(:,3),''FaceColor'',''interp'')']);
                        fieldname_geom='vertex';
                    elseif isfield(eval(var_todraw),'faces') && isfield(eval(var_todraw),'nodes') %Check if 'faces' field exists together with nodes field
                        eval(['trisurf(' var_todraw '.faces,', var_todraw '.nodes(:,1),' var_todraw '.nodes(:,2),' var_todraw '.nodes(:,3),''FaceColor'',''interp'')']);
                        fieldname_geom='nodes';
                    elseif isfield(eval(var_todraw),'vertices') %Check if 'vertices' field exists
                        eval(['scatter3(' var_todraw '.vertices(:,1),' var_todraw '.vertices(:,2),' var_todraw '.vertices(:,3),50,''filled'')']);
                        fieldname_geom='vertices';
                    elseif isfield(eval(var_todraw),'vertex') %Check if 'vertex' field exists
                        eval(['scatter3(' var_todraw '.vertex(:,1),' var_todraw '.vertex(:,2),' var_todraw '.vertex(:,3),50,''filled'')']);
                        fieldname_geom='vertex';
                    elseif isfield(eval(var_todraw),'nodes') %Check if 'nodes' field exists
                        eval(['scatter3(' var_todraw '.nodes(:,1),' var_todraw '.nodes(:,2),' var_todraw '.nodes(:,3),50,''filled'')']);
                        fieldname_geom='nodes';
                    else
                        
                        % Make and check the list of fieldnames
                        % Create "Geometry fieldname to visualize"-text
                        self_UNISYS.intAct.txt_fieldnames = uicontrol('Style','text',...
                            'Units','normalized',...
                            'Position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row5y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                            'String','Fieldname of geometry to visualize (select NODES)',...
                            'BackgroundColor',self_UNISYS.intAct.textbackground_light);
                        
                        % Fieldnames for geom
                        self_UNISYS.intAct.list_fieldnames_draw = uicontrol('style','list',...
                            'Units','normalized',...
                            'position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row5y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                            'CallBack', {@self_UNISYS.GeomFieldnameSelected,self_UNISYS},......
                            'min',0,'max',2,...
                            'string',{''});
                        
                        % Give fieldnames to above list
                        fnames_h=fieldnames(eval(var_todraw));
                        self_UNISYS.intAct.list_fieldnames_draw.String=fnames_h;
                    end
                    
                else
                    eval(['scatter3(' var_todraw '(:,1),' var_todraw '(:,2),' var_todraw '(:,3),50,' var_todraw '(:,3),''filled'')']);
                end
                
                
                if ~isempty(self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value}) %Check if any color can be given
                    if strcmp(self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value},'else:') %Use different variable name
                        varfieldname=[self_UNISYS.intAct.list_varnames_beats.String{self_UNISYS.intAct.list_varnames_beats.Value} '(1).' self_UNISYS.intAct.list_fieldnames_beats.String{self_UNISYS.intAct.list_fieldnames_beats.Value}];
                    else % Use beats
                        varfieldname=[self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value} '(1).' self_UNISYS.intAct.list_fieldnames_beats.String{self_UNISYS.intAct.list_fieldnames_beats.Value}];
                    end
                else
                    varfieldname= [self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value} '.' fieldname_geom '(:,3)'];
                end
                
                if exist('varfieldname','var') %%%%%%%%%%%%%%%%%%%%%%
                    ax_geom.Children(end).FaceVertexCData=eval([varfieldname '-ref']);
                end
                
                axis equal
                self_UNISYS.intAct.txt_No_Geom_disp.String='Geometry';
                
                % Check if isolines should be drawn
                draw_isolines= self_UNISYS.intAct.clrmap_val_isolines.String{self_UNISYS.intAct.clrmap_val_isolines.Value};
                if strcmp(draw_isolines,'Yes')
                    draw_isolines=1;
                else
                    draw_isolines=0;
                end
                
                % Draw isolines if necessary
                if draw_isolines
                    isocell{1}=eval([self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value} '.faces']);
                    isocell{2}=eval([self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value} '.vertices']);
               
                    
                    if ~strcmp(self_UNISYS.intAct.clrmap_val_steps.String,'') && str2double(self_UNISYS.intAct.clrmap_val_steps.String)>0
                        stepsize=str2double(self_UNISYS.intAct.clrmap_val_steps.String);
                    else
                        stepsize=(ax_geom.CLim(2)-ax_geom.CLim(1))/(size(ax_geom.Colormap,1)-1);
                    end
                    minval=floor(ax_geom.CLim(1)/stepsize)*stepsize;
                    maxval=ceil(ax_geom.CLim(2)/stepsize)*stepsize;
                    clrbar_vals=minval:stepsize:maxval;
                    
                    for lp_isolines=1:length(clrbar_vals)
                        IsoLine(isocell,ax_geom.Children(end).FaceVertexCData,[clrbar_vals(lp_isolines) clrbar_vals(lp_isolines)]',[.2 .2 .2],.1);
                    end
                end
                
                % Change alpha
                if ~isempty(self_UNISYS.intAct.clrmap_val_alpha.String) && ~isnan(str2double(self_UNISYS.intAct.clrmap_val_alpha.String))
                    ax_geom.Children(end).EdgeAlpha=str2double(self_UNISYS.intAct.clrmap_val_alpha.String);
                end
                
                putInSelf
                draw_heart_with_clrbar(self_UNISYS); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            catch
                % Display message saying that this variable cannot be plotted
                try
                    delete(ax_geom)
                end
                errordlg('That variable name cannot be plotted','Error','non-modal')
            end
        end
        
        % Fieldname of 'different geom variable'
        function GeomFieldnameSelected(self_UNISYS, ~, varargin)
            getFromSelf
            
            try
                delete(ax_geom)
            end
            
            var_todraw=self_UNISYS.intAct.list_varnames_draw.String{self_UNISYS.intAct.list_varnames_draw.Value};
            fieldname_todraw=self_UNISYS.intAct.list_fieldnames_draw.String{self_UNISYS.intAct.list_fieldnames_draw.Value};
            try
                ax_geom=axes('Units','normalized','Position',[.2 .6 0.3 0.3]);
                eval(['scatter3(' var_todraw '.' fieldname_todraw '(:,1),' var_todraw '.' fieldname_todraw '(:,2),' var_todraw '.' fieldname_todraw '(:,3),50,' var_todraw '.' fieldname_todraw '(:,3),''filled'')']);
                axis equal
            catch
                errordlg('That variable name cannot be plotted','Error','non-modal')
            end
            putInSelf
        end
        
        % Button selected function: Beats
        function self_UNISYS=BeatsButtonPushed(self_UNISYS, ~, varargin)
            if ~isempty(self_UNISYS.vars_exclude)
                getFromSelf
            end
            
            try
                delete(self_UNISYS.intAct.Beats_txt_else)
            end
            
            try
                delete(self_UNISYS.intAct.list_varnames_beats)
            end
            
            try
                delete(self_UNISYS.intAct.txt_fieldname_beats)
            end
            
            try
                delete(self_UNISYS.intAct.list_fieldnames_beats)
            end
            
            try
                if strcmp(self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value},'else:') % If "else" is selected: display other options
                    
                    % Create "Beats-variable to visualize"-text
                    self_UNISYS.intAct.Beats_txt_else = uicontrol('Style','text',...
                        'Units','normalized',...
                        'Position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row3y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                        'String','Select other beats-variable to visualize',...
                        'BackgroundColor',self_UNISYS.intAct.textbackground_light);
                    
                    % Variable names for beats
                    self_UNISYS.intAct.list_varnames_beats = uicontrol('style','list',...
                        'Units','normalized',...
                        'position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row3y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                        'CallBack', {@self_UNISYS.Beats_VarName_Selected,self_UNISYS},...
                        'min',0,'max',2,...
                        'string',{''});
                    
                    % List only structs
                    vars=whos;
                    structs=find(strcmp({varnames.class},'struct'));
                    ind_good_doubles_or_structs=structs';
                    varnames={vars(ind_good_doubles_or_structs).name};
                    self_UNISYS.intAct.list_varnames_beats.String=varnames;
                else
                    Beats_VarName_Selected(self_UNISYS)
                end
                
                putInSelf
                
            end
        end
        
        % If a beats variable is selected
        function Beats_VarName_Selected(self_UNISYS, ~, varargin)
            
            try
                delete(self_UNISYS.intAct.txt_fieldnames_beats)
            end
            try
                delete(self_UNISYS.intAct.list_fieldnames_beats)
            end
            
            getFromSelf
            
            if strcmp(self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value},'beats')
                var_tobeat='beats';
            else
                var_tobeat=self_UNISYS.intAct.list_varnames_beats.String{self_UNISYS.intAct.list_varnames_beats.Value};
            end
            
            if isstruct(eval(var_tobeat))
                % Make and check the list of fieldnames
                % Create "Beats fieldname to visualize"-text
                self_UNISYS.intAct.txt_fieldnames_beats = uicontrol('Style','text',...
                    'Units','normalized',...
                    'Position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                    'String','Fieldname of beats to visualize',...
                    'BackgroundColor',self_UNISYS.intAct.textbackground_light);
                
                % Fieldnames for beats
                self_UNISYS.intAct.list_fieldnames_beats = uicontrol('style','list',...
                    'Units','normalized',...
                    'position',[self_UNISYS.intAct.column1x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                    'CallBack', {@self_UNISYS.GeometryButtonPushed,self_UNISYS},...
                    'min',0,'max',2,...
                    'string',{''});
                
                % Give fieldnames to above list: only fieldnames with 2
                % dimensions of which 1 has size 3
                fnames_h1=fieldnames(eval(var_tobeat));
                i=1;
                good_fieldnames=[];
                
                if exist('ax_geom') && isfield(ax_geom,'Children')
                    numvertices=1;
                end
                
                for lp_fieldname=1:length(fnames_h1)
                    if length(size(eval([var_tobeat '(1).' fnames_h1{lp_fieldname}])))==1 || size(eval([var_tobeat '(1).' fnames_h1{lp_fieldname}]),2)==1
                        good_fieldnames(i)=lp_fieldname;
                        i=i+1;
                    end
                end
                
                self_UNISYS.intAct.list_fieldnames_beats.String=fnames_h1(good_fieldnames);
                
                putInSelf
            else
                errordlg('That variable name cannot be plotted','Error','non-modal')
            end
        end
        
        % Contains base checkbox
        function ContainsbaseCheckbox(self_UNISYS, ~, varargin)
            getFromSelf
            if self_UNISYS.intAct.val_Containsbase.Value==0
                delete(self_UNISYS.intAct.BasalNodesButton)
            elseif self_UNISYS.intAct.val_Containsbase.Value==1
                if ~isvalid(self_UNISYS.intAct.BasalNodesButton)
                    % Select basalnodes
                    self_UNISYS.intAct.BasalNodesButton = uicontrol(self_UNISYS.UIFigure, ...
                        'Style','pushbutton',...
                        'Units','normalized',...
                        'Position', [self_UNISYS.intAct.column2x self_UNISYS.intAct.row1y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                        'CallBack', {@self_UNISYS.BasalNodesButton,self_UNISYS},...
                        'String', 'Load manually defined basal nodes',...
                        'BackgroundColor',[.3 .8 .8]);
                end     
            end
            putInSelf
        end
        
        
        % Save option
        function SaveButtonPushed(self_UNISYS, ~, varargin)
            getFromSelf
            
            %Check if no
            if strcmp(self_UNISYS.intAct.val_save.String{self_UNISYS.intAct.val_save.Value},'No')
                %If no: delete other checkboxes
                delete(self_UNISYS.intAct.val_savefig)
                delete(self_UNISYS.intAct.val_savepng)
                delete(self_UNISYS.intAct.val_savename)
                delete(self_UNISYS.intAct.txt_savename)
                delete(self_UNISYS.intAct.SavefolderButton)
            elseif strcmp(self_UNISYS.intAct.val_save.String{self_UNISYS.intAct.val_save.Value},'Yes')
                if ~isvalid(self_UNISYS.intAct.val_savefig)
            % Create "save fig"-checkbox for input
            self_UNISYS.intAct.val_savefig = uicontrol('Style','checkbox',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column3x .35 self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Save results in .fig'},...
                'BackgroundColor','white');

            % Create "save png"-checkbox for input
            self_UNISYS.intAct.val_savepng = uicontrol('Style','checkbox',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column3x .3 self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'String', {'Save results in .png'},...
                'BackgroundColor','white');
            
            % Create "Savename"-text
            self_UNISYS.intAct.txt_savename = uicontrol('Style','text',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column3x self_UNISYS.intAct.row2y+self_UNISYS.intAct.inputheight self_UNISYS.intAct.textwidth self_UNISYS.intAct.textheight],...
                'String','Savename',...
                'BackgroundColor',self_UNISYS.intAct.textbackground_light);
            
            % Create "savename"-textfield for input
            self_UNISYS.intAct.val_savename = uicontrol('style','Edit',...
                'string','Results_UNISYS',...
                'Units','normalized',...
                'Position',[self_UNISYS.intAct.column3x self_UNISYS.intAct.row2y self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'backgroundcolor','w',...
                'Tag','EditField');
            
            % Select folder to save results
            self_UNISYS.intAct.SavefolderButton = uicontrol(self_UNISYS.UIFigure, ...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position', [self_UNISYS.intAct.column3x .125 self_UNISYS.intAct.inputwidth self_UNISYS.intAct.inputheight],...
                'CallBack', {@self_UNISYS.SaveFolderButtonPushed,self_UNISYS},...
                'String', 'Specify folder to save results in',...
                'BackgroundColor',[.3 .8 .8]);
                end
            end
            
            putInSelf
        end
        
        % Savefolder button
        function SaveFolderButtonPushed(self_UNISYS, ~, varargin)
            getFromSelf
            
            savepath = uigetdir('Select a folder to save in');
            
            putInSelf
        end
        
        % Draw
        function draw_heart_with_clrbar(self_UNISYS, ~, varargin)
            
            getFromSelf
            
            try
                delete(axis_colorbar)
            end
            
            % If the heart is not plotted yet: create empty axes so
            % colorbar can be created
            if ~exist('ax_geom','var') || ~isvalid(ax_geom)
                ax_geom=axes('Units','normalized','Position',[.2 .6 0.3 0.3]);
                axis off
                box off
            end
            
            % Check if colors should be flipped upside down
            flipud_var=self_UNISYS.intAct.clrmap_val_flipud.String{self_UNISYS.intAct.clrmap_val_flipud.Value};
            if strcmp(flipud_var,'Yes')
                flipud_var=1;
            elseif strcmp(flipud_var,'No')
                flipud_var=0;
            end
            
            axes(ax_geom);
            
            % Check if colors should be symmetrical
            symmetrical=self_UNISYS.intAct.clrmap_val_symmetrical.String{self_UNISYS.intAct.clrmap_val_symmetrical.Value};
            if strcmp(symmetrical,'Yes')
                symmetrical=1;
            elseif strcmp(symmetrical,'No')
                symmetrical=0;
            end
            
            % Find colormap type and make colorbar
            colorbar_type=self_UNISYS.intAct.clrmap_val_map.String{self_UNISYS.intAct.clrmap_val_map.Value};
            if ~strcmp(colorbar_type,'custom')
                if ~symmetrical
                    map=eval([colorbar_type '(64)']);
                else
                    map=eval([colorbar_type '(32)']);
                end
            else
                map=color_custom;
            end
            
            % Set colormap
            if flipud_var && ~symmetrical
                colormap(flipud(map));
            elseif ~flipud_var && ~symmetrical
                colormap(map);
            elseif flipud_var && symmetrical
                colormap([flipud(map); map])
            elseif ~flipud_var && symmetrical
                colormap([map; flipud(map)])
            end
            clear map axis_colorbar
            axis_colorbar=colorbar(ax_geom,'Location','manual','Units','normalized','Position',[self_UNISYS.intAct.column7x self_UNISYS.intAct.row4y self_UNISYS.intAct.textwidth/2 self_UNISYS.intAct.textheight*2]);
            
            % Set limits
            if ~isempty(get(self_UNISYS.intAct.clrmap_val_lims_lower,'String')) && ~isempty(get(self_UNISYS.intAct.clrmap_val_lims_higher,'String'))
                lims_colorbar=[str2double(get(self_UNISYS.intAct.clrmap_val_lims_lower,'String')) str2double(get(self_UNISYS.intAct.clrmap_val_lims_higher,'String'))];
                self_UNISYS.intAct.clrmap_txt_identical.BackgroundColor=[1 0 0]; % 'Identical' flag does not work if manual limits are set
                self_UNISYS.intAct.clrmap_txt_symmetrical.BackgroundColor=[1 0 0]; % 'Symmetrical' flag does not work if manual limits are set
                if lims_colorbar(1)>lims_colorbar(2)
                    errordlg('Lower limit should be lower than higher limit');
                    return
                else
                    caxis(lims_colorbar)
                end
            else
                self_UNISYS.intAct.clrmap_txt_identical.BackgroundColor=self_UNISYS.intAct.textbackground_light;
                self_UNISYS.intAct.clrmap_txt_symmetrical.BackgroundColor=self_UNISYS.intAct.textbackground_light;
                lims_colorbar=[min(ax_geom.Children(end).FaceVertexCData) max(ax_geom.Children(end).FaceVertexCData)];
            end
            
            % Check stepsize
            if iscell(self_UNISYS.intAct.clrmap_val_steps.String) && ~isempty(self_UNISYS.intAct.clrmap_val_steps.String{1})
                stepsize=str2double(self_UNISYS.intAct.clrmap_val_steps.String{1});
                change_colormap=1;
            elseif iscell(self_UNISYS.intAct.clrmap_val_steps.String) && ~isempty(self_UNISYS.intAct.clrmap_val_steps.String{1})
                stepsize=str2double(self_UNISYS.intAct.clrmap_val_steps.String);
                change_colormap=1;
            else
                change_colormap=0;
            end
            
            if strcmp(colorbar_type,'custom') && (~exist('change_colormap','var') || change_colormap==0)
                change_colormap=1;
                clrs=ax_geom.Children(end).FaceVertexCData;
                stepsize=(max(clrs)-min(clrs))/100;
            end
            
            if change_colormap
                maxval_disp=ceil(lims_colorbar(2)/stepsize)*stepsize;
                minval_disp=floor(lims_colorbar(1)/stepsize)*stepsize;
                range=maxval_disp-minval_disp;
                arraylength_req= round(range/stepsize)+1;
                stepsize_req= range/(arraylength_req-1);
                set(axis_colorbar,'YLim',[minval_disp maxval_disp]);
                clrbar_vals= minval_disp:stepsize:maxval_disp;
                set(gca,'CLim',[minval_disp maxval_disp]);
                if ~strcmp(colorbar_type,'custom')
                    clrmap=eval([colorbar_type '(' num2str(length(clrbar_vals)) ')']);
                else
                    if exist('color_custom','var')
                        clrarray=color_custom;
                        stepsize_old=range/(size(clrarray,1)-1);
                        
                        for lp_clr=1:3
                            clrmap(:,lp_clr)=interp1q((minval_disp:stepsize_old:maxval_disp)',clrarray(:,lp_clr),(minval_disp:stepsize_req:maxval_disp)');
                        end
                    else
                        errordlg('Please specify custom colormap first')
                    end
                end
                colormap(ax_geom,clrmap);
                caxis([minval_disp maxval_disp])
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
                set(axis_colorbar,'YTick',clrbar_vals_disp);
            end
            
            
            % Change limits if they should be symmetrical
            if symmetrical
                caxis([-max(abs(axis_colorbar.Limits)) max(abs(axis_colorbar.Limits))]);
            end
            
            putInSelf
        end
        
        % Specify Colormap
        function SpecifyColorButtonPushed(self_UNISYS, ~, varargin)
            numColors=inputdlg('How many colors should be in the custom colormap?','Custom colormap');
            
            numColors=str2double(numColors);
            
            if isnan(numColors)
                errordlg('Please enter a number')
                return
            else
                color_custom=nan(numColors,3);
                for i=1:numColors
                    color_custom(i,:)=uisetcolor;
                end
                putInSelf
                draw_heart_with_clrbar(self_UNISYS)
            end
        end
        
        % Specify Colormap%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function LoadColorButtonPushed(self_UNISYS, ~, varargin)
            getFromSelf
            
            [colorfilename,colorfilepath]=uigetfile('*.mat','Click custom color map to load');
            
            custom_clrmap=load(fullfile(colorfilepath,colorfilename));
            
            putInSelf
            draw_heart_with_clrbar(self_UNISYS)
        end
        
        % Create save settings-button
        function SaveSettingsButtonPushed(self_UNISYS, ~, varargin)
            % Find/define inputs
            define_UNISYS_inputs(self_UNISYS)
            getFromSelf
            
            UNISYS_settings_folder=uigetdir(pwd,'Select folder to save UNISYS-settings in');
            UNISYS_settings_filename=inputdlg('Enter filename of UNISYS-settings to save','Filename?',[1 100],{'UNISYS_Settings'});
            UNISYS_settings_filename=UNISYS_settings_filename{1};
            
            fieldnames_tokeep={'String','Value','BackgroundColor'};
            fieldnames_all=fieldnames(self_UNISYS.intAct);
            for lp_fieldname=1:length(fieldnames_all)
                fieldname_here=fieldnames_all{lp_fieldname};
                if isstruct(self_UNISYS.intAct.(fieldname_here)) | isgraphics(self_UNISYS.intAct.(fieldname_here))                    
                    fieldnames_current=fieldnames(self_UNISYS.intAct.(fieldname_here));
                    which_tokeep=find(ismember(fieldnames_current,fieldnames_tokeep));
                    for lp_tokeep=1:length(which_tokeep)
                        self_UNISYS_intAct_tosave.(fieldname_here).(fieldnames_current{which_tokeep(lp_tokeep)})=self_UNISYS.intAct.(fieldname_here).(fieldnames_current{which_tokeep(lp_tokeep)});
                    end
                end
            end
            
            save(fullfile(UNISYS_settings_folder,UNISYS_settings_filename),'UNISYS_inputs','self_UNISYS_intAct_tosave');
        end

        % Create load settings-button
        function LoadSettingsButtonPushed(self_UNISYS, ~, varargin)
            % Find/define inputs
            [UNISYS_settings_file,UNISYS_settings_path]=uigetfile('*.mat','Select UNISYS-settings to load','UNISYS_inputs');
            load(fullfile(UNISYS_settings_path,UNISYS_settings_file));   
            
            fieldnames_all=fieldnames(self_UNISYS_intAct_tosave);
            for lp_fieldname=1:length(fieldnames_all)
                fieldname_here=fieldnames_all{lp_fieldname};
                fieldnames_current=fieldnames(self_UNISYS_intAct_tosave.(fieldname_here));
                for lp_fieldname2=1:length(fieldnames_current)
                    self_UNISYS.intAct.(fieldname_here).(fieldnames_current{lp_fieldname2})=self_UNISYS_intAct_tosave.(fieldname_here).(fieldnames_current{lp_fieldname2});
                end
            end
            
            self_UNISYS.intAct=self_UNISYS_intAct_tosave;
            clear self_UNISYS_intAct_tosave
        end
        
        % Create plot-button
        function PlotButtonPushed(self_UNISYS, ~, varargin)
            % Find/define inputs
            define_UNISYS_inputs(self_UNISYS)
                        
            getFromSelf
            
            try
                UNISYS_Main(eval(UNISYS_inputs.geom),eval(UNISYS_inputs.beats),UNISYS_inputs.fieldnames_input,UNISYS_inputs.fieldnames_disp,UNISYS_inputs.reference,UNISYS_inputs.dev_opts)
            catch
                errordlg('The inputs you provided were not correct','Error')
            end
            
            putInSelf
        end
        
        % Define UNISYS inputs
        function define_UNISYS_inputs(self_UNISYS, ~, varargin)
            getFromSelf
            
            % Geometry and 'contains base'
            varnames=who;
            % If geometry is not geom.Heart or geom.Body
            if strcmp(self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value},'else:')
                var_todraw=self_UNISYS.intAct.list_varnames_draw.String{self_UNISYS.intAct.list_varnames_draw.Value};
               
                %Check if variable exists
                varnr_todraw=find(strcmp(varnames,var_todraw));
                fieldname_todraw=self_UNISYS.intAct.list_fieldnames_draw.String{self_UNISYS.intAct.list_fieldnames_draw.Value};
    
                if ~isempty(varnr_todraw)
                    if isfield(eval(var_todraw),fieldname_todraw)
                        UNISYS_inputs.geom=[var_todraw '.' fieldname_todraw];
                    else
                        UNISYS_inputs.geom=var_todraw;
                    end
                end
            %If geometry is geom.Heart or geom.Body:
            else
                var_todraw=self_UNISYS.intAct.Geometry.String{self_UNISYS.intAct.Geometry.Value};
                UNISYS_inputs.geom=var_todraw;
            end   
            
            %Contains base
            if ~isempty(var_todraw)
                if self_UNISYS.intAct.val_Containsbase.Value==1
                    eval([var_todraw '.contains_base=1']);
                elseif self_UNISYS.intAct.val_Containsbase.Value==0
                    eval([var_todraw '.contains_base=0']);
                end
            end
            
            % Beats
            if strcmp(self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value},'beats')
                % If beats variable is 'beats'
                UNISYS_inputs.beats='beats';
            elseif strcmp(self_UNISYS.intAct.Beats.String{self_UNISYS.intAct.Beats.Value},'else:')
                % else
                UNISYS_inputs.beats=self_UNISYS.intAct.list_varnames_beats.String{self_UNISYS.intAct.list_varnames_beats.Value};
            else
                UNISYS_inputs.beats='';
            end          
            
            % Reference
            if ~isempty(self_UNISYS.intAct.val_reference.String)
                if ~isnan(str2double(self_UNISYS.intAct.val_reference.String))
                    UNISYS_inputs.reference=str2double(self_UNISYS.intAct.val_reference.String);
                else
                    UNISYS_inputs.reference=eval(self_UNISYS.intAct.val_reference.String )
                end
            else
                UNISYS_inputs.reference=0;
            end
            
            % Fieldnames_input
            if ~isempty(UNISYS_inputs.beats)
                UNISYS_inputs.fieldnames_input=self_UNISYS.intAct.list_fieldnames_beats.String{self_UNISYS.intAct.list_fieldnames_beats.Value};
            end
            
            % Fieldnames_disp
            UNISYS_inputs.fieldnames_disp=self_UNISYS.intAct.input_fieldnames_disp.String;
            
            % Dev opts        
            % Plot UNISYS
            if strcmp(self_UNISYS.intAct.val_plot.String{self_UNISYS.intAct.val_plot.Value},'Yes')
                UNISYS_inputs.dev_opts.plot.plot=1;
            elseif strcmp(self_UNISYS.intAct.val_plot.String{self_UNISYS.intAct.val_plot.Value},'No')
                UNISYS_inputs.dev_opts.plot.plot=0;                
            end    
            
            %Filefolder basalnodes
            if exist('filefolder_basalnodes','var') 
                UNISYS_inputs.dev_opts.filefolder_basalnodes=savefolder_basalnodes;
            end
            
            %Filename basalnodes
            if exist('filename_basalnodes','var') 
                UNISYS_inputs.dev_opts.filename_basalnodes=savefolder_basalnodes;
            end
            
            %dev_opts.plot
            %dev_opts.plot.heart
            if strcmp(self_UNISYS.intAct.plot_val_heart.String{self_UNISYS.intAct.plot_val_heart.Value},'Yes')
                UNISYS_inputs.dev_opts.plot.hearts=1;
            elseif strcmp(self_UNISYS.intAct.plot_val_heart.String{self_UNISYS.intAct.plot_val_heart.Value},'No')
                UNISYS_inputs.dev_opts.plot.hearts=0;
            end

            %dev_opts.plot.bullseyes
            if strcmp(self_UNISYS.intAct.plot_val_bullseye.String{self_UNISYS.intAct.plot_val_bullseye.Value},'Yes')
                UNISYS_inputs.dev_opts.plot.bullseyes=1;
            elseif strcmp(self_UNISYS.intAct.plot_val_bullseye.String{self_UNISYS.intAct.plot_val_bullseye.Value},'No')
                UNISYS_inputs.dev_opts.plot.bullseyes=0;
            end
            
            %dev_opts.plot.colorbar_hearts
            if strcmp(self_UNISYS.intAct.plot_val_clrbar_heart.String{self_UNISYS.intAct.plot_val_clrbar_heart.Value},'Yes')
                UNISYS_inputs.dev_opts.plot.colorbar_hearts=1;
            elseif strcmp(self_UNISYS.intAct.plot_val_clrbar_heart.String{self_UNISYS.intAct.plot_val_clrbar_heart.Value},'No')
                UNISYS_inputs.dev_opts.plot.colorbar_hearts=0;
            elseif strcmp(self_UNISYS.intAct.plot_val_clrbar_heart.String{self_UNISYS.intAct.plot_val_clrbar_heart.Value},'Only for the last heart')
                UNISYS_inputs.dev_opts.plot.colorbar_hearts=2;
            end
            
            %dev_opts.plot.colorbar_bullseyes
            if strcmp(self_UNISYS.intAct.plot_val_clrbar_bullseye.String{self_UNISYS.intAct.plot_val_clrbar_bullseye.Value},'Yes')
                UNISYS_inputs.dev_opts.plot.colorbar_bullseyes=1;
            elseif strcmp(self_UNISYS.intAct.plot_val_clrbar_bullseye.String{self_UNISYS.intAct.plot_val_clrbar_bullseye.Value},'No')
                UNISYS_inputs.dev_opts.plot.colorbar_bullseyes=0;
            elseif strcmp(self_UNISYS.intAct.plot_val_clrbar_bullseye.String{self_UNISYS.intAct.plot_val_clrbar_bullseye.Value},'Only for the last bullseye')
                UNISYS_inputs.dev_opts.plot.colorbar_bullseyes=2;
            end
            
            %dev_opts.clrmap
            %dev_opts.clrmap.numplotsperrow
            if ~isempty(self_UNISYS.intAct.clrmap_val_numplotsperrow.String) && ~isnan(str2double(self_UNISYS.intAct.clrmap_val_numplotsperrow.String))
                UNISYS_inputs.dev_opts.clrmap.numplotsperrow=str2double(self_UNISYS.intAct.clrmap_val_numplotsperrow.String);
            end
            
            %dev_opts.clrmap.numrows
            if ~isempty(self_UNISYS.intAct.clrmap_val_numrows.String) && ~isnan(str2double(self_UNISYS.intAct.clrmap_val_numrows.String))
                UNISYS_inputs.dev_opts.clrmap.numrows=str2double(self_UNISYS.intAct.clrmap_val_numrows.String);
            end
                        
            %dev_opts.clrmap.steps
            if ~isempty(self_UNISYS.intAct.clrmap_val_steps.String) && ~isnan(str2double(self_UNISYS.intAct.clrmap_val_steps.String))
                UNISYS_inputs.dev_opts.clrmap.steps=str2double(self_UNISYS.intAct.clrmap_val_steps.String);
            end
            
            %dev_opts.clrmap.map
            UNISYS_inputs.dev_opts.clrmap.map= self_UNISYS.intAct.clrmap_val_map.String{self_UNISYS.intAct.clrmap_val_map.Value};
            
            %dev_opts.clrmap.map_spec
            if strcmp(self_UNISYS.intAct.clrmap_val_map.String{self_UNISYS.intAct.clrmap_val_map.Value},'custom')
                UNISYS_inputs.dev_opts.clrmap.map_spec=color_custom;
            end
                
            %dev_opts.clrmap.flipud
            if strcmp(self_UNISYS.intAct.clrmap_val_flipud.String{self_UNISYS.intAct.clrmap_val_flipud.Value},'Yes')
                UNISYS_inputs.dev_opts.clrmap.flipud=1;
            elseif strcmp(self_UNISYS.intAct.clrmap_val_flipud.String{self_UNISYS.intAct.clrmap_val_flipud.Value},'No')
                UNISYS_inputs.dev_opts.clrmap.flipud=0;
            end
            
            %dev_opts.clrmap.lims
            if ~isempty(self_UNISYS.intAct.clrmap_val_lims_lower.String) && isempty(self_UNISYS.intAct.clrmap_val_lims_higher.String) && ~isnan(str2double(self_UNISYS.intAct.clrmap_val_lims_lower.String)) && isnan(str2double(self_UNISYS.intAct.clrmap_val_lims_lower.String))
                UNISYS_inputs.dev_opts.clrmap.lims= [str2double(self_UNISYS.intAct.clrmap_val_lims_lower.String) str2double(self_UNISYS.intAct.clrmap_val_lims_higher.String)];
            end
            
            %dev_opts.clrmap.identical
            if strcmp(self_UNISYS.intAct.clrmap_val_identical.String{self_UNISYS.intAct.clrmap_val_identical.Value},'Yes')
                UNISYS_inputs.dev_opts.clrmap.identical=1;
            elseif strcmp(self_UNISYS.intAct.clrmap_val_identical.String{self_UNISYS.intAct.clrmap_val_identical.Value},'No')
                UNISYS_inputs.dev_opts.clrmap.identical=0;
            end
            
            %dev_opts.clrmap.symmetrical
            if strcmp(self_UNISYS.intAct.clrmap_val_symmetrical.String{self_UNISYS.intAct.clrmap_val_symmetrical.Value},'Yes')
                UNISYS_inputs.dev_opts.clrmap.symmetrical=1;
            elseif strcmp(self_UNISYS.intAct.clrmap_val_symmetrical.String{self_UNISYS.intAct.clrmap_val_symmetrical.Value},'No')
                UNISYS_inputs.dev_opts.clrmap.symmetrical=0;
            end
            
            %dev_opts.clrmap.isolines
            if strcmp(self_UNISYS.intAct.clrmap_val_isolines.String{self_UNISYS.intAct.clrmap_val_isolines.Value},'Yes')
                UNISYS_inputs.dev_opts.clrmap.isolines=1;
            elseif strcmp(self_UNISYS.intAct.clrmap_val_isolines.String{self_UNISYS.intAct.clrmap_val_isolines.Value},'No')
                UNISYS_inputs.dev_opts.clrmap.isolines=0;
            end
            
            %dev_opts.clrmap.alpha
            if ~isempty(self_UNISYS.intAct.clrmap_val_alpha.String) && ~isnan(str2double(self_UNISYS.intAct.clrmap_val_alpha.String)) 
                UNISYS_inputs.dev_opts.clrmap.alpha= str2double(self_UNISYS.intAct.clrmap_val_alpha.String);
            end            
                    
            %dev_opts.save
            %dev_opts.save.savefile
            if strcmp(self_UNISYS.intAct.val_save.String{self_UNISYS.intAct.val_save.Value},'Yes')
                UNISYS_inputs.dev_opts.save.savefile=1;
            elseif strcmp(self_UNISYS.intAct.val_save.String{self_UNISYS.intAct.val_save.Value},'No')    
                UNISYS_inputs.dev_opts.save.savefile=0;
            end
            
            %dev_opts.save.fig
            UNISYS_inputs.dev_opts.save.fig=self_UNISYS.intAct.val_savefig.Value;         
            
            %dev_opts.save.png
            UNISYS_inputs.dev_opts.save.png=self_UNISYS.intAct.val_savepng.Value;
            
            %dev_opts.save.savename
            UNISYS_inputs.dev_opts.save.savename=self_UNISYS.intAct.val_savename.String;
            
            putInSelf
    end
        
        % Create close-button
        function CloseButtonPushed(self_UNISYS, ~, varargin)
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

