# DB1 Notes

> Unfortunately the pain never goes away.

Also see [Vanilla SQL](./vanilla-sql.pdf) for quirks and even more weirdness in Oracle. Use a libre database, please. Free software, free society!

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

Using `sqlcode` and `sqlerrm` you can get the last exception's code/error message.

Using cursors, you can procedurally process data:

```sql
declare
    cursor sales_cursor is select * from sales;
    sales_record sales_cursor%ROWTYPE;
begin
    update customers set credit_limit = 0;

    open sales_cursor;

    loop
        fetch sales_cursor into sales_record;
        exit when sales_cursor%NOTFOUND;

        update
            customers
        set
            credit_limit = extract(year from sysdate)
        where
            customer_id = sales_record.customer_id;
    end loop;

    close sales_cursor;
end;
```

Complex exit logic can be avoided using the `for ... loop`:

```sql
declare
    cursor product_cursor is select * from products;
begin
    for product_record in product_cursor loop
        dbms_output.put_line(product_record.product_name || ': $' || product_record.list_price);
    end loop;
end;
```

Cursors can also have parameters:

```sql
declare
    product_record products%rowtype;
    cursor
        product_cursor (
            low_price number := 0,
            high_price number := 100
        )
    is
        select * from products where list_price between low_price and high_price;
begin
    open product_cursor(50, 100);

    loop
        fetch product_cursor into product_record;
        exit when product_cursor%notfound;

        dbms_output.put_line(product_record.product_name || ': $' || product_record.list_price);
    end loop;

    close product_cursor;
end;
```

The DB can also lock fields for safe multiple access:

```sql
declare
    cursor customers_cursor is select * from customers for update of credit_limit;
begin
    for customer_record in customers_cursor loop
        update customers set credit_limit = 0 where customer_id = customer_record.customer_id;
    end loop;
end;
```

You can create procedures, which are comparable to functions:

```sql
create or replace procedure
    print_contact(customer_id_arg number)
is
    contact_record contacts%rowtype;
begin
    select * into contact_record from contacts where customer_id = customer_id_arg;

    dbms_output.put_line(contact_record.first_name || ' ' || contact_record.last_name);
end;
```

These procedures can then be executed:

```sql
begin
    print_contact(50);
end;
```

Or, without PL/SQL:

```sql
exec print_contact(50);
```

Once a procedure is no longer needed, it can be removed with `drop procedure`:

```sql
drop procedure print_contact;
```

It is also possible to infer a row type using `sys_refcursor` and return rows with `dbms_sql.return_result`:

```sql
create or replace procedure
    get_customer_by_credit(min_credit number)
as
    customer_cursor sys_refcursor;
begin
    open customer_cursor for select * from customers where credit_limit > min_credit;

    dbms_sql.return_result(customer_cursor);
end;
```

You can now call it:

```sql
exec get_customer_by_credit(50);
```

Functions are similar, but require returning a value:

```sql
create or replace function
    get_total_sales_for_year(year_arg integer)
return number
is
    total_sales number := 0;
begin
    select sum(unit_price * quantity) into total_sales
    from order_items
    inner join orders using (order_id)
    where status = 'Shipped'
    group by extract(year from order_date)
    having extract(year from order_date) = year_arg;

    return total_sales;
end;
```

You can call them from PL/SQL:

```sql
declare
    total_sales number := 0;
begin
    total_sales := get_total_sales_for_year(2017);

    dbms_output.put_line('Sales for 2017: ' || total_sales);
end;
```

And remove it with `drop function`:

```sql
drop function get_total_sales_for_year;
```

Packages can be used to group functions and variables:

```sql
create or replace package order_management
as
    shipped_status constant varchar(10) := 'Shipped';
    pending_status constant varchar(10) := 'Pending';
    cancelled_status constant varchar(10) := 'Canceled';

    function get_total_transactions return number;
end order_management;
```
