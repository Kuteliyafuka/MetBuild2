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
# 加载所需的包
library(MetBuild2)  # 假设MetBuild2是一个用于甲基化数据分析的包
library(glmnet)     # 用于LASSO和ElasticNet模型的包

# 设置需要下载的GEO数据集名称
datasets_names <- c("GSE67705", "GSE52588")

# 下载所需的GEO数据，返回列表形式的geo数据
geo_data <- MetDataDownload(datasets_names)

# 初始化空列表以存储beta值
beta_value_list <- list()

# 从下载的GEO数据中提取所需的x数据（例如甲基化beta值）
extracted_list <- MetDataExtract_x(geo_data)

# 将提取的数据合并成一个数据集，以便后续的特征选择
mergedData_for_selection <- MetDataMerge(extracted_list)

# 在合并的数据集中选择前45个CpG位点（特征选择）
selected_CpGs <- CpGs_select(mergedData = mergedData_for_selection, top_CpGs_number = 45)

# 初始化另一个空列表以存储经过选择的beta值
beta_value_list <- list()

# 根据选择的CpGs提取相应的甲基化beta值
extracted_list <- MetDataExtract(geo_data, selected_CpGs)

# 合并提取的beta值数据，生成最终的数据集
mergedData <- MetDataMerge(extracted_list)

# 对合并的数据集进行分区，划分为训练集和测试集
PartitionedData <- MetDataPartition(mergedData)

# 使用ElasticNet进行模型训练，得到ElasticNet模型
ElasticNetModel <- MetDataTrainElasticNet(PartitionedData)

# 从分区后的数据中提取训练集，并将其转换为矩阵形式（去除第一列标签列）
trainSet <- PartitionedData[['trainSet']]
beta_matrix_train <- as.matrix(trainSet[, -1])

# 使用交叉验证的方式训练ElasticNet模型，选择最佳正则化参数lambda
glmnet.Training.CV <- glmnet::cv.glmnet(
  beta_matrix_train,               # 输入特征矩阵（训练集）
  PartitionedData[['age_train']],  # 训练集的年龄标签
  nfolds = 10,                     # 10折交叉验证
  alpha = 0.5,                     # ElasticNet参数（alpha=0.5，0是Ridge，1是LASSO）
  family = "gaussian"              # 线性回归模型（用于连续型变量）
)

# 从交叉验证结果中获取最佳的lambda值（最小的交叉验证误差对应的lambda）
lambda.glmnet.Training <- glmnet.Training.CV$lambda.min

# 对ElasticNet模型进行评估，使用分区后的数据
result <- MetDataModelEvaluation(ElasticNetModel, PartitionedData)

```
![image-20240902090502729](https://github.com/user-attachments/assets/292a945e-a568-4bb0-bd96-b4dd35b95187)

the figure above shows the result of evaluation of the elastic net model based on 6 CpG sites.
