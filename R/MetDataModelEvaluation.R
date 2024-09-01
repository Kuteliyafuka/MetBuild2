#' Model evaluation
#' @description
#' predict age with the model constructed
#'
#'
#' @param model model constructed in the last step
#' @param beta_matrix_train beta value matrix
#' @param age_train numeric vector
#' @param beta_matrix_test beta value matrix
#' @param age_test numeric vector
#' @return results list
#' @export
#' @examples
#' MetDataModelEvaluation(glmnet.Training,beta_matrix_test,beta_matrix_train,trainSet,testSet)
#'

MetDataModelEvaluation <- function(glmnet.Training,PartitionedData){
  library(ggplot2)

  trainSet <- PartitionedData[['trainSet']]
  beta_matrix_train <- as.matrix(trainSet[,-1])
  testSet <- PartitionedData[['testSet']]
  beta_matrix_test <- as.matrix(testSet[,-1])
  number_CpGs <- ncol(trainSet)-1
  #因为加上了多元线性回归，所以这里需要写个if来做判断
  DNAmAgeBasedOnTraining_test=predict(glmnet.Training,beta_matrix_test,type="response",s=lambda.glmnet.Training)
  DNAmAgeBasedOnTraining_train=predict(glmnet.Training,beta_matrix_train,type="response",s=lambda.glmnet.Training)
  #合并数据,做一些微调并做图
  merge_train <- merge(DNAmAgeBasedOnTraining_train,trainSet,by = "row.names")
  merge_test <- merge(DNAmAgeBasedOnTraining_test,testSet,by = "row.names")
  colnames(merge_train)[2:3] <- c("predicted","chronogical")
  colnames(merge_test)[2:3] <- c("predicted","chronogical")
  #计算R方和MAE
  regression_train <- lm(data = merge_train, predicted~chronogical)
  regression_test <- lm(data = merge_test, predicted~chronogical)
  r_squared_train <- summary(regression_train)$r.squared
  r_squared_test <- summary(regression_test)$r.squared

  merge_train$error <- merge_train$chronogical - merge_train$predicted
  merge_test$error <- merge_test$chronogical - merge_test$predicted
  MAE_train <- mean(abs(merge_train$error))
  MAE_test <- mean(abs(merge_test$error))



  plot_1 <- ggplot2::ggplot()+
    ggplot2::geom_point(data = merge_train, mapping = aes(x = predicted, y =chronogical),)+
    ggplot2::geom_smooth(data = merge_train, mapping = aes(x = predicted, y =chronogical),method = "lm")+
    ggplot2::annotate("text",x=55,y=22,label = paste("R square =",round(r_squared_train,3)))+
    ggplot2::annotate("text",x=55,y=15,label = paste("MAE =",round(MAE_train,2)))+
    ggplot2::labs(title = paste(number_CpGs,"CpGs Predictor in TrainSet"), color = 'Legend')

  plot_2 <- ggplot2::ggplot()+
    ggplot2::geom_point(data = merge_test, mapping = aes(x = predicted, y =chronogical),)+
    ggplot2::geom_smooth(data = merge_test, mapping = aes(x = predicted, y =chronogical),method = "lm")+
    ggplot2::annotate("text",x=55,y=22,label = paste("R square =",round(r_squared_test,3)))+
    ggplot2::annotate("text",x=55,y=15,label = paste("MAE =",round(MAE_test,2)))+
    ggplot2::labs(title = paste(number_CpGs,"CpGs Predictor in TestSet"), color = 'Legend')

  predicted_results <- list(merge_train,merge_test,plot_1,plot_2)

  ggsave("train.png",plot = plot_1)
  ggsave("test.png",plot = plot_2)
  return(predicted_results)
}



