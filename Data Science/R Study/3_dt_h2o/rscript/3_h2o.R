##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : H2O를 활용한 Decision Tree Ensemble 
  

    # 스크립트 실행(Run a script) 
     ##  : Windows : 'Ctrl + Enter'
     ##  : MAC     : 'Command + Enter'



##0 Java(JDK) 설치
  system('java -version')
  
  ## java version "1.x.y_zzz"가 나오면 무시
  ## 다른게 나오면 JDK 설치 필요
  ## http://bit.ly/fastJDK8

  install.packages('rJava')
  library(rJava)
  
  
  

  
##0 H2O 패키지 설치

  # http://www.h2o.ai/
    
    ## Java 기반의 H2O를 다운로드하고 R과 연동
    ## RCurl, jsonlite 등 패키지가 먼저 설치되어 있어야 함

  install.packages('RCurl')
  install.packages('jsonlite')

    
    ## install.packages( )로 설치가능하지만, 용량이 커서 미리 다운 받은 파일로 설치 
  
    # install.packages('h2o', type='source', repos='http://h2o-release.s3.amazonaws.com/h2o/rel-yau/2/R')
    # download.packages(pkgs='h2o', type='source', destdir = getwd(), repos='http://h2o-release.s3.amazonaws.com/h2o/rel-yau/2/R')
    
  install.packages('data/h2o_3.26.0.2.tar.gz', repos=NULL, type='source')
  
  
  
    # Windows에서 설치 오류 시
    # .libPaths()
      ## 패키지 설치 경로 확인
    # install.packages('data/h2o_3.26.0.2.tar.gz', repos=NULL, type='source', lib=.libPaths()[2])
    # install.packages('data/h2o_3.26.0.2.tar.gz', repos=NULL, type='source', lib='C:/Program Files/R/R-3.5.2/library')
      ## 패키지 설치 경로 지정
  
  
  
   
 
##1 H2O 시작하기 
 
  library(h2o)
  h2o.init(nthreads=1)
    ## nthreads= : 사용할 CPU 코어수(-1은 모든 코어를 의미) 
    ## http://localhost:54321
 

   
  
 
  
##2 RF / GBM의 적합과 기존 모형과의 비교 
  
  
  # 예제 데이터 불러오기
  spam = read.csv('data/spambase.dat')
    spam$Spam = factor(spam$Spam)  
    
  head(spam)
    ## 4597개 메일의 특성을 변수화 후 Spam 여부를 태그
    ## 각 변수의 속성은 "spambase description.txt" 참고
  
  
  
  # 데이터 분할
  set.seed(2019)
  index = sample(1:nrow(spam), 3200)
  spam_train = spam[index, ]
  spam_test  = spam[-index, ]
  

  # 로지스틱 회귀 모형 적합
  glm_spam = glm(Spam~., data=spam_train, family='binomial')
  pred_glm = predict(glm_spam, spam_test, type='response')
  t_glm    = table(spam_test$Spam, ifelse(pred_glm>=0.5, '1','0'))
  1 - sum(diag(t_glm))/sum(t_glm)


  # 의사결정 나무 모형 적합
  library(rpart)
  tree_spam = rpart(Spam~., data=spam_train, method='class', cp=0.005)
  pred_tree = predict(tree_spam, spam_test, type='class')
  t_tree    = table(spam_test$Spam, pred_tree)
  1 - sum(diag(t_tree))/sum(t_tree)

  
  
  
##2.1 h2o를 활용한 모형 적합 
  
  # h2o 형식 데이터 변환
  spam_train_h2o= as.h2o(spam_train)
  spam_test_h2o = as.h2o(spam_test)

  
  
  # h2o.randomForest( )를 활용한 RF 모형 적합
  rf_spam = h2o.randomForest(x=1:57,
                             y=58,
                             training_frame=spam_train_h2o,
                             validation_frame=spam_test_h2o)
    ## x : 설명변수
    ## y : 관심변수
    ## training_frame  : training 데이터
    ## validation_frame: test 데이터
  
  rf_spam
    
    ## 오분류율 : __%
  
  
  # 함수 살펴보기
  ?h2o.randomForest
    ## ntrees : 앙상블에 활용할 나무의 수
    ## max_depth : 각 모형의 복잡함의 정도(cp와 유사)
    ## sample_rate : 각 모형에 활용할 랜덤 관측치의 비율
    ## col_sample_rate_per_tree : "" 변수의 비율
  
  
  
  
  # h2o.gbm( )을 활용한 GBM 모형 적합 
  gbm_spam = h2o.gbm(x=1:57,
                     y=58,
                     training_frame=spam_train_h2o,
                     validation_frame=spam_test_h2o)
  gbm_spam
  
      ## 오분류율 : __%
      ## training 오분류율 : __%


  
  
  # 분석결과의 구성 확인 
  str(gbm_spam)
  
  
  
  # 함수 살펴보기
  ?h2o.gbm
  
  
  
  
  
  # h2o.glm( )을 활용한 회귀 모형 적합
  glm_spam = h2o.glm(x=1:57,
                     y=58,
                     training_frame=spam_train_h2o,
                     validation_frame=spam_test_h2o, 
                     family='binomial')
  glm_spam
  
    ## 오분류율 : __%

  
  
     
  # h2o.deeplearning( )을 활용한 딥러닝 모형 적합
  dl_spam = h2o.deeplearning(x=1:57,
                             y=58,
                             training_frame=spam_train_h2o,
                             validation_frame=spam_test_h2o)
  dl_spam
  
    ## 오분류율 : __%

  
  
  # 엄청나게 많은 속성(파라미터) 확인
  ?h2o.deeplearning

  
  
  
 
  
  
  
