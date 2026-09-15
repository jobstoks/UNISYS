function mesh_value = krigingInterpolation(W,knownLocations,unknownLocations,Signals)
%krigingInterpolation.m Given kriging wieghts, interpolate signals from
%electrodes to nodes
% n=1;
% for i = 1:length(knownLocations);
%         data_cord(n,:)=knownLocations(i,:);
%         DD(n)=Signals(i);
%         n=n+1;
% end
% for i =1:mesh_size 
%     nn=0;
%     for j = 1:size(data_cord,1);
%         
%         nn=nn+ W(i,j)*DD(j);    
%     
%     end
%     mesh_value(i)=nn;
% end

%Solving for weights - matV*W=matVS
% mesh_value = W * Signals;

mesh_size = size(unknownLocations,1);
mesh_value = zeros(mesh_size, size(Signals,2));

for i =1:size(unknownLocations,1) 
    nn=0;
    for j = 1:size(knownLocations,1)
        nn=nn+ W(i,j)*Signals(j,:);       
    end
    mesh_value(i,:)=nn;
end

return

