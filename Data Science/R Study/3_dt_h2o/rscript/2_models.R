##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : 지도학습(Supervised Learning) 복습




  
##1 (같이 실습) 보험료 청구금액 예측/설명 회귀 모형 적합
   
  # 데이터 불러오기
  insurance = read.csv('data/insurance.csv')
  head(insurance)
  
  new_cust  = read.csv('data/insurance_new.csv')
  new_cust
  

  
  # lm( )을 활용한 회귀 모형 적합
    ## 모형식은 'charges ~ .'을 사용
    ## . : 관심변수를 제외한 모든 변수
  
  # summary( )를 활용한 모형 확인
  
  # predict( )를 활용한 예측
  
  
  
  
  
##2 (같이 실습) 의사결정 나무모형의 활용
  
  # install.packages('rpart')
  # install.packages('rpart.plot')
  library(rpart)
  library(rpart.plot)
  
  
  # rpart( )를 활용한 의사결정 나무 모형 적합
    ## cp값은 충분히 작게(0.001) 지정
  # rpart.plot( )를 활용한 모형 시각화
  # plotcp( )를 활용한 최적 cp값 확인
  # prune( )을 활용한 가지치기 및 모형 시각화
  # predict(모형, 새 데이터)를 활용한 예측
  
  
  
  

  
  
  
##3 (같이 실습) 로지스틱 회귀모형을 활용한 퇴직 예측 모형 개발
  
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

  
  
    ##1##
    # glm( )과 hr_train을 활용하여
    # Attrition을 나머지 모든 변수로 설명하는 로지스틱 회귀모형 적합
  
  
    ##2##
    # summary( )로 각 설명 변수의 효과 확인
  
  
    ##3##
    # predict( )로 hr_test에 대한 퇴직확률 예측
    # 단, type='response' 옵션 활용
  
  
  
  

  
##4 (같이 실습) 의사결정나무를 활용한 퇴직 예측 모형 개발
  

    ##1##
    # rpart( )과 hr_train을 활용하여
    # Attrition을 나머지 모든 변수로 설명하는 의사결정 나무모형 적합
    # 단, cp는 기본값 0.01 활용
  
  
    ##2##
    # rpart.plot( )으로 모형 시각화 후 주요 변수 확인
  
  
  
    ##3##
    # predict( )를 활용하여 hr_test에 대한 예측값 계산
    
  
  
  
  
  
  

##5 오분류율의 계산
  
  tree_exit = rpart(Attrition ~ ., data=hr_train, method='class')
  tree_exit
  rpart.plot(tree_exit, cex=1)
  predict(tree_exit, hr_test)
  
  hr_test_pred = hr_test %>% 
      mutate(pred_Attr = predict(tree_exit, hr_test, type='class'))
  
  hr_test_pred %>% 
    mutate(correct   = pred_Attr==Attrition) %>% 
    count(correct) %>% 
    mutate(rate = n/sum(n))
    
    
  
# End of script