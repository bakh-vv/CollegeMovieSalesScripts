-- select all friends of Gabriel
select name
from Highschooler
where ID in (select ID1
from friend
where id2 in
(select ID 
from Highschooler
where name = 'Gabriel'));

select ID1
from friend
where id2 in
(select ID 
from Highschooler
where name = 'Gabriel');

select name, grade, name, grade
from highschooler

-- grades of those in the Likes table
select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, ID2
from likes, highschooler
where id1=id) as R, highschooler
where ID2 = ID;

-- name of those in the Likes table
select name as N, grade1, ID2, T.grade
from (select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, ID2
from likes, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID;

-- Names of those in the Likes table where grade difference >=2
select N, grade1, name, grade2
from (select name as N, grade1, ID2, T.grade as grade2
from (select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, ID2
from likes, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID) as Y, highschooler
where ID2 = ID and (grade1- grade2) >= 2;

-- find mutual likes
select l1.id1, l1.id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1);

select l1.id1 as id1, l1.id2 as id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1);

-- grades of those in the Likes table
select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, ID2
from likes, highschooler
where id1=id) as R, highschooler
where ID2 = ID;

select ID1, grade as grade1, id2
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1)) as S, highschooler
where id1=id;

-- grades of those in the mutual table
select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, id2
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1)) as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID;

select name as N, grade1, ID2, T.grade
from (select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, id2
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1)) as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID;

-- names of those in the mutual table
select N, grade1, name as Na, grade2
from (select name as N, grade1, ID2, T.grade as grade2
from (select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, id2
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1)) as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID) as Y, highschooler
where ID2 = ID;

-- names of those in the mutual table, distinct pairs, with names sorted alphabetically in each pair
select N, grade1, Na, grade2
from (select N, grade1, name as Na, grade2
from (select name as N, grade1, ID2, T.grade as grade2
from (select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, id2
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where exists (select l2.id1, l2.id2 from likes l2 where l2.id1 = l1.id2 and l2.id2 = l1.id1)) as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID) as Y, highschooler
where ID2 = ID) as Q
where N < Na;

-- student who are neither liking nor liked
select name, grade
from highschooler
where id not in (select id1 from likes union select id2 from likes)
order by grade, name;

-- student A likes student B, but we have no information about whom B likes 
-- (that is, B does not appear as an ID1 in the Likes table)
select N, grade1, Na, grade2
from (select N, grade1, name as Na, grade2
from (select name as N, grade1, ID2, T.grade as grade2
from (select ID1,grade1, ID2, grade
from (select ID1, grade as grade1, id2
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where id2 not in (select id1 from likes)) as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID) as Y, highschooler
where ID2 = ID) as Q;

select name, grade
from highschooler

-- people with friends in different grades
select Id1
from friend f1, highschooler h1
where f1.id1 = h1.id and id2 in
(select ID 
from Highschooler
where grade <> h1.grade);

-- people with no friends in different grades
select name, grade
from highschooler
where id in (select id1 from friend) and id not in (select Id1
from friend f1, highschooler h1
where f1.id1 = h1.id and id2 in
(select ID 
from Highschooler
where grade <> h1.grade))
order by grade, name;

-- where there's a liking, but they're not friends
select l1.id1, l1.id2
from likes l1
where not exists (select * from friend f1 where f1.id1 = l1.id1 and f1.id2 = l1.id2);

/*
select id1, id2, f3.id3
from friend, (select id1 as id3 from friend where id1 in (select id2 from friend where id1=f1.id1)
and id1 in ((select id2 from friend where id1=f1.id2))) as f3; */

-- find a mutual friend between two people who have a liking between them, but who're not friends
select f.id1, f.id2, h.id
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where not exists (select * from friend f1 where f1.id1 = l1.id1 and f1.id2 = l1.id2)) as f, highschooler h
where h.id in (select id1 from friend where id2 = f.id1) and h.id in (select id1 from friend where id2 = f.id2);

select N, grade1, Na, grade2, id3
from (select N, grade1, name as Na, grade2, id3
from (select name as N, grade1, ID2,  grade2, id3
from (select ID1,grade1, ID2, grade as grade2, id3
from (select ID1, grade as grade1, id2, id3
from (select f.id1, f.id2, h.id as id3
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where not exists (select * from friend f1 where f1.id1 = l1.id1 and f1.id2 = l1.id2)) as f, highschooler h
where h.id in (select id1 from friend where id2 = f.id1) and h.id in (select id1 from friend where id2 = f.id2)) 
as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID) as Y, highschooler
where ID2 = ID) as Q;

-- names and grades of students in the query above the higher one
select N, grade1, Na, grade2, name as Nam, grade as grade3
from (select N, grade1, Na, grade2, id3
from (select N, grade1, name as Na, grade2, id3
from (select name as N, grade1, ID2,  grade2, id3
from (select ID1,grade1, ID2, grade as grade2, id3
from (select ID1, grade as grade1, id2, id3
from (select f.id1, f.id2, h.id as id3
from (select l1.id1 as id1, l1.id2 as id2
from likes l1
where not exists (select * from friend f1 where f1.id1 = l1.id1 and f1.id2 = l1.id2)) as f, highschooler h
where h.id in (select id1 from friend where id2 = f.id1) and h.id in (select id1 from friend where id2 = f.id2)) 
as S, highschooler
where id1=id) as R, highschooler
where ID2 = ID) as T, highschooler
where ID1 = ID) as Y, highschooler
where ID2 = ID) as Q) as U, highschooler 
where id3=id;

-- students liked by more than one student
select name, grade
from (select distinct l1.id2 as ID
from likes l1
where (select count(*) from likes l2 where l2.id2=l1.id2) > 1) as L, highschooler
where L.ID = highschooler.ID;