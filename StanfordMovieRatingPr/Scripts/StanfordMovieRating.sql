select title
from movie
where director like N'Steven Spielberg';

select distinct year
from movie
where mID in (select mID from rating where stars >3)
order by year asc;

select title
from movie
where mID not in (select mID from rating);

select name
from reviewer join rating
on reviewer.rID = rating.rID
where ratingDate is null;

select name, title, stars, ratingDate
from reviewer, rating, movie
where reviewer.rID = rating.rID and movie.mID=rating.mID
order by name, title, stars;

ALTER TABLE Movie
ALTER COLUMN title NVARCHAR(MAX);

ALTER TABLE Movie
ALTER COLUMN director NVARCHAR(MAX);

ALTER TABLE Reviewer
ALTER COLUMN name NVARCHAR(MAX);

select name, title
from movie 
join rating on movie.mID = rating.mID
join reviewer on rating.rID= reviewer.rID
group by title;


select *
from rating
where rID, m

select name, title
from movie, reviewer, () as R
where ;

select r1.rID, r1.mID, r1.ratingDate
from Rating r1, Rating r2
where r1.rID = r2.rID and r1.mID = r2.mID and r1.ratingDate > r2.ratingDate and r1.stars > r2.stars;

select r1.rID, r1.mID, r1.ratingDate
from Rating r1, (select rID, mID, count(*) as C
from Rating
group by rID, mID
having count(*) = 2) as r2
where r1.rID = r2.rID and r1.mID = r2.mID and r1.stars > any (select stars from rating r3 
where r3.rID = r1.rID and r3.mID = r1.mID and r3.ratingDate < r1.ratingDate);

select name, title
from reviewer, movie, (select r1.rID, r1.mID, r1.ratingDate
from Rating r1, (select rID, mID, count(*) as C
from Rating
group by rID, mID
having count(*) = 2) as r2
where r1.rID = r2.rID and r1.mID = r2.mID and r1.stars > any (select stars from rating r3 
where r3.rID = r1.rID and r3.mID = r1.mID and r3.ratingDate < r1.ratingDate)) as R
where reviewer.rID = r.rID and movie.mID=r.mID;

select name, title
from Rating r1, Rating r2, movie, reviewer
where r1.rID = r2.rID and r1.mID = r2.mID and r1.ratingDate > r2.ratingDate and r1.stars > r2.stars 
and r1.rID= reviewer.rID and r1.mID = movie.mID;

select distinct title, stars
from movie m1, rating r1
where m1.mID=r1.mID and m1.mID in (select mID from rating) and stars >= 
(select max(stars) from rating r2 where r2.mID = r1.mID)
order by title; 

select stars
from rating
where stars >= (select max(stars) from rating);

select title, (select max(stars) from rating where rating.mID=m1.mID)- 
(select min(stars) from rating where rating.mID=m1.mID) as spread
from movie m1
where mID in (select mID from rating)
order by spread desc, title;

select distinct mID, (select avg(stars) from rating r2 where r2.mID = r1.mID)
from rating r1;

ALTER TABLE Rating
ALTER COLUMN stars DECIMAL(20,13);

select movie.mID,year, avgS
from (select mID, avg(stars) as avgS
from rating
group by mID) as A, movie
where A.mID = movie.mID and year < 1980;

select avg(AV1.avgS) - avg(AV2.avgS)
from (select avgS
from (select mID, avg(stars) as avgS
from rating
group by mID) as A, movie
where A.mID = movie.mID and year < 1980) as AV1, (select avgS
from (select mID, avg(stars) as avgS
from rating
group by mID) as A, movie
where A.mID = movie.mID and year > 1980) as AV2;
