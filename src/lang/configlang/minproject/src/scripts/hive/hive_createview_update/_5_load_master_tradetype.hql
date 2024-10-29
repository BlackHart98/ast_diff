CREATE VIEW master.dimdate AS
SELECT
  sk_dateid,
  CAST(datevalue AS DATE),
  datedesc,
  calendaryearid,
  calendaryeardesc,
  calendarqtrid,
  calendarqtrdesc,
  calendarmonthid,
  calendarmonthdesc,
  calendarweekid,
  calendarweekdesc,
  dayofweeknum,
  dayofweekdesc,
  fiscalyearid,
  fiscalyeardesc,
  fiscalqtrid,
  fiscalqtrdesc,
  holidayflag
FROM staging.`date`

