function [lines_all,lines_boundary,B_ind]=boundaryVerticesAndallLines(F)

Lines = [F(:,[1 2]); F(:,[1 3]); F(:,[2 3])];
Lines = uint32(Lines);
Lines = sort(Lines, 2);

[lines_all, ~, ic] = unique(Lines, 'rows');
edgeCount = accumarray(ic, 1);
lines_boundary = lines_all(edgeCount == 1, :);
B_ind = unique(lines_boundary(:));

lines_all = double(lines_all);
lines_boundary = double(lines_boundary);
B_ind = double(B_ind);
end
