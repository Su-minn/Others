##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : data.table 패키지의 활용 
  

    # 스크립트 실행(Run a script) 
     ##  : Windows : 'Ctrl + Enter'
     ##  : MAC     : 'Command + Enter'




##0 패키지 불러오기  

  install.packages('data.table')
  library(data.table)

  
  
  
  
##1 (큰) 데이터 불러오기

  # MovieLens(영화 평점사이트) 데이터불러오기
    
    ## 출처 : https://grouplens.org/datasets/movielens/


    ## ml_movies.csv ; 영화 기본 정보(movieId, title, genres)
    ## ml_ratings.csv; 영화 평점 정보(userId, movieId, raing, timestamp)


  # 영화 데이터 불러오기
  movies = read.csv('data/movielens/ml_movies.csv')
  head(movies)
  
        
  

  # 평점 데이터 불러오기(시간측정)
    ## 2천만 관측치의 500MB파일
  
    #   t1 = Sys.time()
    # ratings = read.csv('data/movielens/ml_ratings.csv')
    #   t2 = Sys.time()
    #   t2-t1
    #   ## 약 100초
    # 
    # rm(ratings)
    # gc()
    
    

  
  # data.table 패키지의 fread( ) 함수 활용
    t1 = Sys.time()
  ratings = fread('data/movielens/ml_ratings.csv', header=TRUE)
    t2 = Sys.time()
    t2-t1
    ## 약 ...초
      
  ratings
  
  class(ratings)
    ## 기존 data.frame 형식에 data.table 형식을 더함
  
  
  
  
  # 데이터 형식 변환
  movies = data.table(movies)
  movies
    
    
  
  
  
  
  
##2 data.table 형식의 기본 사용법
  
  # dplyr, tidyr 패키지와 같이 데이터 전처리, 부분선택, 요약에 활용
  # 대괄호 인덱스([ ])를 활용
  
  # 체인([ ][ ])으로 연속 작업 가능
  # dplyr의 파이프라인(%>%) 활용 가능
  
  # data.table 형태로 지정된 데이터 DT에 대해 
  # DT[i, j, by] 
    # i : 관측치 선택 및 정렬
    # j : 변수 선택 및 요약값
    # by: 그룹 지정
  
  
  # 참고 사이트 : https://github.com/Rdatatable/data.table/wiki
  


  # 예제 데이터 불러오기
  ins = fread('data/insurance.csv')
  ins
  
  
  
  
  
  
  # 실습 데이터 불러오기
  prices = fread('data/stock.csv', encoding='UTF-8')
  prices
    ## 코스피 상위 50 종목의 2018년 12월 주가 데이터
    
  
  
  
  
      
    
  
##1 DT[i] 형태로 행(관측치) 선택하고 정렬하기
  
  
  
##1.1 행번호로 관측치 선택하기
  ins[1]
    # 첫번째 행
  
  ins[.N]
    # 마지막 행
    # .N : DT의 관측치 수
  

  ins[3:9]      
    # 3~9번째 행 
  
  
  

##1.2 논리연산으로 관측치 선택하기  
  
  ins[age<=30]
    # age가 30이하인 관측치만 선택하기
  
  ins[age<=30 & bmi>=30]
    # "&", "|"을 활용하여 조건 결합 가능
  
    # data.frame 형식과 달리 대괄호 안에서 데이터이름 생략 가능

    
  
  ins[region=='southeast' | region=='northwest']
  ins[age>=20 & age<30]
    # 논리연산에서 동일한 변수를 여러번 활용 가능하지만
  
  ins[region %in% c('southeast','northwest')]
  ins[age %between% c(20,29.9)]
    # %in%, %between% 등 연산자를 활용하는 것이 효율적
  
  
  
   
  

  
##1.3 order( )로 관측치 정렬하기  
  
  ins[order(age)]
    # age의 오름차순으로 정렬
  
  
  ins[order(-age)]
    # age의 내림차순으로 정렬
  
  
  ins[order(-sex, age)]
    # 복수의 변수를 활용하고, 범주형 변수에도 - 적용가능 
  

  ins
    # 원본 데이터의 관측치 순서는 바뀌지 않음
  
  setorder(ins, age, sex)
  ins
    # setorder( )로 원본 데이터의 순서 변경 가능

  
  
  
  
