package com.empresa.asistencia.controller;

import com.empresa.asistencia.dto.EmpleadoDTO;
import com.empresa.asistencia.entity.EstadoEmpleado;
import com.empresa.asistencia.service.EmpleadoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/empleados")
@RequiredArgsConstructor
@Tag(name = "Empleados", description = "API para gestión de empleados")
@SecurityRequirement(name = "basicAuth")
public class EmpleadoController {

    private final EmpleadoService empleadoService;

    @PostMapping
    @Operation(summary = "Crear un nuevo empleado")
    public ResponseEntity<EmpleadoDTO> crearEmpleado(@Valid @RequestBody EmpleadoDTO empleadoDTO) {
        EmpleadoDTO nuevoEmpleado = empleadoService.crearEmpleado(empleadoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(nuevoEmpleado);
    }

    @GetMapping
    @Operation(summary = "Obtener todos los empleados")
    public ResponseEntity<List<EmpleadoDTO>> obtenerTodosLosEmpleados() {
        List<EmpleadoDTO> empleados = empleadoService.obtenerTodosLosEmpleados();
        return ResponseEntity.ok(empleados);
    }

    @GetMapping("/paginado")
    @Operation(summary = "Obtener todos los empleados con paginación")
    public ResponseEntity<Page<EmpleadoDTO>> obtenerEmpleadosPaginado(Pageable pageable) {
        Page<EmpleadoDTO> empleados = empleadoService.obtenerTodosLosEmpleadosPaginado(pageable);
        return ResponseEntity.ok(empleados);
    }

    @GetMapping("/estado/{estado}")
    @Operation(summary = "Obtener empleados por estado")
    public ResponseEntity<Page<EmpleadoDTO>> obtenerEmpleadosPorEstado(
            @PathVariable EstadoEmpleado estado,
            Pageable pageable) {
        Page<EmpleadoDTO> empleados = empleadoService.obtenerEmpleadosPorEstado(estado, pageable);
        return ResponseEntity.ok(empleados);
    }

    @GetMapping("/departamento/{departamentoId}")
    @Operation(summary = "Obtener empleados por departamento")
    public ResponseEntity<Page<EmpleadoDTO>> obtenerEmpleadosPorDepartamento(
            @PathVariable Long departamentoId,
            Pageable pageable) {
        Page<EmpleadoDTO> empleados = empleadoService.obtenerEmpleadosPorDepartamento(departamentoId, pageable);
        return ResponseEntity.ok(empleados);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener un empleado por ID")
    public ResponseEntity<EmpleadoDTO> obtenerEmpleadoPorId(@PathVariable Long id) {
        EmpleadoDTO empleado = empleadoService.obtenerEmpleadoPorId(id);
        return ResponseEntity.ok(empleado);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar un empleado")
    public ResponseEntity<EmpleadoDTO> actualizarEmpleado(
            @PathVariable Long id,
            @Valid @RequestBody EmpleadoDTO empleadoDTO) {
        EmpleadoDTO empleadoActualizado = empleadoService.actualizarEmpleado(id, empleadoDTO);
        return ResponseEntity.ok(empleadoActualizado);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Dar de baja un empleado (cambio de estado)")
    public ResponseEntity<Void> darDeBajaEmpleado(@PathVariable Long id) {
        empleadoService.darDeBajaEmpleado(id);
        return ResponseEntity.noContent().build();
    }
}