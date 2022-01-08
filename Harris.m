clc;
clear;

I = [1,0,0,0,0;
    0,1,0,0,0;
    1,1,1,0,0;
    0,0,0,0,0];

kappa =0.05;

derX = [-1,1];
derY = [-1;1];

% They could directly give us the following derivatives as matrices
Ix = conv2(I,derX,'same');
Iy = conv2(I, derY,'same');

H = [1,1,1;
    1,1,1;
    1,1,1];

Ix2 = Ix.^2;

Iy2 = Iy.^2;

IxIy = Ix.*Iy;

SIx2 = conv2(Ix2,H,'same');
SIy2 = conv2(Iy2,H,'same');
SIxIy = conv2(IxIy,H,'same');

R = (SIx2.*SIy2 - SIxIy.^2) - kappa*((SIx2+SIy2).^2)