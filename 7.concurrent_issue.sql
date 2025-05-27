-- 1. read uncommitted : 커밋되지 않은 read 가능 -> dirty read 문제 발생
-- 실습절차
-- 1) 워크벤치에서 auto_commit해제, update 후, commit 하지 않음(transaction1)
-- 2) 터미널을 열어 select 했을 때 위 변경사항이 읽히는지 확인(transaction2)
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read가 발생하지 않음

-- 2. read committed : 커밋한 데이터만 read 가능 -> phantom read 발생 ( 또는 non-repeatable read)
--워크벤치에서 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;

-- 터미널에서 실행
insert into author(email, role) values("xxxxxx@naver.com", 'user');

-- mariadb에서는 한 트랜잭션 내에서는 첫번째 읽은 read가 보장되기 때문에 read committed는 발생하지 않는다.

--  3. repeatable read : 읽기의 일관성 보장 -> lost update 문제 발생 -> 배타적 잠금(select for update) 으로 해결 
--lost update 문제 발생
DELIMITER //
CREATE PROCEDURE concurrent_test1()
BEGIN
    declare count int; 
    start transaction;
    insert into post(title, author_id) values ('hello world', 1);
    select post_count into count from author where id=1;
    do sleep(15);
    update author set post_count=count+1 where id=3;
    commit;
END//
DELIMITER ; 

-- 터미널에서는 아래코드 실행
    
    select post_count from author where id=1;

-- lost update 문제 해결 : select for update 시에 트랜잭션이 종료후에 특정 행에 대한 lock 풀림

-- serializable : 모든 트랜잭션 순차적 실행 - > 동시성 문제 없음 (성능저하)

