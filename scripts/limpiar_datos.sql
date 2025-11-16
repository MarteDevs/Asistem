-- Script de limpieza y reinicio de datos
-- Este script limpia todas las tablas y reinicia los contadores

-- =====================================================
-- DESACTIVAR VERIFICACIÓN DE CLAVES FORÁNEAS
-- =====================================================
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- LIMPIAR TABLAS EN ORDEN CORRECTO
-- =====================================================

-- Primero limpiar la tabla hija (registros_asistencia)
TRUNCATE TABLE registros_asistencia;
SELECT '✅ Tabla registros_asistencia limpiada' as mensaje;

-- Luego limpiar la tabla intermedia (empleados)
TRUNCATE TABLE empleados;
SELECT '✅ Tabla empleados limpiada' as mensaje;

-- Finalmente limpiar la tabla padre (departamentos)
TRUNCATE TABLE departamentos;
SELECT '✅ Tabla departamentos limpiada' as mensaje;

-- =====================================================
-- REACTIVAR VERIFICACIÓN DE CLAVES FORÁNEAS
-- =====================================================
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- VERIFICACIÓN DE LIMPIEZA
-- =====================================================
SELECT '' as mensaje;
SELECT 'VERIFICACIÓN DE LIMPIEZA:' as mensaje;
SELECT '--------------------------------' as mensaje;

-- Verificar que las tablas estén vacías
SELECT 
    'departamentos' as tabla,
    COUNT(*) as registros
FROM departamentos
UNION ALL
SELECT 
    'empleados' as tabla,
    COUNT(*) as registros
FROM empleados
UNION ALL
SELECT 
    'registros_asistencia' as tabla,
    COUNT(*) as registros
FROM registros_asistencia;

SELECT '' as mensaje;
SELECT '========================================' as mensaje;
SELECT '✅ LIMPIEZA COMPLETADA - BASE DE DATOS VACÍA' as mensaje;
SELECT '========================================' as mensaje;
SELECT '' as mensaje;
SELECT 'Para cargar datos de prueba, ejecuta:' as mensaje;
SELECT 'SOURCE cargar_datos_prueba.sql' as mensaje;