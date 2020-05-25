##--------------------------------------##
##        아무나를 위한 R 세미나        ## 
##                                      ##
##      임경덕(imkdoug@gmail.com)       ##
##--------------------------------------##

 

  ## 주제 : ggplot2 패키지를 활용한 시각화


    # 스크립트 실행(Run a script) 
     ##  Windows : 'Ctrl + Enter'
     ##  MAC     : 'Command + Enter'




##0 색상


  # plot 함수로 색깔 점 찍기
  plot(0,0, pch=16, cex=10, col='black')
  plot(0,0, pch=16, cex=10, col='pink')
  plot(0,0, pch=16, cex=10, col='dodgerblue')
    ## 일반적으로 "col=" 옵션으로 색상 변경 가능
  
    ## 색상이름은 아래 참고
    ## http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
    

  # rgb( ) 함수와 "#RRGGBB" HEX코드 활용
  rgb(134, 38, 51, maxColorValue=255)
    ## Korea University Crimson : Pantone 202 C

  plot(0,0, pch=16, cex=10, col='#862633')
  
  
  
  # RColorBrewer 패키지의 활용
  install.packages('RColorBrewer')
  library(RColorBrewer)

    ## http://colorbrewer2.org/

  
  # 패키지 내 모든 색상조합 확인  
  display.brewer.all()  
    ## 색상조합 이름 확인
  
  brewer.pal(9, 'Set1')
  brewer.pal(9, 'Blues')
  brewer.pal(9, 'YlGnBu')
  brewer.pal(9, 'Spectral')
  
  
  

  
##1 ggplot2 패키지를 활용한 시각화

  # ggplot2 패키지 설치, 불러오기 
  install.packages('ggplot2')
  library(ggplot2)
    
  
  # 데이터 요약/처리를 위한 패키지도 불러오기  
  library(dplyr)
  library(tidyr)

  
  
  # 예제 데이터 불러오기
  insurance = read.csv('data/insurance.csv')
  head(insurance)

  
  # 실습 데이터도 불러오기
  stud_perf = read.csv('data/StudentsPerformance.csv')
  head(stud_perf)
  
  
  
  # 기본함수를 활용한 시각화(막대그래프)
  t1 = table(insurance$sex)
  barplot(t1)

  
  
  
##1.1 ggplot( )을 활용한 막대그래프
  
  # 성별 회원수 
  insurance %>% 
    ggplot(aes(x=sex))
    ## 데이터를 파이프 라인으로 ggplot( )으로 전달
    ## aes : aesthetic.
    ##       순서대로 그래프의 x, y, fill(색)을 의미

    
  insurance %>% 
    ggplot(aes(x=sex)) +
    geom_bar()
    ## +와 함수로 그래프의 종류 선택
    ## geom : Geometric object

    
  insurance %>% 
    ggplot(aes(x=sex, fill=region)) +
    geom_bar()
    ## aes( )의 fill 옵션으로 그룹별 색상 지정
  

  insurance %>% 
    ggplot(aes(x=sex, fill=region)) +
    geom_bar(position = 'dodge')
    ## 그래프 내 옵션 선택 가능
  

  insurance %>% 
    ggplot(aes(x=sex, fill=region)) +
    geom_bar(position = 'dodge') + 
    scale_fill_brewer(palette='Set1')
    ## +로 색상, 글자, 축, 배경 등 속성 변경 가능

  
  insurance %>% 
    ggplot(aes(x=sex, fill=region)) +
    geom_bar(position = 'dodge') + 
    theme_minimal()+
    scale_fill_brewer(palette='Set1')
    ## theme_xxxx( )로 기본 테마 지정 가능


  
##1.2 ggplot( )을 활용한 막대그래프(2)
  
  # 이미 요약된 데이터의 활용
  agg = insurance %>% 
    mutate(bmi_grp = cut(bmi, 
                         breaks=c(0,30,35,40,100), 
                         labels=c('G1','G2','G3','G4'))) %>% 
    group_by(smoker, bmi_grp) %>% 
    summarise(CNT = length(charges),
              MEAN= mean(charges))
  agg
  
  
  # geom_col( )을 활용한 막대그래프
  agg %>% 
    ggplot(aes(x=bmi_grp, y=MEAN, fill=smoker)) +
    geom_col(position = 'dodge')+
    scale_fill_brewer(palette='Set1', direction=-1)
  
  

  
  # (실습) stud_perf 데이터에서 parental.level.of.education별 막대그래프 생성
  
  stud_perf %>% 
    ggplot()
  
  # (실습) stud_perf에서 parental.level.of.education별 math.score의 중앙값 계산 후 막대그래프 생성
  # median( ) : 중앙값 계산
  
  
  
  
  
  
  
