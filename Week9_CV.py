#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Week 9
'''1. Below is shown a template T and an image I . Calculate the result of performing template matching on 
the image, and hence, suggest the location of the object depicted in the template assuming that there is 
exactly one such object in the image. Use the following similarity measures (a) normalised cross-correlation 
(b) sum of absolute differences.'''
# template matching

T = np.array([
    [100, 150, 200],
    [150, 10, 200],
    [200, 200, 250]
])

I = np.array([
    [60, 50, 40, 40],
    [150, 100, 100, 80],
    [50, 20, 200, 80],
    [200, 150, 150, 50]
])

T2 = np.sqrt(np.square(T).sum())
t0 = T.shape[0]
t1 = T.shape[1]
for i in range(I.shape[0] - t1 + 1):
    for j in range(I.shape[1] - t1 + 1):
        im = I[i:i+t0, j:j+t1]
        print(im)
        im2 = np.sqrt(np.square(im).sum())
        print("similarity (Cross correlation):", round((T * im).sum(), 2))
        print("similarity (Norm cross correlation):", round((T * im).sum()/(T2*im2), 2))
        print("similarity (Correlation coefficient):", 
              round(((T-T.mean()) * (im-im.mean())).sum()/
                    (np.sqrt(np.square(T-T.mean()).sum()) * 
                             np.sqrt(np.square(im-im.mean()).sum())), 2))
        print("sum of abs 'distance':", np.abs(T - im).sum())
        print()


# In[ ]:


'''Q3) Below are shown three binary templates T1, T2 and T3 together with a patch I of a binary 
image. Determine which template best matches the image patch using the following similarity 
measures (a) cross-correlation, (b) normalised cross-correlation, (c) correlation coefficient, 
(d) sum of absolute differences.
'''

T = [[1,1,1],[1,0,0],[1,1,1]]

I1 = [[1,1,1],[1,0,0],[1,1,1]]
I2 = [[1,0,0],[1,0,0],[1,1,1]]
I3 = [[1,1,1],[1,0,1],[1,1,1]]
#I4 = [[1,1,0],[0,1,0],[1,1,0]]

# Change image for values I1,I2.....
image = I1
template = T

image = np.array(image)
template = np.array(template)

#normalised cross correlation
ncc = sum(sum(np.array(image)*np.array(template)))/(np.linalg.norm(template)*np.linalg.norm(image))
print('Normalised Cross Correlation: ',ncc)

#cross correlation
cc = ncc * (np.linalg.norm(template)*np.linalg.norm(image))
print('Cross Correlation: ', cc)

#corrlation coefficient
mean_centered_image = np.array(image)-np.mean(np.array(image))
mean_centered_template = np.array(template)-np.mean(np.array(template))  
mean_centered_dot = (mean_centered_image)*(mean_centered_template)
coeff = mean_centered_dot / ((np.linalg.norm(mean_centered_template)*np.linalg.norm(mean_centered_image)))
print('Correlation Coefficient: ', sum(sum(coeff)))


#sum of squared difference
sum_diff = sum(sum((image - template)*(image-template)))
print('Sum of Sqared Difference: ', sum_diff)

#euclidean distance
euc_dist = sqrt(sum_diff)
print('Euclidean Distance: ', euc_dist)

#sum of absolute distance
abs_dist = sum(sum((abs(image - template))))
print('Absolute Distance: ', abs_dist)

#average distance
avg_dist = sum(sum(abs((image - template))))/9
print('Average Distance: ', avg_dist)
print(abs(image - template))


# In[ ]:


'''Q7) 7. In a simple bag-of-words object recognition system images are represented by 
histograms showing the number of occurrences of 10 “codewords”. The number of occurrences of
the codewords in three training images are given below: ObjectA = (2,0,0,5,1,0,0,0,3,1)'''

# bag of words

I = np.array([2, 1, 1, 0, 1, 1, 0, 2, 0, 1])
features = np.array([
    [2, 0, 0, 5, 1, 0, 0, 0, 3, 1],
    [0, 0, 1, 2, 0, 3, 1, 0, 1, 0],
    [1, 1, 2, 0, 0, 1, 0, 3, 1, 1]
])

for f in features:
    print("Norm cross correlation:",
        round((f * I).sum()/(np.sqrt(np.square(f).sum())*np.sqrt(np.square(I).sum())), 2))

