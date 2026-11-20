-- Landing zone: everything as text, exactly as received
CREATE TABLE raw_trades (
    raw_id       SERIAL PRIMARY KEY,
    trade_id     TEXT,
    trade_date   TEXT,
    symbol       TEXT,
    side         TEXT,
    quantity     TEXT,
    price        TEXT,
    currency     TEXT,
    source_file  TEXT,
    loaded_at    TIMESTAMP DEFAULT now()
);

-- Clean blotter: strict rules
CREATE TABLE trades (
    trade_id     TEXT PRIMARY KEY,
    trade_date   DATE NOT NULL,
    symbol       TEXT NOT NULL,
    side         TEXT NOT NULL CHECK (side IN ('BUY', 'SELL')),
    quantity     NUMERIC NOT NULL CHECK (quantity > 0),
    price        NUMERIC(18,6) NOT NULL CHECK (price >= 0),
    currency     CHAR(3) NOT NULL CHECK (currency ~ '^[A-Z]{3}$'),
    source_file  TEXT,
    loaded_at    TIMESTAMP DEFAULT now()
);

-- Audit trail: what we rejected and why
CREATE TABLE rejected_trades (
    reject_id    SERIAL PRIMARY KEY,
    raw_id       INTEGER,
    reason       TEXT NOT NULL,
    rejected_at  TIMESTAMP DEFAULT now()
);