##1.3 ggplot( )을 활용한 열지도(heatmap)
  
  # 데이터 요약
  agg2 = insurance %>% 
    mutate(bmi_grp = cut(bmi, 
                         breaks=c(0,30,35,40,100), 
                         labels=c('G1','G2','G3','G4'))) %>% 
    group_by(region, bmi_grp) %>% 
    summarise(Q90 = quantile(charges, 0.9))
    ## quantile( , q) : q*100% 값 계산
  
  agg2
  
  
  # geom_tile( )을 활용한 열지도
  agg2 %>% 
    ggplot(aes(x=region, y=bmi_grp, fill=Q90)) +
    geom_tile()
  
  
  # 색상 지정  
  agg2 %>% 
    ggplot(aes(x=region, y=bmi_grp, fill=Q90)) +
    geom_tile() +
    scale_fill_gradient(low='white', high='#FF6600')
  
  
  agg2 %>% 
    ggplot(aes(x=region, y=bmi_grp, fill=Q90)) +
    geom_tile() +
    scale_fill_distiller(palette='YlGnBu')
    # scale_fill_distiller(palette='Spectral')
  
  
  
  # (실습) stud_perf에서 race.ethnicity, parental.level.of.education별 math.score 평균 계산 후 저장
  #        저장된 데이터로 열지도 시각화
  

  
  
##2 ggplot( )을 활용한 산점도
  
  # geom_point( )를 활용한 산점도
  stud_perf %>% 
    ggplot(aes(x=math.score, y=reading.score)) +
    geom_point()
  

  # color= 를 활용한 점 색상 지정 
  stud_perf %>% 
    ggplot(aes(x=math.score, y=reading.score, color=gender)) +
    geom_point()
  
  
  
    
  
  
  
  
  
  
##3 ggplot( )을 활용한 그룹별 상자그림

  # 기본함수를 활용한 그룹별 상자그림
  boxplot(insurance$charges ~insurance$region)
  
  
  # geom_boxplot( )을 활용한 그룹별 상자그림
  insurance %>% 
    ggplot(aes(x=region, y=charges))+
    geom_boxplot()

  
  insurance %>% 
    ggplot(aes(x=region, y=charges, fill=smoker))+
    geom_boxplot()
  
  
  
  # ggplot2 예제: http://www.r-graph-gallery.com/portfolio/ggplot2-package/  
    
  
  
  # (실습) stud_perf에서 gender별 math.score의 상자그림 그리기 
  # (실습) stud_perf에서 gender별 test.preparation.course에 따라 색을 다르게한 reading.score의 상자그림 그리기 
  
  
  

  
  
  
##4 facet의 활용
  
  # facet_wrap( )을 활용한 한 변수 기준 분할
  insurance %>% 
    ggplot(aes(x=charges, fill=smoker)) + 
    geom_histogram()
  
  
  insurance %>% 
    ggplot(aes(x=charges, fill=smoker)) + 
    geom_histogram() +
    facet_wrap(~region)
  
  
  
  # facet_grid( )를 활용한 격자 분할
  insurance %>% 
    ggplot(aes(x=charges, fill=smoker)) + 
    geom_histogram() +
    facet_grid(sex~region)
  
  
  
  # (실습) stud_perf에서 facet_wrap( )을 활용하여 parental.level.of.education별로 분할한 
  # gender별 test.preparation.course에 따라 색을 다르게한 reading.score의 상자그림 그리기 
  
  
  
  
  

  
##5 ggsave( )를 활용한 그림 파일의 저장
  
  
  ggsave(filename='result.jpg')
  ggsave(filename='result.jpg', width=20, height=10)
    ## 가장 최근의 그림을 저장
  
    
  
  ## 구글 검색 "r graphics cookbook pdf"
    # http://users.metu.edu.tr/ozancan/R%20Graphics%20Cookbook.pdf
  
  

# dplyr + tidyr + ggplot2 + ... = tidyverse  
  
  ## www.tidyverse.org

  
  
  

  
# End of script