insert into Student values (432, 'Kevin', null, 1500);
insert into Student values (321, 'Lori', null, 2500);

-- covers all
select sID, sName, GPA
from Student
where GPA <= 3.5 or GPA > 3.5 or GPA is NULL;


select sID, sName, GPA, sizeHS
from Student
where GPA > 3.5 or sizeHS < 1600 or sizeHS >= 1600;

select count(distinct GPA)
from student
where gpa is not null;

select count(distinct GPA)
from student; -- null isn't counted as a distinct value

select distinct GPA
from student;  -- however null is selected and returned in a set as a distinct value