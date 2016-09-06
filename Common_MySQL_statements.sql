##Load File into db##

load data infile 'C:\\Users\\mshump\\Desktop\\cs_data_dump_01_base_packages.csv' IGNORE into table fin_corp_ma.k_1_doc_v1
fields terminated by ',' lines terminated by '\n';



##Create primary key (unique column to index)##

CREATE TABLE fin_corp_ma.k_1_doc_v2 AS 
select l.*, 
    @curRow := @curRow + 1 AS row_number
 From fin_corp_ma.k_1_doc_v1 l
 JOIN    (SELECT @curRow := 0) r;
 

##Index primary key and additional index for joining or aggregation##

 
ALTER TABLE fin_corp_ma.k_1_doc_v2 Add Primary Key rn(row_number), 
    Add Index acct(uniqueaccountid) ;



##Update a single column in an existing table##

update finmts.domains_all set Domain = Replace(Domain, '*.','');


##Create Table with some additional columns##


CREATE TABLE fin_corp_ma.tmp_k_4_v7 AS
 
select *,
     Sum(case Aspect when 'Hosting' then billamt else 0 end)  as suHostAmt_sum,
     Sum(case Aspect when 'Addon' then billamt else 0 end)  as suAddAmt_sum,
     Sum(case Aspect when 'Domain' then billamt else 0 end)  as sudomainAmt_sum,

    From fin_corp_ma.tmp_k_4_v6
    Group By uniqueaccountid;



##truncate table finmts.Client_Base;
truncate table finmts.Client_Base;


##Create View
create view fin_corp_ma.cali_file4_view as
select *,
case term when 1 then 1 when 12 then 12 else 0 end as Term1MO,
if(billamt >= 0, 'Inflow', 'Outflow') as Directiontxn,
case billamt when 0 then 0 else 1 end as Paidtxn,
Extract(Year_Month from billdate) as billdateYRMO,
Extract(Year from billdate) as billdateYR,
Period_Diff(Extract(Year_Month from billdate), Extract(Year_Month from startdate)) as MonthsSinceSignup,
If(billdate <> startdate,0,1) as InitialTxn
From fin_corp_ma.cali_file4_2 LIMIT 0, 100;



##JOining

CREATE TABLE fin_corp_ma.k_5_v2 AS 
select  a.*, b.channelgroup,
        Extract(Year_Month from a.signupdate) as custsudateYRMO,
        Extract(Year from a.signupdate) as custsudateYR,
        Extract(Year_Month from a.billthrudate) as custbtdateYRMO,
        Extract(Year from a.billthrudate) as custbtdateYR,
        Extract(Year_Month from a.canceldate) as custcldateYRMO,
        Extract(Year from a.canceldate) as custcldateYR
    From fin_corp_ma.k_5_v1 a INNER JOIN fin_corp_ma.k_cg b
    ON a.Channel = b.Channel;



#Export

SELECT * FROM fin_corp_ma.k_5_prof1 INTO OUTFILE 'C:\\Users\\mshump\\Desktop\\k_5_prof1.csv'
    FIELDS TERMINATED BY ',';

##Export 2

SELECT *
INTO OUTFILE 'C:\\Users\\mshump\\Desktop\\k_5_prof2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'
FROM fin_corp_ma.k_5_prof2;

#LEft Join

CREATE TABLE fin_corp_ma.k_4_v4 AS 
select a.uniqueaccountid,
        a.customerid,
        a.transactionid,
        a.billdate,
        a.billamt,
        a.billterm,
        a.proddescriptor,
        a.prodtype,
        a.transactiontype,
        a.billtermgroup,
        a.billdateYRMO,
        a.billdateYR,
        a.brand,
        a.channel,
        a.Aspect,
        a.channelgroup,
        a.signupcusttype,
        a.signupterm,
        b.firstbilldate,
        Period_Diff(Extract(Year_Month from a.billdate), Extract(Year_Month from b.firstbilldate)) as monthsincebt
    From fin_corp_ma.k_4_v3 a Left JOIN fin_corp_ma.tmp_k_4_v2 b
    ON a.uniqueaccountid = b.uniqueaccountid;


## Count rows

CREATE TABLE k_2_v2 AS 
select l.*, 
    @curRow := @curRow + 1 AS row_number
 From k_2_v1 l
 JOIN    (SELECT @curRow := 0) r;

## Sort

ALTER TABLE fin_corp_ma.tmpz_k_4_v6 ORDER BY uniqueaccountid,  starthostpack  ASC ;


#Concat

CREATE TABLE k_prodmig_v3 AS 
select  *,
    RTRIM(CONCAT_WS(' ',pack_0,pack_1,pack_2,pack_3,pack_4))  as packpurpath
From k_prodmig_v2;


#Misc

CREATE TABLE fin_corp_ma.k_4r_v2 AS 
select a.uniqueaccountid,
        a.customerid,
        a.transactionid,
        a.billdate,
        a.billamt,
        a.billterm,
        a.prodescriptor as proddescriptor,
        a.prodtype,
        a.transactiontype,
        case a.billterm when 1 then 1 when 12 then 12 else 0 end as billtermgroup,
        Extract(Year_Month from a.billdate) as billdateYRMO,
        Extract(Year from a.billdate) as billdateYR,
        b.brand,
        b.channel,
        'Other'  as Aspect,
        b.channelgroup,
        b.signupcusttype,
        b.signupterm,
        b.firstbilldate,
        Period_Diff(Extract(Year_Month from a.billdate), Extract(Year_Month from b.firstbilldate)) as monthsincebt,
    
        b.firstbilldate as firstcustdate,
        
        case  when  b.firsthostdate = a.billdate then 'New' else ' Renew' end as Cust_New_Renew,
        b.firsthostdate,
        Period_Diff(Extract(Year_Month from a.billdate), Extract(Year_Month from b.firsthostdate)) as monthsincefh,
        case when b.firsthostdate > 0 then 'Yes' else 'No' end as HasHostTxn
    
    From fin_corp_ma.zk_4r_v1 a Left JOIN fin_corp_ma.k_5_prof_f b
    ON a.uniqueaccountid = b.uniqueaccountid;


#Add unique Index

CREATE TABLE fin_corp_ma.k_2_doc_v2 AS 
select l.*, 
    @curRow := @curRow + 1 AS row_number
 From fin_corp_ma.k_2_doc_v1 l
 JOIN    (SELECT @curRow := 0) r;
 
 
 ALTER TABLE fin_corp_ma.k_2_doc_v2 Add Primary Key rn(row_number), 
    Add Index acct(uniqueaccountid) ;

##MYSQL commands

mysql -ufinance -pfunpass

then, when you're in there:

show full processlist;
-shows everything that's running

kill <id>;
-grab an id from the processlist to kill the query (can be bad if you're doing updates or alters, because you'll leave a table in an indeterminate
state)

use <databasename>;
-logs you into a database (or schema, in your parlance), if you want to run manual queries


