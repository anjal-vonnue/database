Yes. This is an important concept, so let's learn it from scratch.

## 1. First: what is a foreign key?

Suppose you have:

```sql
CREATE TABLE restaurants (
    restaurant_id BIGINT PRIMARY KEY,
    name VARCHAR(200)
);
```

and:

```sql
CREATE TABLE menu_items (
    menu_item_id BIGINT PRIMARY KEY,
    restaurant_id BIGINT NOT NULL
);
```

You can say:

```sql
FOREIGN KEY (restaurant_id)
REFERENCES restaurants (restaurant_id)
```

This means:

> `menu_items.restaurant_id` must refer to an existing `restaurants.restaurant_id`.

For example:

```text
restaurants
restaurant_id
-------------
1
2
3
```

Then:

```text
menu_items
menu_item_id | restaurant_id
-------------|--------------
10           | 1       ✅
11           | 2       ✅
12           | 99      ❌
```

because restaurant 99 doesn't exist.

---

# 2. So what is a composite foreign key?

A **composite foreign key** is a foreign key made from **multiple columns**.

Instead of:

```sql
FOREIGN KEY (restaurant_id)
REFERENCES restaurants (restaurant_id)
```

you have something like:

```sql
FOREIGN KEY (restaurant_id, table_number)
REFERENCES dining_tables (restaurant_id, table_number)
```

You're saying:

> These two values together must match an existing pair in the parent table.

---

# 3. Why would we ever need that?

Here's a good example.

Imagine a restaurant identifies tables using numbers:

```text
Restaurant 1:
Table 1
Table 2
Table 3

Restaurant 2:
Table 1
Table 2
Table 3
```

Notice something interesting:

**Table 1 exists in both restaurants.**

So:

```text
restaurant_id = 1
table_number = 1
```

means something different from:

```text
restaurant_id = 2
table_number = 1
```

The **combination** identifies the table.

So your table might be:

```sql
CREATE TABLE dining_tables (
    restaurant_id BIGINT NOT NULL,
    table_number INTEGER NOT NULL,

    PRIMARY KEY (restaurant_id, table_number)
);
```

Now the primary key itself is composite:

```text
(restaurant_id, table_number)
```

---

# 4. Now another table wants to reference it

Suppose you have:

```sql
CREATE TABLE table_assignments (
    reservation_id BIGINT NOT NULL,
    restaurant_id BIGINT NOT NULL,
    table_number INTEGER NOT NULL
);
```

You want to ensure that the table being assigned actually exists.

You need:

```sql
FOREIGN KEY (restaurant_id, table_number)
REFERENCES dining_tables (restaurant_id, table_number)
```

Now PostgreSQL checks the **pair**.

For example, if:

```text
dining_tables

restaurant_id | table_number
--------------|-------------
1             | 1
1             | 2
2             | 1
2             | 2
```

Then:

```text
restaurant_id = 1
table_number = 2
```

is valid.

And:

```text
restaurant_id = 1
table_number = 99
```

is invalid.

---

# 5. Why can't we reference just `restaurant_id`?

This is the important part.

Suppose you wrote:

```sql
FOREIGN KEY (restaurant_id)
REFERENCES dining_tables (restaurant_id)
```

What does that mean?

PostgreSQL would only know:

> Does restaurant 1 exist in `dining_tables`?

But there are multiple rows:

```text
restaurant_id | table_number
--------------|-------------
1             | 1
1             | 2
1             | 3
```

`restaurant_id = 1` isn't enough to identify **which table** you're referring to.

You need:

```text
restaurant_id + table_number
```

together.

---

# 6. The rule PostgreSQL follows

This is the rule I want you to remember:

> A foreign key must reference either a **PRIMARY KEY** or a **UNIQUE constraint** in the parent table.

For example:

```sql
CREATE TABLE restaurants (
    restaurant_id BIGINT PRIMARY KEY
);
```

You can do:

```sql
FOREIGN KEY (restaurant_id)
REFERENCES restaurants (restaurant_id)
```

because `restaurant_id` is a primary key.

---

## Composite example

If the parent has:

```sql
CREATE TABLE dining_tables (
    restaurant_id BIGINT NOT NULL,
    table_number INTEGER NOT NULL,

    PRIMARY KEY (restaurant_id, table_number)
);
```

then you can do:

```sql
FOREIGN KEY (restaurant_id, table_number)
REFERENCES dining_tables (restaurant_id, table_number)
```

because `(restaurant_id, table_number)` is a primary key.

