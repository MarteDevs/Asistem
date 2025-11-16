package com.empresa.asistencia.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecuritySchemes;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "Sistema de Gestión de Asistencia API",
        description = "API REST para gestión de asistencia de empleados",
        version = "1.0.0",
        contact = @Contact(
            name = "Soporte Técnico",
            email = "soporte@empresa.com"
        ),
        license = @License(
            name = "Apache 2.0",
            url = "http://springdoc.org"
        )
    ),
    security = @SecurityRequirement(name = "basicAuth")
)
@SecuritySchemes({
    @SecurityScheme(
        name = "basicAuth",
        type = SecuritySchemeType.HTTP,
        scheme = "basic"
    )
})
public class OpenApiConfig {
}