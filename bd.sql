-- Eliminación de tablas existentes (en el orden correcto para evitar problemas de claves foráneas)
DROP TABLE IF EXISTS Recetas_Menus;
DROP TABLE IF EXISTS Ingredientes;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Menus;
DROP TABLE IF EXISTS Recetas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Subcategorias;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Supercategorias;
DROP TABLE IF EXISTS Usuarios;
-- Creación de tablas
CREATE TABLE Usuarios (
     usuario_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     correo VARCHAR(255) UNIQUE NOT NULL,
     contraseña VARCHAR(255) NOT NULL,
     fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     rol VARCHAR(50) CHECK (
          rol IN ('administrador', 'usuario')
     ) DEFAULT 'usuario'
);
CREATE TABLE Categorias (
     categoria_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL
);
CREATE TABLE Subcategorias (
     subcategoria_id SERIAL PRIMARY KEY,
     categoria_id INT NOT NULL,
     nombre VARCHAR(255) NOT NULL,
     FOREIGN KEY (categoria_id) REFERENCES Categorias (categoria_id)
);
CREATE TABLE Productos (
     producto_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     marca VARCHAR(50),
     descripcion TEXT,
     categoria_id INT,
     subcategoria_id INT,
     unidad_medida VARCHAR(50),
     precio NUMERIC(10, 2),
     foto VARCHAR(255),
     FOREIGN KEY (categoria_id) REFERENCES Categorias (categoria_id),
     FOREIGN KEY (subcategoria_id) REFERENCES Subcategorias (subcategoria_id)
);
CREATE TABLE Stock (
     stock_id SERIAL PRIMARY KEY,
     producto_id INT NOT NULL,
     cantidad_disponible NUMERIC(10, 2),
     fecha_actualizacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (producto_id) REFERENCES Productos (producto_id)
);
CREATE TABLE Recetas (
     receta_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     descripcion TEXT,
     usuario_id INT NOT NULL,
     fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (usuario_id) REFERENCES Usuarios (usuario_id)
);
CREATE TABLE Ingredientes (
     ingrediente_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     receta_id INT NOT NULL,
     producto_id INT NOT NULL,
     cantidad_requerida VARCHAR(255) NOT NULL,
     FOREIGN KEY (receta_id) REFERENCES Recetas (receta_id),
     FOREIGN KEY (producto_id) REFERENCES Productos (producto_id)
);
CREATE TABLE Menus (
     menu_id SERIAL PRIMARY KEY,
     nombre VARCHAR(255) NOT NULL,
     descripcion TEXT,
     usuario_id INT NOT NULL,
     fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (usuario_id) REFERENCES Usuarios (usuario_id)
);
CREATE TABLE Recetas_Menus (
     receta_menu_id SERIAL PRIMARY KEY,
     menu_id INT NOT NULL,
     receta_id INT NOT NULL,
     FOREIGN KEY (menu_id) REFERENCES Menus (menu_id),
     FOREIGN KEY (receta_id) REFERENCES Recetas (receta_id)
);
-- Índices opcionales para mejorar el rendimiento de búsqueda
CREATE INDEX idx_usuarios_correo ON Usuarios (correo);
CREATE INDEX idx_productos_nombre ON Productos (nombre);
CREATE INDEX idx_recetas_nombre ON Recetas (nombre);
CREATE INDEX idx_menus_nombre ON Menus (nombre);
-- Funciones y triggers para gestionar actualizaciones automáticas en Stock (opcional)
CREATE OR REPLACE FUNCTION actualizar_fecha_actualizacion() RETURNS TRIGGER AS $$ BEGIN NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trigger_actualizar_fecha_actualizacion BEFORE
UPDATE ON Stock FOR EACH ROW EXECUTE FUNCTION actualizar_fecha_actualizacion ();

ALTER TABLE Usuarios
ADD tipo_usuario VARCHAR(20) CHECK (
          tipo_usuario IN (
               'free',
               'premium',
               'sin_anuncios'
          )
     ) DEFAULT 'free';
ALTER TABLE Recetas
ADD foto VARCHAR(255);

INSERT INTO Usuarios (
          nombre,
          correo,
          contraseña,
          rol,
          tipo_usuario
     )
VALUES (
          'admin',
          'admin@stock.stir.com',
          'admin',
          'administrador',
          'premium'
     );
-- Insertar supercategorías
INSERT INTO Categorias (nombre)
VALUES ('Fruta y verdura'),
     ('Marisco y pescado'),
     ('Carne'),
     ('Charcutería y quesos'),
     ('Panadería y pastelería'),
     ('Huevos, leche y mantequilla'),
     ('Cereales y galletas'),
     ('Cacao, café e infusiones'),
     ('Azúcar, caramelos y chocolate'),
     ('Zumos'),
     ('Postres y yogures'),
     ('Aceite, especias y salsas'),
     ('Arroz, legumbres y pasta'),
     ('Conservas, caldos y cremas'),
     ('Aperitivos'),
     ('Pizzas y platos preparados'),
     ('Congelados'),
     ('Agua y refrescos'),
     ('Bodega'),
     ('Cuidado facial y corporal'),
     ('Cuidado del cabello'),
     ('Maquillaje'),
     ('Fitoterapia y parafarmacia'),
     ('Bebé'),
     ('Mascotas'),
     ('Limpieza y hogar');
