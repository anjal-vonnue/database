Absolutely. Since you're practicing **database design from requirements → entities → relationships → SQL tables**, here are some problems that gradually get harder.

Try solving them **without looking up the answer first**. For each one, practice identifying:

1. Entities
2. Primary keys
3. Foreign keys
4. One-to-many vs many-to-many relationships
5. Constraints (`CHECK`, `UNIQUE`, etc.)
6. Whether a junction table is needed

---

# Practice 1 — Cinema Booking 🎬

**Difficulty: Easy**

You are designing a database for a cinema booking system.

Requirements:

- The system supports multiple **cinemas**.
- Each cinema has multiple **screens**.
- Each screen has a different number of seats.
- Each screen shows multiple **movies** at different dates and times.
- Customers can book seats for a particular movie showing.
- A customer has a name, email, and phone number.
- Email must be unique.
- A booking can contain multiple seats.
- A seat can only be booked once for a particular movie showing.
- Booking status can be `confirmed`, `cancelled`, or `completed`.

### Your task

Identify the entities and relationships, then write the `CREATE TABLE` statements.

### Think about this carefully:

Would you put:

```text
seat_id
```

directly inside `booking`?

Or do you need another table?

---

# Practice 2 — Online Course Platform 🎓

**Difficulty: Easy → Medium**

You are designing a database for an online learning platform.

Requirements:

- The platform contains multiple **courses**.
- Each course is created by an **instructor**.
- Each course contains multiple **lessons**.
- Students can enroll in multiple courses.
- A course can have many students.
- Therefore, the database must represent student-course enrollment correctly.
- A student has a name and email.
- Email must be unique.
- An enrollment has a status:
  - `active`
  - `completed`
  - `cancelled`

- A lesson has a title and duration in minutes.
- Lesson duration must be greater than 0.

### Your task

Design the database.

### Important question:

You have:

```text
Student
Course
```

A student can take many courses, and a course can have many students.

What table do you need between them?

---

# Practice 3 — Hotel Reservation 🏨

**Difficulty: Medium**

Design a database for a hotel reservation platform.

Requirements:

- The platform supports multiple **hotels**.
- Each hotel has multiple **rooms**.
- Each room belongs to exactly one hotel.
- A room has:
  - room number
  - room type
  - price per night

- Room types can be:
  - `single`
  - `double`
  - `suite`

- Room price must be greater than 0.
- Customers can make reservations.
- A reservation has:
  - customer
  - hotel
  - check-in date
  - check-out date
  - status

- Reservation status can be:
  - `confirmed`
  - `cancelled`
  - `completed`

- One reservation may contain **multiple rooms**.
- A room can appear in many reservations over time.
- Check-out must be after check-in.

### Challenge

You'll need to figure out whether this relationship:

```text
Reservation ←→ Room
```

requires a separate table.

---

# Practice 4 — Food Delivery 🍔

**Difficulty: Medium**

Design a database for a food delivery platform.

Requirements:

- The platform supports multiple restaurants.
- Each restaurant has many menu items.
- Each menu item belongs to exactly one restaurant.
- Customers can place orders.
- An order belongs to one customer.
- An order can contain multiple menu items.
- A menu item can appear in many different orders.
- Each order item must store the quantity ordered.
- Quantity must be greater than 0.
- Customers have:
  - name
  - email
  - phone

- Email must be unique.
- Order status can be:
  - `placed`
  - `preparing`
  - `delivered`
  - `cancelled`

- A menu item's price must be greater than 0.

### Challenge

Consider:

```text
Order
MenuItem
```

Can you directly put `menu_item_id` inside `order`?

If not, what do you need?

Also, **where should `quantity` be stored?**

That's an important database-design question.

---

# Practice 5 — University Course Registration 🎓

**Difficulty: Medium → Hard**

Design a university database.

Requirements:

- A university has multiple departments.
- Each department offers multiple courses.
- Each course belongs to one department.
- Students belong to one department.
- A professor can teach multiple courses.
- A course can have multiple students.
- A student can enroll in multiple courses.
- Enrollment has:
  - enrollment date
  - grade
  - status

- Status can be:
  - `active`
  - `dropped`
  - `completed`

