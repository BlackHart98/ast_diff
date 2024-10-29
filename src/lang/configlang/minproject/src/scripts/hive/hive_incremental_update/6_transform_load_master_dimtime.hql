INSERT INTO master.dimtime
SELECT
  sk_timeid,
  CAST(timevalue AS TIMESTAMP),
  hourid,
  hourdesc,
  minuteid,
  minutedesc,
  secondid,
  seconddesc,
  markethoursflag,
  officehoursflag
FROM staging.time;