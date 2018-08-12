ALTER DATABASE CollegesAndStuffRe
MODIFY FILE (name='CollegesAndStuffRe'
             ,filename='C:\Users\Bakhtiyar\source\repos\CollegeMoviesSalesSQL\CollegesAndStuffPr\CollegesAndStuffRe\CollegesAndStuffRe.mdf'); 

ALTER DATABASE CollegesAndStuffRe SET OFFLINE WITH ROLLBACK IMMEDIATE;

-- copy files .mdf and _log.ldf to new folder through copy-paste

ALTER DATABASE CollegesAndStuffRe SET ONLINE;