##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##



## 주제 : 시간이 있으면 이야기 할 것들


  # 스크립트 실행(Run a script) 
  ##  Windows : 'Ctrl + Enter'
  ##  MAC     : 'Command + Enter'




##1 텍스트 데이터의 활용

  # 예제 데이터 불러오기
  reviews = read.csv('data/jobplanet_reviews.csv', stringsAsFactors=F, fileEncoding='euc-kr')
    ## 잡플래닛 SKT 리뷰
  
  
  # 데이터 구성 살펴보기
  reviews$titles[1:3]
  reviews$pros[1:3]
  reviews$cons[1:3]
  reviews$toceo[1:3]
  
  
  

  # 간단한 텍스트 함수 살펴보기
  nchar(reviews$titles)
    ## 각 제목의 글자수 세기
    
    
  substr(reviews$titles, 1, 10)
    ## 각 문단의 3번째부터 10번째까지 단어 추출하기
    
    
  paste(1:250, '번째 제목 :', reviews$titles)
    ## 콤마로 나열된 글자들을 붙이기
    
  
  paste0(1:250, '번째 제목 :', reviews$titles)
    ## 콤마로 나열된 글자들을 공백없이 붙이기
  
  
  
  
  # 복잡한 텍스트 함수 살펴보기 
  
  # grep( )을 활용한 단어 탐색
  grep('연봉', reviews$titles)
    ## 특정 단어를 포함한 관측치 번호 확인
  
  grep('연봉', reviews$titles, value=TRUE)
  grep('스트레스', reviews$titles, value=TRUE)
    ## value=TRUE : 특정 단어를 포함한 관측치 값 확인
  
  
  # grepl( )을 활용한 포함여부 논리연산  
  grepl('스트레스', reviews$titles)

  
  
  # gsub( )를 활용한 찾아바꾸기
  grep('커리어', reviews$cons, value=TRUE)
  gsub('커리어', '경력', reviews$cons)
    # 특정 단어를 찾아 바꾸기
  
  
  gsub('"', ' ', reviews$titles)
  gsub('[[:punct:]]', '', reviews$titles)
    # 패턴 찾아 바꾸기
    # [[:punct:]] : 모든 특수문자
    

    
  

##1.1 설문 데이터 살펴보기
  
  # 데이터 불러오기
  survey = read.csv('data/survey.csv', fileEncoding='UTF-8')
  survey
  
    
    
    
##2 정규 표현식(regular expression)의 활용

  ?regex
    ## 요약
    ## [ ]    : 한 글자를 의미 
      ## [abc]  : a 또는 b 또는 c 중 한글자
      ## [0-9]  : 0부터 9까지 한글자
      ## [a-z]  : 알파벳 소문자
      ## [가-힣]: 한글 전체

      ## [[:alpha:]] : 알파벳
      ## [[:blank:]]  : 스페이스 혹은 탭
      ## [[:digit:]] : 숫자
      ## [[:punct:]] : 특수문자(키보드에 보이는 것들)
    
    ## .      : 한글자
    ## *      : 앞에 있는 것이 0 또는 여러번 나오는 것
    ## .*     : 길이에 상관없이 아무런 글자(공백포함)
    ## +      : 앞에 있는 것이 한번 이상 나오는것 
    ## {n}    : 앞에 있는 것이 정확히 n번 나오는 것
      ## [[:digit:]]{4} : 4자리수 숫자
    ## {n,m} : 앞에 있는 것이 n번 이상 m번 미만 나오는 것
    ## {n,} : 앞에 있는 것이 n번 이상 나오는 것
      ## [가-힣]{6,} : 한글 6자 이상

  
  
  # 주요 함수
    ## grep( ) : 패턴과 일치하는 관측치 확인
    ## grepl( ): 패턴과 일치여부 논리연산
    ## gsub( ) : 패턴과 일치하는 부분을 찾아 바꾸기
  
  
  
  
  # 간단한 예제
  text = c('가나다123ABC', 'XYZ9', '54321', 'AZ', '10가')
  text

  
  
  # grep( )로 패턴과 일치하는 관측치 찾기
  grep( '[[:digit:]]' , text)
    ## 숫자가 들어 있는 관측치는?

  
  # 조건과 일치하는 관측치 확인하기 
  grep( '[[:digit:]]', text, value=TRUE)
    # "value=TRUE" : 조건과 일치하는 관측치의 실제 값을 출력
  
  
  # 조건과 일치하지 않는 관측치 확인하기 
  grep( '[[:digit:]]', text, value=TRUE, invert=TRUE)
    # "invert=TRUE" : 조건과 일치하지 않는 관측치 찾기
  
  
  
  # grepl( )로 패턴과 일치하지 논리연산하기
  grepl('[[:digit:]]' , text)
    ## 각 관측치에 숫자가 하나라도 있는지 확인
    
    
  # 숫자로 시작하는(^) 관측치 찾기 
  grepl('^[[:digit:]]', text)
    ## "^" : ~로 시작하는
    
    
  # 숫자로 끝나는($) 관측치 찾기
  grepl('[[:digit:]]$', text)
    ## "~$" ~로 끝나는

  
  # 숫자로 아닌 것(^)을 포함한관측치 찾기 
  text
  grepl('[^[:digit:]]', text)
    ## "[^]" : ~가 아닌 

    
  
  # 한글을 포함한 관측치 찾기
  grepl('[가-힣]', text)
    

  # 두 글자 이상 한글을 포함한 관측치 찾기
  grepl('[가-힣]{2,}', text)
  
      
  
  
  # 모든 한자리수 숫자를 *로 변환
  gsub( '[[:digit:]]', '*', text)
    
  
  # 모든 영어 알파벳을 _로 변환
  gsub( '[a-zA-Z]', '_', text)
    
  
  # 세자리수 숫자를 @@@로 변환
  gsub( '[[:digit:]]{3}', '@@@', text)

      
  # 세자리수 이상 숫자를 @@@로 변환
  gsub( '[[:digit:]]{3,}', '@@@', text)
  
  
  # 세자리수 숫자와 한 글자 묶음을 @@@@로 변환
  text
  gsub( '[[:digit:]]{3}[[:alpha:]]', '@@@@', text)
    

  # 세자리 숫자(묶음1) 뒤 세글자(묶음2)를 묶음1로 변환
  gsub( '([[:digit:]]{3})([[:alpha:]]{3})', '\\1', text)
    
  
  # 세자리 숫자(묶음1) 뒤 세글자(묶음2)를 묶음2로 변환
  gsub( '([[:digit:]]{3})([[:alpha:]]{3})', '\\2', text)
    

  
  # 간단한 예제 살펴보기
  naver_query = readLines('data/naver_query.txt', encoding='UTF-8')
  naver_query

    ## "query="  : 지금 검색어
    ## "oquery=" : 직전 검색어
  
  
  # (같이 실습) url에서 'query=' 뒤에 있는 검색어만 추출하기
  
  
  
  
  
  
