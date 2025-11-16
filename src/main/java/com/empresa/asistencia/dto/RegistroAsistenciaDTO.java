package com.empresa.asistencia.dto;

import com.empresa.asistencia.entity.EstadoAsistencia;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegistroAsistenciaDTO {

    private Long id;

    @NotNull(message = "El empleado es obligatorio")
    private Long empleadoId;

    private String empleadoNombre;

    private String departamentoNombre;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate fecha;

    @JsonFormat(pattern = "HH:mm:ss")
    private LocalTime horaEntrada;

    @JsonFormat(pattern = "HH:mm:ss")
    private LocalTime horaSalida;

    private EstadoAsistencia estado;

    private String observacion;
}