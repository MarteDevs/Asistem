package com.empresa.asistencia.controller;

import com.empresa.asistencia.dto.DepartamentoDTO;
import com.empresa.asistencia.service.DepartamentoService;
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
@RequestMapping("/api/departamentos")
@RequiredArgsConstructor
@Tag(name = "Departamentos", description = "API para gestión de departamentos")
@SecurityRequirement(name = "basicAuth")
public class DepartamentoController {

    private final DepartamentoService departamentoService;

    @PostMapping
    @Operation(summary = "Crear un nuevo departamento")
    public ResponseEntity<DepartamentoDTO> crearDepartamento(@Valid @RequestBody DepartamentoDTO departamentoDTO) {
        DepartamentoDTO nuevoDepartamento = departamentoService.crearDepartamento(departamentoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(nuevoDepartamento);
    }

    @GetMapping
    @Operation(summary = "Obtener todos los departamentos")
    public ResponseEntity<List<DepartamentoDTO>> obtenerTodosLosDepartamentos() {
        List<DepartamentoDTO> departamentos = departamentoService.obtenerTodosLosDepartamentos();
        return ResponseEntity.ok(departamentos);
    }

    @GetMapping("/paginado")
    @Operation(summary = "Obtener todos los departamentos con paginación")
    public ResponseEntity<Page<DepartamentoDTO>> obtenerDepartamentosPaginado(Pageable pageable) {
        Page<DepartamentoDTO> departamentos = departamentoService.obtenerTodosLosDepartamentosPaginado(pageable);
        return ResponseEntity.ok(departamentos);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener un departamento por ID")
    public ResponseEntity<DepartamentoDTO> obtenerDepartamentoPorId(@PathVariable Long id) {
        DepartamentoDTO departamento = departamentoService.obtenerDepartamentoPorId(id);
        return ResponseEntity.ok(departamento);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar un departamento")
    public ResponseEntity<DepartamentoDTO> actualizarDepartamento(
            @PathVariable Long id,
            @Valid @RequestBody DepartamentoDTO departamentoDTO) {
        DepartamentoDTO departamentoActualizado = departamentoService.actualizarDepartamento(id, departamentoDTO);
        return ResponseEntity.ok(departamentoActualizado);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar un departamento")
    public ResponseEntity<Void> eliminarDepartamento(@PathVariable Long id) {
        departamentoService.eliminarDepartamento(id);
        return ResponseEntity.noContent().build();
    }
}