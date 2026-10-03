-- the rquirement was each course cotains multiple lessons but it doesn't say a lesson can belong to multiple courses
-- there is no need for course_lesson table. instead we can just add the course_id in the lessons
-- but if i intentionally want a lesson to be reusable across multiple course, then my course_lessons table is correct
-- always put foreign keys in paranthesis
--
--
CREATE TABLE
    enrolled_courses (
        enrollment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id BIGINT NOT NULL,
        course_id BIGINT NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'active',
        CONSTRAINT chk_enrolled_course_status CHECK (status IN ('active', 'completed', 'cancelled')),
        -- in the previous table studend-1 can enroll in course-1 twice, which is not valid
        -- there for added added a unique contraint
        CONSTRAINT uq_student_course UNIQUE (student_id, course_id),
        FOREIGN KEY (student_id) REFERENCES students (student_id),
        FOREIGN KEY (course_id) REFERENCES courses (course_id)
    );