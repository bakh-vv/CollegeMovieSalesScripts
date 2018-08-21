drop table College;
drop table Student;
drop table Apply;

create table College(cName nvarchar(255), state nvarchar(255), enrollment float);
create table Student(sID int, sName nvarchar(255), GPA real, sizeHS float);
create table Apply(sID int, cName nvarchar(255), major nvarchar(255), decision nvarchar(255));