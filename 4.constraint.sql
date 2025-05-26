-- nou null 제약 조건 추가 
alter table author modify column name varchar(255) not null; -- 만약 이미 null값인 컬럼이 존재한다면 에러가 발생한다. 
-- nou null 제약 조건 제거 
alter table author modify column name varchar(255); 
-- not null, unique 제약 조건 동시 추가
alter table author modify email varchar(255) not null unique;

-- 제약 조건 조회회
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = 'post'; 

--테이블 차원의 제약 조건 (pk, fk) 추가/ 제거
--제약조건 삭제
alter table post drop foreign key 제약조건명; -- 이걸 더 권고한다.
alter table post drop constraint 제약조건명; 

-- 제약조건 삭제 (pk)
alter table post drop primary key;

-- 제약 조건 추가
alter table post add constraint post_pk primary key(id);
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/update 제약 조건 테스트
--부모테이블 데이터 delete 시에 fk 컬럼 set null, update 시에 자식 fk 컬럼 cascade
alter table post add constraint post_fk foreign key(author_id) references author(id) ON DELETE SET NULL ON UPDATE CASCADE;


--  default 옵션
-- enum타입 및 현재시간(current_timestamp)에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 입력을 안했을 때 마지막에 입력된 가장 큰 값에서 +1 만큼 자동으로 증가된 숫자값을 적용;
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid 타입
alter table post add column user_id char(36) default (uuid());



