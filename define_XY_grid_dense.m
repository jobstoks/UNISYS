function [XY_grid_dense,segment_labels]=define_XY_grid_dense(numlines,numpointsperline,segments)

pointstepsize=1/numpointsperline;
minval=-pi;
maxval=pi;
stepsize=(maxval-minval)/numlines;
ind=1:numpointsperline;
rho1=nan(numlines*numpointsperline,1);
theta1=rho1;
for i=1:numlines
    theta1(ind)=repmat(minval+stepsize*i,[numpointsperline 1]);
    rho1(ind)=pointstepsize:pointstepsize:1;
    ind=ind+numpointsperline;
end
[XY_grid_dense(:,1),XY_grid_dense(:,2)] = pol2cart(theta1,rho1);
if nargin>2
    if segments
        
        num_radial_sections=3;
        num_circumferential_sections=8;
        
        segment_labels=nan(size(XY_grid_dense,1),1);
        theta_limits_stepsize=(2*pi)/num_circumferential_sections;
        theta_limits=-pi:theta_limits_stepsize:pi;
        rho_limits_stepsize=1/num_radial_sections;
        rho_limits=0:rho_limits_stepsize:1;
        
        loop=1;
        for i=1:length(diff(theta_limits))
            for j=1:length(diff(rho_limits))
                if i==1 && j~=1
                   ind=find(theta1>=theta_limits(i) & theta1<=theta_limits(i+1) & rho1>rho_limits(j) & rho1<=rho_limits(j+1));
                elseif i~=1 && j~=1
                   ind=find(theta1>theta_limits(i) & theta1<=theta_limits(i+1) & rho1>rho_limits(j) & rho1<=rho_limits(j+1));
                elseif i==1 && j==1
                    ind=find(theta1>=theta_limits(i) & theta1<=theta_limits(i+1) & rho1>=rho_limits(j) & rho1<=rho_limits(j+1));
                elseif i~=1 && j==1
                    ind=find(theta1>theta_limits(i) & theta1<=theta_limits(i+1) & rho1>=rho_limits(j) & rho1<=rho_limits(j+1));
                end
                segment_labels(ind)= loop;
                loop=loop+1;
            end
        end
    else
        segment_labels=nan(size(XY_grid_dense,1),1);
    end
else
    segment_labels=nan(size(XY_grid_dense,1),1);
end
end
