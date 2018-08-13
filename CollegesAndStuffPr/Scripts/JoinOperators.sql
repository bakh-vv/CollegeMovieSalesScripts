select distinct sName, major
from student, apply
where student.sID = apply.sID;

select distinct sName, major
from Student join Apply
on student.sID = apply.sID;

select sName, GPA, decision
from Student join Apply
on Student.sID = Apply.sID 
where  sizeHS < 1000 and cName='Stanford' and major = 'CS';

select sName, GPA, decision
from Student join Apply
on Student.sID = Apply.sID and sizeHS < 1000 and cName='Stanford' and major = 'CS';

select Student.sID, sName, GPA, Apply.cName, enrollment
from (Student join Apply on Apply.sID = Student.sID) 
join College 
 on Apply.cName = College.cName;

select distinct sName, major
from Student join Apply
on student.sID = apply.sID;

select sName, GPA, decision
from Student join Apply using (sID) 
where  sizeHS < 1000 and cName='Stanford' and major = 'CS';

select s1.sID, s1.sName, s1.GPA, s2.sID, s2.sName, s2.GPA
from student s1, student s2
where s1.GPA = s2. GPA and s1.sID < s2.sID;

select s1.sID, s1.sName, s1.GPA, s2.sID, s2.sName, s2.GPA
from student s1 join student s2
on s1.GPA = s2. GPA and s1.sID < s2.sID;

select *
from student s1 join student s2
on s1.sID = s2.sID;

select *
from Student;

select sName, student.sID, cName, major
from Student inner join Apply
on student.sID = Apply.sID;

select sName, student.sID, cName, major
from Student left outer join Apply
on student.sID = Apply.sID;

select sName, student.sID, cName, major
from Student left join Apply
on student.sID = Apply.sID;

select sName, student.sID, cName, major
from Student, Apply
where student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from student
where sID not in (select sID from Apply);

insert into Apply values (321, 'MIT', 'history', 'N');
insert into Apply values (321, 'MIT', 'psychology', 'Y');

select sName, apply.sID, cName, major
from Apply left join Student
on student.sID = Apply.sID;

select sName, apply.sID, cName, major
from Student right /*outer*/ join Apply
on student.sID = Apply.sID;

select sName, apply.sID, cName, major
from Student full /*outer*/ join Apply
on student.sID = Apply.sID;

select sName, apply.sID, cName, major
from Student left join Apply
on student.sID = Apply.sID
union
select sName, apply.sID, cName, major
from Student right join Apply
on student.sID = Apply.sID;

select sName, student.sID, cName, major
from Student, Apply
where student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from student
where sID not in (select sID from Apply)
union
select NULL, sID, cName, major
from Apply
where sID not in (select sID from Student);
