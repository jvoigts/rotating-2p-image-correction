Isize=200;
I=randn(Isize,Isize).*0.1+eye(Isize)+flipud(eye(Isize));
I(1:10:end,:)=I(1:10:end,:)+.2;
I(:,1:10:end)=I(:,1:10:end)+.2;
line_angles=10+cos(linspace(0,30,Isize)).*5;
rot_center=[.5 .5].*Isize;
[I_ur, I_mask] = derotate_image(I,line_angles,rot_center);
imagesc(I_ur.*I_mask)