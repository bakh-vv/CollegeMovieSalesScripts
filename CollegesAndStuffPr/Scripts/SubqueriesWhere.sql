Select cname, state
from college c1
where exists (select * from college c2
where c2.state = c1.state and c1.cname <> c2.cname);

Select c1.cname, c1.state
from college c1, college c2
where c2.state = c1.state and c1.cname <> c2.cname;

select cname
from college c1
where not exists (select * from college c2
where c2.enrollment > c1.enrollment)

select sname, GPA
from student
where GPA >= all (select GPA from student);

select cname, enrollment
from college c1
where enrollment > all (select enrollment from college c2
where c2.cname <> c1.cname);

select cname, enrollment
from college c1
where not enrollment <= any (select enrollment from college c2
where c2.cname <> c1.cname);

select sID, sName, sizeHS
from Student
where sizehs > any (select sizehs from student);

select sID, sName, sizeHS
from Student s1
where exists (select sizeHS from student s2 where s1.sizeHS > s2.sizeHS);

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
and sID <> all (select sID from Apply where major = 'EE');

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
and not sID = any (select sID from Apply where major = 'EE');

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where GPA*(sizeHS/1000.0) - GPA > 1.0
or GPA - GPA*(sizeHS/1000.0) > 1.0;

select*
from (select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student) G
where abs(scaledGPA - GPA) > 1.0;

select distinct college.cName, state, GPA
from Student, College, Apply
where student.sID = apply.sID and apply.cName = college.cName
and GPA >= all (select GPA from Student, Apply
where Student.sID = Apply.sID and apply.cName = college.cName);

select cName, state,
(select distinct GPA
from Student, Apply
where student.sID = apply.sID and apply.cName = college.cName
and GPA >= all (select GPA from Student, Apply
where Student.sID = Apply.sID and apply.cName = college.cName)) as GPA 
from College;