select * 
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.ItemID = I.ItemID and F.custID = C.custID;


select S.city, I.color, C.cName, F.price 
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.ItemID = I.ItemID and F.custID = C.custID
and S.state = 'CA' and I.category = 'Tshirt' and C.age < 22 and F.price < 25;

select storeID, custID, sum(price)
from Sales
group by storeID, custID;

--Drill-down
select storeID, itemID, custID, sum(price)
from Sales
group by storeID, itemID, custID;

-- Slicing
select F.storeID, itemID, custID, sum(price)
from Sales F, store S
where F.storeID = S.storeID and state = 'WA'
group by F.storeID, itemID, custID;

-- Dicing
select F.storeID, F.itemID, custID, sum(price)
from Sales F, store S, Item I
where F.storeID = S.storeID and F.ItemID = I.ItemID and state = 'WA' and color = 'red'
group by F.storeID, F.itemID, custID;

select storeID, itemID, custID, sum(price)
from Sales F
group by storeID, itemID, custID;

--Rollup
select itemID, sum(price)
from Sales F
group by itemID;

select state, category, sum(price)
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
group by state, category;

--drill-down
select state, county, category, sum(price)
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
group by state, county, category;

--drilldown
select state, county, category, gender, sum(price)
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.itemID = I.itemID and F.custID = C.custID
group by state, county, category, gender;

--rollup
select state, gender, sum(price)
from Sales F, Store S, Item I, Customer C
where F.storeID = S.storeID and F.itemID = I.itemID and F.custID = C.custID
group by state, gender;

--OLAP SQL constructs
select storeID, itemID, custID, sum(price)
from Sales
group by cube (storeID, itemID, custID);

--double checking
select sum(price) from Sales;

-- put the cube in a table
select storeID, itemID, custID, sum(price) as p
into Cube
from Sales
group by cube (storeID, itemID, custID);

-- quering the cube
select C.*
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is null;

select sum(p)
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is null;

select C.*
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is not null;

select sum(p)
from Cube C, Store S, Item I
where C.storeID = S.storeID and C.itemID = I.itemID
and state = 'CA' and color = 'blue' and custID is not null;

select F.*
from Sales F, Store S, Item I
where F.storeID = S.storeID and F.itemID = I.itemID
and state = 'CA' and color = 'blue';

-- variation of group by cube. give summaries only for some dimensions
select storeID, itemID, custID, sum(price)
from Sales F
group by cube (storeID, custID), itemID;

-- with rollup
select storeID, itemID, custID, sum(price)
from Sales F
group by rollup (storeID, itemID, custID);

select state, county, city, sum(price)
from Sales F, store S
where F.storeID = S.storeID
group by rollup (state, county, city);
-- group by cube wouldn't give us any extra information in this case, it would just be less efficient with the same data
