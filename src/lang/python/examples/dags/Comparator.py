"""sales_pipeline_bundle"""
DAG("""build_dim_table_coord""", start_date=""""${start_time}"""", end_date=""""${end_time}"""", schedule_interval=""""${coord:days(1)}"""")

