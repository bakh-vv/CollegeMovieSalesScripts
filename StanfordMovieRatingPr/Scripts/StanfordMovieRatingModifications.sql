insert into reviewer values (209, 'Roger Ebert');

INSERT INTO rating (rID, mID, stars, ratingDate)
select distinct 207, miD, 5, null
from Movie;

update movie
set year = year + 25
where mid in (select mid
from rating 
group by mid
having avg(stars) >= 4);

select mid
from rating 
group by mid
having avg(stars) >= 4;

select *
from rating
where mid in (select mID
from movie
where year < 1970 or year> 2000) and stars < 4;

select mID
from movie
where year < 1970 or year> 2000;

delete from rating
where mid in (select mID
from movie
where year < 1970 or year> 2000) and stars < 4;