-- Insertar categorías
INSERT INTO Subcategorias (nombre, categoria_id)
VALUES ('Fruta', 1),
     (
          'Lechuga y ensalada preparada',
          1
     ),
     ('Verdura', 1),
     ('Pescado fresco', 2),
     ('Marisco', 2),
     ('Pescado en bandeja', 2),
     ('Pescado congelado', 2),
     ('Salazones y ahumados', 2),
     ('Sushi', 2),
     ('Cerdo', 3),
     ('Aves y pollo', 3),
     ('Vacuno', 3),
     ('Conejo y cordero', 3),
     ('Embutido', 4),
     (
          'Hamburguesas y carne picada',
          3
     ),
     ('Empanados y elaborados', 3),
     ('Arreglos', 3),
     ('Carne congelada', 3),
     ('Aves y jamón cocido', 4),
     ('Chopped y mortadela', 4),
     ('Jamón serrano', 4),
     ('Embutido curado', 4),
     ('Bacón y salchichas', 4),
     ('Queso untable y fresco', 4),
     (
          'Queso curado, semicurado y tierno',
          4
     ),
     (
          'Queso lonchas, rallado y en porciones',
          4
     ),
     ('Paté y sobrasada', 4),
     ('Pan de horno', 5),
     (
          'Pan de molde y otras especialidades',
          5
     ),
     ('Pan tostado y rallado', 5),
     (
          'Picos, rosquilletas y picatostes',
          5
     ),
     ('Bollería de horno', 5),
     ('Bollería envasada', 5),
     ('Tartas y pasteles', 5),
     (
          'Harina y preparado repostería',
          5
     ),
     ('Velas y decoración', 5),
     (
          'Leche y bebidas vegetales',
          6
     ),
     ('Mantequilla y margarina', 6),
     ('Huevos', 6),
     ('Cereales', 7),
     ('Tortitas', 7),
     ('Galletas', 7),
     ('Café cápsula y monodosis', 8),
     ('Café molido y en grano', 8),
     (
          'Café soluble y otras bebidas',
          8
     ),
     (
          'Cacao soluble y chocolate a la taza',
          8
     ),
     ('Té e infusiones', 8),
     ('Azúcar y edulcorante', 9),
     ('Mermelada y miel', 9),
     ('Chocolate', 9),
     ('Chicles y caramelos', 9),
     ('Golosinas', 9),
     ('Tomate y otros sabores', 10),
     ('Fruta variada', 10),
     ('Melocotón y piña', 10),
     ('Naranja', 10),
     ('Yogures desnatados', 11),
     (
          'Yogures naturales y sabores',
          11
     ),
     ('Yogures bífidus', 11),
     ('Yogures de soja', 11),
     (
          'Yogures y postres infantiles',
          11
     ),
     ('Yogures líquidos', 11),
     ('Yogures griegos', 11),
     ('Flan y natillas', 11),
     (
          'Gelatina y otros postres',
          11
     ),
     ('Aceite, vinagre y sal', 12),
     ('Especias', 12),
     (
          'Mayonesa, ketchup y mostaza',
          12
     ),
     ('Otras salsas', 12),
     ('Arroz', 13),
     ('Pasta y fideos', 13),
     ('Legumbres', 13),
     (
          'Atún y otras conservas de pescado',
          14
     ),
     (
          'Berberechos y mejillones',
          14
     ),
     ('Tomate', 14),
     (
          'Conservas de verdura y frutas',
          14
     ),
     ('Sopa y caldo', 14),
     ('Gazpacho y cremas', 14),
     ('Patatas fritas y snacks', 15),
     (
          'Frutos secos y fruta desecada',
          15
     ),
     ('Aceitunas y encurtidos', 15),
     ('Pizzas', 16),
     (
          'Platos preparados calientes',
          16
     ),
     ('Platos preparados fríos', 16),
     ('Verdura', 17),
     ('Arroz y pasta', 17),
     ('Carne', 17),
     ('Pescado', 17),
     ('Marisco', 17),
     ('Pizzas', 17),
     ('Tartas y churros', 17),
     ('Helados', 17),
     ('Hielo', 17),
     ('Agua', 18),
     ('Refresco de cola', 18),
     (
          'Refresco de naranja y de limón',
          18
     ),
     ('Tónica y bitter', 18),
     (
          'Refresco de té y sin gas',
          18
     ),
     ('Isotónico y energético', 18),
     ('Cerveza', 19),
     ('Cerveza sin alcohol', 19),
     (
          'Tinto de verano y sangría',
          19
     ),
     ('Vino tinto', 19),
     ('Vino blanco', 19),
     ('Vino rosado', 19),
     (
          'Vino lambrusco y espumoso',
          19
     ),
     ('Sidra y cava', 19),
     ('Licores', 19),
     (
          'Cuidado e higiene facial',
          20
     ),
     ('Higiene bucal', 20),
     ('Gel y jabón de manos', 20),
     ('Desodorante', 20),
     ('Cuidado corporal', 20),
     ('Higiene íntima', 20),
     ('Depilación', 20),
     (
          'Afeitado y cuidado para hombre',
          20
     ),
     ('Manicura y pedicura', 20),
     ('Perfume y colonia', 20),
     (
          'Protector solar y aftersun',
          20
     ),
     ('Neceseres', 20),
     ('Champú', 21),
     (
          'Acondicionador y mascarilla',
          21
     ),
     ('Fijación cabello', 21),
     ('Coloración cabello', 21),
     ('Peines y accesorios', 21),
     (
          'Bases de maquillaje y corrector',
          22
     ),
     ('Colorete y polvos', 22),
     ('Labios', 22),
     ('Ojos', 22),
     ('Pinceles y brochas', 22),
     ('Fitoterapia', 23),
     ('Parafarmacia', 23),
     ('Alimentación infantil', 24),
     ('Toallitas y pañales', 24),
     ('Higiene y cuidado', 24),
     (
          'Biberón, chupete y menaje',
          24
     ),
     ('Perro', 25),
     ('Gato', 25),
     ('Pez y otros', 25),
     (
          'Detergente y suavizante ropa',
          26
     ),
     ('Limpieza vajilla', 26),
     ('Limpieza cocina', 26),
     ('Limpieza baño y WC', 26),
     (
          'Limpieza muebles y multiusos',
          26
     ),
     (
          'Limpiahogar y fregasuelos',
          26
     ),
     (
          'Lejía y líquidos fuertes',
          26
     ),
     ('Limpiacristales', 26),
     (
          'Estropajo, bayeta y guantes',
          26
     ),
     (
          'Papel higiénico y celulosa',
          26
     ),
     (
          'Pilas y bolsas de basura',
          26
     ),
     (
          'Insecticida y ambientador',
          26
     ),
     (
          'Menaje y conservación de alimentos',
          26
     ),
     (
          'Utensilios de limpieza y calzado',
          26
     );