#1.4 (실습) prices 데이터
  
  prices
  
  

  # 마지막 앞 관측치 선택하기
  
  
  
  # date 순으로 정렬하기
  
  
  
  # (변수) stock 기준으로 '삼성전자' 관측치만 선택하기
  

  
  # date 기준으로 '2018-12-01'부터 '2018-12-10'까지 관측치 선택하기

  
  
  
  
  
  
  
  
      # prices[.N-1]
      # prices[order(date)]
      # prices[stock=='삼성전자']
      # prices[date %between% c('2018-12-01','2018-12-10')]
  
  
  
  
    
  
##2 DT[, j] 형태로 변수선택, 요약값 계산하기
  
    # "," 생략 불가
  
  
  
##2.1 변수 선택하기 
  
  ins[, 2:3]
    # 숫자로 j번째 변수 선택 가능 
    
  
  ins[, list(age)]
    # list( )로 변수 이름을 묶어 표현
  
  
  ins[, .(age)]
    # list( ) 대신 .( )로 표현 가능
  
  
  ins[, .(age, sex)]
    # 콤마(,)로 구분해서 복수 변수 선택
  
  
  
  
  
##2.2 요약값 계산 
  
  ins[, .(sum(charges))]
    ## sum(), length() 등 집계 함수 활용 가능
  
  
  ins[, .(sum(charges), length(charges), length(sex), .N)]
    ## .( )로 data.table 형식으로 출력 가능

  
  ins[, .(SUM=sum(charges), N=length(charges))]
    ## =을 활용하여 요약값 이름 지정 가능 
  

  
  ins[, .(uniqueN(region), uniqueN(sex))]
    ## uniqueN(범주형변수) : 중복값제거한 항목의 수(수준의 수) 계산
  
  

  
  
  
    
##2.3 (실습) prices 데이터 
  
  
  # 변수 date, stock, close만 선택
  
  
  
  # 전체 관측치 수 계산
  
  
  
  # close의 평균과 표준편차(sd) 계산 
  
  
  

  
  
  
      # prices[, .(date, stock, close)]
      # prices[, .N]
      # prices[, .(mean(close), sd(close))]



  
  
  
##3 DT[i, j] 형태로 부분 관측치의 변수선택/요약    
  
  
##3.1 변수와 관측치 부분 선택
  
  ins[5:10, .(age, sex, charges)]
  
  
  ins[region=='southeast', .(age, sex, charges)]  
    # DT[i]와 DT[,j]의 조합
  

    
  
  
  
##3.2 부분관측치에 대한 요약
  
  ins[5:10, .(mean(age), mean(charges))]
  
  ins[region=='southeast', .(mean(age), mean(charges))]  
  
  
  
  
  
##3.3 (실습) prices 
  
  # stock이 '삼성전자'인 관측치에 대해 date, close 선택 
  
  
  
  # stock이 '삼성전자'인 관측치로 close의 최댓값, 최솟값, 평균 계산하기
  
  
  

  
  
  
  
  
    # prices[stock=='삼성전자', .(date, close)]
    # prices[stock=='삼성전자', .(max(close), min(close), mean(close))]


    
  
  

  
##4 DT[, j, by] 형태로 그룹별 요약하기 
  
  
##4.1 그룹별 요약값 계산
  
  ins[, .N, by=sex]
  
  
  ins[, .(.N, sum(charges)), by=region]
  
  

  
  
  
  
##4.2 .SD를 활용한 그룹별 관측치 선택과 요약
  ## .SD : Subset of Data, 따로 지정하지 않으면 전체 변수
  
  ins[, head(.SD, 3), by=.(sex)]
    # 그룹별 첫 k개 관측치
  
  
  ins[, tail(.SD, 3), by=.(sex)]
    # 그룹별 마지막 k개 관측치
  
  
  ins[order(-charges), head(.SD, 3), by=.(sex)]
    # charges의 내림차순으로 정렬했을 때 그룹별 첫 k개 관측치
  
  
  ins[order(charges), tail(.SD, 3), by=.(sex)]
    # charges의 오름차순으로 그룹별 마지막 k개 관측치
  
  
  
  
  
##4.3 (실습) prices 
  
  # stock별 low의 최솟값, high의 최댓값 계산
  
  
  
  
  # stock별 마지막 2개 관측치 확인
  
  
  
  
  # stock별 close의 내림차순으로 첫번째 3개 관측치 확인
  
  
  
  
  

  
  
  
    

    
    # prices[, .(min(low), max(high)), by=stock]
    # prices[, tail(.SD, 2), by=stock]
    # prices[order(-close), head(.SD, 3), by=stock]
  
  
  
  
  

