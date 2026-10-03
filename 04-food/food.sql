CREATE TABLE
    restaurants (
        restaurant_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        location VARCHAR(200) NOT NULL
    );

CREATE TABLE
    menu_items (
        menu_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        item_name VARCHAR(200) NOT NULL,
        restaurant_id BIGINT NOT NULL,
        price NUMERIC(10, 2) NOT NULL,
        CONSTRAINT fk_menu_items_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id),
        CONSTRAINT chk_menu_item_price CHECK (price > 0),
        CONSTRAINT uq_item_in_restaurant UNIQUE (restaurant_id, item_name)
    );

CREATE TABLE
    customers (
        customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        phone VARCHAR(100) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_customer_email UNIQUE (email)
    );

CREATE TABLE
    orders (
        order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        restaurant_id BIGINT NOT NULL,
        customer_id BIGINT NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'placed',
        CONSTRAINT fk_order_restaurent FOREIGN KEY (restaurant_id) REFERENCES restaurants (restaurant_id),
        CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
        CONSTRAINT chk_order_status CHECK (
            status IN ('placed', 'preparing', 'delivered', 'cancelled')
        )
    );

CREATE TABLE
    order_items (
        order_id BIGINT NOT NULL,
        menu_item_id BIGINT NOT NULL,
        quantity INTEGER NOT NULL,
        PRIMARY KEY (order_id, menu_item_id),
        CONSTRAINT chk_order_item_quantity CHECK (quantitiy > 0),
        FOREIGN KEY (order_id) REFERENCES orders (order_id),
        FOREIGN KEY (menu_item_id) REFERENCES menu_items (menu_item_id)
    );