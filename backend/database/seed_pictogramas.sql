-- database/seed_pictogramas.sql
INSERT INTO pictogramas (nombre, codigo_ghs, imagen_url) VALUES
    ('Explosivo',                         'GHS01', '/pictogramas/ghs01.svg'),
    ('Inflamable',                        'GHS02', '/pictogramas/ghs02.svg'),
    ('Comburente',                        'GHS03', '/pictogramas/ghs03.svg'),
    ('Gases a presión',                   'GHS04', '/pictogramas/ghs04.svg'),
    ('Corrosivo',                         'GHS05', '/pictogramas/ghs05.svg'),
    ('Tóxico agudo',                      'GHS06', '/pictogramas/ghs06.svg'),
    ('Nocivo / Irritante',                'GHS07', '/pictogramas/ghs07.svg'),
    ('Peligro para la salud',             'GHS08', '/pictogramas/ghs08.svg'),
    ('Peligroso para el medio ambiente',  'GHS09', '/pictogramas/ghs09.svg')
ON CONFLICT (codigo_ghs) DO NOTHING;