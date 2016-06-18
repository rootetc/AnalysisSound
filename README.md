# AnalysisSound

## 음악 검색 프로그램

사용언어: MATLAB

##참고 자료
https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwjyjefs-4jNAhVF6aYKHSCkAkcQFggfMAA&url=https%3A%2F%2Fwikis.utexas.edu%2Fdownload%2Fattachments%2F3736533%2Fismir2002.pdf&usg=AFQjCNGjFMuRGASBAz7ycIVAB-LuD5ZTpw&sig2=3gXmr6chwtoZPtfHe6CEOA&bvm=bv.123325700,d.dGo&cad=rja
http://coding-geek.com/how-shazam-works/

##key값을 bit를 사용하여 음악검색 수행

###hash table DB 생성 알고리즘

1. 모든 음악파일을 주파수 측으로 변환.
2. 모든 음악에서 특징적인 키 값을 추출 하기 위하여 hamming window의 길이는 2048, overlapping은 31/32로 설정
(overlapping을 높게 하여 구간들간의 coherence를 높여 노이즈를 제거하는 방식)
3. 11.6ms의 구간마다 27개의 비트를 추출 하기 위하여 300hz~2000hz를 28개의 구간으로 분할
4. E(j,i) - E(j,i+1) -  E(j - 1,i) + E(j - 1,i + 1) > 0 인 경우 bit를 1로 setting, 아닌 경우 bit를 0으로 설정.
5. 노래 마다 순차적으로 고유한 id값 할당
6. id값과 key값을 사용하여 배열의 index는 키 값으로 설정 저장되는 내용은 id값 할당.
chained hash table의 구조를 사용하여 중복 처리 수행.


###Music Search 알고리즘

1. 짧은 구간의 노래를 설정
---> 짧은 녹음구간과 5~6번의 녹음을 통해 frame동기화의 성능을 높일 수 있다.
2. hash table DB알고리즘의 1~4번 수행을 통해 key값 추출
3. 키 값을 통해 hash table에 접근 및 해당 되는 id를 count한다.
4. 사용자가 지정한 recall값과 같거나 높을 시 노래를 찾았다고 간주 하여 검색 종료 및 출력
5. 적당한 recall값을 얻지 못하였는 경우 1~3번 과정을 4~5회 수행
6. 4~5회 수행동안 recall값이 threadshold보다 낮은 경후 찾고자 하는 노래가 없다고 간주 후 1~5등의 노래 list들을 출력

검색 정확도 계선 방법: combination algorithm을 사용하여 noise로 인해 깨진 bit를 복구하여 검색의 정확도를 올릴 수 있다.
ex) 1000 --> 1 bit의 error correction 0000, 1100, 1010, 1001....
1,2,3,4...bit 차이를 test한 결과 2bit차이의 correction이 정확도와 속도측면에서 가장 좋은 결과를 나타냈다.

###memory 사용 계선 방법

녹음된 노래에서 추출된 피쳐값들로 Hash table에서 해당 list들이 선택된다.
선택된 list들 갯수만큼 heap을 만들고 heapify를 한다.
pop을 하며 카운팅을 하고 Threshold를 설정하여 버리거나 저장한다.
저장을 하거나 바로 리턴하고 끝낼수도 있다.
저장을 한다면 저장한 것들을 가지고 다시 추려내야한다.
-----> 하지만 matlab의 상황에서는 더 안좋은 결과를 나타냈다.

##shazam 알고리즘

1. Spectrogram 만들기(MATLAB 함수 이용, spectrogram)

2. SPectrogram에서 local peak값 추출
 -1) loc scale로 freq를 나눈다.(6 band로 나눔)
 
 -2) 각 band에서 MAX 값을 구한다.
 
 -3) 각 밴드별로 MAX의 평균을 구한다.
 
 -4) 밴드 별로 평균보다 큰 값만 취한다.

3. 각 peak값의 시간 Index와 freq Index를 이용한다.(의문생김, index를 이용하면 세밀하지 못하다)

4. 구해진 2 colum table에서 feature(f1,f2,delta t)를 만든다.
 -1) circshift이용해서 shift시키면서 구한다.
 (f1,f2,delta t)를 1개의 int값으로 변환한다.
 -1)f1,f2,delta t가 각각 int이니까 9비트 바이너리로 변환후 합친다
 -ex)3,7,2 --> 192830
6. file fomat은 첫번째 줄에 노래제목 그 다음 줄 부터는 feature

----> 노이즈가 발생하였을 시 correction을 하여 검색하는 방법이 모호하다.

##RESULT
![Alt text](C:\Users\Administrator\Desktop\4학년 1학기\자료구조\termproject\result.jpg?raw=true "Optional Title")
