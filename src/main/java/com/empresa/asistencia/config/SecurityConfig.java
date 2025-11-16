package com.empresa.asistencia.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authz -> authz
                // Endpoints públicos
                .requestMatchers("/h2-console/**").permitAll()
                .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()
                
                // Departamentos - solo ADMIN
                .requestMatchers(HttpMethod.GET, "/api/departamentos/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.POST, "/api/departamentos/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.PUT, "/api/departamentos/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/api/departamentos/**").hasRole("ADMIN")
                
                // Empleados - solo ADMIN
                .requestMatchers(HttpMethod.GET, "/api/empleados/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.POST, "/api/empleados/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.PUT, "/api/empleados/**").hasRole("ADMIN")
                .requestMatchers(HttpMethod.DELETE, "/api/empleados/**").hasRole("ADMIN")
                
                // Asistencias - entrada/salida - USER y ADMIN
                .requestMatchers(HttpMethod.POST, "/api/asistencias/marcar-entrada").hasAnyRole("USER", "ADMIN")
                .requestMatchers(HttpMethod.POST, "/api/asistencias/marcar-salida").hasAnyRole("USER", "ADMIN")
                
                // Asistencias - consultas - USER (solo sus datos) y ADMIN (todos)
                .requestMatchers(HttpMethod.GET, "/api/asistencias").hasAnyRole("USER", "ADMIN")
                .requestMatchers(HttpMethod.GET, "/api/asistencias/resumen").hasAnyRole("USER", "ADMIN")
                
                // Cualquier otra petición requiere autenticación
                .anyRequest().authenticated()
            )
            .headers(headers -> headers.frameOptions().disable()) // Para H2 console
            .httpBasic(httpBasic -> httpBasic.realmName("Sistema de Asistencia"));
        
        return http.build();
    }

    @Bean
    public UserDetailsService users() {
        UserDetails admin = User.builder()
            .username("admin")
            .password(passwordEncoder().encode("admin123"))
            .roles("ADMIN")
            .build();
            
        UserDetails user = User.builder()
            .username("user")
            .password(passwordEncoder().encode("user123"))
            .roles("USER")
            .build();
            
        return new InMemoryUserDetailsManager(admin, user);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}