-- Script de datos históricos para Sistema de Asistencia
-- Este script genera registros de asistencia para los últimos 30 días
-- con patrones realistas de asistencia

-- =====================================================
-- FUNCIONES AUXILIARES
-- =====================================================

-- Procedimiento para generar registros de asistencia históricos
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS generar_asistencia_historica()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE empleado_id_var INT;
    DECLARE fecha_var DATE;
    DECLARE dia_semana INT;
    DECLARE hora_entrada TIME;
    DECLARE hora_salida TIME;
    DECLARE estado_var VARCHAR(20);
    DECLARE observacion_var VARCHAR(500);
    DECLARE random_val DECIMAL(3,2);
    
    -- Cursor para recorrer todos los empleados activos
    DECLARE empleado_cursor CURSOR FOR 
        SELECT id FROM empleados WHERE estado = 'ACTIVO';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Generar registros para los últimos 30 días
    SET fecha_var = DATE_SUB(CURDATE(), INTERVAL 30 DAY);
    
    WHILE fecha_var < CURDATE() DO
        SET dia_semana = DAYOFWEEK(fecha_var);
        
        -- Solo generar registros para días laborables (lunes a viernes)
        IF dia_semana BETWEEN 2 AND 6 THEN
            
            OPEN empleado_cursor;
            
            empleado_loop: LOOP
                FETCH empleado_cursor INTO empleado_id_var;
                IF done THEN
                    SET done = FALSE;
                    LEAVE empleado_loop;
                END IF;
                
                -- Generar valor aleatorio para determinar el estado
                SET random_val = RAND();
                
                -- 80% de probabilidad de estar presente
                -- 10% de probabilidad de tardanza  
                -- 10% de probabilidad de ausente
                IF random_val < 0.8 THEN
                    SET estado_var = 'PRESENTE';
                    
                    -- Generar hora de entrada entre 8:15 y 9:00
                    SET hora_entrada = ADDTIME('08:15:00', SEC_TO_TIME(FLOOR(RAND() * 2700)));
                    
                    -- Generar hora de salida entre 17:00 y 18:30
                    SET hora_salida = ADDTIME('17:00:00', SEC_TO_TIME(FLOOR(RAND() * 5400)));
                    
                    SET observacion_var = NULL;
                    
                ELSEIF random_val < 0.9 THEN
                    SET estado_var = 'TARDANZA';
                    
                    -- Generar hora de entrada entre 9:01 y 10:30 (tarde)
                    SET hora_entrada = ADDTIME('09:01:00', SEC_TO_TIME(FLOOR(RAND() * 5340)));
                    
                    -- Generar hora de salida entre 17:30 y 19:00
                    SET hora_salida = ADDTIME('17:30:00', SEC_TO_TIME(FLOOR(RAND() * 5400)));
                    
                    SET observacion_var = CASE FLOOR(RAND() * 4)
                        WHEN 0 THEN 'Tráfico pesado'
                        WHEN 1 THEN 'Problemas de transporte'
                        WHEN 2 THEN 'Motivos personales'
                        ELSE 'Lluvia/intemperie'
                    END;
                    
                ELSE
                    SET estado_var = 'AUSENTE';
                    SET hora_entrada = NULL;
                    SET hora_salida = NULL;
                    
                    SET observacion_var = CASE FLOOR(RAND() * 6)
                        WHEN 0 THEN 'Vacaciones'
                        WHEN 1 THEN 'Enfermedad'
                        WHEN 2 THEN 'Día personal'
                        WHEN 3 THEN 'Cita médica'
                        WHEN 4 THEN 'Capacitación externa'
                        ELSE 'Motivos familiares'
                    END;
                END IF;
                
                -- Verificar si ya existe un registro para este empleado y fecha
                IF NOT EXISTS (
                    SELECT 1 FROM registros_asistencia 
                    WHERE empleado_id = empleado_id_var AND fecha = fecha_var
                ) THEN
                    
                    INSERT INTO registros_asistencia 
                    (empleado_id, fecha, hora_entrada, hora_salida, estado, observacion)
                    VALUES 
                    (empleado_id_var, fecha_var, hora_entrada, hora_salida, estado_var, observacion_var);
                    
                END IF;
                
            END LOOP;
            
            CLOSE empleado_cursor;
            
        END IF;
        
        SET fecha_var = DATE_ADD(fecha_var, INTERVAL 1 DAY);
        
    END WHILE;
    
