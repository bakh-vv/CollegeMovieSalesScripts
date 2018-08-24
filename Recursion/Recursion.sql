create table ParentOf(parent nvarchar(255), child nvarchar(255));

insert into ParentOf values ('Alice', 'Carol');
insert into ParentOf values ('Bob', 'Carol');
insert into ParentOf values ('Carol', 'Dave');
insert into ParentOf values ('Carol', 'George');
insert into ParentOf values ('Dave', 'Mary');
insert into ParentOf values ('Eve', 'Mary');
insert into ParentOf values ('Mary', 'Frank');

with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select ParentOf.parent, Ancestor.d as d
from Ancestor, ParentOf
where Ancestor.a = ParentOf.child and ParentOf.parent = 'Eve')
select d from Ancestor where a = 'Eve';

with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select Ancestor.a, ParentOf.child as d
from Ancestor, ParentOf
where Ancestor.d = ParentOf.parent)
select d from Ancestor where a = 'Carol';


-- recursive query
with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select Ancestor.a, ParentOf.child as d
from Ancestor, ParentOf
where Ancestor.d = ParentOf.parent)
select a from Ancestor where d = 'Mary';

with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select Ancestor.a, ParentOf.child as d
from Ancestor, ParentOf
where Ancestor.d = ParentOf.parent)
select a from Ancestor where d = 'Frank';

with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select Ancestor.a, ParentOf.child as d
from Ancestor, ParentOf
where Ancestor.d = ParentOf.parent)
select a from Ancestor where d = 'George';

with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select Ancestor.a, ParentOf.child as d
from Ancestor, ParentOf
where Ancestor.d = ParentOf.parent)
select a from Ancestor where d = 'Bob';

create table Employee(ID float, salary float);
create table Manager(mID float, eID float);
create table Project(name nvarchar(255), mgrID float);

insert into Employee values (123, 100);
insert into Employee values (234, 90);
insert into Employee values (345, 80);
insert into Employee values (456, 70);
insert into Employee values (567, 60);
insert into Manager values (123, 234);
insert into Manager values (234, 345);
insert into Manager values (234, 456);
insert into Manager values (345, 567);
insert into Project values ('X', 123);

-- recursive query with transitive closure
with Superior as
(select * from Manager
union all
select S.mID, M.eID
from Superior S, Manager M
where S.eID = M.mID)
select sum(salary)
from Employee
where ID in (select mgrID from Project where name = 'X'
union
select eID from Project, Superior 
where Project.name = 'X' and Project.mgrID = Superior.mID);

-- alternative: only compute what's needed (not whole superior relation for the entire company)
with Xemps(ID) as
(select mgrID from Project where name = 'X'
union all
select distinct eID -- T-SQL doesn't allow DISTINCT in the recursive member of the CTE
from Manager M, Xemps X
where X.ID = M.mID)
select sum(salary)
from Employee
where ID in (select ID from Xemps);

-- rewriting the query above without the DISTINCT in the recursive member. the same behaviour
with Xemps(ID) as
(select mgrID from Project where name = 'X'
union all
select eID 
from Manager M, Xemps X
where X.ID = M.mID)
select sum(salary)
from Employee
where ID in (select ID from Xemps);

insert into Project values ('Y', 234);
insert into Project values ('Z', 456);

with 
Yemps(ID) as
(select mgrID from Project where name = 'Y'
union all
select eID 
from Manager M, Yemps Y
where Y.ID = M.mID),
Zemps(ID) as
(select mgrID from Project where name = 'Z'
union all
select eID 
from Manager M, Zemps Z
where Z.ID = M.mID)
select 'Y-total', sum(salary)
from Employee
where ID in (select ID from Yemps)
union
select 'Z-total', sum(salary)
from Employee
where ID in (select ID from Zemps);


create table Flight(orig nvarchar(255), dest nvarchar(255), airline nvarchar(255), cost float);

insert into Flight values ('A', 'ORD', 'United', 200);
insert into Flight values ('ORD', 'B', 'American', 100);
insert into Flight values ('A', 'PHX', 'Southwest', 25);
insert into Flight values ('PHX', 'LAS', 'Southwest', 30);
insert into Flight values ('LAS', 'CMH', 'Frontier', 60);
insert into Flight values ('CMH', 'B', 'Frontier', 60);
insert into Flight values ('A', 'B', 'JetBlue', 195);

-- all possible prices for getting from one airport to another
with Route(orig, dest, total) as
(select orig, dest, cost as total from Flight
union all
select R.orig, F.dest, total + cost as total
from Flight F, Route R
where R.dest = F.orig)
select * from Route
where orig = 'A' and dest = 'B';

-- selecting cheapest one
with Route(orig, dest, total) as
(select orig, dest, cost as total from Flight
union all
select R.orig, F.dest, total + cost as total
from Flight F, Route R
where R.dest = F.orig)
select min(total) from Route
where orig = 'A' and dest = 'B';

