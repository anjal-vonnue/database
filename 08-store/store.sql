CREATE TABLE
    customers (
        customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_customer_email UNIQUE (email)
    );

CREATE TABLE
    products (
        product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        product_name VARCHAR(200) NOT NULL,
        product_price NUMERIC(10, 2) NOT NULL,
        CONSTRAINT chk_product_price CHECK (product_price > 0)
    );

CREATE TABLE
    orders (
        order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        customer_id BIGINT NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'pending',
        CONSTRAINT chk_order_status CHECK (
            status IN (
                'pending',
                'paid',
                'shipped',
                'delivered',
                'cancelled'
            )
        ),
        CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    );

CREATE TABLE
    order_items (
        order_id BIGINT NOT NULL,
        product_id BIGINT NOT NULL,
        PRIMARY KEY (order_id, product_id),
        quantity INTEGER NOT NULL,
        price_at_purchase NUMERIC(10, 2) NOT NULL,
        CONSTRAINT chk_order_item_quantity CHECK (quantity > 0),
        CONSTRAINT chk_order_item_price CHECK (price_at_purchase > 0),
        CONSTRAINT fk_order_item_product FOREIGN KEY (product_id) REFERENCES products (product_id),
        CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders (order_id)
    );