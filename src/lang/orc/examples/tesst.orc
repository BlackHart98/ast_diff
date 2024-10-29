module config.dataflow_orc

//import batch.config.batch_config

define action :
     shell:
       name = startHistoricalLoad
       configFile = ${example}#start.sh
       
define action:
    zone:
     name = staging
       configFile = ${example}#start.sh




dataflow flow1 :
        onError = fail
        configurationProperties:
          "javax.jdo.option.ConnectionURL"="jdbc:mysql://127.0.0.1/metastore?createDatabaseIfNotExist=true"
          "javax.jdo.option.ConnectionDriverName"="com.mysql.jdbc.Driver"
          "javax.jdo.option.ConnectionUserName"="hive"
        dag :
            startHistoricalLoad 
            staging 
            sqoop  :
                    action = "import" 
                    configFile =  ${tradetype_table}#tradetype_table.par

                parallel :
                        zone:
                                name =  transformation
                                action = "recreate"
                                &&
                        transform:
                                view =  finwireCMP
                                &&
                        transform:
                                view =  finwireSec
                                &&
                        transform:
                                view =  finwireFin
        transform:
                        view =  tradetype

define action :
     kill:
       message = "action failed"