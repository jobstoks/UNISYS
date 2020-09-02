% Creating a voltage colour map

red = [0.6353 0.0784 0.1843];
red2 = [1 0.4 0.4];
yellow = [1 0.8 0.2];
green = [0 0.6 0.6];
blue = [0.6 0.8 1];
blue2 = [0.2 0.2 1];

purple = [0.6 0 1];
pink = [0.8 0 0.8];

cmap_uyen = [red;red2;yellow;green;blue;blue2;purple];

D = cmap_uyen;
N = 10; % elements

    nD      = size(D,1); 
    x       = 1:nD;
    dN      = (nD-1)/N;
    xi      = 1:dN:nD;
    Di(:,1) = interp1(x',D(:,1),xi','pchip');
    Di(:,2) = interp1(x',D(:,2),xi','pchip');    
    Di(:,3) = interp1(x',D(:,3),xi','pchip'); 
    D       = Di;

cmap_uyen = D;    
    
save cmap_uyen cmap_uyen