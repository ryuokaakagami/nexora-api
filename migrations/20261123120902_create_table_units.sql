CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE CHECK (char_length(name) BETWEEN 2 AND 50),
    symbol TEXT NOT NULL UNIQUE CHECK (char_length(symbol) BETWEEN 1 AND 15),
    allow_decimal BOOLEAN NOT NULL DEFAULT false,
    updated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);