##5 ':='를 활용한 변수 추가

    
##5.1 변수 추가와 업데이트, 제거
  ins[, temp := 10]
  print(ins)
    # 모든 관측치에 10을 입력한 변수 추가
  
  ins[sex=='male', temp2 := 1]
  ins
    # 조건을 만족시키는 관측치만 변수 추가
  
  ins[is.na(temp2), ]
  ins[is.na(temp2), temp2 := 2]
  ins
    # 결측값을 대체
  
  
  ins[ , `:=`(temp = 999,
              temp2= 888)]
  ins
    # `:=`로 여러개 값을 추가 가능
    # 동일한 변수이름을 지정하면 업데이트 

    
  ins[ , temp := NULL]
  ins[ , temp2:= NULL]
    # ':=NULL'로 변수 제거

  
  ins[, mean_charges     := mean(charges)]
  ins
  
  ins[, mean_charges_sex := mean(charges), by=.(sex)]
  ins
    # 전체 및 그룹 요약값 입력 가능 
  
  

  
  
  
##5.2 그룹 변수의 입력

  ins[ , obs_id := rowid(region)]
  ins
    # rowid( ) : 그룹 내 인덱스
  
  
  ins[order(charges) , obs_id2:= rowid(region)]
  ins
    # 정렬 후 그룹 내 인덱스
  
  
  ins[order(charges) , obs_id3:= rowid(sex, region)]
  ins
    # 그룹 변수 조합 내 일련번호 생성

  
  
  
  
  
##5.3 이동값 및 상댓값, 이동평균 등 계산  
  
  ins[, a1 := shift(charges, 1, type='lag')]
  
  ins[, a2 := shift(charges, 1, type='lag'), by=sex]
  
  ins[, a3 := shift(charges, 2, type='lead'), by=sex]
  
  ins[, a4 := shift(charges, 2, type='lead', fill=0), by=sex]
  
  ins
    # shift(..., type='lag')로 값 밀기
    # by로 그룹별 값 밀기 가능
    # type='lead'로 값 당기기
    # fill로 결측값 채우기
  
  
  
  ins[, b1 := charges/min(charges), by=.(sex)]
  ins[, b2 := charges/max(charges), by=.(sex)]
  ins[, b3 := charges/first(charges), by=.(sex)]
  ins[, b4 := charges/last(charges), by=.(sex)]

  ins[order(-charges), b3 := charges/fist(charges), by=.(sex)]
  ins
    # 그룹별 최솟값(min),최댓값(max),최초값(first),최종값(last) 기준 상대값 계산 가능
  

  ins[, shift(charges, 0:2, type='lag'), by=.(sex)]
    # 복수 변수 생성/저장 가능
  
  ins[, paste0('New_val_', 1:3) := shift(charges, 0:2, type='lag'), by=.(sex)]
  
  
  

    
    
##5.4 (실습) prices  활용
    
  # close/open을 계산해서 return으로 저장하기
  
  

  # stock별로 date 순서로 관측치 일련번호 변수 추가하기 
  
  
  
  # stock별로 전일 종가를 close_d1으로, 최댓값을 close_max로 저장하기
  
    

  
  
  
  
  
  
  
  
  
      # prices[, return := close/open]
      # prices[order(date), date_id := rowid(stock)]
      # prices[ , `:=`(close_d1 = shift(close, 1, type='lag', fill=0),
      #               close_max= max(close)), by=.(stock)]

  
  

  
  
  
##6 setkey( )의 활용
  
  # setkey( )를 활용한 key 지정
  setkey(ins, sex)
  ins
    # key로 지정된 변수 기준 정렬
  
  
  key(ins)  
    # key( )로 지정된 key 확인 가능
  
  
  
  
  
##6.1 key를 활용한 데이터 결합
  
  DT_sex = data.table(sex=c('female','male'), val=c('ABC','XYZ'))
  setkey(DT_sex, sex)
  
  
  DT_sex[ins]
    # ins에 DT_sex를 Left join(Excel의 vlookup)
  
  
  DT_sex[ins, nomatch=0]
    # Inner join
  
  
  
  
  
  
##6.3 (실습) 예제 데이터 결합
  
  # 데이터 불러오기 
  sales = fread('data/ex_sales.csv')
  prod  = fread('data/ex_prod.csv')
  
  
  
  # sales와 prod의 key를 PROD로 지정하기
  
  
  # DT2[DT1] 형식으로 sales와 prod의 left join 하기
  
  
  # DT2[DT1] 형식으로 sales와 prod의 inner join 하기
  
  
  
  
  
  
  
      # setkey(sales, PROD)
      # setkey(prod,  PROD)
      # prod[sales]
      # prod[sales, nomatch=0]


  

  
  
  
