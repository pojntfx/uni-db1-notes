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

You can use `default` as an alternative to the `:=` operator when assigning variables in the declaration section. DO NOT use `=` when assignment, even re-assignment also uses `:=`.

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

`if ... then ... end if` can be used for branching:

```sql
declare
    sales number := 20000;
begin
    if sales > 10000 then
        dbms_output.put_line('Lots of sales!');
    end if;
end;
```

Inline expressions are also supported:

```sql
large_sales := sales > 10000
```

Booleans need not be compared with `my_bool = true`, a simple `if my_bool then` is fine.

`elseif ... then` is NOT valid syntax; `elsif ... then` is valid syntax.

Statements may also be nested:

```sql
declare
    sales number := 20000;
begin
    if sales > 10000 then
        if sales > 15000 then
            dbms_output.put_line('A new sales record!');
        else
            dbms_output.put_line('Lots of sales!');
        end if;
    end if;
end;
```

You may use the `case` keyword for switch cases:

```sql
declare
    grade char(1);
    message varchar2(255);
begin
    grade := 'A';

    case grade
        when 'A' then
            message := 'Excellent';
        when 'B' then
            message := 'Great';
        when 'C' then
            message := 'Good';
        when 'D' then
            message := 'Fair';
        when 'F' then
            message := 'Poor';
        else
            raise case_not_found;
    end case;

    dbms_output.put_line(message);
end;
```

A `label`/`goto` equivalent is also available:

```sql
begin
    goto do_work;
    goto goodbye;

    <<do_work>>
    dbms_output.put_line('mawahaha');

    <<goodbye>>
    dbms_output.put_line('Goodbye!');
end;
```
