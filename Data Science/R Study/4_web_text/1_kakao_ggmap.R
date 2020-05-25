##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : KAKAO API와 구글 지도 API



##0 JDK 설치
  system('java -version')
  
  ## java version "1.x.y_zzz"가 나오면 무시
  ## 다른게 나오면 JDK 설치 필요
  ## http://bit.ly/fastJDK8

  
  
  


##0 KAKAO API 등록

  # https://developers.kakao.com/

  # "REST API 키" 복사 -> 아래 따옴표 사이에 붙여넣기
  
  key = ''

    key = 'KakaoAK e7780758e31f2cf06596644539b35535'
    # 5 


  
  
##1 주소 -> 위경도 함수 만들기
  
  # 주의 : 아래의 내용은 어렵습니다!
  
  # 사용자 정의 함수
  mean_abc = function(a, b, c){
    M = (a+b+c)/3
    return(M)
  }
    ## "mean_abc는 
    ##  세개의 입력값 a, b, c가 들어오면 
    ##  모두 더해서 3으로 나누고 M으로 저장한 다음
    ##  이 M을 돌려주는 함수다."
  
  mean_abc(5, 8, 11)
  
  
    
  # 아래를 실행해서 Func_Get_latlong( ) 함수 만들기 
  install.packages('httr')
  
  Func_Get_latlong = function(addr, key){ 
    addr_rev = gsub('([[:alnum:]]{1,} [[:alnum:]]{1,} [[:alnum:]]{1,} [[:alnum:]]{1,} [[:alnum:]]{1,}) .*', '\\1', addr)
    addr_Queryurl = paste0('http://dapi.kakao.com/v2/local/search/address.json?query=', addr_rev)
    if (Encoding(addr_Queryurl)!='UTF-8') addr_Queryurl = iconv(addr_Queryurl, to='UTF-8')
    
    Info_Get = httr::GET(URLencode(addr_Queryurl), 
                         httr::add_headers(Authorization=key))
    Info_Get_json = httr::content(Info_Get, as='text')
    temp_return = (jsonlite::fromJSON(Info_Get_json, simplifyDataFrame=T)$documents)[c('x','y')]
    if ( !is.null(temp_return$x) & length(temp_return$x)>=2) temp_return = temp_return[1,]
    return(temp_return)
  }

  latlon = Func_Get_latlong('서울특별시 성북구 안암로 145 고려대학교', key)
  latlon
    
  ab = Func_Get_latlong('서울특별시 동대문구 제기동 왕산로19라길47 제스트빌', key)
  
  ## 카카오맵 기준 애기능 입구가 등록되어 있음
  
  
    ## 집주소 등등 넣어보기
  
  
  
  
  
  
##2 주소 검색 함수 만들기

  # 아래를 실행해서 Func_Search_latlong( ) 함수 만들기 
  Func_Search_latlong = function(keyword, latlon, radius, key=key){ 
    keyword_Queryurl = paste0('http://dapi.kakao.com/v2/local/search/keyword.json?x=', latlon$x, '&y=', latlon$y,'&radius=', radius, '&query=', keyword)
    if (Encoding(keyword_Queryurl)!='UTF-8') keyword_Queryurl = iconv(keyword_Queryurl, to='UTF-8')
    
    Info_Get = httr::GET(URLencode(keyword_Queryurl), 
                         httr::add_headers(Authorization=key))
    Info_Get_json = httr::content(Info_Get, as='text')
    temp_return = (jsonlite::fromJSON(Info_Get_json, simplifyDataFrame=T)$documents)
    return(temp_return)
  }
  
  KU = Func_Search_latlong('고려대학교 본관', latlon, 1000, key)
  KU
  KU = KU[1, 11:12]
  KU
  
  
  SB_nearby = Func_Search_latlong('스타벅스', KU, 2000, key)
  SB_nearby
    ## 미리 확인한 이 건물의 위경도를 중심으로
    ## 반경 2KM(=2000M)안에서 '스타벅스' 찾기
  
  
 ttt = Func_Search_latlong('내과', ab, 2000, key)
 ttt 
  
    ## 위에서 확인한 집주소 등을 기준으로 편의점, 마트 등등 찾기
    
  
    ## 예제 : 특정 가맹점을 중심으로 반경 500M이내의 경쟁업체 찾기
  
  
  
  
  
  
  
