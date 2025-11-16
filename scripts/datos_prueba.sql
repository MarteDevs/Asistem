-- Script de datos de prueba para Sistema de Asistencia
-- Base de datos: asistencia_db
-- Orden de inserción: departamentos -> empleados -> registros_asistencia

-- =====================================================
-- 1. INSERTAR DEPARTAMENTOS
-- =====================================================
INSERT INTO departamentos (nombre) VALUES 
('Recursos Humanos'),
('Tecnología de la Información'),
('Contabilidad'),
('Ventas'),
('Marketing'),
('Operaciones'),
('Administración'),
('Compras'),
('Calidad'),
('Atención al Cliente');

-- =====================================================
-- 2. INSERTAR EMPLEADOS
-- =====================================================

-- Departamento 1: Recursos Humanos
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('María González López', 'maria.gonzalez@empresa.com', '12345678A', 'ACTIVO', 1),
('Carlos Rodríguez Martín', 'carlos.rodriguez@empresa.com', '87654321B', 'ACTIVO', 1),
('Ana Martínez Sánchez', 'ana.martinez@empresa.com', '11223344C', 'ACTIVO', 1);

-- Departamento 2: Tecnología de la Información
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Juan Pérez García', 'juan.perez@empresa.com', '22334455D', 'ACTIVO', 2),
('Laura Fernández Gómez', 'laura.fernandez@empresa.com', '33445566E', 'ACTIVO', 2),
('Pedro Sánchez Ruiz', 'pedro.sanchez@empresa.com', '44556677F', 'ACTIVO', 2),
('Sofía Díaz Hernández', 'sofia.diaz@empresa.com', '55667788G', 'ACTIVO', 2),
('Miguel Torres Vega', 'miguel.torres@empresa.com', '66778899H', 'ACTIVO', 2);

-- Departamento 3: Contabilidad
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Elena Ramírez Jiménez', 'elena.ramirez@empresa.com', '77889900I', 'ACTIVO', 3),
('David Moreno Silva', 'david.moreno@empresa.com', '88990011J', 'ACTIVO', 3),
('Carmen Romero Flores', 'carmen.romero@empresa.com', '99001122K', 'ACTIVO', 3);

-- Departamento 4: Ventas
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Roberto Castro Blanco', 'roberto.castro@empresa.com', '10022334L', 'ACTIVO', 4),
('Patricia Vázquez Morales', 'patricia.vazquez@empresa.com', '20133445M', 'ACTIVO', 4),
('Alberto Ortega Delgado', 'alberto.ortega@empresa.com', '30244556N', 'ACTIVO', 4),
('Rosa Gil Cabrera', 'rosa.gil@empresa.com', '40355667O', 'ACTIVO', 4);

-- Departamento 5: Marketing
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Isabel Reyes Pérez', 'isabel.reyes@empresa.com', '50466778P', 'ACTIVO', 5),
('Francisco Molina Ortiz', 'francisco.molina@empresa.com', '60577889Q', 'ACTIVO', 5),
('Teresa Navarro Serrano', 'teresa.navarro@empresa.com', '70688990R', 'ACTIVO', 5);

-- Departamento 6: Operaciones
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Manuel Domínguez Parra', 'manuel.dominguez@empresa.com', '80799001S', 'ACTIVO', 6),
('Silvia Iglesias Rojas', 'silvia.iglesias@empresa.com', '90800112T', 'ACTIVO', 6);

-- Departamento 7: Administración
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Rafael Gutiérrez Molina', 'rafael.gutierrez@empresa.com', '10911223U', 'ACTIVO', 7),
('Nuria Castillo Bravo', 'nuria.castillo@empresa.com', '21022334V', 'ACTIVO', 7);

-- Departamento 8: Compras
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Óscar Marín Peña', 'oscar.marin@empresa.com', '31133445W', 'ACTIVO', 8),
('Beatriz Aguilar Moya', 'beatriz.aguilar@empresa.com', '41244556X', 'ACTIVO', 8);

-- Departamento 9: Calidad
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Arturo Núñez Carrasco', 'arturo.nunez@empresa.com', '51355667Y', 'ACTIVO', 9);

