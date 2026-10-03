-- in previous version the same room number can be repeated in the same hotel therefore added a unique constraint
CREATE TABLE
    rooms (
        room_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        room_number INTEGER NOT NULL,
        room_type VARCHAR(40) NOT NULL DEFAULT 'single',
        price_per_night INTEGER NOT NULL,
        hotel_id BIGINT NOT NULL,
        CONSTRAINT chk_room_type CHECK (room_type IN ('single', 'double', 'suite')),
        CONSTRAINT chk_room_price_per_night CHECK (price_per_night > 0),
        CONSTRAINT fk_rooms_hotel FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id),
        CONSTRAINT uq_room_number_per_hotel UNIQUE (hotel_id, room_number)
    );