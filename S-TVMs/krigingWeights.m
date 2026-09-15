function W = krigingWeights(knownLocations,unknownLocations)
%krigingWeights.m Computes the Kriging weights for a Kriging interpolation
% scheme


%Finding the distance between data points 
% l=1;
% for i = 1:size(knownLocations,1);
%     n=size(knownLocations,1)-i;
%     for j =1:n;
%         %varr(l)=(((DD(i)-DD(i+j)))^2)/2;
%         dist(l)=sqrt(((knownLocations(i,1)-knownLocations(i+j,1))^2)+((knownLocations(i,2)-knownLocations(i+j,2))^2)+((knownLocations(i,3)-knownLocations(i+j,3))^2));
%         l=l+1;
%     end
% end

%Finding the distance between sensor points and mesh coordinates
% for i =1:size(unknownLocations,1);
%    krdist_M_S(i,:)= sqrt(((knownLocations(:,1)-unknownLocations(i,1)).^2)+((knownLocations(:,2)-unknownLocations(i,2)).^2)+((knownLocations(:,3)-unknownLocations(i,3)).^2));
% end

%Finding Distance and the matrix to solve weights
%disp(['Looping through ' num2str(size(knownLocations,1)) ' known locations ...'])
for j = 1:size(knownLocations,1)
%    for k = j:size(knownLocations,1); 
%        if j==k;
%            matV(j,k)=0;
%        else
%            matV(j,k)=(sqrt(((knownLocations(j,1)-knownLocations(k,1))^2)+((knownLocations(j,2)-knownLocations(k,2))^2)+((knownLocations(j,3)-knownLocations(k,3))^2)));
%            matV(k,j)=matV(j,k);
%        end
%    end
   % matV(j,:)=(sqrt(((knownLocations(j,1)-knownLocations(:,1)).^2)+((knownLocations(j,2)-knownLocations(:,2)).^2)));
   % krdist_M_S(:,j)= sqrt(((knownLocations(j,1)-unknownLocations(:,1)).^2)+((knownLocations(j,2)-unknownLocations(:,2)).^2));
   matV(j,:)=(sqrt(((knownLocations(j,1)-knownLocations(:,1)).^2)+((knownLocations(j,2)-knownLocations(:,2)).^2)+((knownLocations(j,3)-knownLocations(:,3)).^2)));
   krdist_M_S(:,j)= sqrt(((knownLocations(j,1)-unknownLocations(:,1)).^2)+((knownLocations(j,2)-unknownLocations(:,2)).^2)+((knownLocations(j,3)-unknownLocations(:,3)).^2));
    
  
end

%
%Ordinary Kriging where weight add to 1 - w1+w2+..+wn=1;
matV(size(knownLocations,1)+1,:)=1;
matV(:,size(knownLocations,1)+1)=1;
matV(size(knownLocations,1)+1,size(knownLocations,1)+1)=0;

matVS=krdist_M_S;
matVS(:,size(knownLocations,1)+1)=1;
invMatV = inv(matV);
W =(matVS)*invMatV;
% for i =1:100%size(unknownLocations,1)
%     matVS=(krdist_M_S(i,:));
%     matVS(size(knownLocations,1)+1)=1;
%     W2(i,:)=(matVS)*inv(matV);
% end

% remove last row
W(:,end)=[];
%mesh_size = size(unknownLocations,1);

return
