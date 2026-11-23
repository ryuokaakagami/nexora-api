CREATE TABLE stock_movements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    supplier_id UUID REFERENCES suppliers(id) ON DELETE RESTRICT,
    movement_type TEXT NOT NULL CHECK (movement_type IN ('in', 'out', 'adjustment')),
    quantity_change NUMERIC(12, 3) NOT NULL CHECK (quantity_change <> 0),
    stock_before NUMERIC(12, 3) NOT NULL CHECK (stock_before >= 0),
    stock_after NUMERIC(12, 3) NOT NULL CHECK (stock_after >= 0),
    reference_code TEXT CHECK (char_length(reference_code) <= 100),
    note TEXT CHECK (char_length(note) <= 500),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT chk_movement_sign CHECK (
        (movement_type = 'in' AND quantity_change > 0)
        OR (movement_type = 'out' AND quantity_change < 0)
        OR (movement_type = 'adjustment' AND quantity_change <> 0)
    ),
    CONSTRAINT chk_stock_math CHECK (stock_before + quantity_change = stock_after)
);

CREATE INDEX idx_stock_movements_variant_id ON stock_movements(product_variant_id);
CREATE INDEX idx_stock_movements_supplier_id ON stock_movements(supplier_id);
CREATE INDEX idx_stock_movements_created_at ON stock_movements(created_at DESC);