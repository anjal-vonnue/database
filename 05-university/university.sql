--
--Each course has exactly one professor then you do NOT need a junction table:
--
CREATE TABLE
    departments (
        department_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL
    );

CREATE TABLE
    professors (
        professor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_professor_email UNIQUE (email)
    );

CREATE TABLE
    courses (
        course_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        department_id BIGINT NOT NULL,
        professor_id BIGINT NOT NULL,
        CONSTRAINT fk_course_department FOREIGN KEY (department_id) REFERENCES departments (department_id),
        CONSTRAINT fk_course_professor FOREIGN KEY (professor_id) REFERENCES professors (professor_id)
    );

CREATE TABLE
    students (
        student_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        department_id BIGINT NOT NULL,
        CONSTRAINT uq_student_email UNIQUE (email),
        CONSTRAINT fk_student_department FOREIGN KEY (department_id) REFERENCES departments (department_id)
    );

CREATE TABLE
    enrollments (
        enrollment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id BIGINT NOT NULL,
        course_id BIGINT NOT NULL,
        enrollment_date TIMESTAMP NOT NULL,
        grade VARCHAR(20),
        status VARCHAR(30) NOT NULL DEFAULT 'active',
        CONSTRAINT uq_enrollment_student_course UNIQUE (student_id, course_id),
        CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) REFERENCES students (student_id),
        CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) REFERENCES courses (course_id),
        CONSTRAINT chk_enrollment_grage CHECK (grade IN ('A', 'B', 'C', 'D', 'F')),
        CONSTRAINT chk_enrollment_status CHECK (status IN ('active', 'dropped', 'completed'))
    );