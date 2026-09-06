-- database/schema.sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE usuarios (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre        VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    rol           VARCHAR(20) NOT NULL DEFAULT 'analista'
                  CHECK (rol IN ('admin', 'analista', 'auditor')),
    activo        BOOLEAN NOT NULL DEFAULT true,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE proveedores (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre     VARCHAR(150) NOT NULL,
    email      VARCHAR(150),
    telefono   VARCHAR(30),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE pictogramas (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre     VARCHAR(100) NOT NULL,
    codigo_ghs VARCHAR(20) UNIQUE NOT NULL,
    imagen_url TEXT
);

CREATE TABLE reactivos (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_interno        VARCHAR(50) UNIQUE NOT NULL,
    nombre                VARCHAR(200) NOT NULL,
    sinonimos             TEXT,
    cas                   VARCHAR(30),
    formula_molecular     VARCHAR(100),
    marca                 VARCHAR(100),
    proveedor_id          UUID REFERENCES proveedores(id),
    concentracion         VARCHAR(80),
    presentacion          VARCHAR(100),
    cantidad_inicial      NUMERIC(12,3) NOT NULL,
    cantidad_actual       NUMERIC(12,3) NOT NULL,
    unidad_medida         VARCHAR(10) NOT NULL
                          CHECK (unidad_medida IN ('L','mL','g','kg','mg','µg','µL','unidad')),
    lote                  VARCHAR(80),
    fecha_vencimiento     DATE,
    fecha_ingreso         DATE DEFAULT CURRENT_DATE,
    fecha_apertura        DATE,
    analista_apertura_id  UUID REFERENCES usuarios(id),
    estado                VARCHAR(20) NOT NULL DEFAULT 'en_inventario'
                          CHECK (estado IN ('en_uso','agotado','en_compra','en_inventario')),
    ubicacion             VARCHAR(100),
    almacenamiento        TEXT,
    peligrosidad          VARCHAR(100),
    numero_un             VARCHAR(20),
    tipo_residuo          VARCHAR(20)
                          CHECK (tipo_residuo IN ('acido','base','halogenado','organico','inorganico','especial')),
    ficha_seguridad_url   TEXT,
    es_controlado         BOOLEAN NOT NULL DEFAULT false,
    precio                NUMERIC(12,2),
    activo                BOOLEAN NOT NULL DEFAULT true,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE reactivo_pictogramas (
    reactivo_id   UUID NOT NULL REFERENCES reactivos(id) ON DELETE CASCADE,
    pictograma_id UUID NOT NULL REFERENCES pictogramas(id) ON DELETE CASCADE,
    PRIMARY KEY (reactivo_id, pictograma_id)
);

CREATE TABLE preparacion_soluciones (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre             VARCHAR(200) NOT NULL,
    descripcion        TEXT,
    volumen_final      NUMERIC(12,3),
    unidad_volumen     VARCHAR(10) NOT NULL DEFAULT 'mL'
                       CHECK (unidad_volumen IN ('L','mL','µL')),
    procedimiento      TEXT,
    observaciones      TEXT,
    fecha_preparacion  DATE DEFAULT CURRENT_DATE,
    fecha_vencimiento  DATE,
    responsable_id     UUID REFERENCES usuarios(id),
    estado             VARCHAR(20) NOT NULL DEFAULT 'activa'
                       CHECK (estado IN ('activa','vencida','descartada')),
    agua_tipo          VARCHAR(20) NOT NULL DEFAULT 'No Aplica'
                       CHECK (agua_tipo IN ('Destilada','Bidestilada','Desionizada','Ultrapura','No Aplica')),
    agua_lote          VARCHAR(100),
    agua_vencimiento   DATE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE preparacion_reactivos (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    preparacion_id UUID NOT NULL REFERENCES preparacion_soluciones(id) ON DELETE CASCADE,
    reactivo_id    UUID NOT NULL REFERENCES reactivos(id),
    cantidad       NUMERIC(12,3) NOT NULL,
    unidad         VARCHAR(10) NOT NULL
                   CHECK (unidad IN ('L','mL','µL','g','kg','mg','µg','unidad')),
    concentracion  VARCHAR(80),
    orden          INT,
    observacion    VARCHAR(300)
);

CREATE TABLE sicoq_consumos (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reactivo_id         UUID NOT NULL REFERENCES reactivos(id),
    responsable_id      UUID REFERENCES usuarios(id),
    nombre_responsable  VARCHAR(100) NOT NULL,
    cantidad            NUMERIC(12,3) NOT NULL,
    unidad              VARCHAR(10) NOT NULL
                        CHECK (unidad IN ('L','mL','µL','g','kg','mg','µg')),
    uso_descripcion     VARCHAR(500) NOT NULL,
    observaciones       VARCHAR(500),
    numero_acta         VARCHAR(50),
    fecha_consumo       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reactivos_updated_at
    BEFORE UPDATE ON reactivos
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_preparaciones_updated_at
    BEFORE UPDATE ON preparacion_soluciones
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE INDEX idx_reactivos_nombre ON reactivos (nombre);
CREATE INDEX idx_reactivos_cas ON reactivos (cas);
CREATE INDEX idx_reactivos_estado ON reactivos (estado);
CREATE INDEX idx_sicoq_fecha ON sicoq_consumos (fecha_consumo);
CREATE INDEX idx_preparaciones_estado ON preparacion_soluciones (estado);