-- =============================================
-- ZYRA SHOP - Esquema Completo D1 (RESETEO TOTAL)
-- =============================================

-- Eliminar tablas existentes para evitar errores de "already exists"
DROP TABLE IF EXISTS pedido_items;
DROP TABLE IF EXISTS items_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS carrito;
DROP TABLE IF EXISTS colores;
DROP TABLE IF EXISTS tallas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS ajustes;

-- 0. Ajustes (Contenido editable)
CREATE TABLE ajustes (
  clave TEXT PRIMARY KEY,
  valor TEXT
);
CREATE TABLE categorias (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  imagen_url TEXT,
  activa INTEGER DEFAULT 1
);

-- 2. Productos
CREATE TABLE productos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  descripcion TEXT,
  precio REAL NOT NULL,
  precio_oferta REAL,
  categoria_id INTEGER,
  imagen_url TEXT,
  genero TEXT DEFAULT 'unisex',
  destacado INTEGER DEFAULT 0,
  nuevo INTEGER DEFAULT 0,
  estado TEXT DEFAULT 'activo',
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- 3. Usuarios
CREATE TABLE usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  telefono TEXT,
  direccion TEXT,
  rol TEXT DEFAULT 'cliente',
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tallas
CREATE TABLE tallas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  producto_id INTEGER,
  nombre TEXT NOT NULL,
  stock INTEGER DEFAULT 0,
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 5. Colores
CREATE TABLE colores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  producto_id INTEGER,
  nombre TEXT NOT NULL,
  hex_code TEXT,
  imagen_url TEXT,
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 6. Carrito
CREATE TABLE carrito (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER,
  producto_id INTEGER,
  talla_id INTEGER,
  color_id INTEGER,
  cantidad INTEGER DEFAULT 1,
  fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- 7. Pedidos
CREATE TABLE pedidos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER,
  total REAL NOT NULL,
  estado TEXT DEFAULT 'pendiente',
  nombre_envio TEXT,
  direccion_envio TEXT,
  telefono_envio TEXT,
  email_envio TEXT,
  notas TEXT,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- 8. Items de Pedido
CREATE TABLE pedido_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  pedido_id INTEGER,
  producto_id INTEGER,
  nombre_producto TEXT,
  talla TEXT,
  color TEXT,
  cantidad INTEGER,
  precio_unitario REAL,
  FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
);

-- =============================================
-- DATOS INICIALES (SEED DATA)
-- =============================================

-- Categorías con fotos reales (Unsplash)
INSERT INTO categorias (id, nombre, imagen_url) VALUES 
(1, 'Rostro', 'https://images.unsplash.com/photo-1596704017254-9b12106fc19a?q=80&w=2070'),
(2, 'Ojos', 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?q=80&w=2070'),
(3, 'Labios', 'https://images.unsplash.com/photo-1586776193466-91edd2267b1c?q=80&w=2069'),
(4, 'Skincare', 'https://images.unsplash.com/photo-1556228515-ce4a913f423b?q=80&w=2070');

-- Usuario Admin (password: admin123)
-- Hash corregido para el worker: h_g10hvh
INSERT INTO usuarios (id, nombre, email, password_hash, rol) VALUES 
(1, 'Admin Zyra', 'admin@zyra.com', 'h_g10hvh', 'admin');

-- Productos (Maquillaje y Belleza)
INSERT INTO productos (id, nombre, descripcion, precio, precio_oferta, categoria_id, imagen_url, genero, destacado, nuevo) VALUES
(1, 'Labial Matte SuperStay', 'Labial de larga duración, acabado mate aterciopelado. Color intenso que no se transfiere.', 15.00, 12.00, 3, 'https://images.unsplash.com/photo-1586776193466-91edd2267b1c?q=80&w=2069', 'unisex', 1, 1),
(2, 'Base de Maquillaje Fit Me', 'Base fluida que se adapta a tu tono de piel. Acabado natural y control de brillo.', 22.00, 18.00, 1, 'https://images.unsplash.com/photo-1596704017254-9b12106fc19a?q=80&w=2070', 'unisex', 1, 1),
(3, 'Máscara de Pestañas Lash Sensational', 'Efecto abanico para unas pestañas largas y voluminosas. Negro intenso.', 12.00, NULL, 2, 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?q=80&w=2070', 'unisex', 1, 0),
(4, 'Serum Hidratante Pro-Glow', 'Skincare esencial con ácido hialurónico para una piel radiante y saludable.', 35.00, 30.00, 4, 'https://images.unsplash.com/photo-1556228515-ce4a913f423b?q=80&w=2070', 'unisex', 1, 1),
(5, 'Paleta de Sombras Nude Edition', '12 tonos altamente pigmentados entre mates y brillantes para un look versátil.', 28.00, NULL, 2, 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=2087', 'unisex', 0, 1);

-- Tallas (Para maquillaje usamos Tonos o 'Única')
INSERT INTO tallas (producto_id, nombre, stock) VALUES
(1, 'Nude', 20), (1, 'Red', 20), (1, 'Pink', 15),
(2, '110 Porcelana', 10), (2, '220 Natural', 10), (2, '330 Toffee', 10),
(3, 'Negro', 50),
(4, 'Única', 30),
(5, 'Única', 25);

-- Colores (Mapeo de tonos para selección visual)
INSERT INTO colores (producto_id, nombre, hex_code) VALUES
(1, 'Nude Oasis', '#d2b48c'), (1, 'Ruby Red', '#9b111e'), (2, 'Light', '#f5e1d2'), (2, 'Medium', '#d2b48c');

-- Ajustes iniciales
INSERT INTO ajustes (clave, valor) VALUES 
('quienes_somos', 'ZYRA-SHOP es tu destino premium de belleza y empoderamiento. Inspiradas por la elegancia y la sofisticación, ofrecemos productos de alta gama que resaltan tu belleza natural. Fundada en 2026, nuestra misión es brindar asesoría personalizada y productos de calidad excepcional para cada tipo de piel.');
