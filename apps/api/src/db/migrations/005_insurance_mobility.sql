-- Insurance and protection; mobility (hire, rides).

CREATE TABLE insurers (
  id     TEXT PRIMARY KEY,
  name   TEXT NOT NULL UNIQUE,
  phone  TEXT,
  active INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE insurance_requests (
  id         TEXT PRIMARY KEY,
  owner_id   TEXT NOT NULL REFERENCES users(id),
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  cover_type TEXT NOT NULL CHECK (cover_type IN ('comprehensive','third_party_plus','third_party')),
  notes      TEXT,
  status     TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','placed','closed')),
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE insurance_quotes (
  id            TEXT PRIMARY KEY,
  request_id    TEXT NOT NULL REFERENCES insurance_requests(id),
  broker_org_id TEXT NOT NULL REFERENCES orgs(id),
  insurer_id    TEXT NOT NULL REFERENCES insurers(id),
  premium_minor INTEGER NOT NULL CHECK (premium_minor > 0),
  cover_type    TEXT NOT NULL,
  terms         TEXT,
  valid_until   TEXT,
  status        TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','accepted','declined')),
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE policies (
  id            TEXT PRIMARY KEY,
  vehicle_id    TEXT NOT NULL REFERENCES vehicles(id),
  owner_id      TEXT NOT NULL REFERENCES users(id),
  insurer_id    TEXT NOT NULL REFERENCES insurers(id),
  broker_org_id TEXT REFERENCES orgs(id),
  policy_no     TEXT NOT NULL,
  cover_type    TEXT NOT NULL,
  premium_minor INTEGER NOT NULL,
  starts_at     TEXT NOT NULL,
  ends_at       TEXT NOT NULL,
  status        TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','expired','cancelled')),
  document_id   TEXT,
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  UNIQUE (insurer_id, policy_no)
);
CREATE TABLE claims (
  id          TEXT PRIMARY KEY,
  claimant_id TEXT NOT NULL REFERENCES users(id),
  ref_type    TEXT CHECK (ref_type IN ('job','booking','order','policy')),
  ref_id      TEXT,
  vehicle_id  TEXT REFERENCES vehicles(id),
  incident    TEXT NOT NULL,
  incident_at TEXT NOT NULL,
  description TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','in_review','resolved','rejected')),
  resolution  TEXT,
  resolver_id TEXT REFERENCES users(id),
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  resolved_at TEXT
);

CREATE TABLE rental_listings (
  id             TEXT PRIMARY KEY,
  vehicle_id     TEXT NOT NULL UNIQUE REFERENCES vehicles(id),
  owner_user_id  TEXT REFERENCES users(id),
  owner_org_id   TEXT REFERENCES orgs(id),
  daily_minor    INTEGER,
  town_minor     INTEGER,
  monthly_minor  INTEGER,
  min_term_months INTEGER NOT NULL DEFAULT 6,
  pickup_area    TEXT,
  lat            REAL,
  lng            REAL,
  rules          TEXT,
  active         INTEGER NOT NULL DEFAULT 1,
  created_at     TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE bookings (
  id              TEXT PRIMARY KEY,
  listing_id      TEXT NOT NULL REFERENCES rental_listings(id),
  renter_id       TEXT NOT NULL REFERENCES users(id),
  mode            TEXT NOT NULL CHECK (mode IN ('daily','town','lease')),
  start_at        TEXT NOT NULL,
  end_at          TEXT NOT NULL,
  units           INTEGER NOT NULL,          -- days, or months for a lease
  price_minor     INTEGER NOT NULL,
  protection_minor INTEGER NOT NULL,
  total_minor     INTEGER NOT NULL,
  pickup          TEXT,
  dropoff         TEXT,
  status          TEXT NOT NULL DEFAULT 'awaiting_payment' CHECK (status IN ('awaiting_payment','paid','confirmed','active','returned','completed','cancelled')),
  created_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  updated_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_bookings_listing ON bookings(listing_id, status);

CREATE TABLE driver_status (
  user_id    TEXT PRIMARY KEY REFERENCES users(id),
  online     INTEGER NOT NULL DEFAULT 0,
  vehicle_id TEXT REFERENCES vehicles(id),
  lat        REAL,
  lng        REAL,
  updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE rides (
  id            TEXT PRIMARY KEY,
  rider_id      TEXT NOT NULL REFERENCES users(id),
  driver_id     TEXT REFERENCES users(id),
  pickup_label  TEXT NOT NULL,
  pickup_lat    REAL NOT NULL,
  pickup_lng    REAL NOT NULL,
  drop_label    TEXT NOT NULL,
  drop_lat      REAL NOT NULL,
  drop_lng      REAL NOT NULL,
  distance_m    INTEGER NOT NULL,
  fare_minor    INTEGER NOT NULL,
  fee_minor     INTEGER NOT NULL DEFAULT 0,
  status        TEXT NOT NULL DEFAULT 'requested' CHECK (status IN ('requested','accepted','in_trip','complete','cancelled','expired')),
  expires_at    TEXT NOT NULL,
  accepted_at   TEXT,
  started_at    TEXT,
  completed_at  TEXT,
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_rides_status ON rides(status, created_at);
