-- Таблица групп
CREATE TABLE student_group (
    id   INTEGER PRIMARY KEY,
    name TEXT    NOT NULL
);

-- Таблица студентов
CREATE TABLE student (
    id        INTEGER PRIMARY KEY,
    full_name TEXT    NOT NULL,
    group_id  INTEGER NOT NULL,
    FOREIGN KEY (group_id)
        REFERENCES student_group(id)
        ON DELETE CASCADE
);
