select /* distinct */ sName, major
from dbo.Student, dbo.Apply
where Student.sID = Apply.sID;

select sName, GPA, decision
from Student, Apply
where sizeHS < 1000 and cName='Stanford' and major = 'CS' and Student.sID = Apply.sID;

select distinct College.cName
from College, Apply
where College.cName = Apply.cName
and enrollment > 20000 and major = 'CS';

select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName
order by GPA desc, enrollment;

select sID, major
from Apply
where major like '%bio%';

select *
from Apply
where major like '%bio%';

select *
from Student, College;

select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000) as 'scaled GPA'
from Student;
