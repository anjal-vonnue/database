CREATE TABLE
    airlines (
        airline_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL
    );

CREATE TABLE
    flights (
        flight_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        flight_number VARCHAR(100) NOT NULL,
        departure_airport VARCHAR(100) NOT NULL,
        arrival_airport VARCHAR(100) NOT NULL,
        departure_time TIMESTAMP NOT NULL,
        arrival_time TIMESTAMP NOT NULL,
        airline_id BIGINT NOT NULL,
        CONSTRAINT uq_flight_airline UNIQUE (airline_id, flight_number),
        CONSTRAINT fk_flight_airline FOREIGN KEY (airline_id) REFERENCES airlines (airline_id)
    );

CREATE TABLE
    seats (
        seat_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        seat_number VARCHAR(100) NOT NULL,
        flight_id BIGINT NOT NULL,
        CONSTRAINT uq_seat_flight UNIQUE (flight_id, seat_number),
        CONSTRAINT fk_seat_flight FOREIGN KEY (flight_id) REFERENCES flights (flight_id)
    );

CREATE TABLE
    customers (
        customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(100) NOT NULL,
        CONSTRAINT uq_customer_email UNIQUE (email)
    );

CREATE TABLE
    reservations (
        reservation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        customer_id BIGINT NOT NULL,
        status VARCHAR(100) DEFAULT 'confirmed',
        CONSTRAINT chk_reservation_status CHECK (status IN ('confirmed', 'cancelled', 'completed')),
        CONSTRAINT fK_reservation_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    );

CREATE TABLE
    passengers (
        passenger_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        date_of_birth VARCHAR(100) NOT NULL,
        passport_number VARCHAR(200) NOT NULL,
        reservation_id BIGINT NOT NULL,
        CONSTRAINT uq_passenger_passport UNIQUE (passport_number),
        CONSTRAINT fk_passenger_reservation FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id)
    );

CREATE TABLE
    flight_segments (
        flight_segment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        reservation_id BIGINT NOT NULL,
        flight_id BIGINT NOT NULL,
        CONSTRAINT fk_flight_segment_reservation FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id),
        CONSTRAINT fk_flight_segment_flight FOREIGN KEY (flight_id) REFERENCES flights (flight_id)
    );

CREATE TABLE
    seat_assignments (
        passenger_id BIGINT NOT NULL,
        flight_segment_id BIGINT NOT NULL,
        seat_id BIGINT NOT NULL,
        PRIMARY KEY (passenger_id, flight_segment_id),
        CONSTRAINT fk_seat_assignment_passenger FOREIGN KEY (passenger_id) REFERENCES passengers (passenger_id),
        CONSTRAINT fk_seat_assignment_flight_segment FOREIGN KEY (flight_segment_id) REFERENCES flight_segments (flight_segment_id),
        CONSTRAINT fk_seat_assignment_seat FOREIGN KEY (seat_id) REFERENCES seats (seat_id),
        -- in this the same seat can be assigned to different passengers in the same flight segment therefore adding a unique constraint
        CONSTRAINT uq_segment_seat UNIQUE (flight_segment_id, seat_id)
    );