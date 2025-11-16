package com.empresa.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResumenAsistenciaDTO {

    private Long empleadoId;
    private String empleadoNombre;
    private String departamentoNombre;
    private Long totalDiasTrabajados;
    private Long totalPresentes;
    private Long totalTardanzas;
    private Long totalAusencias;
    private Double porcentajeAsistencia;
}