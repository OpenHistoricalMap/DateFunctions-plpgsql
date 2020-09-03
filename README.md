# OpenHistoricalMap Date Functions

These Pl/PgSQL functions provide for PostgreSQL, certain utility functions used by OpenHistoricalMap for representing dates beyond the typical range of Julian and Unix epochs. The intent here is to be able to represent very large dates such as 100,000 BCE in a numeric fashion so they may be compared using simple mathematical filters such as `<=` and `>=` Underlying libraries tend to have a limited range of dates, and to have trouble calculating beyond the Unix epoch or Julian day 0.

Functions are provided to work with these two broad issues in date information contributed to OHM:
* Representing dates as a universal numeric format, which can exceed the typical epoch bounds. Representations such as Julian day and Unix epoch have limitations which would not cover pre-historic times such as 25,000 BCE. Thus, the decimal date representation in which the year is kept as-given and the month-and-day are converted into a decimal portion, yielding dates such as _-44.796448_ (March 15, 44 BCE). This is similar to the R `decimal_date()` function, except that it does not convert to an epoch and therefore works with extreme dates.
* Expanding partial dates such as _2000_ for use as filtering "bookends". When 2000 is used as a starting date for filtering we want to treat it as _2000-01-01_, and when used as an end date for filtering we want to treat it as _2000-12-31_ By "casting" these partial dates as full dates for each specific use case, we can treat these partial dates as a filter-capable range of dates, without requiring the contributors to supply "false accuracy" such as manually entering "-01-01" onto their dates.


### Provided SQL Functions

Unless stated otherwise, all functions presume a proleptic Gregorian calendar. That is, 365 days per year except for leap years which have a 29th day in February.

Unless stated otherwise, all functions are overloaded so they can accept year and month parameters as `integer` and/or `varchar` data types. This is indicated in the examples below, where we are capricious with passing numeric or string values.

#### `(varchar) pad_date(datelikestring varchar, startend varchar = 'start')`

Pad an incomplete date, and return an ISO-formatted date string indicating the first or last day of the month (if a year and month were given) or of the year (if only a year were given). The `startend` is either **start** or else **end** indicating which "side of the bookend" to represent.

Example: `SELECT pad_date('20000-02', 'end')` returns _20000-02-29_ since the year 20,000 CE would be a leap year.

Example: `SELECT pad_date('-15232', 'start')` returns _-15232-01-01_ representing the first day of that year.

#### `(float) isodatetodecimaldate(datestring, trytofixinvalid)`

Parse an ISO-shaped date string, and return the date in decimal representation.

The optional parameter `trytofixinvalid` defines the handling for invalid dates such as _1917-28-31_ or _2020-13-31_
* `NULL` (default) = an invalid date will raise an exception
* `FALSE` = an invalid date will return NULL
* `TRUE` = try hard to return a number; return the 1st of the month if the month is valid, or the year if even the month is invalid

Example: `SELECT isodatetodecimaldate(2000-01-01)` returns _2000.001366_

Example: `SELECT isodatetodecimaldate(2000-12-31)` returns _2000.998634_

Example: `SELECT isodatetodecimaldate(-2000-01-01)` returns _-2000.998634_ Note that January for CE years is more negative than December, being further from the 0 origin.

Example: `SELECT isodatetodecimaldate(-2000-12-31)` returns _-2000.001366_ Note that December for CE years is less negative than December, being closer to the 0 origin.

Example: `SELECT isodatetodecimaldate('1917-04-31')` results in an exception

Example: `SELECT isodatetodecimaldate('1917-04-31', FALSE)` returns _NULL_

Example: `SELECT isodatetodecimaldate('1917-04-31', TRUE)` returns _1917.247945_ for April 1

Example: `SELECT isodatetodecimaldate('1917-13-32', TRUE)` returns _1917_ which is the year with 0 decimal portion

#### `(varchar) decimaldatetoisodate(datestring)`

Parse a decimal date into its year, month, day and return an ISO-shaped date string representing that date.

Example: `decimaldatetoisodate(2000.998634)` returns _2000-12-31_

Example: `decimaldatetoisodate(1999.001370)` returns _1999-12-31_

Example: `decimaldatetoisodate(-10191.998634)` returns _-10191-01-01_

Example: `decimaldatetoisodate(-10191.001366)` returns _-10191-12-31_

#### `(integer array[3]) decimaldatetoyearmonthday(datestring)`

Parse a decimal date into its year, month, day and return these as an array of 3 integers.

#### `(float) yday(year, month, day)`

Return the day of the year which this date woud have been; similar to `yday` in other date implementations.

