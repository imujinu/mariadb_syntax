-- post 테이블의 author_id값을 nullable 하게 변경
alter table post modify column author_id bigint;

--inner join
--두 테이블 사이에 지정된 조건에 맞는 레코드만을 반환. on 조건을 통해 교집합찾기.
--즉, post 테이블에 글쓴적이 있는 author와 글쓴이가 author에 있는 post 데이터를 결합하여 출력하는 
select * from author inner join post on author.id =post.author.id;
select * from author a inner join post p on a.id = p.author_id;
-- 출력 순서만 달라질 뿐 위 커리와 아래 쿼리는 동일
select * from post p inner join author a on a.id = p.author_id;
-- 만약 같게 하고 싶다면
select a.*, p.* from post p inner join author a on a.id = p.author_id;

-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오
-- post의 글쓴이가 없는 데이터는 제외. 글쓴이중에 글쓴적 없는 사람도 제외외
select p.*, a.email from post p inner join author a on p.author_id = a.id;
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오오
select p.title, p.content, a.name form post p inner join author a on p.author_id = a.id;
-- A left join B : A테이블의 데이터는 모두조회하고, 관련있는 (ON조건) B데이터도 출력.
-- 글쓴이는 모두 출력하되, 글을쓴적 있다면 관련글도 같이 출력하라.
select * from author a left join post p on a.id = p.author_id; 

-- 모든 글목록을 출력하고 , 만약 저자가 있다면 이메일 정보를 출력해라
select p.*, a.email from post p left join on p.author_id = a.id;

-- 모든 글목록을 출력하고 , 관련된 저자 정보 출력(author_id not null 이라면 )
-- 아래 두 쿼리는 동일
select * from post p left join author a on p.author_id = a.id;
select * from post p inner join author a on p.author_id = a.id;

-- 실습) 글쓴이가 있는 글 중에서 글의 타이틀과 저자의 email을 출력하되, 저자의 나이가 30세 이상인 글만 출력.
select p.*, a.email from post p inner join author a on p.author_id = a.id where a.age>= 30; 

-- 전체 글 목록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글목록만을 출력.
select p.* from post p left join author a on p.author_id = a.id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력
