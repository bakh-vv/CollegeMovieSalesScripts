create view CSaccept as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y';

delete from CSaccept where sID = 123; -- works because satisfies requirements for automatic "updatable views"

create view CSEE as
select sID, cName, major
from Apply
where major = 'CS' or major = 'EE';


insert into CSEE values (111, 'Berkeley', 'CS');
insert into CSEE values (222, 'Berkeley', 'psychology');

insert into CSaccept values (333, 'Berkeley');

-- WITH CHECK OPTION makes sure modified data is visible through the view after the modification
create view CSaccept2 as
select sID, cName
from Apply
where major = 'CS' and decision = 'Y'
with check option;

insert into CSaccept2 values (444, 'Berkeley');

create view CSEE2 as
select sID, cName, major
from Apply
where major = 'CS' or major = 'EE'
with check option;

insert into CSEE2 values (444, 'Berkeley', 'psychology');
insert into CSEE2 values (444, 'Berkeley', 'CS');

create view HSgpa as
select sizeHS, avg(gpa) as GPA
from Student
group by sizeHS;

insert into HSgpa values (3000, 3.0); -- isn't compliant with restrictions because of aggregation

create view Majors as
select distinct major from Apply;

insert into Majors values ('chemistry');
delete from Majors where major = 'CS';

create view NonUnique as
select * from Student S1
where exists (select * from Student S2
			  where S1.sID <> S2.sID
			  and S2.GPA = S1.GPA and S2.sizeHS = S1.sizeHS);

-- works because in T-SQL you can reference the same table in subquery (can't in SQL Standard)
delete from NonUnique where sName = 'Amy';

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (654, 'Amy', 3.9, 1000);

create view Bio as
select * from Student
where sID in (select sID from Apply where major like 'bio%'); --allows for updatable views by SQL Standard

delete from Bio where sName = 'Bob';

insert into Bio values (555, 'Karen',  3.9, 1000);

create view Bio2 as
select * from Student
where sID in (select sID from Apply where major like 'bio%')
with check option;

insert into Bio2 values (666, 'Lori',  3.9, 1000);


create view Stan(sID,aID, sName, major) as 
select Student.sID, Apply.sID, sName, major
from Student, Apply
where Student.sID = Apply.sID and cName = 'Stanford';

update Stan set sName = 'CS major' where major = 'CS';

update Stan set aID = 666 where aID = 123;

create view Stan2(sID,aID, sNAme, major) as 
select Student.sID, Apply.sID, sName, major
from Student, Apply
where Student.sID = Apply.sID and cName = 'Stanford'
with check option;

update Stan2 set aID = 777 where aID = 678;