##3 ggmap 패키지를 활용한 Google 지도 시각화
  
  # 패키지 설치 및 불러오기
  install.packages('ggmap')
  library(ggmap)
    ## Google's Terms of Service: 
    ##   https://cloud.google.com/maps-platform/terms/.
    ## API 등록 후 API Key 확인
  
  
  # register_google('API Key') 실행
  ggkey = 'AIzaSyCg2ceZXU60KOTidn_9Bs6lWPomohuEJLk'
  register_google(ggkey)
    ## 혹시나 계정설정을 못하신 분들은...
    
  
  
  
##3.1 위도와 경도

  # geocode( )를 활용한 위도, 경도 확인
    # 경도(longitude, 왼쪽/오른쪽)/위도(latitude, 위아래) 확인 
  latlon_gg = geocode('서울특별시 성북구 안암로 145')
  latlon_gg
  as.numeric(latlon_gg)
    
  
  
 
  
  
##1.2 (활용 예제) 시군구별 요약 결과의 시각화

  # 데이터 불러오기
  aggr_data = read.csv('data/result_ggmap.csv', fileEncoding='euc-kr')
  aggr_data
  
  
  
  # get_googlemap( )을 활용한 지도 다운로드 
  m = get_googlemap('Seoul', zoom = 11, maptype = 'roadmap')
    ## get_googlemap('검색 키워드', ... )
  
  
  # ggmap( )을 활용한 지도 그리기 
    ## windows() 
    ## quartz()
  ggmap(m)
  
  
  
  # 지도에 점찍기(ggplot2 패키지 활용)
  ggmap(m) + geom_point(aes(x=lon, y=lat, size=mean_call), 
                        data=aggr_data, 
                        col='#862633', 
                        alpha=0.4)
  
  
  
  # 텍스트 추가
  ggmap(m) + geom_point(aes(x=lon, y=lat, size=mean_call), 
                        data=aggr_data, 
                        col='#862633', 
                        alpha=0.4) + 
            geom_text(aes(label=시군구), data=aggr_data, vjust=1, hjust=1)
    
  

  
  
    
##1.3 (같이 실습) 주변 스타벅스의 시각화
  
  # 경도, 위도 확인
    # latlon = Func_Get_latlong('서울특별시 성북구 안암동 안암로 145', key)
    # SB_nearby = Func_Search_latlong('스타벅스', latlon, 1000, key)
  KU
  str(KU)
  
  KU$x = as.numeric(KU$x)
  KU$y = as.numeric(KU$y)
    ## 글자(character)를 숫자(numeric)로 변환
  KU
  
  SB_nearby$x = as.numeric(SB_nearby$x)
  SB_nearby$y = as.numeric(SB_nearby$y)
  SB_nearby
  

  # latlon 중심 구글 지도 다운로드 
  m2 = get_googlemap(c(lon=KU$x, lat=KU$y), zoom = 15, maptype = 'roadmap')
    ## location 대신 c(lon=KU$x, lat=KU$y) 넣기
  ggmap(m2)  
  windows()
  
  # 경도/위도 활용 점찍기 
  ggmap(m2) + geom_point(aes(x=x, y=y), data=SB_nearby)
    # latlondata 대신 SB_nearby 넣기
  
  
  
  
    ## (참고) 이미지 표현하기
    install.packages('ggimage')
    library(ggimage)

    ggmap(m2) + 
      geom_image(aes(x=x, y=y, image='data/ku.png'), data=KU, size=0.2, alpha=0.9) + 
      geom_image(aes(x=x, y=y, image='data/sb.png'), data=SB_nearby, size=0.05, alpha=0.9)
    
    
    
    ## (실습) SB_nearby 데이터와 'data/sb.PNG'를 활용하여 시각화
    
    
    

      
      
    
    
      
      # geom_image(aes(x=x, y=y, image='data/sb.png'),data=SB_nearby, size=0.1, alpha=0.9)
  
  
    
    
# End of script