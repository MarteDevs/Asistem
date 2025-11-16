package com.empresa.asistencia.service;

import com.empresa.asistencia.dto.*;
import com.empresa.asistencia.entity.*;
import com.empresa.asistencia.exception.RecursoNoEncontradoException;
import com.empresa.asistencia.exception.ValidacionNegocioException;
import com.empresa.asistencia.repository.EmpleadoRepository;
import com.empresa.asistencia.repository.RegistroAsistenciaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class AsistenciaService {

    private final RegistroAsistenciaRepository registroAsistenciaRepository;
    private final EmpleadoRepository empleadoRepository;

    private static final LocalTime HORA_LIMITE_ENTRADA = LocalTime.of(9, 0); // 9:00 AM

    public RegistroAsistenciaDTO marcarEntrada(MarcarEntradaDTO marcarEntradaDTO) {
        Empleado empleado = empleadoRepository.findById(marcarEntradaDTO.getEmpleadoId())
                .orElseThrow(() -> new RecursoNoEncontradoException("Empleado", marcarEntradaDTO.getEmpleadoId()));

        if (empleado.getEstado() == EstadoEmpleado.INACTIVO) {
            throw new ValidacionNegocioException("No se puede marcar entrada de un empleado inactivo");
        }

        LocalDate fecha = marcarEntradaDTO.getFecha() != null ? marcarEntradaDTO.getFecha() : LocalDate.now();
        LocalTime horaEntrada = marcarEntradaDTO.getHoraEntrada() != null ? marcarEntradaDTO.getHoraEntrada() : LocalTime.now();

        // Verificar si ya existe un registro de entrada para este empleado en esta fecha sin salida
        registroAsistenciaRepository.findByEmpleadoIdAndFecha(empleado.getId(), fecha)
                .ifPresent(registro -> {
                    if (registro.getHoraSalida() == null) {
                        throw new ValidacionNegocioException("El empleado ya tiene una entrada registrada para esta fecha sin marcar salida");
                    }
                });

        RegistroAsistencia registroAsistencia = new RegistroAsistencia();
        registroAsistencia.setEmpleado(empleado);
        registroAsistencia.setFecha(fecha);
        registroAsistencia.setHoraEntrada(horaEntrada);
        registroAsistencia.setEstado(calcularEstadoAsistencia(horaEntrada));
        registroAsistencia.setObservacion(marcarEntradaDTO.getObservacion());

        RegistroAsistencia registroGuardado = registroAsistenciaRepository.save(registroAsistencia);
        return convertirADTO(registroGuardado);
    }

    public RegistroAsistenciaDTO marcarSalida(MarcarSalidaDTO marcarSalidaDTO) {
        Empleado empleado = empleadoRepository.findById(marcarSalidaDTO.getEmpleadoId())
                .orElseThrow(() -> new RecursoNoEncontradoException("Empleado", marcarSalidaDTO.getEmpleadoId()));

        LocalDate fecha = marcarSalidaDTO.getFecha() != null ? marcarSalidaDTO.getFecha() : LocalDate.now();
        LocalTime horaSalida = marcarSalidaDTO.getHoraSalida() != null ? marcarSalidaDTO.getHoraSalida() : LocalTime.now();

        RegistroAsistencia registroAsistencia = registroAsistenciaRepository.findByEmpleadoIdAndFecha(empleado.getId(), fecha)
                .orElseThrow(() -> new ValidacionNegocioException("No se encontró un registro de entrada para este empleado en la fecha especificada"));

        if (registroAsistencia.getHoraSalida() != null) {
            throw new ValidacionNegocioException("El empleado ya tiene registrada una salida para esta fecha");
        }

        registroAsistencia.setHoraSalida(horaSalida);
        registroAsistencia.setObservacion(marcarSalidaDTO.getObservacion());

        RegistroAsistencia registroActualizado = registroAsistenciaRepository.save(registroAsistencia);
        return convertirADTO(registroActualizado);
    }

    @Transactional(readOnly = true)
    public List<RegistroAsistenciaDTO> obtenerAsistenciasPorEmpleadoYFechas(Long empleadoId, LocalDate fechaDesde, LocalDate fechaHasta) {
        return registroAsistenciaRepository.findByEmpleadoIdAndFechaBetween(empleadoId, fechaDesde, fechaHasta)
                .stream()
                .map(this::convertirADTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<RegistroAsistenciaDTO> obtenerAsistenciasPorDepartamento(Long departamentoId, Pageable pageable) {
        return registroAsistenciaRepository.findByDepartamentoId(departamentoId, pageable)
                .map(this::convertirADTO);
    }

    @Transactional(readOnly = true)
    public Page<RegistroAsistenciaDTO> obtenerAsistenciasPorFiltros(Long empleadoId, Long departamentoId, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable) {
        if (empleadoId != null && fechaDesde != null && fechaHasta != null) {
            return registroAsistenciaRepository.findByEmpleadoIdAndFechaBetween(empleadoId, fechaDesde, fechaHasta, pageable)
                    .map(this::convertirADTO);
        } else if (departamentoId != null) {
            return registroAsistenciaRepository.findByDepartamentoId(departamentoId, pageable)
                    .map(this::convertirADTO);
        } else {
            return registroAsistenciaRepository.findAll(pageable)
                    .map(this::convertirADTO);
        }
    }

    @Transactional(readOnly = true)
    public ResumenAsistenciaDTO obtenerResumenAsistencia(Long empleadoId, LocalDate fechaDesde, LocalDate fechaHasta) {
        Empleado empleado = empleadoRepository.findById(empleadoId)
                .orElseThrow(() -> new RecursoNoEncontradoException("Empleado", empleadoId));

        List<RegistroAsistencia> registros = registroAsistenciaRepository.findByEmpleadoIdAndFechaBetween(empleadoId, fechaDesde, fechaHasta);

        long totalDias = registros.size();
        long totalPresentes = registros.stream().filter(r -> r.getEstado() == EstadoAsistencia.PRESENTE).count();
        long totalTardanzas = registros.stream().filter(r -> r.getEstado() == EstadoAsistencia.TARDANZA).count();
        long totalAusencias = registros.stream().filter(r -> r.getEstado() == EstadoAsistencia.AUSENTE).count();

        double porcentajeAsistencia = totalDias > 0 ? ((double) (totalPresentes + totalTardanzas) / totalDias) * 100 : 0;

        ResumenAsistenciaDTO resumen = new ResumenAsistenciaDTO();
        resumen.setEmpleadoId(empleado.getId());
        resumen.setEmpleadoNombre(empleado.getNombreCompleto());
        resumen.setDepartamentoNombre(empleado.getDepartamento().getNombre());
        resumen.setTotalDiasTrabajados(totalDias);
        resumen.setTotalPresentes(totalPresentes);
        resumen.setTotalTardanzas(totalTardanzas);
        resumen.setTotalAusencias(totalAusencias);
        resumen.setPorcentajeAsistencia(porcentajeAsistencia);

        return resumen;
    }

    private EstadoAsistencia calcularEstadoAsistencia(LocalTime horaEntrada) {
        if (horaEntrada.isAfter(HORA_LIMITE_ENTRADA)) {
            return EstadoAsistencia.TARDANZA;
        }
        return EstadoAsistencia.PRESENTE;
    }

    private RegistroAsistenciaDTO convertirADTO(RegistroAsistencia registro) {
        RegistroAsistenciaDTO dto = new RegistroAsistenciaDTO();
        dto.setId(registro.getId());
        dto.setEmpleadoId(registro.getEmpleado().getId());
        dto.setEmpleadoNombre(registro.getEmpleado().getNombreCompleto());
        dto.setDepartamentoNombre(registro.getEmpleado().getDepartamento().getNombre());
        dto.setFecha(registro.getFecha());
        dto.setHoraEntrada(registro.getHoraEntrada());
        dto.setHoraSalida(registro.getHoraSalida());
        dto.setEstado(registro.getEstado());
        dto.setObservacion(registro.getObservacion());
        return dto;
    }
}