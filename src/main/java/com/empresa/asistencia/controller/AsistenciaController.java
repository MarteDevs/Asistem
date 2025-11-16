package com.empresa.asistencia.controller;

import com.empresa.asistencia.dto.*;
import com.empresa.asistencia.service.AsistenciaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/asistencias")
@RequiredArgsConstructor
@Tag(name = "Asistencias", description = "API para gestión de asistencias")
@SecurityRequirement(name = "basicAuth")
public class AsistenciaController {

    private final AsistenciaService asistenciaService;

    @PostMapping("/marcar-entrada")
    @Operation(summary = "Marcar entrada de empleado")
    public ResponseEntity<RegistroAsistenciaDTO> marcarEntrada(@Valid @RequestBody MarcarEntradaDTO marcarEntradaDTO) {
        RegistroAsistenciaDTO registro = asistenciaService.marcarEntrada(marcarEntradaDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(registro);
    }

    @PostMapping("/marcar-salida")
    @Operation(summary = "Marcar salida de empleado")
    public ResponseEntity<RegistroAsistenciaDTO> marcarSalida(@Valid @RequestBody MarcarSalidaDTO marcarSalidaDTO) {
        RegistroAsistenciaDTO registro = asistenciaService.marcarSalida(marcarSalidaDTO);
        return ResponseEntity.ok(registro);
    }

    @GetMapping
    @Operation(summary = "Obtener asistencias con filtros")
    public ResponseEntity<Page<RegistroAsistenciaDTO>> obtenerAsistencias(
            @RequestParam(required = false) Long empleadoId,
            @RequestParam(required = false) Long departamentoId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fechaHasta,
            Pageable pageable) {
        
        Page<RegistroAsistenciaDTO> asistencias = asistenciaService.obtenerAsistenciasPorFiltros(
                empleadoId, departamentoId, fechaDesde, fechaHasta, pageable);
        return ResponseEntity.ok(asistencias);
    }

    @GetMapping("/empleado/{empleadoId}")
    @Operation(summary = "Obtener asistencias por empleado y rango de fechas")
    public ResponseEntity<List<RegistroAsistenciaDTO>> obtenerAsistenciasPorEmpleadoYFechas(
            @PathVariable Long empleadoId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fechaDesde,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fechaHasta) {
        
        List<RegistroAsistenciaDTO> asistencias = asistenciaService.obtenerAsistenciasPorEmpleadoYFechas(
                empleadoId, fechaDesde, fechaHasta);
        return ResponseEntity.ok(asistencias);
    }

    @GetMapping("/departamento/{departamentoId}")
    @Operation(summary = "Obtener asistencias por departamento")
    public ResponseEntity<Page<RegistroAsistenciaDTO>> obtenerAsistenciasPorDepartamento(
            @PathVariable Long departamentoId,
            Pageable pageable) {
        
        Page<RegistroAsistenciaDTO> asistencias = asistenciaService.obtenerAsistenciasPorDepartamento(
                departamentoId, pageable);
        return ResponseEntity.ok(asistencias);
    }

    @GetMapping("/resumen")
    @Operation(summary = "Obtener resumen de asistencias por empleado")
    public ResponseEntity<ResumenAsistenciaDTO> obtenerResumenAsistencia(
            @RequestParam Long empleadoId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fechaDesde,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fechaHasta) {
        
        ResumenAsistenciaDTO resumen = asistenciaService.obtenerResumenAsistencia(
                empleadoId, fechaDesde, fechaHasta);
        return ResponseEntity.ok(resumen);
    }
}