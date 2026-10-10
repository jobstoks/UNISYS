function f=fun_zx(x,a1,a2)
% rotate along z-axis to let two points have the same x(for 2D-plane)
z1=cos(x)*a1(1)-sin(x)*a1(2); z2=cos(x)*a2(1)-sin(x)*a2(2);
f=z1-z2;
end
