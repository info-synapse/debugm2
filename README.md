# debugm2
Press create server ...
Then press "test". It will return bad request and the exception is like the one below.
The press checkbox "use direct ..." to test again with success (this method throws very rare errors)


<img src="https://github.com/info-synapse/debugm2/blob/main/screenshot1.png" width="50%" height="50%">


copy from error log

20240125 15482638  +    mormot.rest.sqlite3.TRestServerDB(037bcfc0).URI GET root?sql=select%20event_id,testget(event_id)%20as%20fresult%20from%20bet_events%20limit%2010 in=0 B
20240125 15482638 SQL   	mormot.rest.sqlite3.TRestServerDB(037bcfc0) 60us returned 1 row as 11 B select count(*) as cc from wsbet_events where event_id=1;

20240125 15482638 res   	mormot.db.raw.sqlite3.TSqlDatabase(0381a958) [{"cc":0}] 

20240125 15482638 EXC   	ESqlite3Exception {Message:"Error SQLITE_MISUSE (21) [FieldsToJson] using 3.44.2 - another row available",ErrorCode:21,SQLite3ErrorCode:"secMISUSE"} [HttpSrv 8887root THttpApiSrv] at 8272ab  

20240125 15482638 res   	{"TSqlDatabase(0381a958)":{FileName:":memory:",UseCache:true,UseCacheSize:16777216,TransactionActive:false,BusyTimeout:0,CacheSize:4294965296,PageSize:4096,PageCount:4138,FileSize:16949248,WALMode:false,Synchronous:"smFull",LockingMode:"lmNormal",MemoryMappedMB:0,user_version:0,OpenV2Flags:6,BackupBackgroundInProcess:false,BackupBackgroundLastTime:"",BackupBackgroundLastFileName:"",SQLite3Library:{"TSqlite3LibraryStatic(0379c430)":{Version:"TSqlite3LibraryStatic 3.44.2 with internal MM"}}}}

20240125 15482638 debug 	mormot.rest.sqlite3.TRestServerDB(037bcfc0) TRestServerRoutingRest.Error: {  "errorCode":400,  "errorText":"Bad Request"  }
20240125 15482639 srvr  	  Read GET root=400 out=49 B in 1.87ms
20240125 15482639 ret   	mormot.rest.server.TRestServerRoutingRest(03f43f00) {  "errorCode":400,  "errorText":"Bad Request"  }
