-- only needed for database driven tempstore (see application config)
CREATE TABLE "tempstore" (
        "key"           TEXT            PRIMARY KEY,
        "data"          BYTEA           NOT NULL );

-- Attention: USER is a reserved word in PostgreSQL. We use it anyway in
-- this example. Don't forget the double quotes where neccessary.
CREATE TABLE "user" (
        "id"            SERIAL8         PRIMARY KEY,
        "ident"         TEXT            NOT NULL,
        "password"      TEXT,
        "name"          TEXT,
        "lang"          TEXT,
        "write_priv"    BOOLEAN         NOT NULL DEFAULT FALSE,
        "admin"         BOOLEAN         NOT NULL DEFAULT FALSE );

CREATE TABLE "session" (
        "ident"         TEXT            PRIMARY KEY,
        "csrf_secret"   TEXT            NOT NULL,
        "expiry"        TIMESTAMPTZ     NOT NULL DEFAULT NOW() + '24 hours',
        "user_id"       INT8            REFERENCES "user" ("id") ON DELETE SET NULL ON UPDATE CASCADE );

CREATE TABLE "media_type" (
        "id"            SERIAL8         PRIMARY KEY,
        "name"          TEXT            NOT NULL,
        "description"   TEXT );

CREATE TABLE "genre" (
        "id"            SERIAL8         PRIMARY KEY,
        "name"          TEXT            NOT NULL,
        "description"   TEXT );

CREATE TABLE "medium" (
        "id"            SERIAL8         PRIMARY KEY,
        "media_type_id" INT8            NOT NULL REFERENCES "media_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        "name"          TEXT            NOT NULL,
        "copyprotected" BOOLEAN         NOT NULL );

CREATE TABLE "classification" (
        PRIMARY KEY ("medium_id", "genre_id"),
        "medium_id"     INT8            REFERENCES "medium" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
        "genre_id"      INT8            REFERENCES "genre" ("id") ON DELETE CASCADE ON UPDATE CASCADE );

CREATE TABLE "track" (
        "id"            SERIAL8         PRIMARY KEY,
        "medium_id"     INT8            NOT NULL REFERENCES "medium" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
        "position"      INT8            NOT NULL,
        "name"          TEXT            NOT NULL,
        "description"   TEXT,
        "duration"      INTERVAL,
        UNIQUE ("medium_id", "position") );

INSERT INTO "user" ("ident", "password", "name", "write_priv", "admin")
  VALUES ('admin', 'admin', 'Administrator', true, true);

INSERT INTO "user" ("ident", "password", "name", "write_priv", "admin")
  VALUES ('user', 'User', 'User', true, false);

INSERT INTO "user" ("ident", "password", "name", "write_priv", "admin")
  VALUES ('anon', 'anon', 'Anonymous', false, false);

INSERT INTO "media_type" ("name", "description") VALUES ('CD', '');
INSERT INTO "media_type" ("name", "description") VALUES ('Tape', '');

INSERT INTO "genre" ("name", "description") VALUES ('Klassik', '');
INSERT INTO "genre" ("name", "description") VALUES ('Gospel', '');
INSERT INTO "genre" ("name", "description") VALUES ('Jazz', '');
INSERT INTO "genre" ("name", "description") VALUES ('Traditional', '');
INSERT INTO "genre" ("name", "description") VALUES ('Latin', '');
INSERT INTO "genre" ("name", "description") VALUES ('Blues', '');
INSERT INTO "genre" ("name", "description") VALUES ('Rhythm & blues', '');
INSERT INTO "genre" ("name", "description") VALUES ('Funk', '');
INSERT INTO "genre" ("name", "description") VALUES ('Rock', '');
INSERT INTO "genre" ("name", "description") VALUES ('Pop', '');
INSERT INTO "genre" ("name", "description") VALUES ('Country', '');
INSERT INTO "genre" ("name", "description") VALUES ('Electronic', '');
INSERT INTO "genre" ("name", "description") VALUES ('Ska / Reggea', '');
INSERT INTO "genre" ("name", "description") VALUES ('Hip hop / Rap', '');