-- Departamento 10: Atención al Cliente
INSERT INTO empleados (nombre_completo, email, dni, estado, departamento_id) VALUES
('Lorena Santiago Vega', 'lorena.santiago@empresa.com', '61466778Z', 'ACTIVO', 10),
('Héctor Mora Lozano', 'hector.mora@empresa.com', '71577890A', 'ACTIVO', 10);

-- =====================================================
-- 3. INSERTAR REGISTROS DE ASISTENCIA
-- =====================================================

-- Función para generar registros de asistencia para los últimos 30 días
-- Registros variados: presentes, con tardanza y ausentes

-- Empleado 1: María González (Recursos Humanos)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:45:00', '17:30:00', 'PRESENTE', 'Día normal de trabajo'),
(1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '09:15:00', '17:45:00', 'TARDANZA', 'Llegó 15 minutos tarde por tráfico'),
(1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:30:00', '17:15:00', 'PRESENTE', NULL),
(1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:50:00', '17:20:00', 'PRESENTE', NULL),
(1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, NULL, 'AUSENTE', 'Permiso médico');

-- Empleado 2: Carlos Rodríguez (Recursos Humanos)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(2, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:35:00', '17:25:00', 'PRESENTE', NULL),
(2, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:40:00', '17:35:00', 'PRESENTE', NULL),
(2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '09:20:00', '18:00:00', 'TARDANZA', 'Problemas de transporte'),
(2, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:25:00', '17:10:00', 'PRESENTE', NULL),
(2, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:30:00', '17:15:00', 'PRESENTE', NULL);

-- Empleado 3: Juan Pérez (Tecnología)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(4, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:20:00', '17:00:00', 'PRESENTE', 'Llegó temprano'),
(4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:30:00', '17:20:00', 'PRESENTE', NULL),
(4, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:45:00', '17:30:00', 'PRESENTE', NULL),
(4, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, NULL, 'AUSENTE', 'Vacaciones'),
(4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:35:00', '17:25:00', 'PRESENTE', NULL);

-- Empleado 4: Laura Fernández (Tecnología)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(5, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '09:10:00', '18:00:00', 'TARDANZA', 'Llegó 10 minutos tarde'),
(5, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:30:00', '17:20:00', 'PRESENTE', NULL),
(5, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:40:00', '17:30:00', 'PRESENTE', NULL),
(5, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:25:00', '17:15:00', 'PRESENTE', NULL),
(5, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:50:00', '17:40:00', 'PRESENTE', NULL);

-- Empleado 5: Roberto Castro (Ventas) - Ejemplo de vendedor con horario flexible
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(13, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '09:30:00', '18:30:00', 'PRESENTE', 'Reunión con cliente por la mañana'),
(13, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '10:00:00', '19:00:00', 'TARDANZA', 'Visita a cliente'),
(13, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:45:00', '17:45:00', 'PRESENTE', NULL),
(13, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '09:15:00', '18:15:00', 'PRESENTE', NULL),
(13, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, NULL, 'AUSENTE', 'Día de campo');

-- Empleado 6: Elena Ramírez (Contabilidad) - Muy puntual
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(10, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:25:00', '17:05:00', 'PRESENTE', 'Siempre llega 5 min antes'),
(10, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:28:00', '17:08:00', 'PRESENTE', NULL),
(10, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:30:00', '17:10:00', 'PRESENTE', NULL),
(10, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:27:00', '17:07:00', 'PRESENTE', NULL),
(10, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:30:00', '17:10:00', 'PRESENTE', NULL);

-- Empleado 7: Isabel Reyes (Marketing) - Horario creativo
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(16, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '09:00:00', '18:00:00', 'PRESENTE', 'Brainstorming creativo'),
(16, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '10:30:00', '19:30:00', 'TARDANZA', 'Sesión de fotos para campaña'),
(16, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:45:00', '17:45:00', 'PRESENTE', NULL),
(16, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, NULL, 'AUSENTE', 'Presentación de campaña en otra ciudad'),
(16, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '09:15:00', '18:15:00', 'PRESENTE', NULL);

-- Empleado 8: Manuel Domínguez (Operaciones) - Turno mañana
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(19, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '06:00:00', '14:00:00', 'PRESENTE', 'Turno mañana'),
(19, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '06:05:00', '14:05:00', 'PRESENTE', NULL),
(19, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '06:10:00', '14:10:00', 'PRESENTE', NULL),
(19, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '06:00:00', '14:00:00', 'PRESENTE', NULL),
(19, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, NULL, 'AUSENTE', 'Día de descanso compensatorio');

-- Empleado 9: Rafael Gutiérrez (Administración)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(21, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:30:00', '17:15:00', 'PRESENTE', NULL),
(21, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:35:00', '17:20:00', 'PRESENTE', NULL),
(21, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '09:25:00', '18:10:00', 'TARDANZA', 'Llegó tarde por lluvia'),
(21, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:28:00', '17:13:00', 'PRESENTE', NULL),
(21, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:32:00', '17:17:00', 'PRESENTE', NULL);

-- Empleado 10: Óscar Marín (Compras)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(23, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:40:00', '17:30:00', 'PRESENTE', NULL),
(23, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:45:00', '17:35:00', 'PRESENTE', NULL),
(23, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:38:00', '17:28:00', 'PRESENTE', NULL),
(23, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, NULL, 'AUSENTE', 'Capacitación de proveedores'),
(23, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:42:00', '17:32:00', 'PRESENTE', NULL);

-- Empleado 11: Arturo Núñez (Calidad)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(25, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:15:00', '17:00:00', 'PRESENTE', 'Auditoría de calidad'),
(25, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:20:00', '17:05:00', 'PRESENTE', NULL),
(25, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:18:00', '17:03:00', 'PRESENTE', NULL),
(25, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '08:22:00', '17:07:00', 'PRESENTE', NULL),
(25, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:25:00', '17:10:00', 'PRESENTE', NULL);

-- Empleado 12: Lorena Santiago (Atención al Cliente)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(26, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '09:00:00', '18:00:00', 'PRESENTE', 'Atención telefónica'),
(26, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '09:05:00', '18:05:00', 'PRESENTE', NULL),
(26, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:55:00', '17:55:00', 'PRESENTE', NULL),
(26, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '09:10:00', '18:10:00', 'PRESENTE', NULL),
(26, DATE_SUB(CURDATE(), INTERVAL 5 DAY), NULL, NULL, 'AUSENTE', 'Día de capacitación');

-- =====================================================
-- 4. CONSULTAS DE VERIFICACIÓN
-- =====================================================

-- Verificar total de departamentos
SELECT 'Total Departamentos:' as descripcion, COUNT(*) as total FROM departamentos;

-- Verificar total de empleados por departamento
SELECT d.nombre as departamento, COUNT(e.id) as total_empleados 
FROM departamentos d 
LEFT JOIN empleados e ON d.id = e.departamento_id 
GROUP BY d.nombre 
ORDER BY total_empleados DESC;

-- Verificar total de empleados activos
SELECT 'Total Empleados Activos:' as descripcion, COUNT(*) as total FROM empleados WHERE estado = 'ACTIVO';

-- Verificar registros de asistencia recientes
SELECT 'Total Registros Asistencia:' as descripcion, COUNT(*) as total FROM registros_asistencia WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 5 DAY);

-- Ver distribución de estados de asistencia
SELECT estado, COUNT(*) as total 
FROM registros_asistencia 
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 5 DAY)
GROUP BY estado;

-- Empleados sin registro de asistencia hoy
SELECT e.nombre_completo, d.nombre as departamento 
FROM empleados e 
JOIN departamentos d ON e.departamento_id = d.id 
WHERE e.estado = 'ACTIVO' 
AND e.id NOT IN (
    SELECT empleado_id 
    FROM registros_asistencia 
    WHERE fecha = CURDATE()
);

SELECT '=== SCRIPT DE DATOS DE PRUEBA EJECUTADO EXITOSAMENTE ===' as mensaje;