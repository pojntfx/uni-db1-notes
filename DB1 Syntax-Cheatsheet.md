% DB1 Syntax-Cheatsheet
% Felicitas Pojtinger
% \today
\setcounter{tocdepth}{5}
\tableofcontents

# DB1 Syntax-Cheatsheet

> "Come, let us go down and confuse their language so they will not understand each other" - Genesis 11:7, _Die Bibel_

Mehr Details unter [https://github.com/pojntfx/uni-db1-notes](https://github.com/pojntfx/uni-db1-notes).

## Data Definition Language

### Tabellen

#### Tabelle erstellen

```sql
create table persons (
    person_id number primary key not null ,
    first_name varchar2(50),
    last_name varchar2(50) default 'Duck' not null
);
```

#### Tabelle löschen

```sql
drop table persons;
```

#### Tabelle umbenennen

```sql
alter table persons rename to people;
```

### Spalten

#### Spalten hinzufügen

```sql
alter table persons add ( phone varchar2(20), email varchar2(100) )
```

#### Spalten bearbeiten

```sql
alter table persons modify birthdate date null;
```

#### Spalten löschen

```sql
alter table persons drop column birthdate;
```

### Constraints

#### Constraints hinzufügen

```sql
alter table purchase_orders add constraint purchase_orders_order_id_pk primary key(order_id);
```

#### Constraints löschen

```sql
alter table purchase_orders drop constraint purchase_orders_order_id_pk;
```

### Views

#### Views erstellen

```sql
create view employees_years_of_service
as select
    employee_id, first_name || ' ' || last_name as full_name,
    floor(months_between(current_date, hire_date) / 12) as years_of_service
from employees;
```

#### Views löschen

```sql
drop view employees_years_of_service;
```

### Indizes

#### Indizes erstellen

```sql
create index members_full_name on members(first_name, last_name);
```

#### Indizes löschen

```sql
drop index members_full_name;
```

### Trigger

#### Trigger erstellen

```sql
create trigger customers_credit_trigger
    before update of credit_limit
    on customers
declare
    current_day number;
begin
    current_day := extract(day from sysdate);

    if current_day between 28 and 31 then
        raise_application_error(-20100, 'Locked at the end of the month');
    end if;
end;
```

#### Trigger löschen

```sql
drop trigger customers_credit_trigger;
```

## Data Manipulation Language

### Datentypen

- `CHAR|CHARACTER (size)`
- `VARCHAR2 (size)`

- `DATE`
- `INTERVAL YEAR TO MONTH`
- `INTERVAL DAY TO SECOND`

- `INTEGER|INT`
- `NUMBER (precision [, scale ])`
- `FLOAT (precision)`

### Zeilenoperationen

#### Insert

```sql
insert into discounts(
    discount_name,
    amount,
    start_date,
    expired_date
) values (
    'Summer Promotion',
    9.5,
    date '2017-05-01',
    date '2017-08-31'
)
```

#### Update

```sql
update products
set list_price = 420
where list_price < 69;
```

#### Delete

```sql
delete from products
where list_price > 69;
```

### Unions

Gleiche Anzahl von Spalten, mehr Zeilen.

```sql
select
    first_name,
    last_name,
    email,
    'contact' as role
from contacts
union select
    first_name,
    last_name,
    email,
    'employee' as role
from employees order by role
```

### Joins

Mehr Spalten & mehr Zeilen

#### Inner Join

```sql
select
    a.id as id_a,
    a.color as color_a,
    b.id as id_b,
    b.color as color_b
from palette_a a
inner join palette_b b using(color);
```

#### Left Outer Join

```sql
select
    a.id as id_a,
    a.color as color_a,
    b.id as id_b,
    b.color as color_b
from palette_a a
left outer join palette_b b using(color);
```

#### Right Outer Join

```sql
select
    a.id as id_a,
    a.color as color_a,
    b.id as id_b, b.color as color_b
from palette_a a
right outer join palette_b b using(color);
```

#### Full Outer Join

```sql
select
    a.id as id_a,
    a.color as color_a,
    b.id as id_b,
    b.color as color_b
from palette_a a
full outer join palette_b b using(color);
```

- Trigger-Typen
- Hell (`><`)
