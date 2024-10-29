

CREATE VIEW master.dimtime AS
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