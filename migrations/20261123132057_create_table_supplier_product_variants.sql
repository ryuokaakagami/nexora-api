CREATE TABLE supplier_product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    product_variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    supplier_sku TEXT CHECK (char_length(supplier_sku) <= 100),
    cost_price NUMERIC(14, 2) CHECK (cost_price >= 0),
    is_primary BOOLEAN NOT NULL DEFAULT false,
    updated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE (supplier_id, product_variant_id)    
);

CREATE INDEX idx_supplier_variants_variant_id ON supplier_product_variants(product_variant_id);
CREATE UNIQUE INDEX idx_variant_primary_supplier
    ON supplier_product_variants(product_variant_id)
    WHERE is_primary;