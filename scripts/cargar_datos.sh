#!/bin/bash

# Script ejecutable para cargar datos de prueba en MySQL
# Uso: ./cargar_datos.sh [usuario] [contraseña] [base_de_datos]

# Configuración por defecto
DB_USER="${1:-root}"
DB_PASS="${2:-marte}"
DB_NAME="${3:-asistencia_db}"

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  CARGADOR DE DATOS DE PRUEBA${NC}"
echo -e "${BLUE}  Sistema de Asistencia de Empleados${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Verificar que MySQL esté disponible
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}❌ Error: MySQL no está instalado o no está en el PATH${NC}"
    exit 1
fi

# Verificar conexión a MySQL
echo -e "${BLUE}🔍 Verificando conexión a MySQL...${NC}"
if mysql -u"$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" &> /dev/null; then
    echo -e "${GREEN}✅ Conexión exitosa a la base de datos $DB_NAME${NC}"
else
    echo -e "${RED}❌ Error: No se puede conectar a MySQL o la base de datos $DB_NAME no existe${NC}"
    echo -e "${RED}   Usuario: $DB_USER${NC}"
    echo -e "${RED}   Base de datos: $DB_NAME${NC}"
    exit 1
fi

# Mostrar menú de opciones
echo ""
echo -e "${BLUE}📋 Opciones disponibles:${NC}"
echo "1) Cargar datos básicos (departamentos, empleados, algunos registros)"
echo "2) Cargar datos históricos (30 días de registros)"
echo "3) Limpiar todos los datos"
echo "4) Cargar todo (básicos + históricos)"
echo ""
read -p "Seleccione una opción (1-4): " opcion

case $opcion in
    1)
        echo -e "${BLUE}📊 Cargando datos básicos...${NC}"
        mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < cargar_datos_prueba.sql
        echo -e "${GREEN}✅ Datos básicos cargados exitosamente${NC}"
        ;;
    2)
        echo -e "${BLUE}📈 Cargando datos históricos...${NC}"
        mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < datos_historicos.sql
        echo -e "${GREEN}✅ Datos históricos cargados exitosamente${NC}"
        ;;
    3)
        echo -e "${RED}🗑️  Limpiando todos los datos...${NC}"
        mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < limpiar_datos.sql
        echo -e "${GREEN}✅ Todos los datos han sido eliminados${NC}"
        ;;
    4)
        echo -e "${BLUE}📊 Cargando datos básicos...${NC}"
        mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < cargar_datos_prueba.sql
        echo -e "${BLUE}📈 Cargando datos históricos...${NC}"
        mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < datos_historicos.sql
        echo -e "${GREEN}✅ Todos los datos han sido cargados exitosamente${NC}"
        ;;
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac

# Mostrar resumen final
echo ""
echo -e "${BLUE}📋 Resumen de datos cargados:${NC}"
mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
SELECT 
    'Departamentos' as tipo, COUNT(*) as cantidad FROM departamentos
UNION ALL
SELECT 
    'Empleados' as tipo, COUNT(*) as cantidad FROM empleados
UNION ALL
SELECT 
    'Registros de asistencia' as tipo, COUNT(*) as cantidad FROM registros_asistencia;
"

echo ""
echo -e "${GREEN}🎉 Proceso completado exitosamente!${NC}"
echo -e "${BLUE}Puedes verificar los datos en tu aplicación web${NC}"
echo ""
echo -e "${BLUE}Para ejecutar nuevamente:${NC}"
echo -e "  ./cargar_datos.sh $DB_USER [contraseña] [base_de_datos]"
echo ""
echo -e "${BLUE}Para limpiar y volver a cargar:${NC}"
echo -e "  ./cargar_datos.sh $DB_USER [contraseña] [base_de_datos]"
echo -e "  Selecciona opción 3 para limpiar, luego opción 4 para cargar todo"