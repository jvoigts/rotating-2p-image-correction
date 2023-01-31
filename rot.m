function [X Y] = rot(X,Y,center,phi);

X=X-center(1);
Y=Y-center(2);

A=[X' Y'];

M=[cos(phi), -sin(phi) ; sin(phi), cos(phi)];

A=A*M;

X=A(:,1)+center(1);
Y=A(:,2)+center(2);