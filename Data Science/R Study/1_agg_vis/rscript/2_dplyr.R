##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##

 

  ## 주제 : dplyr 패키지를 활용한 데이터 요약


    # 스크립트 실행(Run a script) 
     ##  Windows : 'Ctrl + Enter'
     ##  MAC     : 'Command + Enter'




##1 dplyr 패키지를 활용한 요약

  # dplyr 패키지 설치
  install.packages('dplyr')
  library(dplyr)


  # SKT의 delivery 데이터 활용
    ## 원본 출처 : SKT Big Data Hub(www.bigdatahub.co.kr)

  delivery = read.csv('data/SKT.csv', fileEncoding='UTF-8')
  head(delivery)


  

    
##1.1 slice( )로 특정 행만 불러오기
  ## 행번호를 활용해서 특정 행을 불러오기 
  ## 햄 슬라이스...

  slice(delivery, c(1,3,5:10))
    ## slice(데이터명, 잘라서가져올 행)
    ## 1, 3, 5~10 행만 불러오기



  
##1.2 filter( )로 조건에 맞는 데이터 행만 불러오기
  filter(delivery, 시군구=='성북구')
    ## { filter(데이터명, 조건) }
    ## '성북구' 데이터만 불러오기


  filter(delivery, 시군구=='성북구', 요일 %in% c('토', '일'), 업종=='피자' | 통화건수>=100)
    ## 복수의 조건 사용
    ## filter(데이터명, 조건1, 조건2, 조건3, ...)
    ## 조건문은 논리연산(==, !=, >, < 등)을 활용
    ## 'OR'은 | 로 연결, 'AND'는 ,로 연결



  
##1.3 arrange( )로 정렬하기(오름차순)
  arrange(delivery, 시군구, 요일, 업종)
    ## arrange(데이터명, 정렬기준변수1, 정렬기준변수2, ...)

  arrange(delivery, desc(시군구), 요일, 업종)
    ## 내림차순(Descending)으로 정렬할 때는 'desc' 옵션 활용



  

##1.4 select( )로 변수를 선택하거나 제외하기
  select(delivery, 통화건수)
  
  
  
  # ":"를 활용한 순서대로 여러변수 선택하기 
  select(delivery, 시간대:통화건수)

  

  # "-"를 활용한 변수제외
  select(delivery, -요일)


  
    

##1.5 distinct( )로 반복 내용제거하기
  distinct( delivery, 업종)


  
  
  
  
##1.6 mutate( )로 기존 변수를 활용한 임시 변수 만들기
  
  mutate(delivery, 새요일=paste0(요일, '요일'))
    
  
    # 변수 추가 
    # delivery$새요일 = paste0(delivery$요일, '요일')
  
  

  
##1.7 count( )로 그룹별 개수 세기
  count(delivery, 시군구)
  
  
  

    
##1.8 group_by( )로 그룹 지정해주기
  delivery_grp = group_by(delivery, 시군구)

  
  
  

##1.9 summarize( )로 요약 하기
  summarise(delivery_grp, length(통화건수))
    ## "delivery %>% count(통화건수)"와 동일
  
  summarise(delivery_grp, n())
    ## n() : length(아무변수)와 동일
  
  summarise(delivery_grp, n_distinct(업종))
    ## n_distinct() : 중복값 제거한 후 개수 세기

    
  summarise(delivery, mean(통화건수), m = min(통화건수), M = max(통화건수))
  summarise(delivery_grp, mean(통화건수), m = min(통화건수), M = max(통화건수))
    ## 원본 데이터는 전체 요약, 그룹이 지정된 데이터는 그룹별 요약

  
  
  
  
  
##1.10 top_n( )으로 상위 관측치 확인하기  
  
  top_n(delivery, 5, 통화건수)
  
  top_n(delivery_grp, 5, 통화건수)
  
  
  
    
  
  
  
  
##1.11 파이프라인( %>% )을 활용한 연속작업
  delivery %>% 
    filter(업종=='중국음식') %>%
    group_by(시군구) %>% 
    summarise(mean_call = mean(통화건수)) %>% 
    arrange(desc(mean_call))
  
  

    
  # 데이터 저장
  new_data = delivery %>% filter(업종=='중국음식') %>% group_by(시군구) %>% 
            summarise(mean_call = mean(통화건수)) %>% arrange(desc(mean_call))
  

  
  
  # 결과를 csv파일로 저장
  write.csv(new_data, 'result.csv', row.names=FALSE) 
    ## 작업폴더(Working Directory)에 'result.csv'이름으로 저장



  
  
  
  
  
##2 (실습) 보험료 데이터 요약하기

  # 예제 데이터 불러오기 
  ins = read.csv('data/insurance.csv')

  
  
  #1 데이터 ins에서 sex가 female인 관측치로 region별 관측치 수 계산
  

  #2 charges가 10000이상인 관측치 중에서 smoker별 평균 age 계산
  

  #3 age가 40 미만인 관측치 중에서 sex, smoker별 charges의 평균과 최댓값 계산   

  
  
  
  
  
  
  
    # ins %>% filter(sex=='female') %>% count(region)
    # ins %>% filter(charges >= 10000) %>% group_by(smoker) %>% summarise(mean(age))
    # ins %>% filter(age < 40) %>% group_by(sex, smoker) %>% summarise(mean(charges), max(charges))
  
  
  
  
  
  # 데이터를 csv파일로 저장하기
  
  # 위에서 작업한 내용 중 아무거나 하나를 csv파일로 저장해보기
  

  
  
  
  
  
    # result = ins %>% filter(age < 40) %>% group_by(sex, smoker) %>% summarise(mean(charges), max(charges))
    # write.csv(result, 'result.csv')  

  
  
  
  
