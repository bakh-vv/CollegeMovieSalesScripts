delete from CSaccept where sID = 123;

drop view CSaccept;

create view CSaccept as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y';

insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (123, 'Stanford', 'CS', 'Y');

create trigger CSacceptDelete
on CSaccept
instead of delete
as
begin
delete apply
from apply
join deleted
on apply.sID = deleted.sID
and apply.cName = deleted.cName
and major = 'CS' and decision = 'Y'
end;

drop trigger CSacceptDelete;

create trigger CSacceptDelete2
on CSaccept
instead of delete
as
begin
delete apply
from apply
join deleted
on apply.sID = deleted.sID
and apply.cName = deleted.cName
end;

delete from CSaccept where sID = 345;

insert into Apply values (345, 'Cornell', 'bioengineering', 'N');
insert into Apply values (345, 'Cornell', 'CS', 'Y');
insert into Apply values (345, 'Cornell', 'EE', 'N');

update CSaccept set cName='CMU' where sID = 345;

create trigger CSacceptUpdate
on CSaccept
instead of update
as
if update (cName)
begin
update apply
set apply.cName = (select cName from inserted)
where apply.sID = (select sID from deleted)
and apply.cName = (select cName from deleted)
and major = 'EE' and decision = 'N'
end;

create view CSEE as
select sID, cName, major
from Apply
where major = 'CS' or major = 'EE';

-- automatic translation into the base table
insert into CSEE values (111, 'Berkeley', 'CS');

create trigger CSEEinsert
on CSEE
instead of insert
as
begin
insert into Apply
select sID, cName, major, null
from inserted
end;

drop trigger CSEEinsert;

insert into CSEE values (112, 'Berkeley', 'CS');

insert into CSEE values (222, 'Berkeley', 'biology');

create trigger CSEEinsert
on CSEE
instead of insert
as
if ((select major from inserted) = 'CS' or (select major from inserted) = 'EE')
begin
insert into Apply
select sID, cName, major, null
from inserted
end;

insert into CSEE values (333, 'Berkeley', 'EE');

create view HSgpa as
select sizeHS, avg(gpa) as avgGPA
from Student
group by sizeHS;

-- can't
update HSgpa set avgGPA = 3.6 where sizeHS = 200;

create view Majors as
select distinct major from Apply;

create view NonUnique as
select * from Student S1
where exists (select * from student S2
				where S1.sID <> S2.sID
				and s2.GPA = S1.GPA and s2.sizeHS = S1.sizeHS);

-- delete from NonUnique where sName = 'Amy';

create view Berk as
select Student.sID, major
from Student, Apply
where Student.sID = Apply.sID and cName = 'Berkeley';

create trigger BerkInsert
on Berk
instead of insert as
begin
insert into Apply
select sID, 'Berkeley', major, null
from inserted
where (sID in (select sID from Student))
end;

drop trigger BerkInsert;

insert into Berk
select sID, 'psychology' from Student
where sID not in (select sID from Apply where cName = 'Berkley');

create trigger BerkDelete
on Berk
instead of delete as
begin
delete from Apply
where sID in (select sID from deleted) and cName = 'Berkeley' and major in (select major from deleted)
end; -- not perfectly correct translation

drop trigger BerkDelete;

create trigger BerkDelete
on Berk
instead of delete as
begin
delete apply
from apply
join deleted
on apply.sID = deleted.sID
and apply.major = deleted.major
and cName = 'Berkeley'
end;

insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (987, 'Berkeley', 'CS', 'Y');

delete from Berk where major = 'CS';

create trigger BerkUpdate
on Berk
instead of update as
begin
update Apply
set major = (select major from inserted)
from inserted
where apply.sID = (select sID from inserted) and apply.major = (select major from deleted) and cName = 'Berkeley';
end; -- not entirely correct translation

drop trigger BerkUpdate;

create trigger BerkUpdate
on Berk
instead of update as
begin
update Apply
set major = inserted.major
from inserted, deleted
where apply.sID = deleted.sID
and apply.major = deleted.major
and cName = 'Berkeley'
end;

update Berk set major = 'chemistry' where major = 'psychology';

update Berk set sID = 321 where sID = 123; --unpredicatable behavior

update Student set sID = 123 where sID = 321;

drop table Apply;

create table Apply(sID float, cName nvarchar(255), major nvarchar(255), decision nvarchar(255) not null);

insert into CSEE values (123, 'Berkeley', 'CS'); --null exception

drop table Apply;

create table Apply(sID float, cName nvarchar(255), major nvarchar(255), decision nvarchar(255), unique(sID, cName, major));

insert into CSEE values (123, 'Berkeley', 'CS');
insert into CSEE values (123, 'Berkeley', 'EE');

insert into Berk values(123, 'EE'); -- non unique constraint

update Berk set major = 'CS' where sID = '123';




