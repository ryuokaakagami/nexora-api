CREATE TABLE supplier_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    job_title_id UUID NOT NULL REFERENCES job_titles(id) ON DELETE RESTRICT,
    name TEXT NOT NULL CHECK (char_length(name) BETWEEN 2 AND 255),
    phone TEXT CHECK (char_length(phone) <= 50),
    email TEXT CHECK (char_length(email) <= 255),
    is_primary BOOLEAN NOT NULL DEFAULT false,
    updated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT chk_contact_channel CHECK (
        (phone IS NOT NULL AND btrim(phone) <> '')
        OR (email IS NOT NULL AND btrim(email) <> '')
    )  
);

CREATE INDEX idx_supplier_contacts_supplier_id ON supplier_contacts(supplier_id);
CREATE INDEX idx_supplier_contacts_job_title_id ON supplier_contacts(job_title_id);

CREATE UNIQUE INDEX idx_supplier_primary_contact
    ON supplier_contacts(supplier_id)
    WHERE is_primary;