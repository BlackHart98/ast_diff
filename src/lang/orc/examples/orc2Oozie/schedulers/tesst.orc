module sales_pipeline_bundle

scheduler myScheduler:
	frequency="${coord:days(1)}" 
	startDate="${start_time}" 
	endDate="${end_time}"