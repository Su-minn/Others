##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##


 
  ## 주제 : 간단한 텍스트 마이닝


##1 명사 추출과 워드클라우드
  
  # 조금 복잡한 준비
  install.packages('devtools')
  library(devtools)
    ## github를 활용한 패키지 설치를 위한 함수 install_github( ) 포함
  
  
  install.packages('KoNLP')
  library(KoNLP)
    ## 한글 단어 추출 함수 extractNoun( )등 포함
  
  
  install_github('haven-jeon/NIADic/NIADic', build_vignettes = TRUE)
    ## 정보화진흥원(NIA)의 오픈소스 사전
  
  
  install_github('lchiffon/wordcloud2')
  library(wordcloud2)
    ## 워드 클라우드 생성을 위한 함수 wordcloud2( ) 포함

  
  # 사전 만들기
  buildDictionary()

  
  
  # 데이터 불러오기
  reviews = read.csv('data/jobplanet_reviews.csv', stringsAsFactors=F, fileEncoding='UTF-8')
  reviews$titles 
  
  ddd = gsub('[[:punct:]]', '', reviews$titles)
  
  
  
  
  
  # 명사 추출하기
  nouns = extractNoun(reviews$titles, autoSpacing=T)
  nouns

  
  KoNLP::convertHangulStringToJamos(ddd[249])
  KoNLP::MorphAnalyzer(ddd[249])
  
  
  
  # 경계 허물고 단어 빈도 세기
  unlist(nouns)
  table(unlist(nouns))

  
  # data.frame 형식으로 바꾸기
  nouns_df = as.data.frame(table(unlist(nouns)), stringsAsFactors=F)
  
  library(dplyr)
  nouns_df %>% sample_n(10)
  
  
  # 글자수와 빈도(Freq)를 기준으로 부분선택하기
  nouns_df2 = nouns_df %>% 
    filter(nchar(Var1)>=2, Freq>=3)
  nouns_df2 %>% sample_n(10)
  
  grep('50', reviews$titles, value=T)
  
  
  # wordcloud2( )로 워드클라우드 그리기
  
  wordcloud2(nouns_df2)
  wordcloud2(nouns_df2, fontFamily='궁서')
  wordcloud2(nouns_df2, fontFamily='나눔바른고딕')
    ## 폰트가 설치되어 있으면 설정 가능
  
  wordcloud2(nouns_df2, shape='star')
    ## 몇가지 모양 지정 가능
  
    
  letterCloud(nouns_df2, minSize=0.1, 'G', size=1.2, fontFamily='나눔바른고딕')
    ## 불안정한 함수
  
  
  # (실습) reviews$pros로 워드 클라우드 그리기 
  
  
  
  reviews$pros
  
  ddd = gsub('[[:punct:]]', '', reviews$pros)
  
  
  # 명사 추출하기
  nouns = extractNoun(reviews$pros, autoSpacing=T)
  nouns
  
  
  # 경계 허물고 단어 빈도 세기
  unlist(nouns)
  table(unlist(nouns))
  
  
  # data.frame 형식으로 바꾸기
  nouns_df = as.data.frame(table(unlist(nouns)), stringsAsFactors=F)
  
  library(dplyr)
  nouns_df %>% sample_n(10)
  
  
  # 글자수와 빈도(Freq)를 기준으로 부분선택하기
  nouns_df2 = nouns_df %>% 
    filter(nchar(Var1)>=2, Freq>=3)
  nouns_df2 %>% sample_n(10)
  
  
  # wordcloud2( )로 워드클라우드 그리기
  
  wordcloud2(nouns_df2)
  
  
  
  
  
  
# End of script