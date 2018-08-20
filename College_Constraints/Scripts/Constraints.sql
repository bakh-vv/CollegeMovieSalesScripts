drop table Student;
drop table College;
drop table Apply;

-- Null constraint
create table Student(sID int, sName text, GPA real not null, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, null);
insert into Student values (345, 'Craig', null, 500); -- raises error

update Student set GPA=null where sID=123;
update Student set GPA=null where sID=456;

drop table Student;

create table Student(sID int primary key, sName text, GPA real, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (123, 'Craig', 3.5, 500);

update Student set sID=123 where sName like 'Bob';

update Student set sID= sID-111;
update Student set sID= sID+111;

drop table Student;

create table Student(sID int primary key, sName nvarchar(255) unique, GPA real, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (345, 'Amy', 3.5, 500);
insert into Student values (456, 'Doris', 3.9, 1000);
insert into Student values (567, 'Amy', 3.8, 1500);

create table College(cName nvarchar(255), state nvarchar(255), enrollment int, primary key(cName,state));

insert into College values ('Mason', 'CA', 10000);
insert into College values ('Mason', 'NY', 5000);
insert into College values ('Mason', 'CA', 2000);

create table Apply(sID int, cName nvarchar(255), major nvarchar(255), decision nvarchar(255), 
unique (sID, cName), unique(sID, major));

insert into Apply values (123, 'Stanford', 'CS', null);
insert into Apply values (123, 'Berkeley', 'EE', null);
insert into Apply values (123, 'Stanford', 'biology', null);
insert into Apply values (234, 'Stanford', 'biology', null);
insert into Apply values (123, 'MIT', 'EE', null);
insert into Apply values (123, 'MIT', 'biology', null);

update Apply set major= 'CS' where cName = 'MIT';

insert into Apply values (123, null, null, 'Y');
insert into Apply values (123, null, null, 'N');

drop table Student;

create table Student(sID int, sName nvarchar(255), GPA real check(GPA <= 4.0 and GPA > 0.0), 
sizeHS int check(sizeHS <5000));

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 4.6, 1500);

update Student set sizeHS = 6*sizeHS;

drop table Apply;

create table Apply(sID int, cName nvarchar(255), major nvarchar(255), decision nvarchar(255), 
check(decision = 'N' or cName <> 'Stanford' or major <> 'CS'));

insert into Apply values (123, 'Stanford', 'CS', 'N');
insert into Apply values (123, 'MIT', 'CS', 'Y');
insert into Apply values (123, 'Stanford', 'CS', 'Y');

update Apply set decision= 'Y' where cName = 'Stanford';
update Apply set cName = 'Stanford' where cName = 'MIT';

-- subquieies within Check constraints are allowed by SQL standard, but not implemented by DBMSs
create table T( A int check((select count(distinct A) from T) = (select count(*) from T)));

drop table college;
drop table student;
drop table apply;

-- subquieies within Check constraints are allowed by SQL standard, but not implemented by DBMSs
create table Student(sID int, sName nvarchar(255), GPA real, sizeHS int);
create table Apply(sID int, cName nvarchar(255), major nvarchar(255), decision nvarchar(255), 
check(sID in (select sID from Student)));
create table College(cName nvarchar(255), state nvarchar(255), enrollment int, 
check(enrollment > (select max(sizeHS) from Student)));

-- DBMSs don't support assertions
create assertion Name
check ((select count(distinct A) from T) = (select count(*) from T));

create assertion ReferentialIntegrity
check (not exists (select * from Apply where sID not in (select sID from Student)));

create assertion AvgAccept
check (3.0 < (select avg(GPA) from Student
where sID in (select sID from Apply where decision = 'Y'));

drop table student;
drop table apply;
drop table college;

-- key constraint
create table Student(sID int primary key, sName nvarchar(255), GPA real, sizeHS int);
create table College(cName nvarchar(255) primary key, state nvarchar(255), enrollment int);
create table Apply(sID int references Student(sID), cName nvarchar(255) references College(cName), 
major nvarchar(255), decision nvarchar(255));

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 4.6, 1500);
insert into College values ('Stanford', 'CA', 15000);
insert into College values ('Berkeley', 'CA', 36000);

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');

delete top(1)
from apply
where major = 'CS';

update Apply set sid = 345 where sid = 123;
update Apply set sID = 234 where sid = 123;

delete from College where cName = 'Stanford';

delete from Student where sID = 123;
delete from Student where sID = 234;

-- can't modify the referenced attribute
update College set cName = 'Bezerkley' where cName = 'Berkeley';

drop table Apply;

-- referential integrity special actions
create table Apply(sID int references Student(sID) on delete set null, cName nvarchar(255) references 
College(cName) on update cascade, major nvarchar(255), decision nvarchar(255));

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (345, 'Craig', 3.5, 500);

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');
insert into Apply values (345, 'Stanford', 'history', 'Y');
insert into Apply values (345, 'Stanford', 'CS', 'Y');

delete from Student where sID > 200;

update College set cName = 'Bezerkeley' where cName = 'Berkeley';

-- referential integrity within a single table
create table T(A int, B int, C int, primary key (A,B), foreign key (B,C) references T(A,B));

insert into T values (1, 1, 1);
insert into T values (2, 1, 1);
insert into T values (3, 2, 1);
insert into T values (4, 3, 2);
insert into T values (5, 4, 3);
insert into T values (6, 5, 4);
insert into T values (7, 6, 5);
insert into T values (8, 7, 6);
insert into T values (9, 8, 6);