##3 merge( )로 데이터 결합하기 ----
  
  
  
  # 예제 데이터 불러오기
  sales = read.csv('data/ex_sales.csv')
  sales
  
  prod  = read.csv('data/ex_prod.csv')
  prod
  
  
  
  # merge( )를 활용한 데이터 결합
  merged = merge(sales, prod, by.x='PROD', by.y='PROD')
    ## merge(데이터1, 데이터2, by.x='첫번째데이터의 기준변수', by.y='두번째...')
  
  
  merged = merge(sales, prod, by='PROD')
    ## 기준변수가 같을 때는 "by="으로 한번에 지정 가능
  
  merged

  
  
  
  # all 옵션의 활용
  merge(sales, prod, by='PROD', all.x=TRUE)
    ## all.x=TRUE : 짝이 없는 첫번째 데이터의 관측치도 포함
    ## Excel의 VLOOKUP 느낌
  
  merge(sales, prod, by='PROD', all.y=TRUE)
    ## all.y=TRUE : 짝이 없는 두번째 데이터의 관측치도 포함

  merge(sales, prod, by='PROD', all=TRUE)
    ## all=TRUE : 짝이 없는 모든 관측치 포함

  
  
  
  # 1:1, 다:1은 문제가 없지만 다:다 결합은 조심!
  prod2  = read.csv('data/ex_prod2.csv')
  prod2
    ## 상품 B에 대한 정보가 중복
  
  merge(sales, prod2, by='PROD')
    ## by로 지정된 변수값 기준 
    ## 모든 가능한 결합을 생성
  
  
  

  # (실습) sales 데이터와 user 데이터를 결합
  # -> dplyr 패키지를 활용하여 연령대별 판매량 요약
  library(dplyr)
  
  user = read.csv('data/ex_user.csv')
  user

  
  merged2 = merge()
  merged2

  
  
  
  
  
  
  
    # merged2 = merge(sales, user, by='USER')
    # merged2 %>% group_by(AGE) %>% summarise(n=length(AMOUNT),
    #                                         AMT=sum(AMOUNT))

    

        
  
  
##5 tidyr 패키지의 활용

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
    

  

##6 (실습) 서울시 지하철 이용데이터 
  # 출처 : 공공데이터포털(www.data.go.kr)
  
  # 데이터 불러오기
    ## 역변호가 150인 서울역 데이터 
  library(openxlsx)
  subway_2017 = read.xlsx('data/subway_1701_1709.xlsx')
  

    
    
  # 데이터의 구조 확인
  str(subway_2017)

  
  
  # 첫 10개 관측치만 확인하기
  head(subway_2017, n=10)

  
  
  # 변수이름 확인 
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

            
  
  