##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : 다양한 형식의 데이터 불러오기


    # 스크립트 실행(Run a script) 
     ##  Windows : 'Ctrl + Enter'
     ##  MAC     : 'Command + Enter'




##0 RStudio의 화면구성과 설정 ----

  # 'Tools' → 'Global Options' → 'Appearance'




##0 RStudio Project의 생성

  # 'File' → 'New Project'




  
##1 read.csv( )를 활용한 csv파일 불러오기 ----
  
  # 작업 폴더 확인하기 
  getwd()
  
    # 작업폴더 설정(Set Working Directory) : 'Ctrl/Command + Shift + h'
      ## RStudio Menu ; Session -> Set Working Directory -> Choose...
      ## setwd('Your Working Directory Address')



  
  # 데이터 불러오기
  read.csv('data/test.csv')
    ## 작업 폴더에 있는 test.csv 불러와서 출력하기 
  

  
  
  # '='을 활용해서 저장하기 
  test_data = read.csv('test.csv')
    ## 오른쪽 위 환경창에서 데이터 이름 클릭 

  # View(pop_seoul)
    ## 혹은 직접 View( )에 데이터를 넣고 실행
  
  
  
  
    ## 인코딩 문제(feat. '한글이 깨져요') ----
    read.csv('data/pop_seoul_euckr.csv')
    read.csv('data/pop_seoul_utf8.csv')
      ## 서울시 구/연령대별 인구 통계(2018년)
      ## 인코딩 문제로 둘 중 하나는 정상, 하나는 에러 발생
    
    
    
    # 인코딩 지정
    pop_seoul = read.csv('data/pop_seoul_euckr.csv', fileEncoding='euc-kr')
    pop_seoul = read.csv('data/pop_seoul_utf8.csv', fileEncoding='UTF-8')
      ## Windows 인코딩 : CP949/euc-kr
      ## mac/Linux 인코딩 : UTF-8
      
      ## 같은 운영체제에서는 생략 가능 
  

  
  
    
  # 데이터 샘플 살펴보기
  head(pop_seoul)
  tail(pop_seoul, n=10)
    ## 첫 6개, 끝 10개 관측치만 콘솔창에서 보기
  
  
  
    
  
  # 데이터 특성 확인하기 
  str(pop_seoul)
    ## 데이터의 구조(Structure) 살펴보기

  
  names(pop_seoul)
    ## 변수이름 확인하기
  
  
  nrow(pop_seoul)
  ncol(pop_seoul)
    ## 행/관측치 수, 열/변수 수 확인
  
  
  
  # 데이터 요약
  summary(pop_seoul)

  
  
  # 변수 선택 
  pop_seoul$구분
    ## 데이터이름$변수이름
  
  
  
  

  
  
  
  ## (같이 실습) data 폴더에 있는 StudentsPerformance.csv 불러와서 sp로 저장하기 
  
  
  
  
  
  
  
  
  
  
  
    
  
  
  
  
  
##2 텍스트 데이터의 활용

  # 예제 데이터 불러오기
  reviews = read.csv('data/jobplanet_reviews.csv', stringsAsFactors=F)
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
    

    
    
    
    
##3 정규 표현식(regular expression)의 활용

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
  
  
  
  
    
    
  
  
  

    
    
##4 openxlsx 패키지를 활용한 엑셀파일 불러오기 


  # install.pacakges( )를 활용한 패키지 설치 ----
    ## R은 핵심적인 기능만 포함한 최소 설치
    ## 이후 필요한 기능(패키지)을 다운로드/설치 후 불러와 사용
  
  install.packages('openxlsx')
    # openxlsx 패키지 설치(xlsx 파일 불러오기 가능)
  
  
  # library( )로 설치된 패키지 불러오기
  library(openxlsx)
  

  
  # 데이터 불러오기
  SHEET1 = read.xlsx('data/test.xlsx', sheet=1)
    ## xlsx 파일 경로와 시트 번호를 지정
  SHEET1
  
  
  
  SHEET2 = read.xlsx('data/test.xlsx', sheet=2, startRow=3)
    ## startRow= 옵션으로 데이터 시작 행번호 지정 가능
  SHEET2
  
  
  
  SHEET3 = read.xlsx('data/test.xlsx', sheet=3, colNames=FALSE)
    ## 첫 행이 변수이름이 아니라 관측치일때, colNames=FALSE 옵션 사용
  SHEET3
  
  
  
  


  
## 아래는 2_dplyr.R 이후 다룰 내용   
  

  
##5 merge( )로 데이터 결합하기 ----
  
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

    

        

# End of script