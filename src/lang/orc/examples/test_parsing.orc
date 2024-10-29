module simpleWorkflow

scheduler myScheduler :
	frequency = "Monthly"
	startDate = "..."
	endDate = "..."

task myFSAction :
	FSAction (
		delete = (
			path = "hdfs://foo:8020/usr/joe/temp-data"
		);
		mkdir = (
			path = "myDir/${wf:id()}"
		);
		move = (
			source = "${jobInput}",
			target = "myDir/${wf:id()}/input"
		);
		chmod = (
			path = "${jobOutput}",
			permissions = "-rwxrw-rw-",
			dirFiles = "true"
		);
	) -> myScheduler


task Create_External_Table : 
	HiveAction(
		jobTracker = "xyz.com:8088";
		nameNode = "hdfs://rootname";
		script = "hdfs_path_of_script/external.hive";
	) -> myScheduler


task Create_orc_Table :
	HiveAction(
		jobTracker = "xyz.com:8088";
		nameNode = "hdfs://rootname";
		script = "hdfs_path_of_script/orc.hive";
	) -> myScheduler


task Insert_into_Table :
	HiveAction(
		jobTracker = "xyz.com:8088";
		nameNode = "hdfs://rootname";
		script = "hdfs_path_of_script/Copydata.hive";
		params = [
			"database_name"
			];

	) -> myScheduler



task myPigAction : 
	PigAction(
		jobTracker = "jt.mycompany.com:8032";
		nameNode = "hdfs://nn.mycompany.com:8020";
		prepare = (
			delete = "hdfs://nn.mycompany.com:8020/hdfs/user/joe/pig/output"
		);
		configuration = (
			property = (
				name = "mapred.job.queue.name",
				value = "research"
			)
		);
		script = "pig.script";
		arguments = [
			"-param",
			"age=30",
			"-param",
			"output=hdfs://nn.mycompany.com:8020/hdfs/user/joe/pig/output"
		];
	) -> myScheduler




dataflow flow1 :
        onError = fail 
            startTime=""
            endTime="" 
            frequency =""
            timeZone="" 
            properties:
                "runDate"="Pipeline.instance.runDate"
                "machineName"=${machineName}
        dag :
            startHistoricalLoad 
            staging 
            // (action) wrote it inside
            sqoop  :  
                    action = "import" 
                    // auto-generate name
                    configFile =  ${tradetype_table}#tradetype_table.par
            sqoop  :
                    action = "import" 
                    configFile =  ${statustype_table}#statustype_table.par
            sqoop  :
                    action = "import" 
                    configFile =  ${taxrate_table}#taxrate_table.par
            sqoop : 
                    action = "import" 
                    configFile =  ${industry_table}#industry_table.par
            sqoop : 
                    action = "import" 
                    configFile = ${date_table}#date_table.par
            sqoop  :
                    action = "import" 
                    configFile =  ${time_table}#time_table.par
            sqoop  :
                    action = "import" 
                    configFile =  ${hr_table}#hr_table.par
                    onSuccess = importFinwire  
            sqoop :
                    action = "import" 
                    configFile =  ${finwire_table}#finwire_table.par
                // check join in tpc-di
            parallel :
                    // creating schema
                    zone: 
                        name =  transformation
                        action = "recreate"
                        &&
                    // sql actions
                    transform: 
                        view =  finwireCMP
                        &&
                    transform:
                        view =  finwireSec
                        &&
                    transform:
                        view =  finwireFin
            
            // loading master schema
            transform:
                        view =  tradetype
            transform:
                        view =  statusType
            transform:
                        view =  taxRate
            transform:
                        view =  industry
            transform:
                        view=  dimdate
            transform:
                        view =  dimTime
            transform:
                        view =  temporarybroker
            transform:
                        view =  dimBroker