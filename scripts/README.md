# 📊 Scripts de Datos de Prueba - Sistema de Asistencia

Este directorio contiene scripts SQL para cargar datos de prueba en tu base de datos MySQL del sistema de asistencia de empleados.

## 📁 Archivos Disponibles

### Scripts SQL
- **`cargar_datos_prueba.sql`** - Datos básicos (departamentos, empleados, registros recientes)
- **`datos_historicos.sql`** - Procedimiento para generar 30 días de registros históricos
- **`limpiar_datos.sql`** - Limpia todas las tablas y reinicia contadores

### Script Ejecutable
- **`cargar_datos.sh`** - Script bash interactivo para facilitar la carga

## 🚀 Cómo Usar los Scripts

### Opción 1: Ejecución Directa con MySQL

```bash
# Conectarse a MySQL
mysql -u root -p asistencia_db

# Ejecutar script de datos básicos
SOURCE cargar_datos_prueba.sql;

# (Opcional) Generar datos históricos
SOURCE datos_historicos.sql;
CALL generar_asistencia_historica();

# Salir
EXIT;
```

### Opción 2: Ejecución desde línea de comandos

```bash
# Cargar datos básicos
mysql -u root -p asistencia_db < cargar_datos_prueba.sql

# Cargar datos históricos
mysql -u root -p asistencia_db < datos_historicos.sql
mysql -u root -p asistencia_db -e "CALL generar_asistencia_historica();"

# Limpiar todos los datos
mysql -u root -p asistencia_db < limpiar_datos.sql
```

### Opción 3: Script Interactivo (Recomendado)

```bash
# Hacer el script ejecutable
chmod +x cargar_datos.sh

# Ejecutar con configuración por defecto (usuario: root, pass: marte, db: asistencia_db)
./cargar_datos.sh

# Ejecutar con credenciales personalizadas
./cargar_datos.sh usuario contraseña base_de_datos
```

## 📊 Datos Generados

### Departamentos (10)
- Recursos Humanos (3 empleados)
- Tecnología de la Información (5 empleados)
- Contabilidad (3 empleados)
- Ventas (4 empleados)
- Marketing (3 empleados)
- Operaciones (2 empleados)
- Administración (2 empleados)
- Compras (2 empleados)
- Calidad (1 empleado)
- Atención al Cliente (2 empleados)

### Total: 27 empleados activos

### Registros de Asistencia
- **Datos básicos**: Registros de los últimos 5 días
- **Datos históricos**: Registros de los últimos 30 días (solo días laborables)
- **Distribución**: ~80% Presentes, ~10% Tardanzas, ~10% Ausencias

## 🔍 Verificación de Datos

Después de cargar los datos, puedes verificarlos con estas consultas:

```sql
-- Ver totales
SELECT 'Departamentos' as tipo, COUNT(*) as total FROM departamentos
UNION ALL
SELECT 'Empleados' as tipo, COUNT(*) as total FROM empleados
UNION ALL
SELECT 'Registros' as tipo, COUNT(*) as total FROM registros_asistencia;

-- Ver empleados por departamento
SELECT d.nombre, COUNT(e.id) as empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.nombre;

-- Ver distribución de asistencia reciente
SELECT 
    estado,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM registros_asistencia WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 5 DAY)), 1) as porcentaje
FROM registros_asistencia 
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 5 DAY)
GROUP BY estado;
```

## 🎯 Uso en el Frontend

Una vez cargados los datos, tu aplicación Angular mostrará:

1. **Dashboard**: Estadísticas con datos reales
2. **Empleados**: Lista completa de 27 empleados
3. **Asistencias**: Registros históricos para reportes
4. **Departamentos**: Todos los departamentos con sus empleados

## ⚠️ Notas Importantes

1. **Base de datos**: Asegúrate de tener MySQL ejecutándose y la base de datos `asistencia_db` creada
2. **Credenciales**: Los scripts usan las credenciales del archivo `application.yml`
3. **Backup**: Antes de ejecutar, considera hacer backup de tus datos reales
4. **Reinicio**: Puedes limpiar y volver a cargar los datos las veces que necesites

## 🔄 Flujo Recomendado

1. **Primera vez**: Ejecutar `cargar_datos_prueba.sql` para datos básicos
2. **Desarrollo**: Ejecutar `datos_historicos.sql` para más datos de prueba
3. **Testing**: Usar `limpiar_datos.sql` + `cargar_datos_prueba.sql` para resetear
4. **Producción**: No uses estos scripts, usa datos reales

## 📈 Próximos Pasos

Con los datos cargados, puedes:
- Probar todos los endpoints del backend
- Verificar la integración con el frontend Angular
- Generar reportes de asistencia
- Probar filtros por fecha y departamento
- Validar los cálculos de estadísticas