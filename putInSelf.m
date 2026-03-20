% Put all necessary variables into one struct
varnames=whos;

if exist('self','var')
    self.vars_exclude={'i','self','varargin','fnames'};
    for i=1:length(varnames)
        if ~ismember(varnames(i).name,self.vars_exclude)
            eval(['self.data.' varnames(i).name '=' varnames(i).name ';']);
        end
    end
end
if exist('self_UNISYS','var')
    self_UNISYS.vars_exclude={'i','self','varargin','fnames'};
    for i=1:length(varnames)
        if ~ismember(varnames(i).name,self_UNISYS.vars_exclude)
            eval(['self_UNISYS.data.' varnames(i).name '=' varnames(i).name ';']);
        end
    end
end
