##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : rvest 패키지를 활용한 간단한 웹스크랩




  
##0 Google Chrome(최신 버전) 설치

  # https://www.google.com/chrome/

  # 혹은 현재 크롬 버전 확인
  # 기준 : "76.0.3809.100"






##1 모두에게 열려있는 사이트 웹스크랩


  
  # 패키지 설치
  install.packages('rvest')
  library(rvest)

  # 파이프라인을 위한 dplyr 패키지 불러오기
  library(dplyr)
  
  
  # 크롬 최신버전 설치 
  
  

##1 날씨 데이터 수집 시연
  
   ## Windows 사용자만 주석 지우고 실행
  # ## mac 사용자는 무시
  # 
  # # Sys.setlocale('LC_ALL', 'English')
  # 
  # 
  # # url 지정
  # url = 'http://www.weather.go.kr/weather/climate/past_table.jsp?stn=108&yy=2018&obs=10'
  # 
  # 
  # # read_html( )로 웹문서 다운로드
  # weather_html = read_html(url, encoding='euc-kr')
  # weather_html
  #   
  # 
  # # html_nodes( )로 표 추출
  # weather_table = html_nodes(weather_html, 'table[class="table_develop"]')
  # weather_table
  # 
  # 
  # # html_tables( )로 표 변환
  # result = html_table(weather_table)
  # 
  #   # Sys.setlocale('LC_ALL', 'Korean')
  # 
  # result
  

  
##2 네이버 블로그 제목 스크랩 
  
  
  # (함께 실습) 네이버 블로그 제목 모으기
  url = 'https://search.naver.com/search.naver?where=post&sm=tab_jum&query=웹크롤링'
  selector = '#sp_blog_1 > dl > dt > a'
  url %>% read_html() %>% html_nodes(selector) %>% html_text()
    ## read_html( ) : html 문서 다운로드
    ## html_nodes( ): html 문서 중 특정 부분을 selector로 추출 
    ## html_text( ) : 추출된 부분 중 글자 선택
  
  
  '#sp_blog_1 > dl > dt > a'
  
  
  url %>% read_html() %>% html_nodes(selector) %>% html_attr('title')
    ## html_attr( ) : 특정 속성(attribute) 선택
  
  
  # 일반적인 표현을 활용한 제목 한번에 모으기 
  selector = '#sp_blog_1 > dl > dt > a'
  selector = '#sp_blog_3 > dl > dt > a'
  
  selector = '*[id^=sp_blog_] > dl > dt > a'
  url %>% read_html() %>% html_nodes(selector) %>% html_text()
  
  
  
  # url 속성을 활용한 두번째 페이지 제목 모으기
  url = 'https://search.naver.com/search.naver?where=post&sm=tab_jum&query=고려대학교&start=11'
  url %>% read_html() %>% html_nodes(selector) %>% html_text()
    

  # for loop를 활용한 여러 페이지 제목 모으기
  text = ''
    
  for (i in 1:5){
    url = paste0('https://search.naver.com/search.naver?where=post&sm=tab_jum&query=고려대학교&start=', i*10-9)
    text = c(text, url %>% read_html() %>% html_nodes(selector) %>% html_text())
    Sys.sleep(2)
  }
    # Sys.sleep( k ) : k초 동안 멈춤
      ## 페이지 이동 시간 고려/부정 사용 감시 회피
  
  text
  

  
  
  
  ##(실습) 네이버 뉴스에서 '내가 관심있는내용' 검색 후 제목 모으기 
  
  '#sp_nws1 > dl > dt > a'
 
  url = 'https://search.naver.com/search.naver?where=news&sm=tab_jum&query=웹크롤링'
  selector = '#sp_nws1 > dl > dt > a'
  url %>% read_html() %>% html_nodes(selector) %>% html_text()

  
    text = ''
  
  for (i in 1:5){
    url = paste0('https://search.naver.com/search.naver?where=news&sm=tab_jum&query=웹크롤링&start=', i*10-9)
    text = c(text, url %>% read_html() %>% html_nodes(selector) %>% html_text())
    Sys.sleep(2)
  }
  text
  
  
  
   
  
  
##3 네이버 영화 댓글 스크랩 
  
  
    # 네이버에서 '알라딘' 검색 -> 평점
    ## https://movie.naver.com/movie/bi/mi/basic.nhn?code=163788
  
  
  
  # url 지정
  url = 'http://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=163788&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page=1'
  
  
  # 댓글 불러오기
  selector = 'body > div > div > div.score_result > ul > li > div.score_reple > p'
  url %>% read_html() %>% html_nodes(selector) %>% html_text(trim=T)

  
  
  # 데이터 저장하고 손질하기 
  naver_movie_comments = url %>% read_html() %>% html_nodes(selector) %>% html_text(trim=T)
  

  naver_movie_comments = gsub('^관람객(.*)','\\1', naver_movie_comments)
  naver_movie_comments
    ## 댓글 앞에 붙은 '관람객' 삭제
  
  

  
  
  ## CSS(Selector) 참고
    ## https://www.w3.org/TR/2011/REC-css3-selectors-20110929/
  
  

  
  
  
  # 각 댓글의 영화 평점(1~10)/ 공감수 수집하기
  
  ## 함수는 동일하고 selector 만 변경
  selector = 'body > div > div > div.score_result > ul > li > div.star_score > em'
  naver_movie_stars = url %>% read_html() %>% html_nodes(selector) %>% html_text(trim=T)
  naver_movie_stars

  
  
  selector = 'body > div > div > div.score_result > ul > li > div.btn_area > strong:nth-child(2) > span'
  naver_movie_scores = url %>% read_html() %>% html_nodes(selector) %>% html_text(trim=T)
  naver_movie_scores

  
  
  
  
  
# End of script  