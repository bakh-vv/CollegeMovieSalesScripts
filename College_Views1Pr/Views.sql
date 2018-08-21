create view CSaccept as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y';

select Student.sID, sName, GPA
from Student, CSaccept
where Student.sID = CSaccept.sID and cName = 'Stanford' and GPA <3.8;

create view CSberk as 
select Student.sID, sName, GPA
from Student, CSaccept
where Student.sID = CSaccept.sID and cName = 'Berkeley' and sizeHS > 500;

select * from CSberk where GPA > 3.8;

create view Mega as
select college.cName, state, enrollment, 
		student.sID, sName, GPA, sizeHS, major, decision
from College, Student, Apply
where College.cName = Apply.cName and Student.sID = Apply.sID;

select sID, sName, GPA, cName
from Mega
where GPA > 3.5 and major = 'CS' and enrollment > 15000;

select Student.sID, sName, GPA, College.cName
from College, Student, Apply
where College.cName = Apply.cName and Student.sID = Apply.sID
and GPA > 3.5 and major = 'CS' and enrollment > 15000;