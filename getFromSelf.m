% Get all necessary variables from self-struct

if exist('self','var')
    
    if isempty(self.data)
        errordlg('You did not initialize');
        return
    else
        fnames=fieldnames(self.data);
        for i=1:length(fnames)
            eval([fnames{i} '= self.data.(fnames{i});']);
        end
    end
end
if exist('self_UNISYS','var')
    
    if isempty(self_UNISYS.data)
        errordlg('You did not load any data');
        return
    else
        fnames=fieldnames(self_UNISYS.data);
        for i=1:length(fnames)
            eval([fnames{i} '= self_UNISYS.data.(fnames{i});']);
        end
    end
end
