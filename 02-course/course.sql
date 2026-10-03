CREATE TABLE
    instructors (
        instructor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_instructor_email UNIQUE (email)
    );

CREATE TABLE
    courses (
        course_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        instructor_id BIGINT NOT NULL,
        CONSTRAINT fk_course_instructor FOREIGN KEY (instructor_id) REFERENCES instructors (instructor_id)
    );

CREATE TABLE
    lessons (
        lesson_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        title VARCHAR(200) NOT NULL,
        -- duration in minutes
        duration_minutes INTEGER NOT NULL,
        CONSTRAINT chk_lesson_duration CHECK (duration > 0)
    );

CREATE TABLE
    course_lessons (
        course_id BIGINT NOT NULL,
        lesson_id BIGINT NOT NULL,
        PRIMARY KEY (course_id, lesson_id),
        FOREIGN KEY (course_id) REFERENCES courses (course_id),
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)
    );

CREATE TABLE
    students (
        student_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        email VARCHAR(200) NOT NULL,
        CONSTRAINT uq_student_email UNIQUE (email)
    );

CREATE TABLE
    enrolled_courses (
        enrollment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id BIGINT NOT NULL,
        course_id BIGINT NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'active',
        CONSTRAINT chk_enrolled_course_status CHECK (status IN ('active', 'completed', 'cancelled')),
        FOREIGN KEY (student_id) REFERENCES students (student_id),
        FOREIGN KEY (course_id) REFERENCES courses (course_id)
    );