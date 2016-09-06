install.packages("RODBC")

library(RODBC)

#view datasources
odbcDataSources()

#odbcConnect(dsn, uid="", pwd="") | Open a connection to an ODBC database
#sqlFetch(channel, sqtable) | Read a table from an ODBC database into a data frame
#sqlQuery(channel, query)     | Submit a query to an ODBC database and return the results
#sqlSave(channel, mydf, tablename = sqtable, append = FALSE) | Write or update (append=True) a data frame to a table in the ODBC database
#sqlDrop(channel, sqtable) | Remove a table from the ODBC database
#close(channel) | Close the connection
## schema method does not work very well - be aware


#Connect to Impala - the dsn name Impala should be in the list from the prior command
#it will be whatever you called it
#conn <- odbcConnect("localhost_mysql_64_user", uid="root", pwd="buddylee")
conn <- odbcConnect("localhost_mysql_64_system")


# Find out what tables are available (Optional)
Table_info <- sqlTables(conn)  

Table_target <- Table_info$TABLE_NAME[1]

# Get columns (and some additional info about columns) name from table
col_detail <- sqlColumns(conn, Table_target)
col_name <- sqlColumns(conn, Table_target)$COLUMN_NAME

#Columns <- as.data.frame(colnames(sqlFetch(conn, "claim_group_specialty")))


#Retrieve some results
result <- sqlQuery(conn, "
          `select commid, status, inception_date, signup_amt , signup_term
         
           from  vdeck_file1
           where status = 'Active'     
                   
          limit 10")