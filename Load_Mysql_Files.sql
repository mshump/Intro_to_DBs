# Create table skeleton to load into


CREATE TABLE `db_files`.`ints_file1` (
  `commid` INT NULL,
  `username` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `orig_date` DATE NULL,
  `inception_date` DATE NULL,
  `signup_amt` DOUBLE NULL,
  `signup_term` INT NULL,
  `cancel_date` DATE NULL,
  `lastbill_date` DATE NULL,
  `lastbill_amt` DOUBLE NULL,
  `lastbill_term` INT NULL,
  `nextbill_date` DATE NULL,
  `nextbill_amt` DOUBLE NULL,
  `nextbill_term` INT NULL,
  `nextmethod` VARCHAR(45) NULL,
  `nextoffername` VARCHAR(45) NULL,
  `ignore_this` VARCHAR(45) NULL,
  `pastdue` VARCHAR(45) NULL,
  `origin` VARCHAR(45) NULL,
  `currency` VARCHAR(45) NULL,
  `property` VARCHAR(45) NULL,
  `liveaccount_date` DATE NULL,
  `credits` DOUBLE NULL,
  `schedulefordel` VARCHAR(45) NULL,
  `type` VARCHAR(45) NULL,
  `membership` VARCHAR(45) NULL,
  `nextoffer_id` VARCHAR(45) NULL,
  `nextmaster_id` VARCHAR(45) NULL,
  `lastoffer_id` VARCHAR(45) NULL,
  `reseller` VARCHAR(45) NULL,
  `resold_count` VARCHAR(45) NULL,
  `migration_date` DATE NULL,
  `aff_id` VARCHAR(45) NULL);

#C:\\Program Files\\MySQL\\MySQL Server 5.6\\data\\mysql
#C:\\Users\\mshump\\Desktop\\db\\db Consulting\\Hamed\\Projects\\Files15\\ints_sample.csv

# load data into db - note, MySQL starts with some strange access / permission issues. use the data\mysql folder to load data in

load data infile 'C:\\Program Files\\MySQL\\MySQL Server 5.6\\data\\mysql\\ints_sample.csv' IGNORE 
into table db_files.ints_file1
fields terminated by ','lines terminated by '\n'
IGNORE 1 Lines 

(commid,username, status,
@orig_date,
@inception_date,
signup_amt,signup_term,
@cancel_date,
@lastbill_date,
lastbill_amt,lastbill_term,
@nextbill_date,
nextbill_amt,nextbill_term,nextmethod,
nextoffername,ignore_this,pastdue,origin,currency,property,
@liveaccount_date,
credits,
@schedulefordel,
type,membership,nextoffer_id,nextmaster_id,lastoffer_id,reseller,resold_count,
@migration_date,
aff_id)



SET orig_date = DATE_FORMAT(STR_TO_DATE(@orig_date, '%m/%d/%Y'), '%Y-%m-%d'),
 inception_date = DATE_FORMAT(STR_TO_DATE(@inception_date, '%m/%d/%Y'), '%Y-%m-%d'),
 cancel_date = DATE_FORMAT(STR_TO_DATE(@cancel_date, '%m/%d/%Y'), '%Y-%m-%d'),
 lastbill_date = DATE_FORMAT(STR_TO_DATE(@lastbill_date, '%m/%d/%Y'), '%Y-%m-%d'),
 nextbill_date = DATE_FORMAT(STR_TO_DATE(@nextbill_date, '%m/%d/%Y'), '%Y-%m-%d'),
 liveaccount_date = DATE_FORMAT(STR_TO_DATE(@liveaccount_date, '%m/%d/%Y'), '%Y-%m-%d'),
 schedulefordel = DATE_FORMAT(STR_TO_DATE(@schedulefordel, '%m/%d/%Y'), '%Y-%m-%d'),
 migration_date = DATE_FORMAT(STR_TO_DATE(@migration_date, '%m/%d/%Y'), '%Y-%m-%d');


# this will delete all data from table without loosing the structure you created
truncate db_files.ints_file1;
