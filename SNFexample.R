## First, set all the parameters:
K = 20; # number of neighbors, usually (10~30)
alpha = 0.5; # hyperparameter, usually (0.3~0.8)
T = 20; # Number of Iterations, usually (10~20)

## Data1 is of size n x d_1,
## where n is the number of patients, d_1 is the number of genes,
## Data2 is of size n x d_2,
## where n is the number of patients, d_2 is the number of methylation
data(Data1)
data(Data2)


## Here, the simulation data (SNFdata) has two data types. They are complementary to each other.
## And two data types have the same number of points.
## The first half data belongs to the first cluster; the rest belongs to the second cluster.
truelabel = c(matrix(1,100,1),matrix(2,100,1)); ## the ground truth of the simulated data

## Calculate distance matrices
## (here we calculate Euclidean Distance, you can use other distance, e.g,correlation)
## If the data are all continuous values, we recommend the users to perform
## standard normalization before using SNF,
## though it is optional depending on the data the users want to use.
# Data1 = standardNormalization(Data1);
# Data2 = standardNormalization(Data2);

## Calculate the pair-wise distance;
## If the data is continuous, we recommend to use the function "dist2" as follows
Dist1 = dist2(as.matrix(Data1),as.matrix(Data1));
Dist2 = dist2(as.matrix(Data2),as.matrix(Data2));

## next, construct similarity graphs
W1_ = affinityMatrix(Dist1, K, alpha)
W2_ = affinityMatrix(Dist2, K, alpha)

## These similarity graphs have complementary information about clusters.
par(mfrow=c(1,3))

displayClusters(W1_,truelabel);
displayClusters(W2_,truelabel);

## next, we fuse all the graphs
## then the overall matrix can be computed by similarity network fusion(SNF):
W_ = SNF(list(W1_,W2_), K, T)

## With this unified graph W of size n x n,
## you can do either spectral clustering or Kernel NMF.
## If you need help with further clustering, please let us know.
## You can display clusters in the data by the following function
## where C is the number of clusters.
C = 2 # number of clusters


## You can get cluster labels for each data point by spectral clustering
labels = spectralClustering(W_, C)

displayClusters(W_, labels)


plot(Data1, col=labels, main='Data type 1')
plot(Data2, col=labels, main='Data type 2')

# Use NMI to measure the goodness of the obtained labels.
NMI = calNMI(labels,truelabel);

