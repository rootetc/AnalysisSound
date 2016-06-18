# AnalysisSound
음악 검색 프로그램

사용언어: MATLAB

참고 자료: https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwjyjefs-4jNAhVF6aYKHSCkAkcQFggfMAA&url=https%3A%2F%2Fwikis.utexas.edu%2Fdownload%2Fattachments%2F3736533%2Fismir2002.pdf&usg=AFQjCNGjFMuRGASBAz7ycIVAB-LuD5ZTpw&sig2=3gXmr6chwtoZPtfHe6CEOA&bvm=bv.123325700,d.dGo&cad=rja

hash table DB 생성 알고리즘
1. 모든 음악파일을 주파수 측으로 변환.
2. 모든 음악에서 특징적인 키 값을 추출 하기 위하여 hamming window의 길이는 2048, overlapping은 31/32로 설정
(overlapping을 높게 하여 구간들간의 coherence를 높여 노이즈를 제거하는 방식)
3. 11.6ms의 구간마다 27개의 비트를 추출 하기 위하여 300hz~2000hz를 28개의 구간으로 분할
4. E(j,i) - E(j,i+1) -  E(j - 1,i) + E(j - 1,i + 1) > 0 인 경우 bit를 1로 setting, 아닌 경우 bit를 0으로 설정.
5. 노래 마다 순차적으로 고유한 id값 할당
6. id값과 key값을 사용하여 배열의 index는 키 값으로 설정 저장되는 내용은 id값 할당.
chained hash table의 구조를 사용하여 중복 처리 수행.


검색 알고리즘
1. 짧은 구간의 노래를 설정
---> 짧은 녹음구간과 5~6번의 녹음을 통해 frame동기화의 성능을 높일 수 있다.
2. hash table DB알고리즘의 1~4번 수행을 통해 key값 추출
3. 키 값을 통해 hash table에 접근 및 해당 되는 id를 count한다.
4. 사용자가 지정한 recall값과 같거나 높을 시 노래를 찾았다고 간주 하여 검색 종료 및 출력
5. 적당한 recall값을 얻지 못하였는 경우 1~3번 과정을 4~5회 수행
6. 4~5회 수행동안 recall값이 threadshold보다 낮은 경후 찾고자 하는 노래가 없다고 간주 후 1~5등의 노래 list들을 출력
