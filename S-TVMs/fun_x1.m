function f=fun_x1(x,a1,a2)
% rotate along x-axis to let two points have the same z(for 2D-plane)
z1=sin(x)*a1(2)+cos(x)*a1(3); z2=sin(x)*a2(2)+cos(x)*a2(3);
f=z1-z2;
end