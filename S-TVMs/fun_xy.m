function f=fun_xy(x,a1,a2)
% rotate along x-axis to let two points have the same y(for 2D-plane)
z1=cos(x)*a1(2)-sin(x)*a1(3); z2=cos(x)*a2(2)-sin(x)*a2(3);
f=z1-z2;
end