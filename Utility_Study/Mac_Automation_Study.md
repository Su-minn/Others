

# Mac Automation



## Mac System Preference Setting



### 사용법

Reference #1
[윈도우 최적화 단축키 만들기](https://blackturtle2.net/711647)

1) 시스템 환경설정 들어가기
2) 키보드 선택
3) 단축키 Tap 선택
4) 앱 단축키 Tap 선택
5) + 를 선택하고 원하는 기능 입력 및 shortcut setting

> 여기서 원하는 기능 입력 시에 명칭을 정확하게 입력해야한다!



### 현재 Shorcut Setting

- 화면 왼쪽에 윈도우 배치

  ~~~ 
  control + command + 왼쪽 화살표
  ~~~

- 화면 오른쪽에 윈도우 배치

  ~~~ 
  control + command + 오른쪽 화살표
  ~~~

  

## Keyboard Maestro



### 기본사용법

Reference #1
[맥선생 유튜브](https://www.youtube.com/watch?v=xC8N8nLWDO4)



- 맨 왼쪽의 플러스를 하면 그룹이 생긴다
- 그 오른쪽 플러스는 매크로 설정
- Trigger : Macro를 실행시키는 조건
  - hot key trigger : 단축키 트리거
- Action : action이 모여서 하나의 Macro가 된다
  - Tip : 잘모르면 검색창에 관련 내용을 검색하기
  - Activate a Specific Application : 앱 실행
  - Type a Keystroke : 원하는 키 입력
- Ex. screenshot
  - 1) Mac 기본 스크린샷을 Keystroke로 실행
    action에 command + shift + 4를 등록
  - 2) Screenshot 영역을 드래그 할 것이므로
    'mouse' 검색
  - 3) Move or Click Mouse 들어가서, Without dragging -> and drag to로 변경
    위에 숫자는 좌표를 의미
    - 좌표 입력은 get을 누르고 마우스를 그 곳에 두면 좌표가 뜬다
  - 4) 좌표를 입력해준다
  - 5) 반복을 하고 싶다면 repeat을 검색
    repeat action은 반복하고 싶은 action을 repeat 액션안에 넣고
    원하는 반복횟수를 입력하면 된다
- Image Resize, Web search 등 무궁무진한 Action들을 조합해서 원하는 Macro 만들기 