INSERT INTO Productos (
          nombre,
          marca,
          descripcion,
          categoria_id,
          subcategoria_id,
          unidad_medida,
          precio,
          foto
     )
VALUES (
          'Aceite de oliva 0,4º',
          'Hacendado',
          'Aceite de oliva suave ideal para ensaladas',
          12,
          66,
          'Litro',
          8.00,
          'https://prod-mercadona.imgix.net/images/1a84cd7052b68873985104ac24b87043.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen extra',
          'Hacendado',
          'Aceite de oliva virgen extra de alta calidad',
          12,
          66,
          'Litro',
          29.55,
          'https://prod-mercadona.imgix.net/images/c6ce7821078acb0f45c45ef2b36ee4c6.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen extra',
          'Hacendado',
          'Aceite de oliva virgen extra con un sabor intenso',
          12,
          66,
          'Litro',
          9.90,
          'https://prod-mercadona.imgix.net/images/bed0b39f9e3a67b1f6bfb8f4f04e5694.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen extra Gran Selección',
          'Hacendado',
          'Aceite de oliva virgen extra de selección especial',
          12,
          66,
          'Litro',
          8.10,
          'https://prod-mercadona.imgix.net/images/ca971ebf519d62b535e1d0ad05ebd394.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva 1º',
          'Hacendado',
          'Aceite de oliva con una acidez del 1%',
          12,
          66,
          'Litro',
          8.00,
          'https://prod-mercadona.imgix.net/images/b57ae00beedb23ec86686fa3651fd448.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen',
          'Hacendado',
          'Aceite de oliva virgen ideal para cocina y ensaladas',
          12,
          66,
          'Litro',
          26.30,
          'https://prod-mercadona.imgix.net/images/e58a263f9514576e38a96724b3104f9b.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen',
          'Hacendado',
          'Aceite de oliva virgen de sabor suave',
          12,
          66,
          'Litro',
          8.95,
          'https://prod-mercadona.imgix.net/images/7a14986c6a536dcd485b8bb8b8e24e33.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva suave',
          'Hacendado',
          'Aceite de oliva con sabor suave',
          12,
          66,
          'Litro',
          23.90,
          'https://prod-mercadona.imgix.net/images/617bf49db3b4f79f5e311007e8cee4ab.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva intenso',
          'Hacendado',
          'Aceite de oliva con sabor intenso',
          12,
          66,
          'Litro',
          23.90,
          'https://prod-mercadona.imgix.net/images/bbfe2ec5cc49633c1e2d9988feb58932.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen extra',
          'Hacendado',
          'Aceite de oliva virgen extra de gran calidad',
          12,
          66,
          '500 ml',
          3.30,
          'https://prod-mercadona.imgix.net/images/2dd497b89f607de5efde08d7b1585888.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de oliva virgen extra Picual',
          'Casa Juncal',
          'Aceite de oliva virgen extra variedad Picual',
          12,
          66,
          '500 ml',
          7.85,
          'https://prod-mercadona.imgix.net/images/57c541a2fdb98be59dd3c91185658181.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de girasol refinado 0,2º',
          'Hacendado',
          'Aceite de girasol refinado con baja acidez',
          12,
          66,
          'Litro',
          6.75,
          'https://prod-mercadona.imgix.net/images/8c16a9c5fe8126141815ce55e50cbcba.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de girasol refinado 0,2º',
          'Hacendado',
          'Aceite de girasol refinado de alta calidad',
          12,
          66,
          '500 ml',
          1.45,
          'https://prod-mercadona.imgix.net/images/38334513c2db1608117eb6c2759439f2.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Aceite de coco virgen',
          'Hacendado',
          'Aceite de coco virgen ideal para cocina y cosmética',
          12,
          66,
          '500 ml',
          4.40,
          'https://prod-mercadona.imgix.net/images/4b73d0063a13ed91219d84e7dd70d22d.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Vinagre de vino blanco',
          'Hacendado',
          'Vinagre de vino blanco ideal para ensaladas',
          12,
          66,
          '500 ml',
          0.70,
          'https://prod-mercadona.imgix.net/images/998aae3f62fda2b1e90ecd4e835357e3.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Vinagre de manzana',
          'Hacendado',
          'Vinagre de manzana de alta calidad',
          12,
          66,
          '500 ml',
          0.85,
          'https://prod-mercadona.imgix.net/images/98d5a34a0d30798bbdc520993f63e542.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Limón exprimido',
          'Hacendado',
          'Zumo de limón exprimido, listo para usar',
          12,
          66,
          '500 ml',
          1.00,
          'https://prod-mercadona.imgix.net/images/802d61bae30f424fa8315698f9f245db.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Crema de vinagre balsámico de Módena',
          'Hacendado',
          'Crema de vinagre balsámico con un toque dulce',
          12,
          66,
          '250 ml',
          1.75,
          'https://prod-mercadona.imgix.net/images/d23cb7535fe0a9e9e053713faff31b93.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Vinagre de Jerez reserva',
          'Hacendado',
          'Vinagre de Jerez reserva con sabor intenso',
          12,
          66,
          '250 ml',
          2.00,
          'https://prod-mercadona.imgix.net/images/bfa0c4aabf80adf4cd9a390df6aa7184.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Reducción de vinagre Pedro Ximénez',
          'Hacendado',
          'Reducción de vinagre con un toque dulce',
          12,
          66,
          '250 ml',
          2.25,
          'https://prod-mercadona.imgix.net/images/0f2f3566dedc310f8330782da97cff7b.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Vinagre balsámico de Módena',
          'Hacendado',
          'Vinagre balsámico de Módena con sabor equilibrado',
          12,
          66,
          '500 ml',
          2.45,
          'https://prod-mercadona.imgix.net/images/f65c196d0aae6388f9e6852c381f8da4.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal fina',
          'Hacendado',
          'Sal fina para uso diario en cocina',
          12,
          66,
          '1 kg',
          0.35,
          'https://prod-mercadona.imgix.net/images/5097b3d7450edab7c2d9586299f5f3b9.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal fina de mesa',
          'Hacendado',
          'Sal fina de mesa para uso diario',
          12,
          66,
          '1 kg',
          0.75,
          'https://prod-mercadona.imgix.net/images/14d233ae4aee44619f27e63caaed1f2e.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal yodada fina',
          'Hacendado',
          'Sal yodada fina para una dieta equilibrada',
          12,
          66,
          '1 kg',
          0.35,
          'https://prod-mercadona.imgix.net/images/409a53c0327dff2c4b91e6b4c58efa42.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal gruesa',
          'Hacendado',
          'Sal gruesa ideal para cocinar',
          12,
          66,
          '1 kg',
          0.35,
          'https://prod-mercadona.imgix.net/images/8b9798cc6f23201e8191711f58368727.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Bicarbonato sódico',
          'Hacendado',
          'Bicarbonato sódico para uso en cocina y limpieza',
          12,
          66,
          '500 g',
          1.50,
          'https://prod-mercadona.imgix.net/images/ed1ebfa8c76af67dc21a385de31fc778.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Bicarbonato sódico',
          'Hacendado',
          'Bicarbonato sódico para repostería y limpieza',
          12,
          66,
          '500 g',
          1.10,
          'https://prod-mercadona.imgix.net/images/c7cd20b0038ee22bb7678fbebc26df3f.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal marina en escamas',
          'Polasal',
          'Sal marina en escamas para condimentar platos',
          12,
          66,
          '250 g',
          2.00,
          'https://prod-mercadona.imgix.net/images/36bc3658a807997961ec5fda23dd948e.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal gruesa para hornear',
          'Hacendado',
          'Sal gruesa especial para hornear',
          12,
          66,
          '1 kg',
          1.10,
          'https://prod-mercadona.imgix.net/images/c46d67d22d1cf40d537ab349322b8da2.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal de ajo',
          'Hacendado',
          'Sal de ajo para condimentar platos',
          12,
          66,
          '250 g',
          1.80,
          'https://prod-mercadona.imgix.net/images/bd81680a3655bf89428f333254f34979.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal de frutas sabor limón',
          'Hacendado',
          'Sal de frutas con sabor a limón',
          12,
          66,
          '250 g',
          2.10,
          'https://prod-mercadona.imgix.net/images/5ba4d62436d14a7cc28378beb8629a46.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal 60% menos de sodio',
          'Hacendado',
          'Sal con 60% menos de sodio para una dieta saludable',
          12,
          66,
          '1 kg',
          2.30,
          'https://prod-mercadona.imgix.net/images/94a6e7709ae88d33abaf61dc7bfaec2a.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Preparado para salmón ahumado',
          'Hacendado',
          'Preparado especial para salmón ahumado',
          12,
          66,
          '250 g',
          3.30,
          'https://prod-mercadona.imgix.net/images/029c3c8e49b1d8f5bccae5a4c6283d47.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal rosa del Himalaya',
          'Hacendado',
          'Sal rosa del Himalaya para condimentar',
          12,
          66,
          '500 g',
          1.90,
          'https://prod-mercadona.imgix.net/images/e19be1d4b1c08ca7c7f65dc62a34cd74.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Orégano',
          'Hacendado',
          'Hojas secas de orégano, ideales para sazonar pizzas y platos italianos.',
          1,
          1,
          '25g',
          0.95,
          'https://prod-mercadona.imgix.net/images/20a564cf97b2b9662bb7727d6008ed69.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Perejil',
          'Hacendado',
          'Perejil seco en hojas, perfecto para guisos y ensaladas.',
          1,
          1,
          '20g',
          0.90,
          'https://prod-mercadona.imgix.net/images/b2bc740ba01dd6f5b0c62f44a5557dee.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Hoja de laurel',
          'Hacendado',
          'Hojas de laurel secas, ideales para sopas y estofados.',
          1,
          1,
          '15g',
          0.80,
          'https://prod-mercadona.imgix.net/images/34e7ea3d2a5df1817f89cecadea1e462.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Hierbas provenzales',
          'Hacendado',
          'Mezcla de hierbas aromáticas típicas de la Provenza francesa.',
          1,
          1,
          '30g',
          1.20,
          'https://prod-mercadona.imgix.net/images/75ea233839587117b294f2d15027f57a.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Albahaca',
          'Hacendado',
          'Hojas secas de albahaca, perfectas para salsas y platos mediterráneos.',
          1,
          1,
          '25g',
          1.25,
          'https://prod-mercadona.imgix.net/images/666740b544111126529a014431ba81f4.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Romero',
          'Hacendado',
          'Romero seco, ideal para carnes y guisos.',
          1,
          1,
          '30g',
          1.35,
          'https://prod-mercadona.imgix.net/images/d5b59c36668ad99469b2c16a3d90fad7.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Tomillo',
          'Hacendado',
          'Tomillo seco, perfecto para adobar carnes y verduras.',
          1,
          1,
          '25g',
          1.05,
          'https://prod-mercadona.imgix.net/images/23cda8ba2719d64662af5acde3485411.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Eneldo',
          'Hacendado',
          'Eneldo seco, ideal para pescados y ensaladas.',
          1,
          1,
          '20g',
          1.85,
          'https://prod-mercadona.imgix.net/images/aa7bf59873bb1c4e11267001b37e8632.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Cilantro',
          'Hacendado',
          'Hojas de cilantro secas, perfectas para platos asiáticos y mexicanos.',
          1,
          1,
          '20g',
          1.85,
          'https://prod-mercadona.imgix.net/images/27379a6a13ab30cfb594a4b326f1f66c.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Ajo y Perejil',
          'Hacendado',
          'Mezcla de ajo y perejil secos, ideal para carnes y pescados.',
          1,
          1,
          '25g',
          1.35,
          'https://prod-mercadona.imgix.net/images/87354ac95bb1960b3cdab6dc5e632bb4.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Colorante alimentario',
          'Hacendado',
          'Colorante en polvo para dar color a tus platos.',
          1,
          1,
          '10g',
          0.90,
          'https://prod-mercadona.imgix.net/images/279afe277bed6a3c1af998dbda9b66e7.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimentón dulce',
          'Hacendado',
          'Pimentón dulce, perfecto para paellas y guisos.',
          1,
          1,
          '75g',
          1.00,
          'https://prod-mercadona.imgix.net/images/d01141fdec8c11a291e21f084d94f43c.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimentón dulce',
          'Hacendado',
          'Pimentón dulce, perfecto para paellas y guisos.',
          1,
          1,
          '100g',
          1.40,
          'https://prod-mercadona.imgix.net/images/f36ba84f3f573b9dd2c12d3ba617df4c.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimentón dulce de la Vera',
          'Hacendado',
          'Pimentón dulce de la Vera, con un sabor ahumado único.',
          1,
          1,
          '75g',
          1.75,
          'https://prod-mercadona.imgix.net/images/fc6f52e3aa7435cc0e851a43697e8b06.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Azafrán molido',
          'Hacendado',
          'Azafrán molido, ideal para dar color y sabor a tus platos.',
          1,
          1,
          '1g',
          1.75,
          'https://prod-mercadona.imgix.net/images/d79e295f90865210d4a83792f316b66a.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Azafrán hebra',
          'Hacendado',
          'Hebras de azafrán, para un sabor y color intensos.',
          1,
          1,
          '1g',
          1.70,
          'https://prod-mercadona.imgix.net/images/6b28a5275722bf42ecd58cac70a7497f.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimentón picante',
          'Hacendado',
          'Pimentón picante, perfecto para dar un toque picante a tus platos.',
          1,
          1,
          '75g',
          1.35,
          'https://prod-mercadona.imgix.net/images/2f865dc2dc829da4a0e2962fb922cd9c.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimienta negra molida',
          'Hacendado',
          'Pimienta negra molida, ideal para sazonar cualquier plato.',
          1,
          1,
          '50g',
          1.05,
          'https://prod-mercadona.imgix.net/images/905e76fd8f59b3931ae5e2c586c4a9f5.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Molinillo pimienta negra',
          'Hacendado',
          'Pimienta negra en molinillo, para un sabor fresco y aromático.',
          1,
          1,
          '50g',
          1.65,
          'https://prod-mercadona.imgix.net/images/ff80991c845784c85981a779586661c9.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimienta negra en grano',
          'Hacendado',
          'Pimienta negra en grano, perfecta para moler al momento.',
          1,
          1,
          '50g',
          1.45,
          'https://prod-mercadona.imgix.net/images/ade2f829444a465f07de05c97b526258.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Molinillo mix pimientas',
          'Hacendado',
          'Mezcla de pimientas en molinillo, ideal para dar un toque especial a tus platos.',
          1,
          1,
          '50g',
          1.85,
          'https://prod-mercadona.imgix.net/images/16d512e03ea3f4513a43a085403cba3f.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Pimienta blanca molida',
          'Hacendado',
          'Pimienta blanca molida, ideal para salsas y platos claros.',
          1,
          1,
          '50g',
          2.15,
          'https://prod-mercadona.imgix.net/images/a8cedadb6026482169a838838a6943d3.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Ajo granulado',
          'Hacendado',
          'Ajo granulado, perfecto para sazonar cualquier plato.',
          1,
          1,
          '70g',
          1.10,
          'https://prod-mercadona.imgix.net/images/10f7ce7fe35de8f5b595db38a95a9cc5.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Cebolla frita crujiente',
          'Hacendado',
          'Cebolla frita crujiente, ideal para ensaladas y platos asiáticos.',
          1,
          1,
          '150g',
          1.15,
          'https://prod-mercadona.imgix.net/images/fb2e63195fc20b44ae5f3598c40a7565.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Canela molida',
          'Hacendado',
          'Canela molida, perfecta para postres y bebidas.',
          1,
          1,
          '40g',
          0.95,
          'https://prod-mercadona.imgix.net/images/22948761cf10a9f149a06ec505fb8dcd.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Canela en rama',
          'Hacendado',
          'Ramas de canela, ideales para infusiones y postres.',
          1,
          1,
          '30g',
          1.45,
          'https://prod-mercadona.imgix.net/images/79a95af1248f3f9e5f0a5fab40e06adf.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Comino molido',
          'Hacendado',
          'Comino molido, perfecto para guisos y platos de curry.',
          1,
          1,
          '40g',
          1.20,
          'https://prod-mercadona.imgix.net/images/003c9821946990d15215928c180ec0b7.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Comino en grano',
          'Hacendado',
          'Comino en grano, ideal para tostados y sazonar platos.',
          1,
          1,
          '50g',
          1.95,
          'https://prod-mercadona.imgix.net/images/945a39457b8b947b612650a22e7a2c71.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Curry',
          'Hacendado',
          'Mezcla de especias de curry, ideal para platos indios.',
          1,
          1,
          '45g',
          1.15,
          'https://prod-mercadona.imgix.net/images/41e788d61332bbabe67bcb18c9b74d9e.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Nuez moscada molida',
          'Hacendado',
          'Nuez moscada molida, perfecta para salsas y repostería.',
          1,
          1,
          '40g',
          1.65,
          'https://prod-mercadona.imgix.net/images/26a3c69f637bdb1722940dbaa79f6cf9.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Cebolla en polvo',
          'Hacendado',
          'Cebolla en polvo, ideal para sazonar cualquier plato.',
          1,
          1,
          '50g',
          0.96,
          'https://prod-mercadona.imgix.net/images/4e60df323518b37ef8fcc6be6103526e.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Cayena guindillas',
          'Hacendado',
          'Guindillas de cayena secas, perfectas para dar un toque picante.',
          1,
          1,
          '20g',
          1.30,
          'https://prod-mercadona.imgix.net/images/ca1ef5080300ea3323d59f0911f471db.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Cayena molida',
          'Hacendado',
          'Cayena molida, ideal para platos que requieren un toque picante.',
          1,
          1,
          '30g',
          1.59,
          'https://prod-mercadona.imgix.net/images/e0224e197ff6535f418d187efc499d56.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Cúrcuma',
          'Hacendado',
          'Cúrcuma molida, perfecta para curry y platos orientales.',
          1,
          1,
          '45g',
          1.25,
          'https://prod-mercadona.imgix.net/images/bbb23780061cfd84ea7c8b8890715380.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Jengibre molido',
          'Hacendado',
          'Jengibre molido, ideal para repostería y platos asiáticos.',
          1,
          1,
          '40g',
          1.65,
          'https://prod-mercadona.imgix.net/images/660b9d830317ff63daa0a5a5cfe4cdb2.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sal de ajo',
          'Hacendado',
          'Sal con ajo granulado, perfecta para carnes y salsas.',
          1,
          1,
          '100g',
          1.80,
          'https://prod-mercadona.imgix.net/images/bd81680a3655bf89428f333254f34979.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Ñoras',
          'Hacendado',
          'Pimientos ñoras secas, ideales para guisos y arroces.',
          1,
          1,
          '30g',
          1.40,
          'https://prod-mercadona.imgix.net/images/4e524d80be3b75f95866a26e9f551356.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Clavo en grano',
          'Hacendado',
          'Clavos de olor en grano, perfectos para postres y guisos.',
          1,
          1,
          '30g',
          1.75,
          'https://prod-mercadona.imgix.net/images/4454375471a75b1e36fe451869e79460.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Piñones',
          'Hacendado',
          'Piñones, ideales para repostería y ensaladas.',
          1,
          1,
          '100g',
          2.84,
          'https://prod-mercadona.imgix.net/images/9c0850bc2d27b4cbc067afbaae2dbf2f.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador para fajitas',
          'Hacendado',
          'Mezcla de especias estilo tex-mex, ideal para fajitas.',
          1,
          1,
          '30g',
          0.85,
          'https://prod-mercadona.imgix.net/images/b1fce5f5cf683e62606320f3f63fb426.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador ajo y limón',
          'Hacendado',
          'Mezcla de ajo y limón para sazonar carne y pescado.',
          1,
          1,
          '35g',
          1.05,
          'https://prod-mercadona.imgix.net/images/1c4d5344d0afaa6198d071ad0e2aa5ae.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador hierbas provenzales',
          'Hacendado',
          'Mezcla de hierbas provenzales para pollo y costillas.',
          1,
          1,
          '30g',
          1.00,
          'https://prod-mercadona.imgix.net/images/5f70b8323c4c746222517fe9b1da3b9c.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador sabor barbacoa',
          'Hacendado',
          'Sazonador con sabor a barbacoa para carnes.',
          1,
          1,
          '35g',
          1.35,
          'https://prod-mercadona.imgix.net/images/43dc9ccbba36855392ce7b3e45f7988b.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador para paella con azafrán',
          'Hacendado',
          'Mezcla de especias con azafrán para paellas.',
          1,
          1,
          '30g',
          1.45,
          'https://prod-mercadona.imgix.net/images/f2cdac44f287c5a2b6d89b51d091ad3e.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador para burritos',
          'Hacendado',
          'Mezcla de especias para burritos.',
          1,
          1,
          '35g',
          1.30,
          'https://prod-mercadona.imgix.net/images/e3b68afcc598d5b7e99ec15eaeab9aed.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador pollo y carne',
          'Hacendado',
          'Mezcla de especias para sazonar pollo y carne.',
          1,
          1,
          '50g',
          1.50,
          'https://prod-mercadona.imgix.net/images/7f9510b3a329bea5703ba49e7d62b470.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador pasta',
          'Hacendado',
          'Mezcla de especias para pasta.',
          1,
          1,
          '45g',
          1.60,
          'https://prod-mercadona.imgix.net/images/45eeee3ab3e380f3e0892e61e724bec8.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Mezcla de especias para gazpacho manchego',
          'Hacendado',
          'Mezcla de especias para gazpacho manchego.',
          1,
          1,
          '50g',
          2.50,
          'https://prod-mercadona.imgix.net/images/1da0d4f205b99554f8c4e5d9b00a82a8.jpg?fit=crop&h=300&w=300'
     ),
     (
          'Sazonador sabor queso y bacon',
          'Hacendado',
          'Mezcla de sabor queso y bacon para patatas, snacks, carnes y salsas.',
          1,
          1,
          '40g',
          0.85,
          'https://prod-mercadona.imgix.net/images/980661ae979311a93a905291553f20ff.jpg?fit=crop&h=300&w=300'
     );
