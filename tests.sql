-- tests of the date functions

\set VERBOSITY terse
BEGIN;

DO $$ BEGIN RAISE INFO 'Testing: isleapyear()';END;$$;
DO $$ BEGIN assert (   SELECT isleapyear(-1)   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   SELECT isleapyear('-1')   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   SELECT not isleapyear(-4)   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   SELECT not isleapyear('-4')   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   SELECT not isleapyear('1900')   );END;$$;  -- not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT not isleapyear(1900)   );END;$$;  -- not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT not isleapyear(-1901)   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT not isleapyear('-1901')   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT isleapyear('1684')   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear(1684)   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear('-1684')   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT not isleapyear(-1684)   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT not isleapyear('-1901')   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT not isleapyear(-1901)   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT isleapyear(-2001)   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s
DO $$ BEGIN assert (   SELECT isleapyear('-2001')   );END;$$;  -- BCE leap years: -1, -5, ... but still not on centuries unless also 1000s

DO $$ BEGIN RAISE INFO 'Testing: howmanydaysinyear()';END;$$;
DO $$ BEGIN assert (   howmanydaysinyear(1684) = 366  );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear('1684') = 366   );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear(-1684) = 365   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   howmanydaysinyear('-1684') = 365   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   howmanydaysinyear(-1685) = 366   );END;$$;  -- BCE leap years: -1, -5, ...
DO $$ BEGIN assert (   howmanydaysinyear('-1685') = 366   );END;$$;  -- BCE leap years: -1, -5, ...