---

# 7. You can also use UNIQUE

Suppose:

```sql
CREATE TABLE dining_tables (
    table_id BIGINT PRIMARY KEY,
    restaurant_id BIGINT NOT NULL,
    table_number INTEGER NOT NULL,

    UNIQUE (restaurant_id, table_number)
);
```

Now:

```text
restaurant_id + table_number
```

is unique.

Therefore, you can reference it:

```sql
FOREIGN KEY (restaurant_id, table_number)
REFERENCES dining_tables (restaurant_id, table_number)
```

Even though those columns aren't the primary key.

Why?

Because PostgreSQL knows:

> `(restaurant_id, table_number)` uniquely identifies exactly one row.

---

# 8. Now let's return to your Food Delivery example

You had:

```sql
orders
---------
order_id       PRIMARY KEY
restaurant_id
```

and:

```sql
menu_items
------------
menu_item_id   PRIMARY KEY
restaurant_id
```

Then you wrote:

```sql
FOREIGN KEY (order_id, restaurant_id)
REFERENCES orders (order_id, restaurant_id)
```

PostgreSQL asks:

> Is `(order_id, restaurant_id)` a primary key or unique key in `orders`?

No.

You only have:

```sql
PRIMARY KEY (order_id)
```

So PostgreSQL rejects it.

---

# 9. Why didn't you need the composite FK there?

Because `order_id` already uniquely identifies the order.

You have:

```text
orders

order_id | restaurant_id
---------|--------------
100      | 5
101      | 8
102      | 5
```

If I tell you:

```text
order_id = 100
```

you already know:

```text
restaurant_id = 5
```

There's no need to give PostgreSQL both values.

So this is enough:

```sql
FOREIGN KEY (order_id)
REFERENCES orders (order_id)
```

Likewise:

```sql
FOREIGN KEY (menu_item_id)
REFERENCES menu_items (menu_item_id)
```

---

# 10. A simple mental rule

When you're designing a foreign key, ask:

### Question 1

**Does one column uniquely identify the parent row?**

If yes:

```sql
FOREIGN KEY (id)
REFERENCES parent(id)
```

### Question 2

**Do I need two or more columns together to uniquely identify the parent row?**

If yes:

```sql
FOREIGN KEY (a, b)
REFERENCES parent(a, b)
```

And the parent must have:

```sql
PRIMARY KEY (a, b)
```

or:

```sql
UNIQUE (a, b)
```

---

# 11. Visualizing it

### Simple foreign key

```text
restaurants
┌───────────────┐
│ restaurant_id │ ← PRIMARY KEY
└───────┬───────┘
        │
        │ FK
        ↓
menu_items
┌───────────────┐
│ restaurant_id │
└───────────────┘
```

One column identifies the parent.

---

### Composite foreign key

```text
dining_tables
┌───────────────┬──────────────┐
│ restaurant_id │ table_number │
└───────┬───────┴──────┬───────┘
        │              │
        │      COMPOSITE FK
        │              │
        ↓              ↓
table_assignment
┌───────────────┬──────────────┐
│ restaurant_id │ table_number │
└───────────────┴──────────────┘
```

The **two columns together** identify the parent row.

---

# 12. One last example for practice

Consider:

```sql
CREATE TABLE classrooms (
    building_id INTEGER NOT NULL,
    room_number INTEGER NOT NULL,

    PRIMARY KEY (building_id, room_number)
);
```

Data:

```text
building_id | room_number
------------|------------
1           | 101
1           | 102
2           | 101
2           | 102
```

Notice:

```text
room_number = 101
```

is **not unique**.

But:

```text
(building_id, room_number)
```

is unique.

Therefore, another table needs:

```sql
FOREIGN KEY (building_id, room_number)
REFERENCES classrooms (building_id, room_number)
```

rather than:

```sql
FOREIGN KEY (room_number)
REFERENCES classrooms (room_number) -- ❌
```

because `room_number` alone doesn't identify a classroom.

---

## 🧠 Remember this

**Foreign key → references a unique row in the parent.**

That unique row can be identified by:

```text
ONE column
    ↓
PRIMARY KEY / UNIQUE
```

or:

```text
MULTIPLE columns
    ↓
COMPOSITE PRIMARY KEY / COMPOSITE UNIQUE
```

And that's when you use a **composite foreign key**.

In your Food Delivery problem, you **didn't need one**, because both `order_id` and `menu_item_id` already uniquely identify their respective parent rows by themselves.