##7 기타 참고 사항
  
  # 체인([][])의 활용    
  ins[age %between% c(20,29.9)][, .N, by=region][order(-N)]
  
 
  
  
  
  # tidyr의 spread( ), gather( )를
  # data.table 패키지의 dcast( )와 melt( )로 적용 가능
  library(openxlsx)
  subway = read.xlsx('data/subway_1701_1709.xlsx')
  subway = as.data.table(subway)
  subway
  
  
  # melt( )의 활용
  subway_melt = melt(subway, id.vars=1:5, measure.vars=6:25)
  subway_melt
    ## melt(DT, 
    ##      id.vars=고정할변수이름/번호,
    ##      measure.vars=모을변수이름/번호)
    
    ## 그룹변수 이름은 자동으로 'variable'
    ## 값변수 이름은 자동으로 'value'로 지정
  
  
  # dcast( )의 활용
  dt_agg = dcast(subway_melt, variable ~날짜, value.var='value', fun.aggregate=sum)
  dt_agg
    ## dcast(DT,
    ##       행그룹변수~열그룹변수,
    ##       value.var='수치형변수',
    ##       fun.aggregate=요약함수)
  
  dcast(subway_melt, 역명+구분+variable ~날짜, value.var='value',  fun.aggregate=sum)
  
  
  
  


  
##8 MovieLens 데이터의 요약
    
  # 데이터 살펴보기
  ratings
    ## timestamp : 1970-01-01 00:00:00 이후 누적초
  
  
    
  # userId별 시간순 평점 일련번호 만들기
  ratings[order(timestamp), rowID := rowid(userId)]
    ## ":="으로 변수 추가
  
  ratings
  ratings[userId==138493][order(timestamp)]
    
  
  
  
  # 영화별 평균 평점 계산하기 
  ratings[, mean(rating), by=movieId]
  ratings[, mean(rating), by=movieId][order(-V1)]
  
  
  
  
  
  # (실습) 영화별 평균 평점, 평점 수 계산하기
  
  
  
  # (실습) 영화별 평균 평점, 평점 수 계산하고 평점 수가 500개 이상인 것만 선택
  
  
  
  # (실습) 영화별 평균 평점, 평점 수 계산하고 평점 수가 500개 이상인 것 중에서 평점이 높은 순으로 정렬
  
  
  
  # (실습) 위의 최종 결과를 movies_rating_500으로 저장
  
  
  
  
  
    # ratings[, list(mean_rating = mean(rating), count_rating = length(rating)), by=movieId]
    # ratings[, list(mean_rating = mean(rating), count_rating = length(rating)), by=movieId][count_rating>=500]
    # ratings[, list(mean_rating = mean(rating), count_rating = length(rating)), by=movieId][count_rating>=500][order(-mean_rating)]
    # movies_rating_500 = ratings[, list(mean_rating = mean(rating), count_rating = length(rating)), by=movieId][count_rating>=500][order(-mean_rating)]   

  
  
  
  
  
    
##9 (실습) 데이터 결합하기
  
  # merge( )함수를 활용해서 movies_rating_500와 movies 데이터 결합하기
    ## movies_rating_500의 movieId를 기준으로 movies의 title/genres 추가
  
  movies_rating_500 = ratings[, list(mean_rating = mean(rating), count_rating = length(rating)), by=movieId][count_rating>=500][order(-mean_rating)]   
  
  RT = merge()
    ## 데이터 결합 후에는 key 변수 기준으로 재정렬됨
  RT[order(-mean_rating)][1:10]
  
  

  
  
      ## RT = merge(movies_rating_500, movies, by='movieId', all.x=TRUE)
    
  
  
  # data.table( ) 형식을 활용한 데이터 결합

  # (실습) setkey( )로 두 데이터의 key 지정하기
  
      
      
  

      
  # (실습) DT2[DT1] 형식을 사용한 DT1 기준 left join

  
  
  
  
  
  

  
  
    
    # setkey(ratings, movieId)
    # setkey(movies, movieId)
    # RT = movies[ratings]
  
        
  

  
    
##0 카드 결제 데이터로 자유롭게 실습하기
  
  # 데이터 불러오기
  checkout = fread('data/checkout_v2.csv', encoding='UTF-8')
  checkout
  
  customer = fread('data/customer_v2.csv', encoding='UTF-8')
  customer

  
  
  # 데이터 결합하기
  # 연관 업종 찾기
  
    
# End of script      