##3 (실습) IBM HR 샘플 데이터 요약  
  
  # IBM HR 샘플 데이터
    ## https://www.ibm.com/communities/analytics/watson-analytics-blog/hr-employee-attrition/
    ## 직원의 신상, 근무 정보와 이탈(attrition) 여부를 포함한 데이터

  # 데이터 불러오기
  library(openxlsx)
  ibm_hr = read.xlsx('data/ibm_hr_sample.xlsx')
  head(ibm_hr)
  
  
  
  #0 전체 직원 중에서 Attrition이 'Yes'인 직원수/비율 계산하기
  ibm_hr %>% 
    summarise(N = n(),
              N_Yes =  sum(Attrition=='Yes'),
              P_Yes = mean(Attrition=='Yes'))

  
  #1 JobRole, JobLevel별로 Atrrition이 'Yes'의 비율 계산하기
  
  
  #2 EnvironmentSatisfaction이 4이상인 직원 중에서
  #  JobSatisfaction별로 MonthlyIncome의 평균 계산하기
  
  #3 Department, JobLevel별로 PerformanceRating이 높은 직원 10명의 
  #  WorkLifeBalance의 평균 계산하기
  
  
  

##3.5 설문 데이터 살펴보기
  
  # 데이터 불러오기
  survey = read.csv('data/survey.csv', fileEncoding='UTF-8')
  survey
  
  
  
  
  

  
  
    
##4 tidyr 패키지의 활용

  # 패키지 설치  
  install.packages('tidyr')
  library(tidyr)

  
  
  # 예제 데이터 불러오기
  summarised = read.csv('data/summarised.csv', fileEncoding='utf-8')
  summarised
  

  
  # complete( )를 활용한 빠져있는 조합 생성
  summarised %>% complete(product, year)

  
  
  # replace_na( )를 활용한 결측값 대체
  summarised %>% 
    complete(product, year) %>% 
    replace_na(list(Q1=0, Q2=0, Q3=0, Q4=0))

  
    ## (참고) mutate( )와 ifelse( ), is.na( )를 활용한 결측값 대체
    summarised %>% 
      complete(product, year) %>% 
      mutate(Q1 = ifelse( is.na(Q1), 0, Q1))
  

  
  # (문제 상황) product별 분기 판매량 평균 계산
    
    
    
    
    
    
    
  # gather( )를 활용한 형태 변환
  summarised %>% 
    gather(key='quarter', value='sales', Q1:Q4)

  
  
  # gather( ) 등을 활용한 데이터 요약
  summarised %>% 
    gather(key='quarter', value='sales', Q1:Q4) %>% 
    group_by(product) %>% 
    summarise(M = mean(sales))
  
  
  # 결측 조합을 채운 후 요약
  summarised %>% 
    gather(key='quarter', value='sales', Q1:Q4) %>% 
    complete(product, year, quarter) %>% 
    mutate(sales = ifelse( is.na(sales), 0, sales)) %>% 
    group_by(product) %>% 
    summarise(M = mean(sales))
    

  

##5 (실습) 서울시 지하철 이용데이터 
  # 출처 : 공공데이터포털(www.data.go.kr)
  
  # 데이터 불러오기
    ## 역변호가 150인 서울역 데이터 
  library(openxlsx)
  subway_2017 = read.xlsx('data/subway_1701_1709.xlsx')
  subway_2017
  

    
    
  # 데이터의 구조 확인
  str(subway_2017)

  
  
  # 첫 10개 관측치만 확인하기
  head(subway_2017, n=10)

  
  
  # 변수이름 확인 ->이름변환
  names(subway_2017)
  names(subway_2017)[6:25]
  

    ## 어렵지만 formatC( )도 활용 가능
    formatC(5:25, width=2, flag='0')
      ## 모두 두자리로 바꾸고 빈칸은 0으로 채움
    paste0('H', formatC(5:24, width=2, flag='0'))
    names(subway_2017)[6:25] = paste0('H', formatC(5:24, width=2, flag='0'))
    names(subway_2017)
  
    
  
      
      
        
  # (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
  # '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
  subway2 = NA
  
  
  
  
  
    
    
    
    
  
  
    # subway2 = gather(subway_2017, 시간대, 승객수, H05:H24)
  
  
  
  
    ## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여
  
  
  # 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
  subway2 %>% NA
  
  

  # 위의 결과를 spread( ) 함수를 활용해서 표 형태로 변환
  subway2 %>% NA
   

    
  # 역명/시간대/구분별 전체 승객수 합계 계산
  subway2 %>% NA
  
  
  
  # 2월 한달간 역명/시간대/구분별 전체 승객수 합계 계산
  subway2 %>% NA
  
  
  
  
  
    
    
    
    
    
    
  
  
    # subway2 %>% group_by(역명, 시간대) %>% summarise(SUM = sum(승객수)) %>% arrange(desc(SUM))
  
    # subway2 %>% group_by(역명, 시간대) %>% summarise(SUM = sum(승객수)) %>% spread(시간대, SUM)
  
    # subway2 %>% group_by(역명, 시간대, 구분) %>% summarise(SUM = sum(승객수)) %>% arrange(desc(SUM))
  
    # subway2 %>% filter(월==2) %>% group_by(역명, 시간대, 구분) %>% summarise(SUM = sum(승객수)) %>% arrange(desc(SUM))
  
  
  
  
  
  # (실습) 날씨 데이터 결합
  weather_2017 = read.csv('data/weather_2017.csv', stringsAsFactors = FALSE)  
  head(weather_2017)
  

  
  
  
  
  
  
  
  
    # merged = merge(subway2, weather_2017, by.x='날짜', by.y='date')

            
# End of script