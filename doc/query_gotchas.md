# Developer Documentation

## RawgentoDB::Query

Implemented as class with multiple 'class' methods only.

This has a cost, as the class is standalone, each query will open a new database connection.

The database connection will be closed automatically, when the respective Mysql2::Client instance is garbage collected.

Alternatively, the Mysql::Client can close its connection with a call to ".close".

Users of RawgentoDB should not have to care about these details, so the library should take care of this alone.

However, closing the connection in the Query-Implementation is currently not an option, because closing it would also mean to loose access on the result.  As currently Query often just returns the result and lets the User iterate over what looks like an array, closing the connection prematurely would effectively prevent result consumption.
