function [xys2, G] = TEM(lines, lines_boun, faces, vertices, xy2, type)

G=graph(lines(:,1), lines(:,2)); L=full(laplacian(G));
M = L; nvert = size(L,1);
for k=lines_boun(:,1)'
    M(k,:) = zeros(1,nvert); M(k,k) = 1;
end

faces_sort = sort(faces,2);
nr_facesTwo = 0;
for i = setdiff(1:size(vertices,1),lines_boun(:,1))
    for j = 1:size(M,1)
        if M(i,j) ~= 0 && i~=j
            nr_facesTwo = nr_facesTwo +1;
        end
    end
end
if strcmp(type, 'median')
    facesTwo = nan(nr_facesTwo*2,3); id_facesTwo =1;
    for i = setdiff(1:size(vertices,1),lines_boun(:,1))
        for j = 1:size(M,1)
            if M(i,j) ~= 0 && i~=j
                facesTwo(id_facesTwo:id_facesTwo+1,:) = faces_sort(any(faces_sort==i,2) & any(faces_sort==j,2),:);
                id_facesTwo = id_facesTwo+2; angleAB = nan(2,1);
                % Median weight
                for q=1:2
                    v = setdiff(facesTwo(id_facesTwo-3+q,:), [i,j]);
                    iv = vertices(v,:) - vertices(i,:); liv = norm(iv);
                    jv = vertices(j,:) - vertices(i,:); ljv = norm(jv);
                    angleAB(q) = acos(dot(iv, jv) / (liv*ljv));
                end
                M(i,j) = (tan(angleAB(1)/2) + tan(angleAB(2)/2)) / norm(vertices(i,:)-vertices(j,:));
            end
        end
    end
end


if strcmp(type, 'Beltrami')
    % Laplace-Beltrami weights
    voronoiAreas = zeros(size(vertices,1),1);
    for i = 1:size(vertices, 1)
        facesIndices = sort([find(faces(:,1) == i); find(faces(:,2) == i); find(faces(:,3) == i)],1);
        for j = facesIndices'
            verticesIndices = setdiff(faces(j,:), i);
            kj = vertices(verticesIndices(1),:) - vertices(verticesIndices(2),:); lkj = norm(kj);
            ji = vertices(i,:) - vertices(verticesIndices(1),:); lji = norm(ji);
            ki = vertices(i,:) - vertices(verticesIndices(2),:); lki = norm(ki);
            alpha = acos(dot(ji, -kj) / (lji*lkj));
            beta = acos(dot(ki, kj) / (lki*lkj));
            voronoiAreas(i) = voronoiAreas(i) + (lji^2*cot(alpha) + lki^2*cot(beta)) / 8;
        end
    end

    facesTwo = nan(nr_facesTwo*2,3); id_facesTwo =1;
    for i = setdiff(1:size(vertices,1),lines_boun(:,1))
        for j = 1:size(M,1)
            if M(i,j) ~= 0 && i~=j
                facesTwo(id_facesTwo:id_facesTwo+1,:) = faces_sort(any(faces_sort==i,2) & any(faces_sort==j,2),:);
                id_facesTwo = id_facesTwo+2; angleAB = nan(2,1);
                for q=1:2
                    v = setdiff(facesTwo(id_facesTwo-3+q,:), [i,j]);
                    iv = vertices(i,:) - vertices(v,:); liv = norm(iv);
                    jv = vertices(j,:) - vertices(v,:); ljv = norm(jv);
                    angleAB(q) = acos(dot(iv, jv) / (liv*ljv));
                end
                M(i,j) = (cot(angleAB(1)) + cot(angleAB(2))) / (2*voronoiAreas(i));
            end
        end
    end
end

% compute the diagnal vertices
for i = setdiff(1:size(vertices,1),lines_boun(:,1))
    M(i,i) = -sum([M(i,1:i-1), M(i,i+1:end)]);
end

% compute the interior vertices
xys2 = zeros(nvert,size(xy2,2));
for coord = 1:size(xy2,2)
    x = zeros(nvert,1); x(lines_boun(:,1)) = xy2(lines_boun(:,1),coord);
    xys2(:,coord) = M\x; xys2(lines_boun(:,1),:)=xy2(lines_boun(:,1),:);
end


end