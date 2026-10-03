-- don't write comma at the last
-- added movie table and also remove the cinema screens and added showing table
---
CREATE TABLE
    cinemas (
        cinema_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL
    );

CREATE TABLE
    movies (
        movie_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        movie_name VARCHAR(200) NOT NULL,
    );

CREATE TABLE
    screens (
        screen_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        screen_name VARCHAR(200) NOT NULL,
        seating_capacity INTEGER NOT NULL,
        cinema_id BIGINT NOT NULL,
        CONSTRAINT fk_screens_cinema FOREIGN KEY (cinema_id) REFERENCES cinemas (cinema_id)
    );

CREATE TABLE
    showings (
        showing_id BIGINT GENERATED AS IDENTITY ALWAYS PRIMARY KEY,
        screen_id BIGINT NOT NULL,
        movie_id BIGINT NOT NULL,
        start_time TIMESTAMP NOT NULL,
        end_time TIMESTAMP NOT NULL,
        FOREIGN KEY (screen_id) REFERENCES screens (screen_id),
        FOREIGN KEY (movie_id) REFERENCES movies (movie_id),
        CONSTRAINT chk_showing_time CHECK (end_time > start_time)
    );

CREATE TABLE
    customers (
        customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        phone_number VARCHAR(200) NOT NULL,
        CONSTRAINT uq_customer_email UNIQUE (email)
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
        showing_id BIGINT NOT NULL,
        status VARCHAR(200) NOT NULL DEFAULT 'confirmed',
        CONSTRAINT chk_booking_status CHECK (status IN ('confirmed', 'cancelled', 'completed')),
        CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
        CONSTRAINT fk_booking_showing FOREIGN KEY (showing_id) REFERENCES showings (showing_id)
    );

CREATE TABLE
    seats_booked (
        booking_id BIGINT NOT NULL,
        seat_id BIGINT NOT NULL,
        PRIMARY KEY (booking_id, seat_id),
        CONSTRAINT fk_seats_booked_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id),
        CONSTRAINT fk_seats_booked_seat FOREIGN KEY (seat_id) REFERENCES seats (seat_id)
    );