ALTER TABLE events ADD COLUMNS (eventowner string);

ALTER TABLE events PARTITION (awsregion='us-west-2') ADD COLUMNS (event string);

ALTER TABLE events PARTITION (awsregion='us-west-2') ADD COLUMNS (eventdescription string);