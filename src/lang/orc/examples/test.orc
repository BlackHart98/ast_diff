module build_dim_table_wf

task customer_dim:
	HiveAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			script = "${nameNode}/user/${userName}/${oozieRoot}/scripts/hivewh/dim_customer.hql#dim_customer.hql";
		) -> myScheduler
task date_dim:
	HiveAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			script = "${nameNode}/user/${userName}/${oozieRoot}/scripts/hivewh/dim_date.hql#dim_date.hql";
		) -> myScheduler
task dim_employee:
	HiveAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			script = "${nameNode}/user/${userName}/${oozieRoot}/scripts/hivewh/dim_employee.hql#dim_employee.hql";
		) -> myScheduler
task dim_product:
	HiveAction (
			jobTracker = "${jobTracker}";
			nameNode = "${nameNode}";
			script = "${nameNode}/user/${userName}/${oozieRoot}/scripts/hivewh/dim_product.hql#dim_product.hql";
		) -> myScheduler

-- DAG
builder
	.startWith(customer_dim)
	.onError(kill)
	.then(date_dim)
	.onError(kill)
	.then(dim_employee)
	.onError(kill)
	.then(dim_product)
    .onError(kill)
	.kill(kill, "Action failed, error message[${wf:errorMessage(wf:lastErrorNode())}]")
	.end(end)