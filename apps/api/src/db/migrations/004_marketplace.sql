-- Garage marketplace (requests, quotes, job cards, messages, reviews) and parts sourcing.

CREATE TABLE job_requests (
  id          TEXT PRIMARY KEY,
  customer_id TEXT NOT NULL REFERENCES users(id),
  vehicle_id  TEXT NOT NULL REFERENCES vehicles(id),
  title       TEXT NOT NULL,
  description TEXT,
  trade       TEXT NOT NULL DEFAULT 'mechanic',
  dtcs        TEXT NOT NULL DEFAULT '[]',
  area        TEXT,
  lat         REAL,
  lng         REAL,
  mobile_ok   INTEGER NOT NULL DEFAULT 0,      -- happy for a mobile mechanic to come to me
  budget_minor INTEGER,
  status      TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','awarded','closed','expired')),
  awarded_quote_id TEXT,
  expires_at  TEXT NOT NULL,
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_requests_open ON job_requests(status, trade, created_at);
CREATE TABLE quotes (
  id           TEXT PRIMARY KEY,
  request_id   TEXT NOT NULL REFERENCES job_requests(id),
  org_id       TEXT NOT NULL REFERENCES orgs(id),
  author_id    TEXT NOT NULL REFERENCES users(id),
  amount_minor INTEGER NOT NULL CHECK (amount_minor > 0),
  eta_text     TEXT,
  slot_at      TEXT,
  note         TEXT,
  status       TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','accepted','declined','withdrawn')),
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  UNIQUE (request_id, org_id)
);
CREATE TABLE job_lines (
  id         TEXT PRIMARY KEY,
  job_id     TEXT NOT NULL REFERENCES jobs(id),
  kind       TEXT NOT NULL CHECK (kind IN ('part','labour','other')),
  name       TEXT NOT NULL,
  qty        REAL NOT NULL DEFAULT 1,
  unit_minor INTEGER NOT NULL CHECK (unit_minor >= 0)
);
-- Messages are bound to a thread (a job, booking, order or listing) and cannot be edited: they are evidence.
CREATE TABLE messages (
  id          TEXT PRIMARY KEY,
  thread_type TEXT NOT NULL CHECK (thread_type IN ('job','booking','order','listing','ride','claim')),
  thread_id   TEXT NOT NULL,
  author_id   TEXT NOT NULL REFERENCES users(id),
  body        TEXT NOT NULL,
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_messages_thread ON messages(thread_type, thread_id, created_at);
CREATE TRIGGER messages_no_update BEFORE UPDATE ON messages BEGIN SELECT RAISE(ABORT, 'messages is append-only'); END;
CREATE TRIGGER messages_no_delete BEFORE DELETE ON messages BEGIN SELECT RAISE(ABORT, 'messages is append-only'); END;
-- Reviews only exist for completed, paid jobs: one per job.
CREATE TABLE reviews (
  id         TEXT PRIMARY KEY,
  job_id     TEXT NOT NULL UNIQUE REFERENCES jobs(id),
  author_id  TEXT NOT NULL REFERENCES users(id),
  org_id     TEXT NOT NULL REFERENCES orgs(id),
  rating     INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment    TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE part_listings (
  id           TEXT PRIMARY KEY,
  org_id       TEXT NOT NULL REFERENCES orgs(id),
  name         TEXT NOT NULL,
  category     TEXT NOT NULL,
  brand        TEXT,
  part_number  TEXT,
  tier         TEXT NOT NULL CHECK (tier IN ('oem','aftermarket','recycled')),
  fits         TEXT NOT NULL DEFAULT '[]',   -- [{make, model, from, to}]  (empty = universal)
  price_minor  INTEGER NOT NULL CHECK (price_minor >= 0),
  stock        INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
  delivery_minor INTEGER NOT NULL DEFAULT 0,
  same_day     INTEGER NOT NULL DEFAULT 0,
  active       INTEGER NOT NULL DEFAULT 1,
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_parts_cat ON part_listings(active, category);
CREATE TABLE part_orders (
  id             TEXT PRIMARY KEY,
  buyer_id       TEXT NOT NULL REFERENCES users(id),
  org_id         TEXT NOT NULL REFERENCES orgs(id),
  vehicle_id     TEXT REFERENCES vehicles(id),
  status         TEXT NOT NULL DEFAULT 'placed' CHECK (status IN ('placed','paid','packed','shipped','delivered','cancelled')),
  subtotal_minor INTEGER NOT NULL,
  delivery_minor INTEGER NOT NULL,
  total_minor    INTEGER NOT NULL,
  address        TEXT,
  created_at     TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  updated_at     TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE part_order_lines (
  id         TEXT PRIMARY KEY,
  order_id   TEXT NOT NULL REFERENCES part_orders(id),
  listing_id TEXT NOT NULL REFERENCES part_listings(id),
  name       TEXT NOT NULL,
  qty        INTEGER NOT NULL CHECK (qty > 0),
  unit_minor INTEGER NOT NULL
);

CREATE TABLE obd_scans (
  id         TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  user_id    TEXT NOT NULL REFERENCES users(id),
  source     TEXT NOT NULL CHECK (source IN ('bluetooth','manual','garage')),
  odometer   REAL,
  dtcs       TEXT NOT NULL DEFAULT '[]',
  protocol   TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_obd_vehicle ON obd_scans(vehicle_id, created_at);
