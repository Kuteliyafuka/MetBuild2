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

selected_CpGs <- c('cg22345769','cg00329615','cg19283806','cg11807280','cg16867657','cg18618815')
datasets_names <- c("GSE67705","GSE52588","GSE77445","GSE41169","GSE32148")
#数据下载及预处理
geo_data <- MetDataDownload(datasets_names)
extracted_list <- MetDataExtract(geo_data,selected_CpGs = selected_CpGs)
mergedData <- MetDataMerge(extracted_list)
#模型训练
PartitionedData <- MetDataPartition(mergedData)
ElasticNetModel <- MetDataTrainElasticNet(PartitionedData)
LassoModel <- MetDataTrainLasso(PartitionedData)
MultiRegressionModel<- MetDataTrainMultiRegression(PartitionedData)
#模型评估并进行年龄预测
result <- MetDataModelEvaluation(model_name,PartitionedData)
predicted_age <- predict(model_name,your_β_value_matrix)
```
![image-20240902090502729](https://github.com/user-attachments/assets/292a945e-a568-4bb0-bd96-b4dd35b95187)

the figure above shows the result of evaluation of the elastic net model based on 6 CpG sites.