DO $$ BEGIN RAISE INFO 'Testing: howmanydaysinmonth()';END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth(1684, 2) = 29   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth(1685, '2') = 28   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth('-1684', '2') = 28   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth('-1685', 2) = 29   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: isvalidmonth()';END;$$;
DO $$ BEGIN assert (   isvalidmonth(1)   );END;$$;
DO $$ BEGIN assert (   isvalidmonth(7)   );END;$$;
DO $$ BEGIN assert (   not isvalidmonth(19)   );END;$$;
DO $$ BEGIN assert (   not isvalidmonth(-2)   );END;$$;
DO $$ BEGIN assert (   not isvalidmonth('-2')   );END;$$;
DO $$ BEGIN assert (   not isvalidmonth(0)   );END;$$;
DO $$ BEGIN assert (   isvalidmonth('12')   );END;$$;
DO $$ BEGIN assert (   isvalidmonth('1')   );END;$$;
DO $$ BEGIN assert (   isvalidmonth('3')   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: isvalidmonthday()';END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday(2000, 2, 29)   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday(2000, 2, '29')   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday(2000, '2', 29)   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday(2000, '02', '29')   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday('2000', 2, 29)   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday('2000', 2, '29')   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday('2000', '2', 29)   );END;$$;
DO $$ BEGIN assert (   SELECT isvalidmonthday('2000', '02', '29')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(1999, 2, 29)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(1999, 2, '29')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(1999, '2', 29)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(1999, '02', '29')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday('1999', 2, 29)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday('1999', 2, '29')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday('1999', '2', 29)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday('1999', '02', '29')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(-1999, 1, 32)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(-1999, 1, '-2')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(2999, 1, 32)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(2999, 1, '-2')   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(2999, 13, 1)   );END;$$;
DO $$ BEGIN assert (   SELECT not isvalidmonthday(2999, -1, 1)   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: splitdatestring()';END;$$;
DO $$ BEGIN assert (   SELECT splitdatestring('2000-12-31') = ARRAY[2000,12,31]   );END;$$;
DO $$ BEGIN assert (   SELECT splitdatestring('-12000-02-29') = ARRAY[-12000,2,29]   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: yday()';END;$$;
DO $$ BEGIN assert (   SELECT yday(1900, 1, 1) = 1   );END;$$;
DO $$ BEGIN assert (   SELECT yday(1900, 12, 31) = 365   );END;$$;
DO $$ BEGIN assert (   SELECT yday(2000, 12, 31) = 366   );END;$$;
DO $$ BEGIN assert (   SELECT yday('-1700', 1, 1) = 1   );END;$$;
DO $$ BEGIN assert (   SELECT yday('-1700', 12, '31') = 365   );END;$$;
DO $$ BEGIN assert (   SELECT yday('-2001', '12', 31) = 366   );END;$$;
DO $$ BEGIN assert (   SELECT yday('-2000', '12', 31) = 365   );END;$$;
DO $$ BEGIN assert (   SELECT yday(-1601, '12', '31') = 366   );END;$$;
DO $$ BEGIN assert (   SELECT yday('-1600', '12', '31') = 365   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: pad_date() passthroughs';END;$$;
DO $$ BEGIN assert (   SELECT pad_date('', 'start') = ''   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date(null, 'end') is null   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('218-02-29', 'start') = '218-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('44-03-15', 'start') = '44-03-15'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-5000-07-02'::varchar, 'end') = '-5000-07-02'   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: pad_date() empty string on malformed, expect to see three malformed messages';END;$$;
DO $$ BEGIN assert (   SELECT pad_date('never') = ''   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('before 100 BC') = ''   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('unknown') = ''   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: pad_date() with year-only inputs';END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+2000', 'start') = '2000-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('2000', 'start') = '2000-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-2000', 'start') = '-2000-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-1000000', 'start') = '-1000000-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+2000', 'end') = '2000-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('2000', 'end') = '2000-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-2000', 'end') = '-2000-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-1000000', 'end') = '-1000000-12-31'   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: pad_date() with year-and-month inputs';END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+44-03'::varchar) = '44-03-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-44-03'::varchar) = '-44-03-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+2000-07'::varchar) = '2000-07-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-2000-07'::varchar) = '-2000-07-01'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+2000-02'::varchar, 'end') = '2000-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-2001-02'::varchar, 'end') = '-2001-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+19900-02'::varchar, 'end') = '19900-02-28'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-19900-02'::varchar, 'end') = '-19900-02-28'   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: isodatetodecimaldate()';END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('-0002-01-01') = -1.99863   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('-0002-07-02') = -1.5   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('-0002-12-31') = -1.00137   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('-0001-01-01') = -0.99863   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('-0001-07-02') = -0.5   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('-0001-12-31') = -0.00137   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0000-01-01') = +0.00137   );END;$$; -- 1 BCE, leap year; 183rd day is July 1 due to February being longer
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0000-07-02') = +0.50137   );END;$$; -- 1 BCE, leap year; 183rd day is July 1 due to February being longer
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0000-12-31') = +0.99863   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0001-01-01') = +1.00137   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0001-07-02') = +1.5   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0001-12-31') = +1.99863   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0002-01-01') = +2.00137   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0002-07-02') = +2.5   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('0002-12-31') = +2.99863   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: isodatetodecimaldate() trying to fix invalid input, expect 3 warnings';END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('1917-04-31', FALSE) IS NULL   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('1917-04-31', TRUE) = 1917.24795   );END;$$;
DO $$ BEGIN assert (   SELECT isodatetodecimaldate('1917-13-32', TRUE) = 1917   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: isodatetodecimaldate() with exception on bad input';END;$$;
DO $$ BEGIN  -- this should raise an exception
    SELECT isodatetodecimaldate('1917-04-31');
	EXCEPTION WHEN data_exception THEN RETURN;
    assert(false);
END; $$ LANGUAGE plpgsql;

DO $$ BEGIN RAISE INFO 'Testing: decimaldatetoisodate()';END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(-0.998633) = '-0001-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(-0.5) = '-0001-07-02'   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(-0.001366) = '-0001-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+0.001367) = '0000-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+0.5) = '0000-07-01'   );END;$$; -- 1 BCE, leap year; 183rd day is July 1 due to February being longer
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+0.998634) = '0000-12-31'   );END;$$; -- 1 BCE, leap year; 183rd day is July 1 due to February being longer
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+1.001369) = '0001-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+1.5) = '0001-07-02'   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+1.998631) = '0001-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+2.001369) = '0002-01-01'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+2.5) = '0002-07-02'   );END;$$; -- non leap year, 1823rd day is July 2
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(+2.998631) = '0002-12-31'   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: isodatetodecimaldate() decimaldatetoisodate() back and forth';END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('2000-12-01')) = '2000-12-01'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('2000-12-31')) = '2000-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('2000-02-29')) = '2000-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('1999-12-01')) = '1999-12-01'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('1999-12-31')) = '1999-12-31'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('-1999-02-29')) = '-1999-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('10191-06-30')) = '10191-06-30'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('10191-07-31')) = '10191-07-31'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('-10191-06-30')) = '-10192-06-30'   );END;$$;
DO $$ BEGIN assert (   SELECT decimaldatetoisodate(isodatetodecimaldate('-10191-07-31')) = '-10192-07-31'   );END;$$;

-- done!
DO $$ BEGIN RAISE INFO 'All tests done.';END;$$;
ROLLBACK;