##2.2 적합된 모형의 활용
  
  # h2o.predict( )를 활용한 예측
  h2o.predict(rf_spam, spam_test_h2o)
  h2o.predict(gbm_spam, spam_test_h2o)
  
  
  
  # 설명변수의 중요도 확인 
  h2o.varimp(rf_spam)
  h2o.varimp(gbm_spam)
  
  
    ## 전체 확인 
    varimp_rf = data.frame(h2o.varimp(rf_spam))
    varimp_rf
  
 
  
  

##2.3 grid를 활용한 최적 parameter 탐색
  
  ## parameter에 따라 모형이 다르고, 오분류율이 다름
  ## 최적의 값을 찾기위한 방법

  # h2o.grid( ) 활용
  grid = h2o.grid('randomForest',
                  x=1:57,
                  y=58,
                  training_frame=spam_train_h2o,
                  nfolds = 3,
                  seed=13579,
                  hyper_params = list(ntrees = c(30,50,70),
                                       max_depth=c(10,20,30)))

    ## 파라미터 조합에 대해서 모형 적합 후 평가
    ## nfolds(=k) : k-fold 교차검증 실행
    ##  {(k-1) 덩어리 :모형 적합 -> 1개 덩어리 :검증}을 k번 실행
    
  
  
  # 결과 요약 
  grid
    ## 최선의 파라미터 선택
  
  
  # 최적 모형 적합
  rf_spam_best = h2o.randomForest(
                  x=1:57,
                  y=58,
                  training_frame=spam_train_h2o,
                  validation_frame=spam_test_h2o,
                  max_depth=30, ntrees=70)
  rf_spam_best
  
  
  
  # 모형 다운로드
  h2o.download_pojo(rf_spam_best, path=getwd())
 
  
  
  
  
  
##3 (실습) 보험료 청구금액 예측 앙상블 모형 적합
  
  # 데이터 불러오기
  insurance = read.csv('data/insurance.csv')
  
  
  # 데이터 분할
  set.seed(2019)
  index = sample(1:nrow(insurance), 1000)
  ins_train = insurance[index,]
  ins_test  = insurance[-index,]
  
  
  
  # 의사결정나무모형 적용
  library(rpart)
  tree_ins = rpart(charges ~ ., data=ins_train, cp=0.006)
  tree_ins
  
    ## MAE 계산
    pred_tree = predict(tree_ins, ins_test)
    pred_tree
    
    mean(abs(ins_test$charges - pred_tree))
    
  
    
    
  # 데이터 형식 변환
  ins_train_h2o= as.h2o(ins_train)
  ins_test_h2o = as.h2o(ins_test)
  
  
  # h2o.gbm( ) 함수를 활용한 gbm모형 적합
  gbm_ins = h2o.gbm()
  gbm_ins
  
  

  
  # h2o.randomForest( ) 함수를 활용한 RF모형 적합
  rf_ins = h2o.rf()
  rf_ins
  
  
  
  # h2o.grid( )를 활용한 파라미터 최적화

 
  
  
  
  
  
  

  # gbm_ins = h2o.gbm(x=1:6, 
  #                   y=7, 
  #                   training_frame=ins_train_h2o,
  #                   validation_frame=ins_test_h2o)
  # gbm_ins
  # 
  # 
  # rf_ins = h2o.randomForest(x=1:6, 
  #                           y=7, 
  #                           training_frame=ins_train_h2o,
  #                           validation_frame=ins_test_h2o)
  # rf_ins
  # 
  # 
  # grid = h2o.grid('randomForest',
  #                 x=1:6,
  #                 y=7,
  #                 training_frame=ins_train_h2o,
  #                 nfolds = 3,
  #                 hyper_params = list(ntrees = c(30,50,70),
  #                                      max_depth=c(10,20,30)))
  # 
  # grid
  

  
  
  
##4 (실습) 퇴직확률 예측 모형
  
  # 데이터 불러오기 
    hr = read.csv('data/ibm_hr_sample.csv')
  head(hr)
    ## 예제 데이터셋에 포함되어 있으므로 설명은 생략
    ## 관심변수 : Attrition(퇴직여부)

      
  # 필요없는 변수 제거
  hr$EmployeeCount = NULL
  hr$EmployeeNumber = NULL
  hr$Over18 = NULL
  hr$StandardHours = NULL

  
  
  # 데이터 분할(Train:Test = 70:30)
  library(dplyr)
  set.seed(7030)
  hr = hr %>% 
    mutate(cv = sample(c('train','test'), nrow(hr), replace=T, prob=c(0.7, 0.3)))
  
  hr %>% count(cv)
      
      
  hr_train = hr %>% filter(cv=='train') %>% select(-cv)
  hr_test  = hr %>% filter(cv=='test')  %>% select(-cv)

  
  
  
  
# End of script