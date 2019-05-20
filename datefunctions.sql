--
-- isleapyear(year)
-- given a year, return whether it was a leap year
--
-- howmanydaysinyear(year)
-- given a year, return the number of days in the year
--
-- both of these are overloaded to accept both integer and varchar versions of the year
--

CREATE OR REPLACE FUNCTION isleapyear(
    yearstring VARCHAR  -- the year to be tested; will be converted to integer then passed to isleapyear()
)
RETURNS boolean AS $$
BEGIN
    RETURN isleapyear(yearstring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isleapyear(
    yearint INTEGER  -- the year to be tested, e.g. -20000
)
RETURNS boolean AS $$
BEGIN
    RETURN yearint % 4 = 0 AND (yearint % 100 != 0 OR yearint % 400 = 0);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION howmanydaysinyear(
    yearstring VARCHAR  -- the year to be tested; will be converted to integer then passed to howmanydaysinyear()
)
RETURNS integer AS $$
BEGIN
    RETURN howmanydaysinyear(yearstring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION howmanydaysinyear(
    yearint INTEGER  -- the year to be tested, e.g. -20000
)
RETURNS integer AS $$
BEGIN
    IF isleapyear(yearint) THEN
        RETURN 366;
    ELSE
        RETURN 365;
    END IF;
END;
$$
LANGUAGE plpgsql;

--
-- howmanydaysinmonth(year, month)
-- given a year and month, return the number of days that would have been in that month
-- overloaded to accept varchar/integer in both cases
--

CREATE OR REPLACE FUNCTION howmanydaysinmonth(
    yearstring VARCHAR,
    monthstring VARCHAR
)
RETURNS integer AS $$
BEGIN
    RETURN howmanydaysinmonth(yearstring::integer, monthstring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION howmanydaysinmonth(
    yearstring VARCHAR,
    monthint INTEGER
)
RETURNS integer AS $$
BEGIN
    RETURN howmanydaysinmonth(yearstring::integer, monthint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION howmanydaysinmonth(
    yearint INTEGER,
    monthstring VARCHAR
)
RETURNS integer AS $$
BEGIN
    RETURN howmanydaysinmonth(yearint, monthstring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION howmanydaysinmonth(
    yearint INTEGER,
    monthint INTEGER
)
RETURNS integer AS $$
BEGIN
    RETURN CASE
        WHEN monthint IN (1, 3, 5, 7, 8, 10, 12) THEN 31
        WHEN monthint IN (4, 6, 9, 11) THEN 30
        WHEN monthint = 2 AND isleapyear(yearint) THEN 29
        WHEN monthint = 2 THEN 28
    END;
END;
$$
LANGUAGE plpgsql;


--
-- isvalidmonth(monthnumber))
-- is the given month a valid one, 1 through 12?
--

CREATE OR REPLACE FUNCTION isvalidmonth(
    monthstring VARCHAR
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonth(monthstring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonth(
    monthint INTEGER
)
RETURNS boolean AS $$
BEGIN
    RETURN monthint >=1 AND monthint <= 12;
END;
$$
LANGUAGE plpgsql;


--
-- isvalidmonthday(year, month, day)
-- is the given day valid for the given month+year, e.g. did January have a 34th day?
--

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearstring VARCHAR,
    monthstring VARCHAR,
    daystring VARCHAR
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearstring::integer, monthstring::integer, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearstring VARCHAR,
    monthstring VARCHAR,
    dayint INTEGER
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearstring::integer, monthstring::integer, dayint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearstring VARCHAR,
    monthint INTEGER,
    daystring VARCHAR
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearstring::integer, monthint, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearstring VARCHAR,
    monthint INTEGER,
    dayint INTEGER
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearstring::integer, monthint, dayint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearint INTEGER,
    monthstring VARCHAR,
    daystring VARCHAR
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearint, monthstring::integer, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearint INTEGER,
    monthstring VARCHAR,
    dayint INTEGER
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearint, monthstring::integer, dayint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearint INTEGER,
    monthint INTEGER,
    daystring VARCHAR
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonthday(yearint, monthint, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION isvalidmonthday(
    yearint INTEGER,
    monthint INTEGER,
    dayint INTEGER
)
RETURNS boolean AS $$
BEGIN
    RETURN isvalidmonth(monthint) AND dayint > 0 AND dayint <= howmanydaysinmonth(yearint, monthint);
END;
$$
LANGUAGE plpgsql;


--
-- yday(year, month, day)
-- return the numeric day of the year aka "yday" e.g. 1 for January 1 and 365 for Dec 31
--

CREATE OR REPLACE FUNCTION yday (
    yearstring VARCHAR,
    monthstring VARCHAR,
    daystring VARCHAR
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearstring::integer, monthstring::integer, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearstring VARCHAR,
    monthstring VARCHAR,
    dayint INTEGER
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearstring::integer, monthstring::integer, dayint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearstring VARCHAR,
    monthint INTEGER,
    daystring VARCHAR
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearstring::integer, monthint, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearstring VARCHAR,
    monthint INTEGER,
    dayint INTEGER
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearstring::integer, monthint, dayint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearint INTEGER,
    monthstring VARCHAR,
    daystring VARCHAR
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearint, monthstring::integer, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearint INTEGER,
    monthstring VARCHAR,
    dayint INTEGER
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearint, monthstring::integer, dayint);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearint INTEGER,
    monthint INTEGER,
    daystring VARCHAR
)
RETURNS integer AS $$
BEGIN
    RETURN yday(yearint, monthint, daystring::integer);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION yday (
    yearint INTEGER,
    monthint INTEGER,
    dayint INTEGER
)
RETURNS integer AS $$
DECLARE
    dayspassed INTEGER;
BEGIN
    IF NOT isvalidmonthday(yearint, monthint, dayint) THEN
        RAISE EXCEPTION 'Not a valid date %, %, %', yearint, monthint, dayint;
    END IF;

    -- accumulate the completed months
    dayspassed = 0;
    FOR mnum IN 1..12 LOOP
        EXIT WHEN mnum >= monthint;
        dayspassed = dayspassed + howmanydaysinmonth(yearint, mnum);
    END LOOP;

    -- add the days from the current month
    dayspassed = dayspassed + dayint;

    -- and Bob's your uncle
    RETURN dayspassed;
END;
$$
LANGUAGE plpgsql;


--
-- splitdate(datestring)
-- split a ISO-shaped string into year, month, day array of integers
-- heed a leading - sign as negative year; accept and discard a leading + sign for positive
--

CREATE OR REPLACE FUNCTION splitdatestring(
    datestring VARCHAR
)
RETURNS integer array[3] AS $$
DECLARE
    yearint INTEGER;
    monthint INTEGER;
    dayint INTEGER;
BEGIN
    -- split the string, heeding any leading - sign
    -- implicitly cast to integer
    SELECT splitdate[1], splitdate[2], splitdate[3] into yearint, monthint, dayint
    FROM (
        SELECT ARRAY_AGG(splitdate) splitdate
        FROM (
            SELECT UNNEST(REGEXP_MATCHES(datestring, '^(\-?\+?\d+)\-(\d\d)\-(\d\d)$')) splitdate
        ) y
    ) x;

    RETURN ARRAY[yearint, monthint, dayint];
END;
$$
LANGUAGE plpgsql;


--
-- isodatetodecimaldate(datestring)
-- translate the ISO-shaped date string into a decimal year`
--

CREATE OR REPLACE FUNCTION isodatetodecimaldate(
    datestring VARCHAR
)
RETURNS float AS $$
DECLARE
    yearint INTEGER;
    monthint INTEGER;
    dayint INTEGER;
    splitdate INTEGER ARRAY[3];
    daynumber FLOAT;
    decibit FLOAT;
    daysinyear INTEGER;
    decimaldate FLOAT;
BEGIN
    -- split up the date into three integers
    splitdate := splitdatestring(datestring);
    yearint := splitdate[1];
    monthint := splitdate[2];
    dayint := splitdate[3];
    IF NOT isvalidmonthday(yearint, monthint, dayint) THEN
        RAISE EXCEPTION 'Not a valid date %, %, %', yearint, monthint, dayint;
    END IF;

    -- this is the Nth day of a N-day-long year
    -- for decimal purposes, subtract 0.5 days to force noon on the day (Jan 1 = 0.5)
    daynumber := yday(yearint, monthint, dayint)::float - 0.5;
    daysinyear := howmanydaysinyear(yearint);

    -- divide to get a decimal; invert this if year is <0
    -- larger negative value = further from 0, right? Jan 1 -1000 is -1000.999 but Jan 1 1000 is 1000.001
    decibit = daynumber / daysinyear;
    IF yearint >= 0 THEN
        decimaldate = yearint::float + decibit;
    ELSE
        decimaldate = yearint::float - (1 - decibit);
    END IF;

    -- standardize on 6 decimals, that's more than plenty for 1 part in 366
    RETURN ROUND(decimaldate::numeric, 6);
END;
$$
LANGUAGE plpgsql;


--
-- decimaldatetoisodate(datestring)
-- translate a decimal year into an ISO-shaped date string
--

CREATE OR REPLACE FUNCTION decimaldatetoisodate(
    decimaldate DOUBLE PRECISION
)
RETURNS varchar AS $$
BEGIN
    RETURN decimaldatetoisodate(decimaldate::numeric);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decimaldatetoisodate(
    decimaldate NUMERIC
)
RETURNS varchar AS $$
DECLARE
    yearint INTEGER;
    monthint INTEGER;
    dayint INTEGER;
    yday INTEGER;
    dayspassed INTEGER;
    daysinyear INTEGER;
    daysthismonth INTEGER;
BEGIN
    -- isolate the integer part of the year
    IF decimaldate >= 0 THEN
        yearint := FLOOR(decimaldate)::integer;
    ELSE
        yearint := CEIL(decimaldate)::integer;
    END IF;

    -- translate decimal portion into target yday
    daysinyear := howmanydaysinyear(yearint);
    yday = ROUND(1 + (daysinyear * (ABS(decimaldate) % 1)) - 0.5);
    IF decimaldate < 0 THEN
        yday = daysinyear - yday + 1;
    END IF;

    -- tall over whole months to see which month would contain this day
    dayspassed = 0;
    FOR mnum IN 1..12 LOOP
        daysthismonth = howmanydaysinmonth(yearint, mnum);
        IF dayspassed + daysthismonth < yday THEN
            dayspassed = dayspassed + daysthismonth;
        ELSE
            monthint = mnum;
            EXIT;
        END IF;
    END LOOP;

    -- and the remaining days
    dayint = yday - dayspassed;

    -- concatenate and done
    RETURN CONCAT(yearint::varchar, '-', LPAD(monthint::varchar, 2, '0'), '-', LPAD(dayint::varchar, 2, '0'));
END;
$$
LANGUAGE plpgsql;


--
-- pad_date(datestring, startend)
-- pad out a truncated date with only year or a month, to a full year-month-day date
-- specify whether you want to pad it to the first day or last day of that year/month
--

CREATE OR REPLACE FUNCTION pad_date (
    datestring VARCHAR,  -- the input date string, ISO-8601 shaped e.g. -2000-06-23
    startend VARCHAR default 'start'  -- pad to the start or end of this month/year?
)
RETURNS varchar AS $$
DECLARE
    paddeddate VARCHAR;
    yearstring VARCHAR;
    monthstring VARCHAR;
    lastday VARCHAR;
BEGIN
    -- param sanity check
    IF startend != 'start' AND startend != 'end' THEN
        RAISE EXCEPTION 'pad_date() startend must be start or end';
    END IF;

    -- trim leading + which is accepted per ISO but not really useful
    datestring = REGEXP_REPLACE(datestring, '^\+', '');

    -- leave blanks as-is, as well as already-well-formatted dates
    IF datestring is null OR datestring = '' THEN
        RETURN datestring;
    END IF;
    IF datestring ~* '^\-?\d+\-\d\d\-\d\d$' THEN
        RETURN datestring;
    END IF;

    -- years are easy, just add -12-31 or -01-01
    IF datestring ~* '^\-?\d+$' THEN
        IF startend = 'start' THEN
            RETURN CONCAT(datestring, '-01-01');
        ELSE
            RETURN CONCAT(datestring, '-12-31');
        END IF;
    END IF;

    -- year and month, and we want the start; easy, just append -01
    IF datestring ~* '^\-?\d+\-\d\d$' AND startend = 'start' THEN
        RETURN CONCAT(datestring, '-01');
    END IF;

    -- the interesting/difficult case: find last day of this year+month, append it
    IF datestring ~* '^\-?\d+\-\d\d$' AND startend = 'end' THEN
        yearstring := SUBSTR(datestring, 1, LENGTH(datestring) - 3);
        monthstring := SUBSTR(datestring, LENGTH(datestring) - 1, 2);
        lastday = LPAD(howmanydaysinmonth(yearstring, monthstring)::varchar, 2, '0');
        RETURN CONCAT(datestring, '-', lastday);
    END IF;

    -- if we got here then it must be something else completely malformed; return nothing
    RAISE INFO 'pad_date(%) skipping malformed value', datestring;
    RETURN ''::varchar;
END;
$$
LANGUAGE plpgsql;
