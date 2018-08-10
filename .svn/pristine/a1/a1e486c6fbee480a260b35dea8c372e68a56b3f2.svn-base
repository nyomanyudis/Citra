 CREATE TABLE "stockdata_tbl" ("id" INTEGER , "code" VARCHAR PRIMARY KEY NOT NULL  , "name" VARCHAR, "client_type" INTEGER, "color" VARCHAR);
 CREATE TABLE "brokerdata_tbl" ("id" INTEGER , "code" VARCHAR PRIMARY KEY NOT NULL  , "name" VARCHAR, "status" INTEGER, "type" INTEGER);
 CREATE TABLE "indicesdata_tbl" ("id" INTEGER , "code" VARCHAR PRIMARY KEY NOT NULL  );
 CREATE TABLE "regionalindicesdata_tbl" ("id" INTEGER , "code" VARCHAR PRIMARY KEY NOT NULL  , "name" VARCHAR, "fullname" VARCHAR);
 CREATE TABLE "currencydata_tbl" ("id" INTEGER , "code" VARCHAR PRIMARY KEY NOT NULL  , "name" VARCHAR);
 CREATE TABLE "watchlist_tbl" ("id" PRIMARY KEY NOT NULL );
 CREATE TABLE "prop_tbl" ("userid" VARCHAR, "passwd" VARCHAR, "stockwatch_id" INTEGER, "netbroker_id" INTEGER, "netstock_id" INTEGER, "lastupdate_db" VARCHAR);
 CREATE TABLE "fd_tbl" ("id" PRIMARY KEY NOT NULL );
 CREATE TABLE "regsummary_tbl" ("pos" INTEGER, "type" INTEGER, "id" INTEGER, "code" VARCHAR, "name" VARCHAR);
 -- CREATE TABLE "log_tbl" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "log" VARCHAR);

 CREATE  TABLE "tbl_date" ("last_date" DATETIME);
 -- CREATE  TABLE "tbl_log" ("log_id" INTEGER PRIMARY KEY  AUTOINCREMENT , "log_date" DATETIME,  "log_string" TEXT check(typeof("log_string") = 'text'));
CREATE  TABLE "tbl_log" ("log_id" INTEGER PRIMARY KEY  AUTOINCREMENT , "log_date" DATETIME,  "log_string" VARCHAR);

 CREATE  TABLE "tbl_setting" ("popup_receive" BOOL, "popup_order_status" BOOL);

 INSERT INTO "regsummary_tbl"
 SELECT -1, 1, -1, 'DJIA', ''
 UNION
 SELECT -2, 1, -1, 'HSI', ''
 UNION
 SELECT 0, 1, -1, 'DJIA', ''
 UNION
 SELECT 1, 0, -1, 'COMPOSITE', ''
 UNION
 SELECT 2, 1, -1, 'FTSE', ''
 UNION
 SELECT 3, 1, -1, 'HSI', ''
 UNION
 SELECT 4, 1, -1, 'CAC', ''
 UNION
 SELECT 5, 1, -1, 'KSCI', ''
 UNION
 SELECT 6, 1, -1, 'DAX', ''
 UNION
 SELECT 7, 1, -1, 'SNI', ''
 UNION
 SELECT 8, 1, -1, 'SPX', ''
 UNION
 SELECT 9, 1, -1, 'KCOM', '';
 
 INSERT INTO "prop_tbl" values('', '', -1, -1, -1, '');

 INSERT INTO "tbl_setting" ("popup_receive","popup_order_status") VALUES (1, 0);