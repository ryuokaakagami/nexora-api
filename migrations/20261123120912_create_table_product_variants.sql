CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    unit_id UUID NOT NULL REFERENCES units(id) ON DELETE RESTRICT,
    sku TEXT NOT NULL UNIQUE CHECK (char_length(sku) BETWEEN 3 AND 100),
    name TEXT NOT NULL DEFAULT '-' CHECK (char_length(name) BETWEEN 1 AND 150),
    attributes JSONB NOT NULL DEFAULT '{}'::jsonb,
    stock NUMERIC(12, 3) NOT NULL DEFAULT 0 CHECK (stock >= 0),
    price NUMERIC(14, 2) NOT NULL DEFAULT 0 CHECK (price >= 0),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_product_variants_product_id ON product_variants(product_id);
CREATE INDEX idx_product_variants_unit_id ON product_variants(unit_id);

CREATE UNIQUE INDEX uq_variant_product_name_unit_active
    ON product_variants(product_id, name, unit_id)
    WHERE deleted_at IS NULL;