https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms345405(v=sql.105)

Use the following guidelines to order columns in the CREATE INDEX statement:

1- List the equality (=) columns first (leftmost in the column list).

2- List the inequality (!=,<>,<,>,IN) columns after the equality columns (to the right of equality columns listed).

3- To determine an effective order for the equality columns, order them based on their selectivity; that is, list the most selective columns first.

4- Selectivity is how small % (less rows) of the table you are searching for.

5- Order of columns in the index? Think about the % of the table.