- Grade can be `A`, `B`, `C`, `D`, `F`, or NULL.
- Student email must be unique.

### Challenge

There are several relationships here.

Try drawing:

```text
Department
     |
     ?
     |
Student

Professor
     |
     ?
     |
Course

Student
     |
     ?
     |
Course
```

Determine which relationships are one-to-many and which require junction tables.

---

# Practice 6 — Flight Booking ✈️

**Difficulty: Hard**

Design a database for an airline reservation system.

Requirements:

- The system supports multiple airlines.
- Each airline operates multiple flights.
- A flight has:
  - flight number
  - departure airport
  - arrival airport
  - departure time
  - arrival time

- Customers can make reservations.
- A reservation belongs to one customer.
- A reservation can contain **multiple passengers**.
- A passenger can have:
  - name
  - date of birth
  - passport number

- Passport number must be unique.
- A reservation can contain multiple flight segments.
- A flight segment belongs to a particular flight.
- A passenger can be assigned a seat for each flight segment.
- Seat numbers must not be duplicated for the same flight segment.
- Reservation status can be:
  - `confirmed`
  - `cancelled`
  - `completed`.

### Challenge

There are **multiple many-to-many relationships** hiding here.

Don't start writing SQL immediately.

First figure out:

```text
Reservation ↔ Passenger

Reservation ↔ FlightSegment

Passenger ↔ FlightSegment
```

---

# Practice 7 — Library Management 📚

**Difficulty: Hard**

Design a database for a library system.

Requirements:

- The system supports multiple library branches.
- Each branch has multiple books.
- A book can have multiple authors.
- An author can write multiple books.
- Books have:
  - ISBN
  - title
  - publication year

- ISBN must be unique.
- A physical copy of a book belongs to one branch.
- A book can have multiple physical copies.
- Members can borrow physical copies.
- A member can borrow multiple books.
- A physical copy can be borrowed many times over its lifetime.
- A borrowing record contains:
  - borrowed date
  - due date
  - returned date

- Due date must be after borrowed date.
- A member has a unique email.

### Challenge

There are **two different many-to-many relationships** you need to think about.

One is:

```text
Book ↔ Author
```

The other is not as obvious.

---

# Practice 8 — E-commerce Store 🛒

**Difficulty: Hard**

Design a database for an online store.

Requirements:

- The store has customers.
- Customers can place orders.
- An order can contain multiple products.
- A product can appear in many orders.
- Each order item stores:
  - quantity
  - price at the time of purchase

- Product's current price can change later.
- Therefore, the order must preserve the **price that existed when the customer purchased it**.
- Quantity must be greater than 0.
- Product price must be greater than 0.
- Customers have unique emails.
- Orders have statuses:
  - `pending`
  - `paid`
  - `shipped`
  - `delivered`
  - `cancelled`.

### Very important question

Where should this go?

```text
price_at_purchase
```

Should it be in:

```text
product
```

or:

```text
order
```

or:

```text
order_item
```

Explain why.

---

# 🎯 How I recommend you practice

Don't immediately write SQL.

For each problem, make these four steps.

### Step 1 — List entities

For example:

```text
Restaurant
Customer
Reservation
DiningTable
WaitlistEntry
```

### Step 2 — Identify relationships

Write things like:

```text
Restaurant 1 → many DiningTables

Customer 1 → many Reservations

Reservation many ↔ many DiningTables
```

### Step 3 — Find junction tables

Look for sentences such as:

> "A can have many B, and B can have many A."

That's usually a signal that you need something like:

```text
A_B
```

For example:

```text
Student ↔ Course
```

becomes:

```text
student_course
```

### Step 4 — Write SQL

Only after the above is clear, create:

```sql
CREATE TABLE ...
```

and add:

```sql
PRIMARY KEY
FOREIGN KEY
UNIQUE
CHECK
NOT NULL
```

---

## ⭐ One challenge for you

Start with **Practice 2 (Online Course Platform)**.

Before writing any SQL, send me just this:

```text
Entities:
1.
2.
3.

Relationships:
1.
2.
3.

Junction tables:
1.
2.
```

I'll check your database design **without giving you the answer immediately**, and we'll build it together.
