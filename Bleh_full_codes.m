%Region growing DON'T calculate average!
%Region merging calculate new average!

laplacian = [-1,-1,-1;-1,8,-1;-1,-1,-1];

%SAD
img1 = [1,1,1,1,1,1,1,1,1];
img2 = [1,1,1,1,0,1,1,1,1];
difference = img1 - img2;
absolute = abs(difference);
result = sum(absolute(:));

%Cross corr no ;
t = [1,1,1,1,1,1,1,1,1]; %mask
i=[1,1,1,1,0,1,1,1,1]; %image

topSum = 0;

for x=1:length(t)
    topSum = topSum + (t(x)*i(x));
end

crossCorr = topSum;

%Normalised Cross Corr no ;
t = [1,1,1,1,0,1,1,1,1]; %mask
i=[0.5,0.9,1.0,0.6,0,0.7,0,0,0.6]; %image

topSum = 0;
tsum = 0;
isum=0;

for x=1:length(t)
    topSum = topSum + (t(x)*i(x));
    tsum= tsum + t(x)^2;
    isum= isum + i(x)^2;
end

normalCrossCorr = topSum/( sqrt(tsum) * sqrt(isum) );

%Correlation Coefficient no ;
t = [0,1,0,0,1,0,0,0,0,1,0,1,1,0,1,0]; %mask
i=[0,0,0,0,1,0,1,0,1,1,1,0,0,1,0,0]; %image

topSum = 0;
tsum = 0;
isum=0;

for x=1:length(t)
    topSum = topSum + (( t(x) - mean( t ) ) * (i(x) - mean( i ) ));
    tsum= tsum + ( t(x) - mean(t) )^2;
    isum= isum + ( i(x) - mean(i) )^2;
end

corrCoefficient = topSum/( sqrt(tsum) * sqrt(isum) );


%Euclidean distance
t = [1,1,1,1,0,1,1,1,1]; %mask
i=[0.5,0.9,1.0,0.6,0,0.7,0,0,0.6]; %image

topSum = 0;

for x=1:length(t)
    topSum = topSum + (t(x)-i(x))^2;
end

eulideanDistance = sqrt(topSum);



%Depth from Velocity in x direction
x_before = 3;
x_after = 2;
pixel_size = 0.00015;
focal_length = 0.03;
velocity=0.2;
time_between_x_before_and_after = 0.1;
velocity_of_image_point = (x_after-x_before)/time_between_x_before_and_after;
converted_velocity = velocity_of_image_point * pixel_size;
z = ((-focal_length*velocity)/converted_velocity); %Be careful minus might have to go outside

%Depth from Velocity in z direction
centre_of_image=[50,50];
x_before = 64-centre_of_image(1);
x_after = 76-centre_of_image(1);
velocity=0.4;
time_between_x_before_and_after = 0.5;
velocity_of_image_point = (x_after-x_before)/time_between_x_before_and_after;
z = (x_before*velocity)/velocity_of_image_point;

%Time-to-collision
ttc = x_before/velocity_of_image_point;


% With floating point calulation if the question says "assume the size of
% the output image is the same size as the input image" this means DO NOT
% TAKE AWAY ANY PIXELS! Use method below
input_mask_size = [11,11];
input_image_size =[300,200];
number_of_multiplications = input_mask_size(1) * input_mask_size(2);
number_of_additions = number_of_multiplications - 1;
operations =  (number_of_multiplications + number_of_additions ) * input_image_size(1) * input_image_size(2);

% Use below if we are not padding
input_mask_size = 11;
input_image_size =[300,200];
operations = ( input_mask_size^2 + (input_mask_size^2 - 1) ) * ( input_image_size(1) - input_mask_size + 1 ) * ( input_image_size(2) - input_mask_size + 1 );

%If it is seperable i.e. a gausian where we multiply by 1d and then 1d
%transposed
input_mask_size = [11,1];
input_image_size =[300,200];
number_of_multiplications = input_mask_size(1) * input_mask_size(2);
number_of_additions = number_of_multiplications - 1;
operations =  (number_of_multiplications + number_of_additions ) * input_image_size(1) * input_image_size(2) * 2;


