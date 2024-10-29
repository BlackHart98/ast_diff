module test_workflow


	scheduler myScheduler :
	    frequency = "Monthly"
	    startDate = "..."
	    endDate = "..."
		
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
			
		) -> myScheduler
	
-- Building the workflow DAG	
	builder
		.startWith(loanActivity)
			.onError(fail)
			.kill(
				errorCleanup, 
				"Monthly common table loader failed, error message[${wf:errorMessage(wf:lastErrorNode())}]"
			)
		.end(end)
		
