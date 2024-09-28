# MetBuild2

# Introduction

MetBuild2 is designed for DNA methylation age predictor construction based on personalized CpG sites and GEO datasets.

Though there have already been many methylation age prediction website tools, they are constructed for universal applicability in most tissues, resulting in possible inaccuracy to specific tissues. Moreover, they require data from a large amount of CpG sites, usually produced from illumina 450K/850K array with high cost. 

This MetBuild2 aims to provide convenience for cost-effective methylation detection,such as BBA-seq and pyrosequencing, to predict age by sacrificing accuracy for reduction of labor and cost in an acceptable way.

# Example

- MetBuild2 allows three linear models including multiple regression, lasso and elastic net
- To build a model, user needs to choose the GEO datasets and CpG sites first.
- To predict age, user needs to input β_value_matrix of their own samples(row names are samples' names, col names are probe ID)



```
library(MetBuild2)
library(glmnet)

datasets_names <- c("GSE67705","GSE52588")

geo_data <- MetDataDownload(datasets_names)
beta_value_list = list()
extracted_list <- MetDataExtract_x(geo_data)
mergedData_for_selection <- MetDataMerge(extracted_list)
selected_CpGs <- CpGs_select(mergedData = mergedData_for_selection,top_CpGs_number = 45)

beta_value_list = list()
extracted_list <- MetDataExtract(geo_data,selected_CpGs)
mergedData <- MetDataMerge(extracted_list)

PartitionedData <- MetDataPartition(mergedData)
ElasticNetModel <- MetDataTrainElasticNet(PartitionedData)
trainSet <- PartitionedData[['trainSet']]
beta_matrix_train <- as.matrix(trainSet[,-1])
glmnet.Training.CV = glmnet::cv.glmnet(beta_matrix_train, PartitionedData[['age_train']], nfolds=10,alpha = 0.5,family="gaussian")
lambda.glmnet.Training = glmnet.Training.CV$lambda.min
result <- MetDataModelEvaluation(ElasticNetModel,PartitionedData)
```
![image-20240902090502729](https://github.com/user-attachments/assets/292a945e-a568-4bb0-bd96-b4dd35b95187)

the figure above shows the result of evaluation of the elastic net model based on 6 CpG sites.