-- Recetas centradas en proteínas:
-- Pollo al horno con verduras
INSERT INTO Recetas (
          nombre,
          descripcion,
          usuario_id
     )
VALUES (
          'Pollo al horno con verduras',
          'Deliciosa receta de pollo al horno acompañado de una variedad de verduras asadas.',
          1
     );
INSERT INTO Ingredientes (
          nombre,
          receta_id,
          producto_id,
          cantidad_requerida
     )
VALUES (
          'Pechugas de pollo',
          1,
          1,
          '4 unidades'
     ),
     (
          'Verduras variadas',
          1,
          2,
          '1 kilo'
     ),
     (
          'Aceite de oliva',
          1,
          3,
          '2 cucharadas'
     ),
     (
          'Sal y pimienta',
          1,
          4,
          '0.5 cucharaditas'
     );
-- Salmón a la plancha con quinoa
INSERT INTO Recetas (
          nombre,
          descripcion,
          usuario_id
     )
VALUES (
          'Salmón a la plancha con quinoa',
          'Sabroso filete de salmón cocido a la plancha servido sobre una cama de quinoa.',
          1
     );
INSERT INTO Ingredientes (
          nombre,
          receta_id,
          producto_id,
          cantidad_requerida
     )
VALUES (
          'Filetes de salmón',
          2,
          5,
          '2 unidades'
     ),
     ('Quinoa', 2, 6, '1 taza'),
     (
          'Caldo de verduras',
          2,
          7,
          '0.5 litros'
     ),
     ('Limón', 2, 8, '1 unidad');
