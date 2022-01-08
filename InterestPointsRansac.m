clc;
clear;
% INTERST POINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

threshold = 20;
L = [0.1,0.6,0.0;
    1.0,0.5,0.7;
    0.8,0.7,1.0];

R = [0.3,1.0,0.0;
    0.0,0.0,0.5;
    0.8,0.5,0.1;
    0.3,0.9,0.6;
    0.5,0.9,0.9];

[x_L, y_L] = size(L);
[x_R, y_R] = size(R);

sim = zeros(x_L,x_R);
for i=1:x_L
    for j=1:x_R
        dif = sum(abs(L(i,:) - R(j,:)),'all');% Sum of abs differences
%         dif = sum(abs(L(i,:) - R(j,:)).^2,'all'); % sum of squared differences
%         dif = sqrt(sum(abs(L(i,:) - R(j,:)).^2,'all')); % euclidean distance
        sim(i,j) = dif;
        
        
    end
end
disp("The similarity between interest points is:")
disp("rows are left, columns are right")
sim

% FOR RANSAC 

% Calculate disparity by calculating translation from right to left
% which means for each L subtract the coordinates of its best match on
% the right. The best match is the minimum value in the rows of sim

Lc = [77,30;
    12,85;
    6,69];

Rc = [94,42;
    30,32;
    1,54;
    72,51;
    30,73];

% you must input the matches in this matrix manually
% first column is the index of the pixel on L and 
% second column is its best match (smallest distance) on R
% these are found on the similarity matrix produced above
M = [1,1;
    2,3;
    3,5];


translations = M;

[r,c] = size(M);

for i=1:r
        translations(i,:) = Lc(M(i,1),:) - Rc(M(i,2),:);
        
end

disp("The translation for each point is: ")
translations

[x,y] = size(translations);
cons = zeros(x,1);

for i=1:x
    disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    disp("Chosen Model for Point:")
    i
    disp("Coordinates:")
    Lc(i,:)
    model = translations(i,:);
    consensus = 0;
    for j=1:x
        if j ~= i
            disp(' ');
            disp("------Projecting point:-------")
            disp("Point Number:")
            j
            coordL = Lc(j,:)
            disp("Projection: ")
            coordProj = coordL - model
            disp("True match for this point: ")
            actual = Rc(M(j,2),:)
             dif = sqrt(sum(abs(coordProj - actual).^2));
%             dif = sum(abs(coordProj - actual));
            if dif < threshold 
                disp("******Point is an inlier*********")
                consensus = consensus +1 ;
            end
        end
    end
    disp(' ');
    disp("Consensus for this model is: ")
    consensus
    cons(i) = consensus;
end
disp("Consensus for all models is: ")
cons

% After this, find the point(model/translation) with the highest consensus
% Find all the points that were inliers and get their translations
% Average the translation of the inliers and the point in question
% This average is the best estimation of the model