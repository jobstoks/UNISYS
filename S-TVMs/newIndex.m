function [vertices_n, faces_n, mapping_faces] = newIndex(mapping, vertices, faces)
%   input arguments:
%       mapping - the mapping relatinoship between the new indexes and old indexes, n x 2 (e.g., [1,10;2,5;3,9])
%       vertices - the positions of the points
%       faces - the connections among these vertices
%
%   output arguments:
%       vertices_n - the new vertices
%       faces_n - the new faces
%
%   examples:
%       [vertices_n, faces_n] = myFunctionName(mapping, vertices, faces); 
%
%   NOTES:
%
%   Author information:
%       tiantian wang (tiantian211231@163.com), 26.02.2026


% Input argument validation
if nargin < 3
    error('At least three input arguments are required!');
end

% Main function
% 新顶点
vertices_n = vertices(mapping(:,2),:);

% ---- 核心优化：构建查找表 ----
max_idx = max(faces(:));   
lookup = zeros(max_idx,1);
lookup(mapping(:,2)) = mapping(:,1);

faces_mapped = lookup(faces);
% ---- 找到合法的 faces（3个点都存在映射）----
valid = all(faces_mapped > 0, 2);

faces_n = faces_mapped(valid,:);

% ---- mapping_faces ----
M = find(valid);
mapping_faces = [(1:numel(M))', M];

end