-- Recetas centradas en carbohidratos:
-- Pasta Alfredo con champiñones
INSERT INTO Recetas (
          nombre,
          descripcion,
          usuario_id
     )
VALUES (
          'Pasta Alfredo con champiñones',
          'Plato de pasta cremosa con salsa Alfredo y champiñones salteados.',
          1
     );
INSERT INTO Ingredientes (
          nombre,
          receta_id,
          producto_id,
          cantidad_requerida
     )
VALUES ('Pasta', 3, 9, '0.5 kilos'),
     (
          'Champiñones',
          3,
          10,
          '1 bandeja'
     ),
     (
          'Crema de leche',
          3,
          11,
          '1 taza'
     ),
     ('Ajo', 3, 12, '2 dientes'),
     (
          'Queso parmesano',
          3,
          13,
          '0.5 taza'
     );
-- Arroz con pollo
INSERT INTO Recetas (
          nombre,
          descripcion,
          usuario_id
     )
VALUES (
          'Arroz con pollo',
          'Clásico plato de arroz cocido con pollo y verduras.',
          1
     );
INSERT INTO Ingredientes (
          nombre,
          receta_id,
          producto_id,
          cantidad_requerida
     )
VALUES ('Arroz', 4, 14, '1 taza'),
     (
          'Pechugas de pollo',
          4,
          1,
          '2 unidades'
     ),
     ('Verduras', 4, 3, '0.5 kilos'),
     (
          'Caldo de pollo',
          4,
          15,
          '1 litro'
     ),
     ('Ajo', 4, 16, '2 dientes');
