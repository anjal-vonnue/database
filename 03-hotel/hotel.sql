CREATE TABLE
    hotels (
        hotel_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        location VARCHAR(200) NOT NULL
    );

CREATE TABLE
    rooms (
        room_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        room_number INTEGER NOT NULL,
        room_type VARCHAR(40) NOT NULL DEFAULT 'single',
        price_per_night INTEGER NOT NULL,
        hotel_id BIGINT NOT NULL,
        CONSTRAINT chk_room_type CHECK (room_type IN ('single', 'double', 'suite')),
        CONSTRAINT chk_room_price_per_night CHECK (price_per_night > 0),
        CONSTRAINT fk_rooms_hotel FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id)
    );

CREATE TABLE
    customers (
        customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        phone_number VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_customer_email UNIQUE (email)
    );

CREATE TABLE
    reservations (
        reservation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        customer_id BIGINT NOT NULL,
        hotel_id BIGINT NOT NULL,
        check_in_date TIMESTAMP NOT NULL,
        check_out_date TIMESTAMP NOT NULL,
        status VARCHAR(100) NOT NULL DEFAULT 'confirmed',
        CONSTRAINT fk_reservations_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
        CONSTRAINT fk_reservations_hotel FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id),
        CONSTRAINT chk_in_out_time CHECK (check_out_date > check_in_date),
        CONSTRAINT chk_reservation_status CHECK (status IN ('confirmed', 'cancelled', 'completed'))
    );

CREATE TABLE
    reserved_rooms (
        reservation_id BIGINT NOT NULL,
        room_id BIGINT NOT NULL,
        PRIMARY KEY (reservation_id, room_id),
        CONSTRAINT fk_reserved_rooms_reservation FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id),
        CONSTRAINT fk_reserved_rooms_room FOREIGN KEY (room_id) REFERENCES rooms (room_id)
    );