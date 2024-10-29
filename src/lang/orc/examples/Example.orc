module simpleWorkflow


task createExternalTable:
  HiveAction(
    jobTracker = '...';
    nameNode = "...";
    script = "...";
  ) -> myScheduler 



task createOrcTable:
  HiveAction(
    jobTracker = "...";
    nameNode = "..."; 
    script = "...";
  ) -> myScheduler


task insertIntoTable:
  HiveAction(
    jobTracker = "...";
    nameNode = "...";
    script = "...";
  ) -> myScheduler
    
   
builder
  .startWith(step1)
  .then(step2).onError(test)
  .branch("ctrl-jumpto")
  .if(step1 > step2).do(then => then
                                  .startWith(insertIntoTable)
                                  .kill(killJob, "")
                      )
                    .else(then => then
                                  .startWith(insertIntoTable)
                                  .onError(test))
  .if(step1 > step2).then(insertIntoTable)
                    .else(insertIntoTable)
  .if(step1 > step2).then(insertIntoTable)
  .if(step1 > step2).then(insertIntoTable)
  .if(step1 > step2).then(insertIntoTable)
  .if(step1 > step2).then(insertIntoTable)
  .else(insertIntoTable)
  .kill(thers, "Killing ...")
  .parallel()
    .do(then => 
            then.startWith(external)
                .then(table)
                .onError(test)
                .kill(killJob, "Killing ...")
    )
    .do(then => 
          then.startWith(table)
              .then(insert)
              .onError(testr)
              .kill(killJob, "Killing ...")  
    )
  .join(step5)
  .end(step6)
	 
	 
createExternalTable >> (createOrcTable | insertIntoTable | insertIntoTable) >> createOrcTable
      	
     
    