package com.empresa.asistencia;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class SistemaAsistenciaApplication {

    public static void main(String[] args) {
        try {
            ConfigurableApplicationContext context = SpringApplication.run(SistemaAsistenciaApplication.class, args);
            System.out.println("✅ Sistema de Asistencia iniciado correctamente!");
            System.out.println("📋 Swagger UI: http://localhost:8080/swagger-ui.html");
            System.out.println("💾 H2 Console: http://localhost:8080/h2-console");
            System.out.println("🔐 Usuarios de prueba:");
            System.out.println("   - admin/admin123 (ADMIN)");
            System.out.println("   - user/user123 (USER)");
        } catch (Exception e) {
            System.err.println("❌ Error al iniciar la aplicación: " + e.getMessage());
            e.printStackTrace();
        }
    }
}