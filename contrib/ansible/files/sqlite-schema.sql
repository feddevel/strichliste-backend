PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS "user" (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name VARCHAR(64) NOT NULL,
    email VARCHAR(255) DEFAULT NULL,
    balance INTEGER NOT NULL,
    disabled BOOLEAN NOT NULL,
    created DATETIME NOT NULL,
    updated DATETIME DEFAULT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS UNIQ_USER_NAME ON "user" (name);
CREATE INDEX IF NOT EXISTS IDX_USER_DISABLED_UPDATED ON "user" (disabled, updated);

CREATE TABLE IF NOT EXISTS article (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    precursor_id INTEGER DEFAULT NULL,
    name VARCHAR(255) NOT NULL,
    barcode VARCHAR(32) DEFAULT NULL,
    amount INTEGER NOT NULL,
    active BOOLEAN NOT NULL,
    created DATETIME NOT NULL,
    usage_count INTEGER NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS UNIQ_ARTICLE_PRECURSOR_ID ON article (precursor_id);
CREATE INDEX IF NOT EXISTS IDX_ARTICLE_PRECURSOR_ID ON article (precursor_id);
CREATE INDEX IF NOT EXISTS IDX_ARTICLE_BARCODE ON article (barcode);

CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    user_id INTEGER NOT NULL,
    article_id INTEGER DEFAULT NULL,
    recipient_transaction_id INTEGER DEFAULT NULL,
    sender_transaction_id INTEGER DEFAULT NULL,
    quantity INTEGER DEFAULT NULL,
    comment VARCHAR(255) DEFAULT NULL,
    amount INTEGER NOT NULL,
    deleted BOOLEAN NOT NULL,
    created DATETIME NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS UNIQ_TRANSACTION_RECIPIENT ON transactions (recipient_transaction_id);
CREATE UNIQUE INDEX IF NOT EXISTS UNIQ_TRANSACTION_SENDER ON transactions (sender_transaction_id);
CREATE INDEX IF NOT EXISTS IDX_TRANSACTION_USER ON transactions (user_id);
CREATE INDEX IF NOT EXISTS IDX_TRANSACTION_ARTICLE ON transactions (article_id);

CREATE INDEX IF NOT EXISTS IDX_TRANSACTION_CREATED ON transactions (created);

CREATE TRIGGER IF NOT EXISTS fk_article_precursor
BEFORE INSERT ON article
FOR EACH ROW WHEN NEW.precursor_id IS NOT NULL
BEGIN
    SELECT CASE
        WHEN ((SELECT id FROM article WHERE id = NEW.precursor_id) IS NULL)
        THEN RAISE(ABORT, 'insert on table "article" violates foreign key constraint')
    END;
END;

CREATE TRIGGER IF NOT EXISTS fk_transactions_user
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    SELECT CASE
        WHEN ((SELECT id FROM "user" WHERE id = NEW.user_id) IS NULL)
        THEN RAISE(ABORT, 'insert on table "transactions" violates foreign key constraint')
    END;
END;

CREATE TRIGGER IF NOT EXISTS fk_transactions_article
BEFORE INSERT ON transactions
FOR EACH ROW WHEN NEW.article_id IS NOT NULL
BEGIN
    SELECT CASE
        WHEN ((SELECT id FROM article WHERE id = NEW.article_id) IS NULL)
        THEN RAISE(ABORT, 'insert on table "transactions" violates foreign key constraint')
    END;
END;
