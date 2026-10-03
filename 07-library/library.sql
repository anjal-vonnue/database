-- Don't add UNIQUE just because two columns "look like" they identify something.
-- Ask: "Could this exact combination legitimately happen again?"
--
--
--
CREATE TABLE
    branches (
        branch_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        branch_name VARCHAR(200) NOT NULL
    );

CREATE TABLE
    books (
        book_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        title VARCHAR(200) NOT NULL,
        isbn VARCHAR(50) NOT NULL,
        publication_year INTEGER NOT NULL,
        CONSTRAINT uq_book_isbn UNIQUE (isbn),
        CONSTRAINT chk_book_publication_year CHECK (publication_year > 0)
    );

CREATE TABLE
    physical_copies (
        physical_copy_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        book_id BIGINT NOT NULL,
        branch_id BIGINT NOT NULL,
        CONSTRAINT physical_copy_book FOREIGN KEY (book_id) REFERENCES books (book_id),
        CONSTRAINT physical_copy_branch FOREIGN KEY (branch_id) REFERENCES branches (branch_id)
    );

CREATE TABLE
    authors (
        author_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_author_email UNIQUE (email)
    );

CREATE TABLE
    book_authors (
        author_id BIGINT NOT NULL,
        book_id BIGINT NOT NULL,
        PRIMARY KEY (author_id, book_id),
        CONSTRAINT book_authors_author FOREIGN KEY (author_id) REFERENCES authors (author_id),
        CONSTRAINT book_authors_book FOREIGN KEY (book_id) REFERENCES books (book_id)
    );

CREATE TABLE
    members (
        member_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_member_email UNIQUE (email)
    );

CREATE TABLE
    borrows (
        borrow_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        physical_copy_id BIGINT NOT NULL,
        member_id BIGINT NOT NULL,
        borrowed_date DATE NOT NULL,
        due_date DATE NOT NULL,
        returned_date DATE,
        CONSTRAINT fk_borrow_physical_copy (physical_copy_id) REFERENCES physical_copies (physical_copy_id),
        CONSTRAINT fk_borrow_memeber (member_id) REFERENCES members (member_id),
        CONSTRAINT chk_borrow_due_date CHECK (due_date >= borrowed_date)
    );