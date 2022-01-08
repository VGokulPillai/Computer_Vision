import numpy as np

X = np.array([
    [5, 10, 15], [10, 15, 30], [10, 10, 25],
    [10, 10, 15], [5, 20, 15], [10, 5, 30],
    [5, 5, 15], [30, 10, 5], [30, 10, 10]
])

C = np.array([
    [5, 10, 15], [10, 10, 25]
])
C1 = C


K = C.shape[0]
while (C1 == C).all():
    D = np.empty((X.shape[0], K))
    for i, x in enumerate(X):
        for j, c in enumerate(C):
            d = dist(x, c)
            D[i, j] = d
    
    print(D)
    C1 = np.empty(C.shape)
    clusters = D.argmin(axis=1)
    print("Clusters:", clusters)
    for k in range(K):
        C1[k] = X[np.where(clusters==k)].mean(axis=0)