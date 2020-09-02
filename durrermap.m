%
% return Durrer colormap
%
% $Id: durrermap.m,v 1.1 2012/08/19 15:02:16 potse Exp $
%

function D = durrermap(vargin)

  % set Durrer colormap (with brown)
  Dwb =[213,  106, 134;
       183,   95, 107;
       169,   78,  77;
       203,   87,  72;
       211,  125,  90;
       227,  186, 104;
       229,  223, 113;
       202,  189, 111;
       150,  182, 117;
       103,  150,  78;
       108,  164, 179;
       165,  192, 199;
       129,  158, 192;
        84,  115, 162;
        68,   63,  95;
       111,   89,  76;
       124,  115, 108;
        89,   86,  77;
        59,   49,  48]/255;
    
  
  % set Durrer colormap (without brown)
  Dwob =[213,  106, 134;
       183,   95, 107;
       169,   78,  77;
       203,   87,  72;
       211,  125,  90;
       227,  186, 104;
       229,  223, 113;
       202,  189, 111;
       150,  182, 117;
       103,  150,  78;
       108,  164, 179;
       165,  192, 199;
       129,  158, 192;
        84,  115, 162;
        68,   63,  95]/255;
    
  D   = Dwob;
    
  % interpolate to 15 colors, so that each color represents 10 ms
  nD  = size(D,1);
  nC  = 30;
  x   = [1:nD];
  xi  = [1:(nD-1)/(nC-1):nD];
  D   = interp1(x,D,xi);
    
   
  if (nargin==1) 
    % Create possibility of a denser colormap  
    % N should equal the number of map entries wanted
    nD      = size(D,1); 
    N       = vargin(1);
    x       = 1:nD;
    dN      = (nD-1)/N;
    xi      = 1:dN:nD;
    Di(:,1) = interp1(x',D(:,1),xi','pchip');
    Di(:,2) = interp1(x',D(:,2),xi','pchip');    
    Di(:,3) = interp1(x',D(:,3),xi','pchip'); 
    D       = Di;
  end