-- alternative that maybe more efficient. Starting from point A where we can get for how much
with FromA(dest, total) as
(select dest, cost as total from Flight where orig = 'A' -- if it was non-linear recursion, this restriction would intervene with the process of recursion and not all the links will be calculated
union all
select F.dest, total + cost as total -- you can't put the restriction here, because it will intervene with the process of recursion and not all the links will be calculated in linear case
from Flight F, FromA FA
where FA.dest = F.orig)
select * from FromA;

with FromA(dest, total) as
(select dest, cost as total from Flight where orig = 'A'
union all
select F.dest, total + cost as total
from Flight F, FromA FA
where FA.dest = F.orig)
select min(total) from FromA
where dest = 'B';

-- same idea, but backwards
with ToB(orig, total) as
(select orig, cost as total from Flight where dest = 'B'
union all
select F.orig, total + cost as total
from Flight F, ToB TB
where TB.orig = F.dest)
select * from ToB;

with ToB(orig, total) as
(select orig, cost as total from Flight where dest = 'B'
union all
select F.orig, total + cost as total
from Flight F, ToB TB
where TB.orig = F.dest)
select min(total) from ToB
where orig = 'A';


insert into Flight values ('CMH', 'PHX', 'Frontier', 80); -- creates a possible loop. infinite number of possible routes

-- need to add restriction to limit the number of routes found
with Route(orig, dest, total) as
(select orig, dest, cost as total from Flight
union all
select R.orig, F.dest, total + cost as total
from Flight F, Route R
where R.dest = F.orig
and total + cost < all (select total from Route R2 --can't refer to the recursively defined relation in a subquery
where R2.orig = R.orig and R2.dest = F.dest))
select * from Route
where orig = 'A' and dest = 'B';

-- causes maxrecursion error, because the loops goes past the limit (it's infinite)
with Route(orig, dest, total) as
(select orig, dest, cost as total from Flight
union all
select R.orig, F.dest, total + cost as total
from Flight F, Route R
where R.dest = F.orig)
select * from Route
where orig = 'A' and dest = 'B'
OPTION (MAXRECURSION 200);

-- fix the maxrecursion error by limiting the depth of the recursion by adding column 'level'
with Route(orig, dest, total, level) as
(select orig, dest, cost as total, 0 as level from Flight
union all
select R.orig, F.dest, total + cost as total, level + 1
from Flight F, Route R
where R.dest = F.orig and level < 56)
select * from Route
where orig = 'A' and dest = 'B'
OPTION (MAXRECURSION 56); -- this option is not neccessary, it's a sanity check

-- getting min
with Route(orig, dest, total, level) as
(select orig, dest, cost as total, 0 as level from Flight
union all
select R.orig, F.dest, total + cost as total, level + 1
from Flight F, Route R
where R.dest = F.orig and level < 56)
select min(total) from Route
where orig = 'A' and dest = 'B'
OPTION (MAXRECURSION 56);

-- similar alternative, by adding 'length' - the number of flights
with Route(orig, dest, total, length) as
(select orig, dest, cost as total, 1 from Flight
union all
select R.orig, F.dest, total + cost as total, R.length + 1
from Flight F, Route R
where R.dest = F.orig and R.length < 10) -- presumption is that noone want to take more than 10 flights
select * from Route
where orig = 'A' and dest = 'B';

with Route(orig, dest, total, length) as
(select orig, dest, cost as total, 1 from Flight
union all
select R.orig, F.dest, total + cost as total, R.length + 1
from Flight F, Route R
where R.dest = F.orig and R.length < 10)
select min(total) from Route
where orig = 'A' and dest = 'B';


-- ancestor query from before (shows linear recursion)
with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select Ancestor.a, ParentOf.child as d
from Ancestor, ParentOf
where Ancestor.d = ParentOf.parent)
select a from Ancestor where d = 'Mary';

-- non-linear alternative (two references to Ancestor in the recursion). SQL doesn't support it
with Ancestor(a,d) as 
(select parent as a, child as d from ParentOf
union all
select A1.a, A2.d
from Ancestor A1, Ancestor A2
where A1.d = A1.a)
select a from Ancestor where d = 'Mary';


create table Link (src float, dest float);
create table HubStart (node float);
create table AuthStart (node float);

/* mutual recursion (not supported in t-sql)*/
with
Hub(node) as 
(select node from HubStart
union all
select src from Link L
where dest in (select node from Auth)
group by src having count(*)>=3),
Auth(node) as 
(select node from AuthStart
union all
select dest from Link L
where src in (select node from Hub)
group by dest having count(*)>=3)
select * from Hub;

-- can only be either a node or an authority
with
Hub(node) as 
(select node from HubStart
union all
select src from Link L
where dest in (select node from Auth) and src not in (select node from Auth)
group by src having count(*)>=3),
Auth(node) as 
(select node from AuthStart
union all
select dest from Link L
where src in (select node from Hub) and dest not in (select node from Hub)
group by dest having count(*)>=3)
select * from Hub;
-- there could be nodes where whether it will become a hub or an authority depends entirely on which part of our query
-- gets executed first. non-deterministic behavior / non-unique fixed point of the recursion. Generally you want 
-- deterministic answers for your queries
-- This negative dependance is prohibited by SQL Standard