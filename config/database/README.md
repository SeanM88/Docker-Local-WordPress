# SQL Database exports

If you have an existing SQL database you would like to import using the `import-db.sh` script, place the `.sql` file here.

## Requirements

The `import-db.sh` script expects the file to be named using the `DB_NAME` value set in your project's `.env` file.  So for example, if in your project's `.env` file you set `DB_VALUE=my_cool_database` the filename for your database export should be `my_cool_database.sql`.

## Usage

As long as database's Docker container is running and the database file is named as expected, you should be able to simply run `bash import-db.sh` from the `/config/scripts` directory to import your database.
