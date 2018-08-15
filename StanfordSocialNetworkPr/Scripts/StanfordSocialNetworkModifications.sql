delete from highschooler
where grade = 12;

-- friends and not mutual liking
select l.id1, l.id2
from likes l
where exists (select * from friend f where f.id1 = l.id1 and f.id2 = l.id2) and not exists 
(select * from likes l2 where l2.id1=l.id2 and l2.id2=l.id1);

/*
delete from likes l
where exists (select * from friend f where f.id1 = l.id1 and f.id2 = l.id2) and not exists 
(select * from likes l2 where l2.id1=l.id2 and l2.id2=l.id1); */ -- can't give name to a table in the delete statement

-- pseudocode
/* select *
from likes
where rowid in (select l.id1 as id1, l.id2 as id2
from likes l
where exists (select * from friend f where f.id1 = l.id1 and f.id2 = l.id2) and not exists 
(select * from likes l2 where l2.id1=l.id2 and l2.id2=l.id1)); 8*/

-- delete who are friends and not mutual liking
delete from likes 
where exists (select * from friend f where f.id1 = likes.id1 and f.id2 = likes.id2) and not exists 
(select * from likes l2 where l2.id1=likes.id2 and l2.id2=likes.id1);

-- friends of friends
select  distinct id1, id
from friend, highschooler
where id in (select id2 from friend f1 where f1.id1 = friend.id2) and id1 <> id; 

-- friend of friends who are not friends themselves
select M.id1, M.id
from (select  distinct id1, id
from friend, highschooler
where id in (select id2 from friend f1 where f1.id1 = friend.id2) and id1 <> id) as M
where not exists (select * from friend where friend.id1 = M.id1 and friend.id2 = M.id);

-- make friendships between friend of friends
insert into friend
select M.id1, M.id
from (select  distinct id1, id
from friend, highschooler
where id in (select id2 from friend f1 where f1.id1 = friend.id2) and id1 <> id) as M
where not exists (select * from friend where friend.id1 = M.id1 and friend.id2 = M.id);