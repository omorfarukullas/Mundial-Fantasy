CREATE TABLE gameweeks (
  id          INT PRIMARY KEY,
  deadline_at TIMESTAMPTZ NOT NULL,
  is_active   BOOLEAN DEFAULT FALSE,
  is_finished BOOLEAN DEFAULT FALSE
);

INSERT INTO gameweeks (id, deadline_at, is_active) VALUES
(1, '2026-06-11 17:00:00+00', TRUE),
(2, '2026-06-16 13:00:00+00', FALSE),
(3, '2026-06-21 13:00:00+00', FALSE);
