SELECT * FROM "covid-19"."world_cases_deaths_testing"

SELECT * FROM "flight_delays_csv$partitions" ORDER BY year

SELECT 
   date,
   positive,
   negative,
   pending,
   hospitalized,
   death,
   total,
   deathincrease,
   hospitalizedincrease,
   negativeincrease,
   positiveincrease,
   sta.state AS state_abbreviation,
   abb.state 

FROM "covid-19"."covid_testing_states_daily" sta;

SELECT * FROM "covid-19"."world_cases_deaths_testing" order by "date" desc limit 10;

SELECT DISTINCT "$path" AS data_source_file
FROM sampledb.elb_logs
ORDER By data_source_file ASC;

SELECT 
   date,
   positive,
   negative,
   pending,
   hospitalized,
   death,
   total,
   deathincrease,
   hospitalizedincrease,
   negativeincrease,
   positiveincrease,
   sta.state AS state_abbreviation,
   abb.state 

FROM "covid-19"."covid_testing_states_daily" sta
JOIN "covid-19"."us_state_abbreviations" abb ON sta.state = abb.abbreviation
limit 500;

SELECT data,
        "$PATH"
FROM "default"."myemrlogs"
WHERE regexp_like("$PATH",'s-86URH188Z6B1') AND regexp_like(data, 'ERROR|WARN|INFO|EXCEPTION|FATAL|DEBUG') limit 100;