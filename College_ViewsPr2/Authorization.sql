update Apply
set decision = 'Y'
where sID in (select sID
			  from Student
			  where GPA > 3.9); --required priveleges: update apply(decision), select apply(sID), 
								-- select Student(sID, GPA)

delete from Student
where sID not in (select sID from Apply); -- required priveleges: delete student, select student(sid),
										  -- select Apply(sID)

-- give access to data for Stanford applicants only
create view SS as
select * from Student
where sID in
(select sID from Apply
where cName = 'Stanford');
-- give privelege select on view SS

create view BA as
select * from Apply
where cName = 'Berkeley';
-- give privelege delete on BA view

