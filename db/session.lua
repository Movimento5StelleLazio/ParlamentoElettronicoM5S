CREATE TABLE "session" (
        "ident"                 TEXT            PRIMARY KEY,
        "additional_secret"     TEXT,
        "expiry"                TIMESTAMPTZ     NOT NULL DEFAULT now() + '24 hours',
        "member_id"             INT8            REFERENCES "member" ("id") ON DELETE SET NULL,
        "lang"                  TEXT );
CREATE INDEX "session_expiry_idx" ON "session" ("expiry");

COMMENT ON TABLE "session" IS 'Sessions, i.e. for a web-frontend';

COMMENT ON COLUMN "session"."ident"             IS 'Secret session identifier (i.e. random string)';
COMMENT ON COLUMN "session"."additional_secret" IS 'Additional field to store a secret, which can be used against CSRF attacks';
COMMENT ON COLUMN "session"."member_id"         IS 'Reference to member, who is logged in';
COMMENT ON COLUMN "session"."lang"              IS 'Language code of the selected language';



DELETE FROM "setting" WHERE key = 'tab_mode';