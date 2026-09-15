function f=fun_yx(x,a1,a2)
% rotate along y-axis to let two points have the same z(for 2D-plane)
z1=cos(x)*a1(1)+sin(x)*a1(3); z2=cos(x)*a2(1)+sin(x)*a2(3);
f=z1-z2;
end
