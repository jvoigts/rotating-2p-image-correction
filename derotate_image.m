function [I_ur, I_mask] = derotate_image(I,line_angles,rot_center);

line_angles=rad2deg(line_angles);

[Nlines Ncols]=size(I);
[X,Y] = meshgrid(1:Ncols,1:Nlines);

for t=1:Nlines
    % add translation offsets
    %X(t,:)=X(t,:)+ofs(1,t);
    %Y(t,:)=Y(t,:)+ofs(2,t);
    
    % add rotation
    [xr yr]=rot(X(t,:), Y(t,:),rot_center,line_angles(t));
    X(t,:)=xr;
    Y(t,:)=yr;
end;

[Xknown,Yknown] = meshgrid(1:Ncols,1:Nlines);

for t=1:Nlines
    
    % add rotation
    [xr yr]=rot(Xknown(t,:), Yknown(t,:),rot_center,line_angles(t));
    Xknown(t,:)=xr;
    Yknown(t,:)=yr;
end;


X=max(1,min(X,Ncols));
Y=max(1,min(Y,Nlines));

% make fwd transformed image
%I_t=I_in(sub2ind(size(I_in),round(Y),round(X)));

%better brute force this, but with subsampling
subs=100;

igrid=[1:subs:size(X,1),size(X,1)];
jgrid=[1:subs:size(X,2),size(X,2)];
Xlow=zeros(Nlines,Ncols);
Ylow=zeros(Nlines,Ncols);
pixel_closeness=zeros(Nlines,Ncols);

for i=igrid
    for j=jgrid
        [d,m] =min( ((Xknown(:)-j).^2 + (Yknown(:)-i).^2) );
        [Xlow(i,j),Ylow(i,j)] = ind2sub(size(X),m);
        pixel_closeness(i,j) = d;
    end;
end;
[xqlow, yqlow]=meshgrid(jgrid,igrid);
[Xq,Yq] = meshgrid(1:Ncols,1:Nlines);

Xh=interp2(xqlow,yqlow,Xlow(igrid,jgrid),Xq,Yq);
Yh=interp2(xqlow,yqlow,Ylow(igrid,jgrid),Xq,Yq);
%pixel_closeness_h=interp2(xqlow,yqlow,pixel_closeness(igrid,jgrid),Xq,Yq);
Xh=max(1,min(Xh,Nlines));
Yh=max(1,min(Yh,Ncols));

%I_ur=I_t(sub2ind(size(I_t),round(Xh),round(Yh)));

I_ur=interp2(Xq,Yq,I,Yh,Xh,'nearest');
%I_ur=interp2(Xq,Yq,I_t,Yh,Xh);

%I_ur(pixel_closeness_h>(1*subs))=0;

I_mask=1+(I*0);
%I_mask(pixel_closeness_h>(1*subs))=0;