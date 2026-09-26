-- Profiles, personas (the nine account types), verification, media, wallets and follows.

CREATE TABLE user_profiles (
  user_id         TEXT PRIMARY KEY REFERENCES users(id),
  handle          TEXT UNIQUE,
  bio             TEXT,
  city            TEXT,
  avatar_media    TEXT,
  cover_media     TEXT,
  lang            TEXT NOT NULL DEFAULT 'en',
  currency        TEXT NOT NULL DEFAULT 'GMD' CHECK (currency IN ('GMD','USD','EUR','GBP')),
  units           TEXT NOT NULL DEFAULT 'km' CHECK (units IN ('km','mi')),
  text_scale      REAL NOT NULL DEFAULT 1,
  public_profile  INTEGER NOT NULL DEFAULT 1,
  show_valuation  INTEGER NOT NULL DEFAULT 0,
  pulse_sharing   INTEGER NOT NULL DEFAULT 0,
  created_at      TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

-- One person can hold several personas: owner + collector, or mechanic + parts supplier.
CREATE TABLE user_personas (
  user_id    TEXT NOT NULL REFERENCES users(id),
  persona    TEXT NOT NULL CHECK (persona IN ('owner','collector','fleet','garage','parts','driver','dealer','rental','broker')),
  status     TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','pending','rejected','suspended')),
  org_id     TEXT REFERENCES orgs(id),
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  PRIMARY KEY (user_id, persona)
);

CREATE TABLE media (
  id         TEXT PRIMARY KEY,
  owner_id   TEXT NOT NULL REFERENCES users(id),
  kind       TEXT NOT NULL CHECK (kind IN ('image','doc')),
  mime       TEXT NOT NULL,
  bytes      INTEGER NOT NULL,
  sha256     TEXT NOT NULL,
  visibility TEXT NOT NULL DEFAULT 'public' CHECK (visibility IN ('public','private')),
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE media_links (
  id        TEXT PRIMARY KEY,
  media_id  TEXT NOT NULL REFERENCES media(id),
  ref_type  TEXT NOT NULL,
  ref_id    TEXT NOT NULL,
  caption   TEXT,
  sort      INTEGER NOT NULL DEFAULT 0,
  UNIQUE (media_id, ref_type, ref_id)
);
CREATE INDEX idx_media_links_ref ON media_links(ref_type, ref_id);

-- Business verification (garages, suppliers, dealers, brokers, rental companies): nobody goes live without it.
CREATE TABLE kyc_submissions (
  id            TEXT PRIMARY KEY,
  user_id       TEXT NOT NULL REFERENCES users(id),
  org_id        TEXT REFERENCES orgs(id),
  persona       TEXT NOT NULL,
  business_name TEXT NOT NULL,
  reg_no        TEXT,
  id_number     TEXT,
  specialties   TEXT NOT NULL DEFAULT '[]',
  status        TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected','more_info')),
  note          TEXT,
  reviewer_id   TEXT REFERENCES users(id),
  reviewed_at   TEXT,
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_kyc_status ON kyc_submissions(status, created_at);

-- Follow people, businesses and vehicles. A vehicle follow with intent 'buyback' tells you when a car you used to own resurfaces.
CREATE TABLE follows (
  follower_id TEXT NOT NULL REFERENCES users(id),
  target_type TEXT NOT NULL CHECK (target_type IN ('user','vehicle','org')),
  target_id   TEXT NOT NULL,
  intent      TEXT NOT NULL DEFAULT 'follow' CHECK (intent IN ('follow','buyback')),
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  PRIMARY KEY (follower_id, target_type, target_id)
);
CREATE INDEX idx_follows_target ON follows(target_type, target_id);

-- Wallets and an append-only ledger. Platform fees land in the platform wallet.
CREATE TABLE wallets (
  id            TEXT PRIMARY KEY,
  owner_type    TEXT NOT NULL CHECK (owner_type IN ('user','org','platform')),
  owner_id      TEXT NOT NULL,
  balance_minor INTEGER NOT NULL DEFAULT 0 CHECK (balance_minor >= 0),
  UNIQUE (owner_type, owner_id)
);
CREATE TABLE wallet_entries (
  id            TEXT PRIMARY KEY,
  wallet_id     TEXT NOT NULL REFERENCES wallets(id),
  kind          TEXT NOT NULL CHECK (kind IN ('credit','fee','payout','refund')),
  amount_minor  INTEGER NOT NULL,
  balance_after INTEGER NOT NULL,
  ref_type      TEXT,
  ref_id        TEXT,
  note          TEXT,
  created_at    TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_wallet_entries ON wallet_entries(wallet_id, created_at);
CREATE TRIGGER wallet_entries_no_update BEFORE UPDATE ON wallet_entries BEGIN SELECT RAISE(ABORT, 'wallet_entries is append-only'); END;
CREATE TRIGGER wallet_entries_no_delete BEFORE DELETE ON wallet_entries BEGIN SELECT RAISE(ABORT, 'wallet_entries is append-only'); END;

CREATE TABLE payment_methods (
  id         TEXT PRIMARY KEY,
  user_id    TEXT NOT NULL REFERENCES users(id),
  provider   TEXT NOT NULL CHECK (provider IN ('afrimoney','qmoney')),
  phone      TEXT NOT NULL,
  verified   INTEGER NOT NULL DEFAULT 0,
  is_default INTEGER NOT NULL DEFAULT 0,
  otp_hash   TEXT,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  UNIQUE (user_id, provider, phone)
);
CREATE TABLE payouts (
  id           TEXT PRIMARY KEY,
  wallet_id    TEXT NOT NULL REFERENCES wallets(id),
  requested_by TEXT NOT NULL REFERENCES users(id),
  method_id    TEXT NOT NULL REFERENCES payment_methods(id),
  amount_minor INTEGER NOT NULL CHECK (amount_minor > 0),
  status       TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','paid','failed')),
  provider_ref TEXT,
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE fx_rates (
  currency   TEXT PRIMARY KEY,
  per_gmd    REAL NOT NULL,         -- how much of this currency one dalasi buys
  updated_by TEXT,
  updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
INSERT INTO fx_rates (currency, per_gmd) VALUES ('GMD', 1);
