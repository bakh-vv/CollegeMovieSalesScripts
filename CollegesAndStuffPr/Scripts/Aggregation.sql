select avg(GPA)
from Student;

select min(GPA)
from Student, apply
Where student.sID = apply.sID and apply.major = 'CS';

-- possibly counts same students twice
select avg(GPA)
from Student, apply
Where student.sID = apply.sID and apply.major = 'CS';

-- counts any student only once
select avg(GPA)
from Student
Where sID in (select sid from apply where major = 'CS');

select count(*)
from college
where enrollment > 15000;

select count(*)
from apply
where cname = 'Cornell';

select count(distinct sID)
from apply
where cname = 'Cornell';

select *
from student s1
where (select count(*) from student s2 where s1.sID <> s2.sID and s1.GPA = s2.GPA) = 
(select count(*) from student s2 where s1.sID <> s2.sID and s1.sizeHS = s2.sizeHS);

select CS.avgGPA - NonCS.avgGPA
from (select avg(GPA) as avgGPA from Student where sID in (select sID from Apply where major = 'CS')) as CS, 
(select avg(GPA) as avgGPA from Student where sID not in (select sID from Apply where major = 'CS')) as NonCS;

select distinct (select avg(GPA) as avgGPA from Student where sID in (select sID from Apply where major = 'CS')) - 
(select avg(GPA) as avgGPA from Student where sID not in (select sID from Apply where major = 'CS'))
from student;

select cName, count(*)
from apply
group by cName;

select cName, count(distinct sID)
from apply
group by cName;

select state, sum(enrollment)
from College
group by state;

select cName, major, min(GPA), max(GPA)
from Student, Apply
where student.sID = apply.sID
group by cName, major;

select max(mx-mn)
from (select cName, major, min(GPA) as mn, max(GPA) as mx
from Student, Apply
where student.sID = apply.sID
group by cName, major) as M;

select student.sID, cName, count(distinct cName)
from student, apply
where student.sID = apply.sID
group by student.sID;

select student.sID, count(distinct cName)
from student, apply
where student.sID = apply.sID
group by student.sID
union
select student.sID, 0
from student
where sID not in (select sID from apply);

select cName
from Apply
group by cName
having count(*) < 5;

select distinct cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

select cName
from Apply
group by cName
having count(distinct sID) < 5;

select major
from Student, Apply
where student.sID = apply.sID
group by major
having max(GPA) < (select avg(GPA) from Student);