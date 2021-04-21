function [XY_grid_dense,segment_labels_corrected]=define_XY_grid_dense(numlines,numpointsperline,segments,numsegments)

if ~exist('numsegments','var')
    numsegments=24;
end

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

if numsegments==20
    segment_labels(segment_labels==4)=1;
    segment_labels(segment_labels==10)=7;
    segment_labels(segment_labels==16)=13;
    segment_labels(segment_labels==22)=19;
    
    segment_labels_corrected=segment_labels;
    j=0;
    for i=1:max(segment_labels)
        %     i
        %     j
        if sum(segment_labels==i+j)==0
            %        'yes'
            segment_labels_corrected(segment_labels==i+1+j)=i;
            %        [num2str(i+j+1) ' becomes ' num2str(i)]
            %        [num2str(sum(segment_labels==i+1+j)) ' values were changed']
            j=j+1;
        else
            %        'no'
            segment_labels_corrected(segment_labels==i+j)=i;
            %        [num2str(i+j) ' becomes ' num2str(i)]
            %        [num2str(sum(segment_labels==i+j)) ' values were changed']
        end
    end
else
    segment_labels_corrected=segment_labels;
end
end