-- Recetas generales:
-- Ensalada César
INSERT INTO Recetas (
          nombre,
          descripcion,
          usuario_id
     )
VALUES (
          'Ensalada César',
          'Ensalada clásica con lechuga romana, pollo a la parrilla, croutones y aderezo César.',
          1
     );
INSERT INTO Ingredientes (
          nombre,
          receta_id,
          producto_id,
          cantidad_requerida
     )
VALUES (
          'Lechuga romana',
          5,
          17,
          '1 unidad'
     ),
     (
          'Pollo a la parrilla',
          5,
          1,
          '1 pechuga'
     ),
     (
          'Croutones',
          5,
          18,
          '0.5 taza'
     ),
     (
          'Queso parmesano',
          5,
          19,
          '0.25 taza'
     ),
     (
          'Aderezo César',
          5,
          20,
          '0.25 taza'
     );
-- Tortilla española
INSERT INTO Recetas (
          nombre,
          descripcion,
          usuario_id
     )
VALUES (
          'Tortilla española',
          'Clásica tortilla española hecha con papas, cebolla y huevos.',
          1
     );
INSERT INTO Ingredientes (
          nombre,
          receta_id,
          producto_id,
          cantidad_requerida
     )
VALUES ('Papas', 6, 21, '2 unidades'),
     ('Cebolla', 6, 22, '1 unidad'),
     ('Huevos', 6, 23, '1 unidad'),
     (
          'Aceite de oliva',
          6,
          24,
          '2 cucharadas'
     );
