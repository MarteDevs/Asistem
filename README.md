# Sistema de Gestión de Asistencia de Empleados

API REST desarrollada con Spring Boot para la gestión de asistencia de empleados en una empresa.

## 🚀 Tecnologías Utilizadas

- **Java 17+**
- **Spring Boot 3.x**
- **Spring Data JPA**
- **Spring Security**
- **Spring Validation**
- **H2 Database** (desarrollo)
- **MySQL** (producción)
- **Lombok**
- **Swagger/OpenAPI 3.0**
- **Maven**

## 📋 Requisitos Previos

- Java 17 o superior
- Maven 3.6+
- MySQL 8.0+ (opcional, para producción)

## 🔧 Instalación y Configuración

### 1. Clonar el repositorio
```bash
git clone [URL_DEL_REPOSITORIO]
cd sistema-asistencia
```

### 2. Compilar el proyecto
```bash
mvn clean install
```

### 3. Configuración de Base de Datos

#### Perfil de Desarrollo (H2 - por defecto)
El sistema usa H2 en memoria por defecto. No requiere configuración adicional.

#### Perfil de Producción (MySQL)
1. Crear la base de datos en MySQL:
```sql
CREATE DATABASE asistencia_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Configurar las credenciales en `application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/asistencia_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
    username: tu_usuario
    password: tu_contraseña
```

### 4. Ejecutar la aplicación

#### Con perfil de desarrollo (H2):
```bash
mvn spring-boot:run
```

#### Con perfil de producción (MySQL):
```bash
mvn spring-boot:run -Dspring.profiles.active=mysql
```

## 🔐 Usuarios de Prueba

El sistema incluye usuarios de prueba configurados automáticamente:

| Usuario | Contraseña | Rol |
|---------|------------|-----|
| admin   | admin123   | ADMIN |
| user    | user123    | USER |

## 📚 Documentación de la API

Una vez ejecutada la aplicación, puedes acceder a:

- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **H2 Console**: http://localhost:8080/h2-console
  - JDBC URL: `jdbc:h2:mem:asistencia_db`
  - Username: `sa`
  - Password: (dejar vacío)

## 📡 Endpoints de la API

### Departamentos
- `GET /api/departamentos` - Listar todos los departamentos
- `GET /api/departamentos/paginado` - Listar departamentos con paginación
- `GET /api/departamentos/{id}` - Obtener departamento por ID
- `POST /api/departamentos` - Crear nuevo departamento
- `PUT /api/departamentos/{id}` - Actualizar departamento
- `DELETE /api/departamentos/{id}` - Eliminar departamento

### Empleados
- `GET /api/empleados` - Listar todos los empleados
- `GET /api/empleados/paginado` - Listar empleados con paginación
- `GET /api/empleados/estado/{estado}` - Filtrar empleados por estado (ACTIVO/INACTIVO)
- `GET /api/empleados/departamento/{departamentoId}` - Filtrar empleados por departamento
- `GET /api/empleados/{id}` - Obtener empleado por ID
- `POST /api/empleados` - Crear nuevo empleado
- `PUT /api/empleados/{id}` - Actualizar empleado
- `DELETE /api/empleados/{id}` - Dar de baja empleado (cambio de estado)

### Asistencias
- `POST /api/asistencias/marcar-entrada` - Registrar entrada de empleado
- `POST /api/asistencias/marcar-salida` - Registrar salida de empleado
- `GET /api/asistencias` - Listar asistencias con filtros
- `GET /api/asistencias/empleado/{empleadoId}?fechaDesde=YYYY-MM-DD&fechaHasta=YYYY-MM-DD` - Asistencias por empleado y rango de fechas
- `GET /api/asistencias/departamento/{departamentoId}` - Asistencias por departamento
- `GET /api/asistencias/resumen?empleadoId=X&fechaDesde=YYYY-MM-DD&fechaHasta=YYYY-MM-DD` - Resumen de asistencias

## 📋 Ejemplos de Uso

### Crear un departamento
```bash
curl -X POST http://localhost:8080/api/departamentos \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
  -d '{
    "nombre": "Recursos Humanos"
  }'
```

### Crear un empleado
```bash
curl -X POST http://localhost:8080/api/empleados \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
  -d '{
    "nombreCompleto": "Juan Pérez García",
    "email": "juan.perez@empresa.com",
    "dni": "12345678A",
    "departamentoId": 1
  }'
```

### Marcar entrada
```bash
curl -X POST http://localhost:8080/api/asistencias/marcar-entrada \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic dXNlcjp1c2VyMTIz" \
  -d '{
    "empleadoId": 1,
    "fecha": "2025-11-15",
    "horaEntrada": "08:30:00",
    "observacion": "Llegada puntual"
  }'
```

### Marcar salida
```bash
curl -X POST http://localhost:8080/api/asistencias/marcar-salida \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic dXNlcjp1c2VyMTIz" \
  -d '{
    "empleadoId": 1,
    "fecha": "2025-11-15",
    "horaSalida": "17:30:00"
  }'
```

### Obtener resumen de asistencias
```bash
curl -X GET "http://localhost:8080/api/asistencias/resumen?empleadoId=1&fechaDesde=2025-11-01&fechaHasta=2025-11-30" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM="
```

## 🔒 Seguridad

### Roles y Permisos

- **ADMIN**: Acceso completo a todos los endpoints
- **USER**: Solo puede marcar su propia entrada/salida y ver sus asistencias

### Configuración de Seguridad

La seguridad está configurada en `SecurityConfig.java` con:
- Autenticación HTTP Basic
- Autorización basada en roles
- CORS habilitado
- CSRF deshabilitado para API REST

## 🧪 Testing

### Ejecutar pruebas unitarias
```bash
mvn test
```

### Ejecutar pruebas de integración
```bash
mvn integration-test
```

## 📊 Reglas de Negocio

### Asistencias
- Un empleado no puede registrar dos entradas para la misma fecha sin haber registrado una salida
- El estado de asistencia se calcula automáticamente:
  - **PRESENTE**: Si la entrada es antes de las 9:00 AM
  - **TARDANZA**: Si la entrada es después de las 9:00 AM
  - **AUSENTE**: No se registra entrada en el día
- Solo empleados activos pueden marcar asistencia

### Empleados
- El email debe ser único
- El DNI debe ser único (si se proporciona)
- La baja es lógica (cambio de estado a INACTIVO)

### Departamentos
- El nombre del departamento debe ser único
- No se puede eliminar un departamento con empleados activos

## 🐛 Manejo de Errores

El sistema implementa un manejador global de excepciones que devuelve respuestas JSON estructuradas:

```json
{
  "timestamp": "2025-11-15T10:30:00",
  "status": 404,
  "error": "Recurso no encontrado",
  "message": "Empleado con ID 1 no encontrado"
}
```

## 📁 Estructura del Proyecto

```
src/
├── main/
│   ├── java/com/empresa/asistencia/
│   │   ├── config/          # Configuraciones de seguridad, web, OpenAPI
│   │   ├── controller/      # Controladores REST
│   │   ├── dto/            # Objetos de transferencia de datos
│   │   ├── entity/         # Entidades JPA
│   │   ├── exception/      # Excepciones personalizadas
│   │   ├── repository/     # Interfaces de repositorio
│   │   ├── service/        # Lógica de negocio
│   │   └── SistemaAsistenciaApplication.java
│   └── resources/
│       └── application.yml  # Configuración de la aplicación
└── test/                    # Pruebas unitarias y de integración
```

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia Apache 2.0 - ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Soporte

Para soporte técnico, contactar a:
- Email: soporte@empresa.com
- Teléfono: +XX XXX XXXX