Example: `yday(1900, 1, 1)` returns 1 since January 1 is the first day of the year.

Example: `yday(1900, 12, 31)` returns 365 since this is the 365th day of the year.

Example: `yday(2000, 12, 31)` returns 366 since this is the 366th day of the year (2000 was a leap year).

#### `(integer array[3]) splitdatestring(datelikestring)`

Split the date-shaped ISO string into an array of integers: year, month, day. This will heed any leading - sign as indicating a negative year, and will accept and silently discard a leading + sign indicating a positive year.

Example: `SELECT splitdatestring('-20000-02-29')` returns _{-20000,2,29}_

#### `(boolean) isleapyear(year)`

Indicate whether the given year would be a leap year.

Example: `SELECT isleapyear('-10191')` returns _false_ since the year 10,191 BCE would not have been a leap year.

Example: `SELECT isleapyear(10192)` returns _true_ since the year 10,192 BCE would be a leap year.

#### `(integer) howmanydaysinyear(year)`

Return the number of days in this year.

Example: `SELECT howmanydaysinyear(-2000)` returns _366_ since 2,000 BCE would have been a leap year.

#### `(integer) howmanydaysinmonth(year, month)`

Return the number of days in this month.

Example: `SELECT howmanydaysinmonth('-2000', 2)` returns _29_ since 2000 BCE would have been a leap year.

#### `(boolean) isvalidmonth(month)`

Indicate whether whether the given month is a valid one, in the range 1 through 12.

Example: `SELECT isvalidmonth('12')` return _true_.

Example: `SELECT isvalidmonth(13)` return _false_.

#### `(boolean) isvalidmonthday(year, month, day)`

Indicate whether whether the given day would have been a valid one, during the given year and month. That is, is >= 1 and the month had at least that many days in that year.

Example: `SELECT isvalidmonthday(2000, 2, 29)` return _true_ because this was a leap year and February has 29 days.

Example: `SELECT isvalidmonthday(-1999, 2, 29)` return _false_ because February would have had 28 days in this month.

Example: `SELECT isvalidmonthday(2000, 1, 34)` return _false_ because January has 31 days.


### Year 0 and Subtracting Decimal Dates

The Gregorian calendar has no year 0. The morning after Dec 31 of 1 BCE would be Jan 1 of 1 CE, without a span of two years having passed (-1 to 0, and 0 to +1).

This is important to keep in mind when trying to subtract one date from another, and crossing the CE/BCE boundary: **You must subtract 2 years from the mathematical difference to find the real difference.**

This is a known issue with calculating differences across the BCE/CE boundary, and is not novel to this expression of dates as decimal format.


### Our Use Case and Technical Challenges

At OpenHistoricalMap, for the purpose of filtering vector tiles, we needed a method of converting dates into a number which could be unequivocally compared as `>=` and `<=`.

* Dates in ISO 8601 string format such as _2000-01-01_ fall flat when dealing with BCE dates, e.g. _-2500-01-01_ is greater than _-2499-12-31_
* We need support outside the range of the Unix epoch (1900-2039) and earlier than that of the Julian calendar (_-4713-01-01_).
  * Existing libraries do not support dates outside of their range. Dates prior to 0 J are out of range in Python and in PostgreSQL, and are silently (erroneously) converted to 0 J by PHP. Underlying C libraries using `struct tm` do not work outside of Unix epoch range.

Effectively, this means we had to create our own implementation of the R `decimal_date()` function, without recourse to underlying libraries.

As such, the technique chosen here is to convert the specified date into a decimal year, without recourse to the underlying date/time libraries.
* Dates are supplied in ISO 8601-like format and support positive and negative years, e.g. _-2000-01-01_ and _2000-01-01_ and _+2000-01-01_
* The Gregorian calendar is treated as proleptic: 365 or 366 says, February 29 existing only when `year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)`
* The returned decimal value represents the year, plus a decimal portion indicating "how far along" the year is at 12 noon on the given day. Keep in mind that since years vary between 365 and 336 days' length, the decimal "value" of a date may vary between years:
  * Example: 1999 has 365 days, so 12 noon on January 1 would be _1999.001370_ and on December 31 would be _1999.998630_
  * Example: 2000 has 366 days, so 12 noon on January 1 would be _2000.001366_ and on December 31 would be _2000.998634_
* In the case of negative years (BCE dates) the decimal portion is "inverted" into days from December 31, since December of a BCE year is closer to the 0 mark.
  * Example: Dec 31 2000 BCE is _-2000.001366_ and Jan 1 2000 BCE is _-2000.998634_
