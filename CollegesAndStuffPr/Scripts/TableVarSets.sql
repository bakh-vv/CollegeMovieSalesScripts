select Student.siD, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where student.sID = apply.sid and Apply.cname = college.cname;

select S.sID, S.sName, s.GPA, A.cName, C.enrollment
from Student S, College C, Apply A
where A.sID = S.sID and A.cName = C.cName;

select s1.sID, s1.sName, s1.GPA, s2.sID, s2.sName, s2.GPA 
from student S1, student S2
where s1.GPA = s2.GPA and s1.sID < s2.sID;

select cname as name from college
union
select sname from student;

select cname as name from college
union all
select sname as name from student
order by name;

select sID from apply where major = 'CS'
intersect
select sID from apply where major = 'EE';

select distinct A1.sID
from Apply A1, Apply A2
where A1.major = 'CS' and A2.major = 'EE' and A1.sID = A2.sID;

select sID from apply where major = 'CS'
except
select sID from apply where major = 'EE';

select distinct sID from apply where major = 'CS';

select distinct A1.sID
from Apply A1, Apply A2
where A1.major = 'CS' and A2.major <> 'EE' and A1.sID = A2.sID;

