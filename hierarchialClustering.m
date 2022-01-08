%hierarchical clustering
ar = [[5 10 15;
    10 15 30;
    10 10 25];
    [10 10 15;
    5 20 15;
    10 5 30];
    [5 5 15;
    30 10 5;
    30 10 10]]

z = linkage(ar,"centroid","cityblock")
dendrogram(z)