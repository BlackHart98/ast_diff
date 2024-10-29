module config.dataFlow


define action:
    zone:
     name = staging

define action :
     shell:
       name = startHistoricalLoad
       configFile = ${example}#start.sh

                   dataflow flow1 :
                    onError = fail 
                    dag :
                        startHistoricalLoad 
                        staging 
                        sqoop  :
                                action = "import" 
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