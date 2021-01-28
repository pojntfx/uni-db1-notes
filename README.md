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

The `exception` block is used to handle exceptions, for example `zero_divide` for divisions by zero (`when others then` handles unexpected other exceptions):

```sql
declare
    result number;
begin
    result := 1/0;

    exception
        when zero_divide then
            dbms_output.put_line(sqlerrm);
        when others then
            dbms_output.put_line('An unexpected error occured: ' || sqlerrm);
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

Use `select ... into` to fetch data into variables; `%TYPE` infers the type of a column:

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

The equivalent of the `while` loop is the `loop`. `exit`/`continue` prevents an infinite loop:

```sql
declare
    i number := 0;
begin
    loop
        i := i + 1;

        dbms_output.put_line('Iterator: ' || i);

        if i >= 10 then
            exit;
        end if;
    end loop;

    dbms_output.put_line('Done!');
end;
```

For loops can be done using the `for i in 0..100 loop ... end loop` syntax:

```sql
begin
    for i in 0..100 loop
        dbms_output.put_line(i);
    end loop;
end;
```

While loops work as you'd expect; but also require the `loop` keyword:

```sql
declare
    i number := 0;
begin
    while i <= 100 loop
        dbms_output.put_line(i);

        i := i + 1;
    end loop;
end;
```

You can also use `%ROWTYPE` to infer the type of a row and select an entire row at once:

```sql
declare
    customer customers%ROWTYPE;
begin
    select * into customer from customers where customer_id = 100;

    dbms_output.put_line(customer.name || '/' || customer.website);
end;
```

It is also possible to use OOP-style object/row creation thanks to `%ROWTYPE`:

```sql
declare
    person persons%ROWTYPE;

begin
    person.person_id := 1;
    person.first_name := 'John';
    person.last_name := 'Doe';

    insert into persons values person;
end;
```

You can create custom exceptions:

```sql
declare
    e_credit_too_high exception;
    pragma exception_init(e_credit_too_high, -20001);
begin
    if 10000 > 1000 then
        raise e_credit_too_high;
    end if;
end;
```

If you want to raise a custom exception, use `raise_application_error`:

```sql
declare
    e_credit_too_high exception;
    pragma exception_init(e_credit_too_high, -20001);
begin
    raise_application_error(-20001, 'Credit is to high!');
end;
```

Using `sqlcode` and `sqlerrm` you can the last exception's code/error message.
