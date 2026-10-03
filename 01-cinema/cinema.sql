CREATE TABLE
    cinemas (
        cinema_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
    );

CREATE TABLE
    screens (
        screen_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        screen_name VARCHAR(200) NOT NULL,
        seating_capactiy INTEGER NOT NULL,
    );

CREATE TABLE
    cinema_screens (
        cinema_screens_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        cinema_id BIGINT NOT NULL,
        screen_id BIGINT NOT NULL,
        start_time TIMESTAMP NOT NULL,
        end_time TIMESTAMP NOT NULL,
        CONSTRAINT fk_cinema_screen_cinema FOREIGN KEY (cinema_id) REFERENCES cinemas (cinema_id),
        CONSTRAINT fk_cinema_screen_screen FOREIGN KEY (screen_id) REFERENCES screens (screen_id)
    );

CREATE TABLE
    customers (
        customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        phone_number VARCHAR(200) NOT NULL,
        CONSTRAINT uq_customer_email UNIQUE (email),
    );

CREATE TABLE
    seats (
        seat_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        seat_name VARCHAR(20) NOT NULL,
        screen_id BIGINT NOT NULL,
        -- seat name must be unique in each screen screen 1 have seat name : s2, but not two times
        -- also screen 2 can also have s2 because both are different screens
        CONSTRAINT uq_seats_seat_name_screen UNIQUE (screen_id, seat_name),
        CONSTRAINT fk_seats_screen FOREIGN KEY (screen_id) REFERENCES screens (screen_id)
    );

CREATE TABLE
    bookings (
        booking_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        customer_id BIGINT NOT NULL,
        cinema_screens_id BIGINT NOT NULL,
        total_seats INTEGER NOT NULL,
        status VARCHAR(200) NOT NULL DEFAULT 'confirmed',
        CONSTRAINT chk_booking_status CHECK (status IN ('confirmed', 'cancelled', 'completed')),
        CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
        CONSTRAINT fk_booking_cinema_screens FOREIGN KEY (cinema_screens_id) REFERENCES cinema_screens (cinema_screens_id)
    );

CREATE TABLE
    seats_booked (
        booking_id BIGINT NOT NULL,
        seat_id BIGINT NOT NULL,
        PRIMARY KEY (booking_id, seat_id),
        CONSTRAINT fk_seats_booked_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id),
        CONSTRAINT fk_seats_booked_seat FOREIGN KEY (seat_id) REFERENCES seats (seat_id)
    );