--사용자관리
--사용자목록조회
select * from mysql.user;

-- 사용자생성
create user 'jinwoo98'@'%' identified by '4321';

-- 사용자에게 권한부여
grant select on board.author to 'jin'@'%';
grant select, insert on board. * to 'jin'@'%';
grant all privileges on board. * to 'jin'@'%';

--사용자 권한 회수
revoke select on board.author from 'jin'@'%';

--사용자 권환 조회
show grants for 'jin'@'%';

--사용자 계정 삭제
drop user 'jin'@'%';