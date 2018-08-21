IF sessionproperty('ANSI_NULLS') = 1 
   PRINT 'Everything is fine'
ELSE
   PRINT 'Cough. It''s dusty in here';

IF sessionproperty('ARITHABORT') = 1 
   PRINT 'Everything is fine'
ELSE
   PRINT 'Cough. It''s dusty in here';

IF sessionproperty('NUMERIC_ROUNDABOUT') = 1 
   PRINT 'Everything is fine'
ELSE
   PRINT 'Cough. It''s dusty in here';

create view CA_CS
with schemabinding -- allows creating index on the view (to materialize it)
as
select C.cName, S.sName
from dbo.College C, dbo.Student S, dbo.Apply A
where C.cName = A.cName and S.sID = A.sID
and C.state = 'CA' and A.major = 'CS';


create unique clustered index Idx_V1 -- make the view stored in the database
on CA_CS (cName, sName);