%Grayscale Conversion
b = [208,233,71;231,161,140;32,24,245];
g = [247,245,36;40,124,107;248,204,234];
r = [202,9,173;245,217,193;167,239,190];
(b+g+r)/3;



%Convolve without rotation
mask = [0.1,0.5,1;0,0.1,0.3;0.4,0.6,0.2];
image = [0.01,0.09,0.01;0.09,0.64,0.09;0.01,0.09,0.01];
conv2(image, mask, 'same');

%Convolve with rotation
mask = [1,0;0,2];
image = [100,80,11;67,8,24;43,70,21];
rotatedMask = imrotate(mask, 180);
conv2(image, mask, 'same');



%Upsample
resized = imresize([177,243;81,8],[3,3],'Method','bilinear');



%Threshold
image = [112,203,114;97,47,165;195,125,181];
level=100;
image = image > level;



%Closing = Dilation + Erosion
%Opening = Erosion + Dilation 



%Pinhole calculation x'=(f' * x)/z
%Remember to convert to meters/millimeters
%Depth z is depth of 3d point
threed_point_x =  400;
focal_length = 30;
depth_z = 2500;
x_image = (threed_point_x * focal_length ) / depth_z;

threed_point_y =  500;
y_image = (threed_point_y * focal_length ) / depth_z;



%Thin lens equation 1/f = 1/z' + 1/z
%Calculate F
image_pane_depth = 30.36;
threed_point_depth = 2500;
focal_length = 1/( (1/abs(image_pane_depth)) + (1/abs(threed_point_depth)) );

%Calculate image pane depth 1/z' = 1/f-1/z
focal_length = 30;
threed_point_depth = 2500;
image_pane_depth = 1/( (1/abs(focal_length)) - (1/abs(threed_point_depth)) );



%Gaussian estimation
sigma=0.6;
mask_size=3;
fspecial('gaussian', mask_size, sigma)

%or use equation
x=0;
y=0;
sigma=0.6;
gaussian=(1/(2*pi*sigma^2)) * exp( -((x^2 + y^2)/(2*sigma^2) ));



%Magnification Factors
sizeOfArray = [12,12];
pixels = [800,600];
pixel_size_x = sizeOfArray(1)/pixels(1);
pixel_size_y = sizeOfArray(2)/pixels(2);
focal_length = 20;

magnification_x = -focal_length/pixel_size_x;
magnification_y = -focal_length/pixel_size_y;

%Where point in 3d space is in image
magification_x = -1333.3;
magification_y = -1000;

image_plane_x = 400; %principle point
image_plane_y = 300;

depth = 500;

point_x = 50;
point_y=50;
point_z=500;

(1/point_z) * [magification_x,0,image_plane_x;0,magification_y, image_plane_y;0,0,1] * [1,0,0,0;0,1,0,0;0,0,1,0] * [point_x;point_y;point_z;1];

%Hough transform
%We do it at points (x,y) where there is an edge only!
angle = degtorad( 90 );
x=2;
y=2;

r = ( y*cos(angle) ) - (x * sin(angle));


%Harris Corner Detector
ix = [1,0,-2;0,-1,0;0,-3,1];
iy = [2,1,-3;0,0,0;0,-2,1];

ix2 = ix.^2;
iy2 = iy.^2;
ixiy = ix .* iy;


%Gabor
x=0;
y=0;
angle = degtorad( 90 );
phase=0;
spatial=0;
freq=0;
sigma=0;

x_prime = (  x * cos(angle) ) + (y * sin(angle) );
y_prime = (  -x * sin(angle) ) + (y * cos(angle) );

gabor = exp( -1 * ( ( x_prime^2 + (spatial^2 * y_prime^2) )/ 2 * sigma^2) ) * cos( ( 2 * pi * x_prime * freq ) + phase );


%Agglomerative hierarchical clustering
dendrogram( linkage( [5,10,15;10,15,30;10,10,25;10,10,15;5,20,15;10,5,30;5,5,15;30,10,5;30,10,10], 'centroid');

function ssd = ssddist(v1, v2)
difference = v1 - v2;
absolute = abs(difference);
ssd = sum(absolute(:));
end

