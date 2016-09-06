

## create new table with subset
drop table if exists db_files.ip_file1_ss;


create table db_files.ip_file1_ss as
SELECT * 

FROM db_files.ip_file1
where property = "ipage"
	and UserName Not Like '%Delete%'
limit 1000;

## quick view of records
select * from db_files.ip_file1_ss;


## quick summary
select 	
		count(distinct(UserName)) as user_dct
		,count(CommID) as ct_sub
		,sum(NextAmt) as nextbill_amt
		
from db_files.ip_file1_ss;


## look at grouping + converting strings that should be numbers (easily)

select 	NextTerm*1
		,count(distinct(UserName)) as user_dct
		,count(CommID) as ct_sub
		,sum(NextAmt) as nextbill_amt

from db_files.ip_file1_ss
group by NextTerm*1
order by NextTerm*1;



## look at grouping + converting strings that should be numbers (easily)

ALTER TABLE db_files.ip_file1_ss #Add Primary Key cid(CommID), 
    Add Index nt(NextTerm) ;

select 	NextTerm*1
		,count(distinct(UserName)) as user_dct
		,count(CommID) as ct_sub
		,sum(NextAmt) as nextbill_amt

from db_files.ip_file1_ss
group by NextTerm*1
order by NextTerm*1;



## create subset of file4
drop table if exists db_files.ip_file4_ss;

create table db_files.ip_file4_ss as
SELECT TransactionID, UserName, TransactionDate, Amount, ProductFamily, Term 
FROM db_files.ip_file4
where Brand = "ipage"
and UserName Not Like '%Delete%'
;


## show an inner join to return 238 rows
# w/o index 30.8 secs
# w/ index  0.125 secs
drop table  if exists db_files.temp_1;


create table db_files.temp_1 as

#Explain Extended  ## uncomment to test Explain Extended output
select  

a.CommID, a.Username, a.Status, a.InceptionDate, a.SignupAmt, a.SignupTerm, a.DelDate, a.Origin, a.Property,
	   b.UserName as UN , b.TransactionDate, b.Amount, b.Term, b.ProductFamily

 from db_files.ip_file1_ss a
 Inner Join db_files.ip_file4_ss b on a.UserName = b.UserName;


# describe

describe db_files.ip_file1_ss;
describe db_files.ip_file4_ss;

## add index to file1 and file 4 for join
ALTER TABLE db_files.ip_file1_ss #Add Primary Key cid(CommID), 
    Add Index un(UserName) ;

ALTER TABLE db_files.ip_file4_ss #Add Primary Key cid(CommID), 
    Add Index un(UserName) ;

# w/ index  0.125 secs
drop table  if exists db_files.temp_1;


## Inner Join
create table db_files.inner_temp as
select  #a.UserName as auser, b.UserName as buser

a.CommID, a.Username, a.Status, a.InceptionDate, a.SignupAmt, a.SignupTerm, a.DelDate, a.Origin, a.Property,
	   b.UserName as UN , b.TransactionDate, b.Amount, b.Term, b.ProductFamily

 from db_files.ip_file1_ss a
 Inner Join db_files.ip_file4_ss b on a.UserName = b.UserName;

# Left Join
drop table  if exists db_files.left_temp;


create table db_files.left_temp as
select  #a.UserName as auser, b.UserName as buser

a.CommID, a.Username, a.Status, a.InceptionDate, a.SignupAmt, a.SignupTerm, a.DelDate, a.Origin, a.Property,
	   b.UserName as UN , b.TransactionDate, b.Amount, b.Term, b.ProductFamily

 from db_files.ip_file1_ss a
 left Join db_files.ip_file4_ss b on a.UserName = b.UserName;


# right Join
drop table  if exists db_files.right_temp;

create table db_files.right_temp as
select  #a.UserName as auser, b.UserName as buser

a.CommID, a.Username, a.Status, a.InceptionDate, a.SignupAmt, a.SignupTerm, a.DelDate, a.Origin, a.Property,
	   b.UserName as UN , b.TransactionDate, b.Amount, b.Term, b.ProductFamily

 from db_files.ip_file1_ss a
 right Join db_files.ip_file4_ss b on a.UserName = b.UserName;