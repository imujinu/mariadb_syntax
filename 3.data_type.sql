-- tinyint : -128~127까지 표현
-- author 테이블에 age 컬럼 변경
alter table author modify column age tinyint;


-- int : 4바이트 (대략, 40억 숫자범위)

-- bigint : 8바이트
-- author, post 테이블의 id값 bigint변경
alter table author,post modify column id bigint primary key;

-- decimal(총자릿수, 소수부자릿수)
alter table post add column price decimal(10,3);
-- decimal 소숫점 초과 시 짤림현상발생생
insert into post(id, title, price, author_id) values(5, 'hello python',10.33412, );

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column gender gender(10);
alter table author add column self_introduction text;

-- blob(바이너리데이터) 타입 실습
-- 일반적으로 blob을 저장하기 보다, varchar로 설계하고 이미지경로만을 저장함. 
alter table author add column profile_image longblob;
insert into author(id, email, profile_image) values(8, 'aaa@naver.com', LOAD_FILE('"C:\\강아지.png"'))

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role컬럼 추가
alter table author add column role ENUM('user','admin');
-- enum에 지정된 값이 아닌 경우
insert into author(id, email, role) values(10, 'sss@naver.com', 'hello');
-- role을 지정 안한 경우
insert into author(id, email) values(10, 'sss@naver.com');
-- enum에 지정된 값인 경우
insert into author(id, email, role) values(11, 'sss@naver.com', 'admin')

-- date와 datetime
-- 날짜타입의 입력, 수정, 조회시에 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, author_id ) values(7, 'hello', 3);
alter table post add column created_time datetime default current_timestamp();

-- 비교 연산자
select * from author where id >=2 and id<=4;
select * from author where id >=2 and id<=4;
select * from author where id in (2,3,4);

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title not like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';

-- regexp : 정규포현식을 활용한 조회
select * from post where title regexp '[a-z]' -- 하나라도 알파벳 소문자가 들어이으면
select * from post where title regexp '[가-힣]' -- 하나라도 한글이 있으면

-- 숫자 -> 날짜
select cast(20250523 as date) from author; -- 2025-05-23
-- 문자 -> 날짜
select cast('20250523' as date) from author; -- 2025-05-23
-- 문자 -> 숫자
select cast('12' as unsigned);

-- 날짜조회 방법 : 2025-05-23 14:30:25
--like패턴, 부동호 활용, date_format 
select * from post where created_time like '2025-05%'; -- 문자열처럼 조회 
-- 5월 1일부터, 5월 20일까지. 날짜만 입력 시 시간부분은 00:00:00이 자동으로 붙음 
select * from post where '2025-05-01'<= created_time and created_time < '2025-05-21';
select * from post where created_time between '2025-05-01' and  '2025-05-20';

select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;
select * from post where date_format(created_time, '%m') = '05';

select * from post where cast(date_format(created_time, '%m') as unsigned) = '05';

