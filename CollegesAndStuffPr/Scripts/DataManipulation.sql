insert into college values ('Carnegie Mellon', 'PA', 11500);

select *
from Student
where sID not in (select sID from Apply);

select sID, 'Carnegie Mellon', 'CS', null
from Student
where sID not in (select sID from Apply);

insert into Apply
select sID, 'Carnegie Mellon', 'CS', null
from Student
where sID not in (select sID from Apply);

insert into Apply
select sID, 'Carnegie Mellon', 'EE', 'Y'
from Student
where sID in (select sID from Apply where major = 'EE' and decision = 'N');

delete from Student
where sID in 
(select sID
from Apply
group by sID
having count(distinct major) > 2);

delete from Apply
where sID in 
(select sID
from Apply
group by sID
having count(distinct major) > 2);

select * from College 
where cName not in (select cName from apply where major = 'CS');

delete from College 
where cName not in (select cName from apply where major = 'CS');

select * from Apply
where cName = 'Carnegie Mellon'
and sID in (select sID from Student where GPA < 3.6);

update Apply
set decision = 'Y', major = 'economics'
where cName = 'Carnegie Mellon'
and sID in (select sID from Student where GPA < 3.6);

select * from Apply
where major = 'EE'
and sID in (select sID from Student where GPA >= all (select GPA from Student where sID in 
(select sID from Apply where major = 'EE')));

update Apply
set major = 'CSE'
where major = 'EE'
and sID in (select sID from Student where GPA >= all (select GPA from Student where sID in 
(select sID from Apply where major = 'EE')));

update Student
set GPA = (select max(GPA) from Student),
sizeHS = (select min(sizeHS) from Student);

update Apply
set decision = 'Y';