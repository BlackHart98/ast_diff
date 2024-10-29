CREATE VIEW IF NOT EXISTS date_dimension AS SELECT 
  date_format(d, 'yyyy-MM-dd') AS id, 
  d AS full_date, 
  YEAR(d) AS year, 
  FROM_UNIXTIME((UNIX_TIMESTAMP(d) - (86400 * (date_format(d, 'u') - 1)))) AS week_start_date, 
  date_format(d, 'u') AS week_day, 
  date_format(d, 'EEEE') AS day_name, 
  (CASE WHEN (date_format(d, 'u')  IN (6,7)) THEN 0 
        ELSE 1 
  END) AS day_is_weekday, 
  date_format(d, 'MM') AS month, 
  date_format(d, 'MMMM') AS month_name, 
  date_format(d, 'Q') AS fiscal_qtr, 
  YEAR(d) AS fiscal_year
FROM (SELECT 
  explode(split(space(DATEDIFF('2050-01-01', '2014-01-01')), ' ')) + '2014-01-01' AS d
) date_array;