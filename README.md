# OpenHistoricalMap Date Functions

These Pl/PgSQL functions provide for PostgreSQL, certain utility functions used by OpenHistoricalMap for representing dates beyond the typical range of Julian and Unix epochs. The intent here is to be able to represent very large dates such as 100,000 BCE in a numeric fashion so they may be compared using simple mathematical filters such as `<=` and `>=` Underlying libraries tend to have a limited range of dates, and to have trouble calculating beyond the Unix epoch or Julian day 0.

Functions are provided to work with these two broad issues in date information contributed to OHM:
* Representing dates as a universal numeric format, which can exceed the typical epoch bounds. Representations such as Julian day and Unix epoch have limitations which would not cover pre-historic times such as 25,000 BCE. Thus, the decimal date representation in which the year is kept as-given and the month-and-day are converted into a decimal portion, yielding dates such as _-44.796448_ (March 15, 44 BCE). This is similar to the R `decimal_date()` function, except that it does not convert to an epoch and therefore works with extreme dates.
* Expanding partial dates such as _2000_ for use as filtering "bookends". When 2000 is used as a starting date for filtering we want to treat it as _2000-01-01_, and when used as an end date for filtering we want to treat it as _2000-12-31_ By "casting" these partial dates as full dates for each specific use case, we can treat these partial dates as a filter-capable range of dates, without requiring the contributors to supply "false accuracy" such as manually entering "-01-01" onto their dates.


### Provided SQL Functions

Unless stated otherwise, all functions presume a proleptic Gregorian calendar. That is, 365 days per year except for leap years which have a 29th day in February.

Unless stated otherwise, all functions are overloaded so they can accept year and month parameters as `integer` and/or `varchar` data types. This is indicated in the examples below, where we are capricious with passing numeric or string values.

* `(varchar) pad_date(datelikestring varchar, startend varchar = 'start')`
Pad an incomplete date, and return an ISO-formatted date string indicating the first or last day of the month (if a year and month were given) or of the year (if only a year were given). The `startend` is either **start** or else **end** indicating which "side of the bookend" to represent.
Example: `SELECT pad_date('20000-02', 'end')` returns _20000-02-29_ since the year 20,000 CE would be a leap year.
Example: `SELECT pad_date('-15232', 'start')` returns _-15232-01-01_ representing the first day of that year.


* `(float) yday(year, month, day)`
Return the day of the year which this date woud have been; similar to `yday` in other date implementations.
Example: `yday(1900, 1, 1)` would return 1 since January 1 is the first day of the year.
Example: `yday(1900, 12, 31)` would return 365 since this is the 365th day of the year.
Example: `yday(2000, 12, 31)` would return 366 since this is the 366th day of the year (2000 was a leap year).

* `(boolean) isleapyear(year)`
Indicate whether the given year would be a leap year.
Example: `SELECT isleapyear('-10191')` returns _false_ since the year 10,191 BCE would not have been a leap year.

* `(integer) howmanydaysinyear(year)`
Return the number of days in this year.
Example: `SELECT howmanydaysinyear(-2000)` returns _366_ since 2,000 BCE would have been a leap year.

* `(integer) howmanydaysinmonth(year, month)`
Return the number of days in this month.
Example: `SELECT howmanydaysinmonth('-2000', 2)` returns _29_ since 2000 BCE would have been a leap year.

* `(boolean) isvalidmonth(month)`
Indicate whether whether the given month is a valid one, in the range 1 through 12.
Example: `SELECT isvalidmonth('12')` return _true_.
Example: `SELECT isvalidmonth(13)` return _false_.

* `(boolean) isvalidmonthday(year, month, day)`
Indicate whether whether the given day would have been a valid one, during the given year and month. That is, is >= 1 and the month had at least that many days in that year.
Example: `SELECT isvalidmonthday(2000, 2, 29)` return _true_ because this was a leap year and February has 29 days.
Example: `SELECT isvalidmonthday(-1999, 2, 29)` return _false_ because February would have had 28 days in this month.
Example: `SELECT isvalidmonthday(2000, 1, 34)` return _false_ because January has 31 days.


### Year 0 and Subtracting Decimal Dates

The Gregorian calendar has no year 0. The morning after Dec 31 of 1 BCE would be Jan 1 of 1 CE, without a span of two years having passed (-1 to 0, and 0 to +1).

This is important to keep in mind when trying to subtract one date from another, and crossing the CE/BCE boundary: **You must subtract 2 years from the mathematical difference to find the real difference.**

This is a known issue with calculating differences across the BCE/CE boundary, and is not novel to this expression of dates as decimal format.

