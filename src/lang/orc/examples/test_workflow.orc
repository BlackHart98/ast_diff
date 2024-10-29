module test_workflow


	scheduler myScheduler :
	    frequency = "Monthly"
	    startDate = "..."
	    endDate = "..."
		
	task createFlagFolder :
		JavaAction (
			jobTracker = "${jobTracker}";
			nameNode = "${oozieFsActionPrefix}";
			mainClass = "com.lendingclub.edh.etl.lcdp.OozieFSAction";
			arguments = [
				"${hadoopConfigPath}",
				"mkdir", 
				"${wfOutput}"
			];
		) -> myScheduler
	
	task sendRevRecLoadStartedEmail : 
		EmailAction (
			to = "${revRecEmailReceivers}";
			subject = "${revRecEmailTitle}--Started loading of \"cr_fac_inv_asset_monthly\" and \"investor_detail_monthly\" tables.";
			body = "Started loading of \"cr_fac_inv_asset_monthly\" and \"investor_detail_monthly\" tables.";
		) -> myScheduler
	
	
	task loanActivity : 
		HiveAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			configuration = (
				property = (
					name = "mapred.job.queue.name",
					value = "${queueName}"
				),
				property = (
					name = "mapred.reduce.tasks",
					value = "${queueName}"
				)
			);
			script = "${applicationPath}/hql-scripts/base_loan_activity.sql";
			params = [
				"baseDB=${baseDB}",
				"financeDB=${financeDB}",
				"shareDB=${shareDB}",
				"tlcencDB=${tlcencDB}",
				"riskDB=${riskDB}",
				"startDate=${startDate}",
				"endDate=${endDate}",
				"monthEnd=${monthEnd}",
				"prior_monthDate=${prior_monthDate}",
				"prior_mnth=${prior_mnth}",
				"interimDB=${interimDB}",
				"PERIOD_TS=${poke_period_ts}",
				"mergeparam=${mergeparam}"
			];
		) -> myScheduler
	

	task investorActivity : 
		HiveAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			configuration = (
				property = (
					name = "mapred.job.queue.name",
					value = "${queueName}"
				),
				property = (
					name = "mapred.reduce.tasks",
					value = "${queueName}"
				)
			);
			script = "${applicationPath}/hql-scripts/base_investor_activity.sql";
			params = [
				"financeDB=${financeDB}",
				"baseDB=${baseDB}",
				"interimDB=${interimDB}",
				"tlcencDB=${tlcencDB}",
				"riskDB=${riskDB}",
				"startDate=${startDate}",
				"endDate=${endDate}",
				"monthEnd=${monthEnd}",
				"PERIOD_TS=${poke_period_ts}",
				"mergeparam=${mergeparam}"
			];
		) -> myScheduler
		
	

	task sendRevRecLoadSuccessEmail : 
		EmailAction (
			to = "${revRecBizEmailReceivers}";
			subject = "${revRecEmailTitle}--Loading of \"cr_fac_inv_asset_monthly\" and \"investor_detail_monthly\" tables completed successfully.";
			body = "Loading of \"cr_fac_inv_asset_monthly\" and \"investor_detail_monthly\" tables completed successfully.";
		) -> myScheduler
	
	
	task sendRevRecLoadFailedEmail : 
		EmailAction (
			to = "${revRecEmailReceivers}";
			subject = "Loading of \"cr_fac_inv_asset_monthly\" and \"investor_detail_monthly\" tables completed successfully.";
			body = "Loading of \"cr_fac_inv_asset_monthly\" and \"investor_detail_monthly\" tables failed.The workflow ${wf:name()}'s instance with id ${wf:id()} failed. Last Failed Node: ${wf:lastErrorNode()} Message: ${wf:errorMessage(wf:lastErrorNode())}.";
		) -> myScheduler
	
	
	task createSuccessMarkerFile : 
		FSAction (
			touchz = (
				path = "${wfOutput}/_SUCCESS"
			);
		) -> myScheduler
	
	
	
	task fail : 
		JavaAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			configuration = (
				property = (
					name = "mapred.job.queue.name",
					value = "${queueName}"
				),			
				property = (
					name = "oozie.action.sharelib.for.java",
					value = "hive,sqoop"
				)
			);
			mainClass = "com.lendingclub.edh.alert.AlertAction";
			arguments = [
				"-app_config_file",
				"${appConfigFile}",
				"-hadoop_config_path",
				"${hadoopConfigPath}",
				"-wf_id",
				"${wf:id()}",
				"-wf_name",
				"${wf:name()}",
				"-email_to",
				"${notificationEmail_2}, ${revRecEmailReceivers}",
				"-email_subject",
				"${emailTitle} Workflow ${wf:name()} failed.",
				"-email_body",
				"The workflow ${wf:name()}'s instance with id ${wf:id()} failed. Last Failed Node: ${wf:lastErrorNode()}  Message: ${wf:errorMessage(wf:lastErrorNode())}"
			];
		) -> myScheduler
	
	
-- Building the workflow DAG	
	builder
		.startWith(createFlagFolder)
			.onError(fail)
			.kill(
				errorCleanup, 
				"Monthly common table loader failed, error message[${wf:errorMessage(wf:lastErrorNode())}]"
			)
		.then(sendRecRevLoadStartEmail)
		.then(loanActivity)
			.onError(sendRevRecLoadFailedEmail)
		.then(investorActivity)
			.onError(sendRevRecLoadFailedEmail)
				.then(fail)
		.then(sendRevRecLoadSuccessEmail)
		.then(createSuccessMarkerFile)
			.onError(fail)
			.kill(
				errorCleanup, 
				"Monthly common table loader failed, error message[${wf:errorMessage(wf:lastErrorNode())}]"
			)
		.end(end)
		