END //

DELIMITER ;

-- =====================================================
-- EJECUTAR PROCEDIMIENTO
-- =====================================================

-- Llamar al procedimiento para generar datos históricos
CALL generar_asistencia_historica();

-- =====================================================
-- CONSULTAS DE VERIFICACIÓN
-- =====================================================

-- Verificar cantidad de registros generados
SELECT 
    'Registros de asistencia generados:' as descripcion,
    COUNT(*) as total
FROM registros_asistencia 
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Verificar distribución por estado
SELECT 
    estado,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM registros_asistencia WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)), 2) as porcentaje
FROM registros_asistencia 
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY estado
ORDER BY cantidad DESC;

-- Top 5 empleados con más tardanzas
SELECT 
    e.nombre_completo,
    d.nombre as departamento,
    COUNT(*) as tardanzas
FROM registros_asistencia ra
JOIN empleados e ON ra.empleado_id = e.id
JOIN departamentos d ON e.departamento_id = d.id
WHERE ra.estado = 'TARDANZA' 
AND ra.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY e.id, e.nombre_completo, d.nombre
ORDER BY tardanzas DESC
LIMIT 5;

-- Empleados con más ausencias
SELECT 
    e.nombre_completo,
    d.nombre as departamento,
    COUNT(*) as ausencias
FROM registros_asistencia ra
JOIN empleados e ON ra.empleado_id = e.id
JOIN departamentos d ON e.departamento_id = d.id
WHERE ra.estado = 'AUSENTE' 
AND ra.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY e.id, e.nombre_completo, d.nombre
ORDER BY ausencias DESC
LIMIT 5;

-- Promedio de horas trabajadas por departamento (solo presentes)
SELECT 
    d.nombre as departamento,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, 
        CONCAT(ra.fecha, ' ', ra.hora_entrada), 
        CONCAT(ra.fecha, ' ', ra.hora_salida)) / 60), 2) as promedio_horas
FROM registros_asistencia ra
JOIN empleados e ON ra.empleado_id = e.id
JOIN departamentos d ON e.departamento_id = d.id
WHERE ra.estado = 'PRESENTE'
AND ra.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
AND ra.hora_entrada IS NOT NULL 
AND ra.hora_salida IS NOT NULL
GROUP BY d.id, d.nombre
ORDER BY promedio_horas DESC;

-- Resumen por día de la semana
SELECT 
    CASE DAYOFWEEK(fecha)
        WHEN 2 THEN 'Lunes'
        WHEN 3 THEN 'Martes'
        WHEN 4 THEN 'Miércoles'
        WHEN 5 THEN 'Jueves'
        WHEN 6 THEN 'Viernes'
        ELSE 'Fin de semana'
    END as dia_semana,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN estado = 'PRESENTE' THEN 1 END) as presentes,
    COUNT(CASE WHEN estado = 'TARDANZA' THEN 1 END) as tardanzas,
    COUNT(CASE WHEN estado = 'AUSENTE' THEN 1 END) as ausentes
FROM registros_asistencia 
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY DAYOFWEEK(fecha)
ORDER BY DAYOFWEEK(fecha);

SELECT '=== DATOS HISTÓRICOS GENERADOS EXITOSAMENTE ===' as mensaje;

-- =====================================================
-- LIMPIEZA (opcional - descomentar si se necesita)
-- =====================================================

-- DROP PROCEDURE IF EXISTS generar_asistencia_historica;