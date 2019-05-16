## Provided SQL Functions

```
isleapyear(year varchar)
isleapyear(year integer)
```

```
howmanydaysinyear(year varchar)
howmanydaysinyear(year integer)
```

```
howmanydaysinmonth(year integer, month integer)
howmanydaysinmonth(year varchar, month varchar)
howmanydaysinmonth(year integer, month varchar)
howmanydaysinmonth(year varchar, month integer)
```

```
pad_date(datelikestring varchar, startend varchar = 'start')
```

`datelikestring` 
`startend` 


### Tests and Demos

```
-- tests: these are not leap years; both integer and string versions
SELECT isleapyear('1900'), isleapyear(1900), isleapyear('-1900'), isleapyear(-1900), howmanydaysinyear(1900), howmanydaysinyear('-1900');
SELECT isleapyear('1863'), isleapyear(1863), isleapyear('-1863'), isleapyear(-1863), howmanydaysinyear(1863), howmanydaysinyear('-1863');

-- tests: these are leap years; both integer and string versions
SELECT isleapyear('20000'), isleapyear(20000), isleapyear('-20000'), isleapyear(-20000), howmanydaysinyear(20000), howmanydaysinyear('-20000');
SELECT isleapyear('1684'), isleapyear(1684), isleapyear('-1684'), isleapyear(-1684), howmanydaysinyear(1684), howmanydaysinyear('-1684');

-- tests: how many days in these months? in particular, extreme BCE leap years
SELECT howmanydaysinmonth(2000, 2), howmanydaysinmonth('2000', '02'), howmanydaysinmonth('2000', 2), howmanydaysinmonth(2000, '2');
SELECT howmanydaysinmonth(1900, 2), howmanydaysinmonth('1900', '02'), howmanydaysinmonth('1900', 2), howmanydaysinmonth(1900, '2');
SELECT howmanydaysinmonth(-22000, 2), howmanydaysinmonth('-22000', '02'), howmanydaysinmonth('-22000', 2), howmanydaysinmonth(-22000, '2');
SELECT howmanydaysinmonth(-21900, 2), howmanydaysinmonth('-21900', '02'), howmanydaysinmonth('-21900', 2), howmanydaysinmonth(-21900, '2');

-- tests: bad startend param raises an exception
SELECT pad_date('', 'nope');

-- tests: leading + should be stripped but leading - should remain negative
SELECT pad_date('+2000-07-02'::varchar), pad_date('-2000-07-02'::varchar);

-- tests: some dates that should come back as-given
-- meaning already-good or blank/null
SELECT pad_date('', 'start'), pad_date(null, 'end');
SELECT pad_date('2018-02-29'::varchar, 'start'), pad_date('-5000-07-02'::varchar, 'end');

-- tests: a few badly malformed dates that should come back empty
-- and should rase some NOTICE messages apprising of the weirdness
SELECT pad_date('never'::varchar), pad_date('before 100 BC'), pad_date('unknown');

-- tests: start/end of some years, CE with and without + sign and and BCE
SELECT pad_date('+2000', 'start'), pad_date('+2000', 'end');
SELECT pad_date('2000', 'start'), pad_date('2000', 'end');
SELECT pad_date('-2000', 'start'), pad_date('-2000', 'end');
SELECT pad_date('-1000000', 'start'), pad_date('-1000000', 'end');

-- tests: start/end day of a given month, especially CE and BCE leap years
SELECT pad_date('+2000-02', 'start'), pad_date('+2000-02', 'end');
SELECT pad_date('1900-02', 'start'), pad_date('1900-02', 'end');
SELECT pad_date('-2000-02', 'start'), pad_date('-2000-02', 'end');
SELECT pad_date('-21900-02', 'start'), pad_date('-21900-02', 'end');

-- try with some real data and see how it cleans up
SELECT start_date, end_date, pad_date(start_date, 'start'), pad_date(end_date, 'end') FROM osm_building_polygon WHERE start_date != '';
```
