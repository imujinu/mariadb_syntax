-- view : 실제데이터를 참조만 하는 가상의 테이블 SELECT만 가능
-- 사용목적 : 1) 복잡한 쿼리를 사전 생성 2) 권한분리

-- view 생성
create view author_for_marketing as select name, email from author;

-- view 조회회
w

--view 권한부여
grant select on board.author_for_view to '계정명'@'%';

-- 프로시저
delimiter // 
create procedure hello_procedure('input 값') 
begin
    select 'hello world';
end
// delimiter ;

-- 프로시저 호출
call hello_procedure();

--프로시저 삭제 
drop procedure hello_procedure;

-- 회원 목록 조회 : 한글 목록 조회()
delimiter //
create procedure select_member()
begin
    select * from author;  
end
// delimiter ;

--회원 상세 조회 : input 값 사용

DELIMITER //
CREATE PROCEDURE insert_write(
    IN nameInput VARCHAR(255), 
    IN passwordInput VARCHAR(255),
    IN emailInput VARCHAR(255), 
    IN title VARCHAR(255), 
    IN contents VARCHAR(255)
)
BEGIN
-- declare 는 첫번째 begin 밑에 위치
    DECLARE authorIdInput BIGINT;
    DECLARE postIdInput BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO author(email, name, password) 
    VALUES (emailInput, nameInput, passwordInput);

    SELECT id INTO authorIdInput 
    FROM author 
    WHERE email = emailInput;

    INSERT INTO post(title, contents) 
    VALUES (title, contents);

    SELECT id INTO postIdInput 
    FROM post 
    ORDER BY id DESC 
    LIMIT 1;

    INSERT INTO author_post(author_id, post_id) 
    VALUES (authorIdInput, postIdInput);

    SELECT * 
    FROM author a 
    INNER JOIN author_post ap ON a.id = ap.author_id 
    INNER JOIN post p ON ap.post_id = p.id;

    COMMIT;
END //

DELIMITER ;

-- 글 삭제

delimiter //
create procedure delete_post
(in emailInput varchar(255), in postId bigint)
begin

declare authorId bigint;
declare postId bigint;

declare exit_handler for SQLEXCEPTION

begin
rollback;
end;

 start transaction

if 조건 then
-- else if도 사용 가능 


else

end if;

select id into authorId from author where email=emailInput;
select id from post 



-- 글쓴이가 나밖에 없는 경우 : author_post 삭제, post까지 삭제

-- 글쓴이가 나 이외에 다른 사람도 있는 경우 : 

-- 여러명이 편집가능한 글에서 삭제

delimiter //
create procedure 글삭제(in postIdInput bigint, in emailInput varchar(255))
declare authorPostCount bigint;
begin
    select count(*) into authorPostCount from author_post where post_id = postIdInput;

    if authorPostCount=1 then
--else if도 사용 가능
    delete from author_post where post_id = postIdInput and author_id = (select id from author where email = emailInput);
    delete from post where id = postIdInput;
    else
    end if;
    delete from author_post where post_id = postIdInput and author_id = (select id from author where email = emailInput);
end
// delimiter ;

-- 여러명이 편집가능한 글에서 글삭제
delimiter //
create procedure 글삭제(in postIdInput bigint, in emailInput varchar(255))
begin
    declare authorId bigint;
    declare authorPostCount bigint;
    select count(*) into authorPostCount from author_post where post_id = postIdInput;
    select id into authorId from author where email = emailInput;
    -- 글쓴이가 나밖에 없는경우: author_post삭제, post까지 삭제
    -- 글쓴이가 나 이외에 다른사람도 있는경우 : author_post만 삭제
    if authorPostCount=1 then
--  elseif도 사용 가능
        delete from author_post where author_id = authorId and post_id = postIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post where author_id = authorId and post_id = postIdInput;
    end if;
end
// delimiter ;
-- 반복문을 통한 post 대량 생산
delimiter //
create procedure 대량글쓰기(in countInput bigint, in emailInput varchar(255))
begin
-- declare는 begin밑에 위치 
    declare authorIdInput bigint;
    declare postIdInput bigint;
    declare countValue bigint default 0;
    while countValue<countInput do
        select id into authorIdInput from author where email = emailInput;
        insert into post(title) values("안녕하세요");
        select id into postIdInput from post order by id desc limit 1;
        insert into author_post(author_id, post_id) values(authorIdInput, postIdInput);
        set countValue = countValue+1;
    end while;
end 
// delimiter ;