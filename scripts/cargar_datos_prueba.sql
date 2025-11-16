-- Script maestro para cargar todos los datos de prueba
-- Ejecuta primero los datos básicos y luego los históricos

-- =====================================================
-- MENSAJE DE INICIO
-- =====================================================
SELECT '========================================' as mensaje;
SELECT 'INICIANDO CARGA DE DATOS DE PRUEBA' as mensaje;
SELECT 'SISTEMA DE ASISTENCIA DE EMPLEADOS' as mensaje;
SELECT '========================================' as mensaje;
SELECT '' as mensaje;

-- =====================================================
-- VERIFICAR BASE DE DATOS
-- =====================================================
SELECT 'Verificando base de datos...' as mensaje;

-- Verificar si las tablas existen
SELECT 
    CASE 
        WHEN COUNT(*) = 3 THEN '✅ Todas las tablas existen'
        ELSE '❌ Faltan tablas necesarias'
    END as estado_tablas
FROM information_schema.tables 
WHERE table_schema = DATABASE() 
AND table_name IN ('departamentos', 'empleados', 'registros_asistencia');

-- =====================================================
-- LIMPIAR DATOS EXISTENTES (opcional)
-- =====================================================
SELECT '' as mensaje;
SELECT 'Limpiando datos existentes...' as mensaje;

-- Desactivar verificación de claves foráneas temporalmente
SET FOREIGN_KEY_CHECKS = 0;

-- Limpiar tablas en orden correcto (hijos primero, padres después)
TRUNCATE TABLE registros_asistencia;
TRUNCATE TABLE empleados;
TRUNCATE TABLE departamentos;

-- Reactivar verificación de claves foráneas
SET FOREIGN_KEY_CHECKS = 1;

SELECT '✅ Datos existentes limpiados' as mensaje;

-- =====================================================
-- CARGAR DEPARTAMENTOS
-- =====================================================
SELECT '' as mensaje;
SELECT 'Cargando departamentos...' as mensaje;

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

SELECT CONCAT('✅ ', ROW_COUNT(), ' departamentos insertados') as mensaje;

-- =====================================================
-- CARGAR EMPLEADOS
-- =====================================================
SELECT '' as mensaje;
SELECT 'Cargando empleados...' as mensaje;

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

SELECT CONCAT('✅ ', ROW_COUNT() + 3, ' empleados insertados') as mensaje;

-- =====================================================
-- CARGAR REGISTROS DE ASISTENCIA RECIENTES
-- =====================================================
SELECT '' as mensaje;
SELECT 'Cargando registros de asistencia recientes...' as mensaje;

-- Registros de los últimos 5 días para algunos empleados
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

-- Empleado 4: Juan Pérez (Tecnología)
INSERT INTO registros_asistencia (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion) VALUES
(4, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '08:20:00', '17:00:00', 'PRESENTE', 'Llegó temprano'),
(4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '08:30:00', '17:20:00', 'PRESENTE', NULL),
(4, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:45:00', '17:30:00', 'PRESENTE', NULL),
(4, DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, NULL, 'AUSENTE', 'Vacaciones'),
(4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '08:35:00', '17:25:00', 'PRESENTE', NULL);

SELECT CONCAT('✅ ', ROW_COUNT() + 10, ' registros de asistencia insertados') as mensaje;

-- =====================================================
-- VERIFICACIÓN FINAL
-- =====================================================
SELECT '' as mensaje;
SELECT 'VERIFICACIÓN DE DATOS CARGADOS:' as mensaje;
SELECT '--------------------------------' as mensaje;

-- Total de departamentos
SELECT CONCAT('📊 Departamentos: ', COUNT(*)) as info FROM departamentos;

-- Total de empleados
SELECT CONCAT('👥 Empleados: ', COUNT(*)) as info FROM empleados;

-- Total de registros de asistencia
SELECT CONCAT('📝 Registros de asistencia: ', COUNT(*)) as info FROM registros_asistencia;

-- Distribución de empleados por departamento
SELECT '' as mensaje;
SELECT 'DISTRIBUCIÓN POR DEPARTAMENTOS:' as mensaje;
SELECT d.nombre as departamento, COUNT(e.id) as empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.nombre
ORDER BY empleados DESC;

-- Estadísticas de asistencia reciente
SELECT '' as mensaje;
SELECT 'ESTADÍSTICAS DE ASISTENCIA (ÚLTIMOS 5 DÍAS):' as mensaje;
SELECT 
    estado,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM registros_asistencia WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 5 DAY)), 1) as porcentaje
FROM registros_asistencia 
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 5 DAY)
GROUP BY estado;

-- Empleados sin registro hoy
SELECT '' as mensaje;
SELECT 'EMPLEADOS SIN REGISTRO HOY:' as mensaje;
SELECT e.nombre_completo, d.nombre as departamento
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
WHERE e.estado = 'ACTIVO'
AND e.id NOT IN (
    SELECT empleado_id 
    FROM registros_asistencia 
    WHERE fecha = CURDATE()
)
ORDER BY d.nombre, e.nombre_completo;

SELECT '' as mensaje;
SELECT '========================================' as mensaje;
SELECT '✅ CARGA DE DATOS COMPLETADA EXITOSAMENTE' as mensaje;
SELECT '========================================' as mensaje;

-- =====================================================
-- INSTRUCCIONES PARA GENERAR MÁS DATOS HISTÓRICOS
-- =====================================================
SELECT '' as mensaje;
SELECT 'PARA GENERAR MÁS DATOS HISTÓRICOS:' as mensaje;
SELECT 'Ejecuta: CALL generar_asistencia_historica();' as mensaje;
SELECT 'Esto generará registros para los últimos 30 días' as mensaje;