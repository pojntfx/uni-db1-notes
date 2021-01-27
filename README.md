# DB1 Notes

> Unfortunately the pain never goes away.

Also see [Vanilla SQL](./vanilla-sql.pdf) for quirks and more even weirdness in Oracle.

## PL/SQL

Block structure:

```plaintext
Declaration Section
begin
Execution Section
exception
Exception Section
end
```

The most simple example is as follows:

```sql
begin
   dbms_output.put_line('Hello World!');
end;
```

Use `put_line` from the `dmbs_output` package to print to stdout.

You can use the declare section for variables:

```sql
declare
    message varchar(255) := 'Hello, World!';
begin
    dbms_output.put_line(message);
end;
```

The `exception` block is used to handle exceptions, for example `zero_divide` for divisions by zero:

```sql
declare
    result number;
begin
    result := 1/0;

    exception
        when zero_divide then
            dbms_output.put_line(sqlerrm);
end;
```

PL/SQL extends SQL by adding a boolean type (which can have the values true, false and null).

You always have to specify an execution section; use `null` for a no-op:

```sql
declare
begin
    null;
end;
```

Variables need not be given a value at declaration if they are nullable:

```sql
declare
    total_sales number(15,2);
    credit_limit number(10,0);
    contact_name varchar2(255);
begin
    null;
end;
```

You can use `default` as an alternative to the `:=` operator when assigning variables in the declaration section.

If a variable is defined as not null, it can't take a string of length 0:

```sql
declare
    shipping_status varchar2(25) not null := 'shipped';
begin
    shipping_status := ''; -- You need to specify any string != ''
end;
```

Use `select ... into` to fetch data into variables:

```sql
declare
    customer_name customers.name%TYPE;
    customer_credit_limit customers.credit_limit%TYPE;
begin
    select
        name, credit_limit
    into
        customer_name, customer_credit_limit
    from customers where customer_id = 38;

    dbms_output.put_line(customer_name || ': ' || customer_credit_limit);
end;
```

You can use `--` for single line comments and `/*` for multi line comments.

Constants are created with the `constant` keyword and forbid reassignment:

```sql
declare
    price constant number := 10;
begin
    price := 20; -- Will throw an exception
end;
```
