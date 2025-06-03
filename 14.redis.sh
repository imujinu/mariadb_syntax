# 도커를 통한 redis 설치 -> 도커를 통한 redis 설치
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속
redis-cli

# docker - redis 접속명령어
docker exec -it 컨테이너id redis-cli

# redis는 0~15번 까지의 db로 구성 (default는 0번 db)
# db 번호 선택
select db번호

# db 내 모든 키 조회
keys *

# 가장 일반적인 string 자료구조

# set을 통해 key:value 세팅
set user:email:1 hong1@naver.com
set user1 hong1@naver.com

# 기존에 key:value가 존재할 경우 덮어쓰기
set user1 hong3@naver.com

# key 값이 이미 존재하면 pass, 없으면 set : nx
set user1 hong4@naver.com nx

# 만료시간(ttl time to live) 설정(초단위) : ex
set user5 hong5@naver.com ex 10

# 특정 key 삭제
del user1

# redis 실전 활용 : token 등 사용자 인증정보 저장
set user1:access_token abcdef1234 ex 1800

set user1:refresh_token abcdef1234 ex 1800

# 현재 DB내 모든 KEY값 삭제
flushdb

# redis 실전 활용 : 좋아요 기능 구현 - > 동시성 이슈 해결
# redis는 key:value가 모두 문자열이다. 내부적으로는 '0'으로 
set likes:posting:1 0

# 특정 key값의 value를 1만큼 증가 
incr likes:posting:1 
# 특정 key 값의 value를 1만큼 감소
decr likes:posting:1 

# redis 실전활용 : 재고관리 구현 -> 동시성 이슈 해결
set stocks:product:1 100
decr stocks:product:1 
incr stock:product:1

# redis 실전활용 : 캐싱기능 구현
# 1번 회원 정보 조회 : select name , email , age from member where id = 1; 
# 위 데이터의 결과값을 spring을 통해 json 으로 변형하여, redis에 캐싱

# 최종적인 데이터 형식 : {"name":"hong", "email":"hong@daum.net", "age":30}
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

#list 자료구조
#redis 의 list는 deque와 같은 자료구조, 즉 double-ended queue 자료구조 
# lpush : 데이터를 list 자료구조에 왼쪽부터 삽입
# rpush : 데이터를 list 자료구조에 오른쪽부터 삽입
lpush hongs hong1
lpush hongs hong2
rpush hongs hong3
rpush hongs hong4

#list 조회 : 0은 리스트의 시작인덱스를 의미, =1은 리스트의 마지막 인덱스를 의미 
lrange hongs 0 -1 # 전체조회
lrange hongs -1 -1 # 마지막 값 조회
lrange hongs 0 0 #첫번째값조회
lrange hongs -2 -1 #마지막 2번째부터 마지막까지
lrange hongs 0 2 #0번째부터터 2번째까지

# list 값 꺼내기
rpop hongs
lpop hongs

rpoplpush abc bcd # abc에서 bcd에 넣겠다.

#list의 데이터 개수 조회
llen hongs
#ttl 적용
expire hongs 20
#ttl 조회
ttl hongs

# redis 실전 활용 : 최근 조회한 상품 목록
rpush user1 : recent : product
rpush user1 : recent : product
rpush user1 : recent  product orange:

# 최근본상품 3개 조회
lrange user1:recent:product 3 -1                                                                                                                                                                                            product


# set 자료구조 : 중복 없음, 순서 없음
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3

# set 조회
smembers memberlist

# set 멤버 개수 조회
scard memerlist

# 특정 멤버가 set 안에 있는 존재여부 확인
sismember memberlist m2

# redis 실전화용 : 좋아요 구현 
# 게시글상세보기에 들어가면
scard posting:likes:1
sismember memberlikes:1
sadd posting:likes:1 a1@naver.com
# 좋아요한사람을 클릭하면 
smembers posting:likes:1

# zset : sorted set 
# zset을 활용해서 최근시간순으로 정렬가능
# zset도 set이므로 같은 상품을 add할 경우에 중복이 제거되고, score(시간) 값만 업데아트 
zadd user:1:recent:product 091330 mango
zadd user:1:recent:product 091330 apple
zadd user:1:recent:product 091331 orange
zadd user:1:recent:product 091332 kiwi
zadd user:1:recent:product 091333 grape
zadd user:1:recent:product 091329 apple

#zset 조회 : zrange(score기준오름차순), zrevrange(기준내림차순)
zrange user:1:recent:product 0 2
zrange user:1:recent:product -3 -1

#withscore를 통해 score까지 같ㅇ ㅣ출력
zrevrange user:1:recent:productr 0 2 withscores

#종목 : 삼성전자, 시세 55000원, 시간 : 현재시간(유닉스타임스태프) -> 년월일시간을 초단위로 변환한것.
zadd stock:price:se 1748911141 55000
zadd stock:price:se 1748911141 55000
zadd stock:price:se 1748911141 55000
zadd stock:price:se 1748911141 55000
zadd stock:price:se 1748911141 55000

#삼성전자의 현재시세
zreverange stock:price:lg 0 0
zrange stock:price:lg -1 -1

#hashes : value가 map 형태의 자료구조 
 set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex
 hset member:info:1 name hong email hong@daum.net age 30
 hgetall member:info:1
 hset member:info:1 name hong2