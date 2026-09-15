function [vm,N]=TPS3D(xy,noisyvals,xm,ym,zm,lambda)
[m,n]=size(xy);
D=nan(n,n);
for i=1:n
    for j=1:n
        D(i,j)=sqrt(sum((xy(:,i)-xy(:,j)).^2));
    end
end
U=D.^2.*log(D+eps);

T=[ones(1,n);xy];
A=[U+diag(lambda*ones(n,1)),T';T,zeros(m+1,m+1)];
B=[noisyvals,zeros(1,m+1)]';
X=inv(A)*B;
N = norm(A*X-B);

% 
b=X(1:n); a=X(n+1:n+m+1);
Xm=xm(:); Ym=ym(:); Zm=zm(:); v=[];
for ind=1:size(Xm,1)
    x=Xm(ind); y=Ym(ind); z=Zm(ind);
    for i=1:n
        d(i)=sqrt(sum(([x;y;z]-xy(:,i)).^2));
    end
    u=d.^2.*log(d+eps); 
    v(ind)=a'*[1;x;y;z] + u*b;
end
vm=[]; vm=reshape(v,size(xm));
end