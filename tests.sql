-- tests of the date functions

\set VERBOSITY terse
BEGIN;

DO $$ BEGIN RAISE INFO 'Testing: isleapyear()';END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear('1900')   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear(1900)   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear(-1900)   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear('-1900')   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear('21900')   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear(21900)   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear(-21900)   );END;$$;
DO $$ BEGIN assert (   SELECT not isleapyear('-21900')   );END;$$;

DO $$ BEGIN assert (   SELECT isleapyear('1684')   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear(1684)   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear('-1684')   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear(-1684)   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear('22000')   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear(22000)   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear(-22000)   );END;$$;
DO $$ BEGIN assert (   SELECT isleapyear('-22000')   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: howmanydaysinyear()';END;$$;
DO $$ BEGIN assert (   howmanydaysinyear(1684) = 366  );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear('1684') = 366   );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear(-1684) = 366   );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear('-1684') = 366   );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear(19900) = 365  );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear('19900') = 365   );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear(-19900) = 365   );END;$$;
DO $$ BEGIN assert (   howmanydaysinyear('-19900') = 365   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: howmanydaysinmonth()';END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth('-1684', '2') = 29   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth(1684, 2) = 29   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth('-1684', 2) = 29   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth(1684, '2') = 29   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth('-29700', '2') = 28   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth(29700, 2) = 28   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth('-29700', 2) = 28   );END;$$;
DO $$ BEGIN assert (   howmanydaysinmonth(29700, '2') = 28   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: pad_date() passthroughs';END;$$;
DO $$ BEGIN assert (   SELECT pad_date('', 'start') = ''   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date(null, 'end') is null   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('218-02-29', 'start') = '218-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('44-03-15', 'start') = '44-03-15'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-5000-07-02'::varchar, 'end') = '-5000-07-02'   );END;$$;

DO $$ BEGIN RAISE INFO 'Testing: pad_date() empty string on malformed, expect to see some malformed messages';END;$$;
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
DO $$ BEGIN assert (   SELECT pad_date('-2000-02'::varchar, 'end') = '-2000-02-29'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('+19900-02'::varchar, 'end') = '19900-02-28'   );END;$$;
DO $$ BEGIN assert (   SELECT pad_date('-19900-02'::varchar, 'end') = '-19900-02-28'   );END;$$;

DO $$ BEGIN RAISE INFO 'All tests done.';END;$$;
ROLLBACK;
