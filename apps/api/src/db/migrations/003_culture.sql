-- Car culture: the feed, builds, events, collections. Cars can be celebrities too.

CREATE TABLE builds (
  id         TEXT PRIMARY KEY,
  vehicle_id TEXT NOT NULL REFERENCES vehicles(id),
  owner_id   TEXT NOT NULL REFERENCES users(id),
  title      TEXT NOT NULL,
  goal       TEXT,
  status     TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','paused','done')),
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE posts (
  id               TEXT PRIMARY KEY,
  author_id        TEXT NOT NULL REFERENCES users(id),
  kind             TEXT NOT NULL DEFAULT 'post' CHECK (kind IN ('post','build_update','event_share','listing_share','recall')),
  vehicle_id       TEXT REFERENCES vehicles(id),
  build_id         TEXT REFERENCES builds(id),
  title            TEXT,
  body             TEXT NOT NULL,
  hashtags         TEXT NOT NULL DEFAULT '[]',
  passport_block_id TEXT,              -- set when the update is backed by a garage-sealed passport entry
  hours            REAL,
  cost_minor       INTEGER,
  like_count       INTEGER NOT NULL DEFAULT 0,
  comment_count    INTEGER NOT NULL DEFAULT 0,
  hidden           INTEGER NOT NULL DEFAULT 0,
  created_at       TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_posts_time ON posts(hidden, created_at);
CREATE INDEX idx_posts_vehicle ON posts(vehicle_id, created_at);
CREATE INDEX idx_posts_author ON posts(author_id, created_at);
CREATE TABLE likes (
  user_id TEXT NOT NULL REFERENCES users(id),
  post_id TEXT NOT NULL REFERENCES posts(id),
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  PRIMARY KEY (user_id, post_id)
);
CREATE TABLE comments (
  id         TEXT PRIMARY KEY,
  post_id    TEXT NOT NULL REFERENCES posts(id),
  author_id  TEXT NOT NULL REFERENCES users(id),
  body       TEXT NOT NULL,
  hidden     INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_comments_post ON comments(post_id, created_at);
CREATE TABLE reports (
  id          TEXT PRIMARY KEY,
  reporter_id TEXT NOT NULL REFERENCES users(id),
  target_type TEXT NOT NULL,
  target_id   TEXT NOT NULL,
  reason      TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','actioned','dismissed')),
  created_at  TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE TABLE events (
  id           TEXT PRIMARY KEY,
  host_user_id TEXT REFERENCES users(id),
  host_org_id  TEXT REFERENCES orgs(id),
  title        TEXT NOT NULL,
  description  TEXT,
  starts_at    TEXT NOT NULL,
  ends_at      TEXT,
  place        TEXT NOT NULL,
  lat          REAL,
  lng          REAL,
  status       TEXT NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled','cancelled')),
  created_at   TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_events_time ON events(starts_at);
CREATE TABLE event_rsvps (
  event_id TEXT NOT NULL REFERENCES events(id),
  user_id  TEXT NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
  PRIMARY KEY (event_id, user_id)
);
-- What a car is worth over time: a collection is a portfolio.
CREATE TABLE valuations (
  id          TEXT PRIMARY KEY,
  vehicle_id  TEXT NOT NULL REFERENCES vehicles(id),
  value_minor INTEGER NOT NULL CHECK (value_minor >= 0),
  source      TEXT NOT NULL CHECK (source IN ('owner','appraisal','sale')),
  note        TEXT,
  at          TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);
CREATE INDEX idx_valuations ON valuations(vehicle_id, at);
