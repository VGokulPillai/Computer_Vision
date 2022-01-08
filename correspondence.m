clc;
clear;
% WORKS FOR ODD SIZES OF NEIGHBORHOODS
% You must input the neighborhood of the left point manually
% in variable p
p = [7,6,7;
    4,5,4;
    7,6,8];

I = [7,6,7,5;
    4,5,4,5;
    7,6,8,7];

sim = I;
I_copy = I;
[x,y] = size(p);

% PADDING
padding = floor(x/2);
I = padarray(I,[padding padding],0)

[rows,cols] = size(I);

for i=1+padding:rows-padding
    for j=1+padding:cols-padding
        sum = 0;
        for k = i-padding:i+padding
            for l = j-padding:j+padding
                I(k,l);
                p((k-i+(padding+1)),(l-j+(padding+1)));
                d = abs(I(k,l) - p((k-i+(padding+1)),(l-j+(padding+1)))); % for sum of squares and eucl add ^2
                sum = sum+d;
            end
        end
        sim(i-padding,j-padding) = sum; % for euclidean do sqrt(sum)
    end
end

disp("The similarity matrix is: ")
sim





% NO PADDING - CAN ALSO GET THE CENTRAL PART OF ABOVE
offset = floor(x/2);

I = I_copy;
[rows,cols] = size(I);
sim = I(1+offset:rows-offset,1+offset:cols-offset);

for i=1+offset:rows-offset
    for j=1+offset:cols-offset
        sum = 0;
        for k = i-offset:i+offset
            for l = j-offset:j+offset
                I(k,l);
                p((k-i+(offset+1)),(l-j+(offset+1)));
                d = abs(I(k,l) - p((k-i+(offset+1)),(l-j+(offset+1)))); % for sum of squares and eucl add ^2
                sum = sum+d;
            end
        end
        sim(i-offset,j-offset) = sum; % for euclidean do sqrt(sum)
    end
end
disp("The similarity matrix wihtout padding is: ")
sim

% TO find the RIGHT TO LEFT disparity find the most similar point in the matrix and
% subtract those coordinates from the coordinates of the point

