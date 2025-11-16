package com.empresa.asistencia.service;

import com.empresa.asistencia.dto.EmpleadoDTO;
import com.empresa.asistencia.entity.Departamento;
import com.empresa.asistencia.entity.Empleado;
import com.empresa.asistencia.entity.EstadoEmpleado;
import com.empresa.asistencia.exception.RecursoNoEncontradoException;
import com.empresa.asistencia.exception.RegistroDuplicadoException;
import com.empresa.asistencia.repository.DepartamentoRepository;
import com.empresa.asistencia.repository.EmpleadoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class EmpleadoService {

    private final EmpleadoRepository empleadoRepository;
    private final DepartamentoRepository departamentoRepository;

    public EmpleadoDTO crearEmpleado(EmpleadoDTO empleadoDTO) {
        validarEmailUnico(empleadoDTO.getEmail());
        validarDniUnico(empleadoDTO.getDni());

        Departamento departamento = departamentoRepository.findById(empleadoDTO.getDepartamentoId())
                .orElseThrow(() -> new RecursoNoEncontradoException("Departamento", empleadoDTO.getDepartamentoId()));

        Empleado empleado = new Empleado();
        empleado.setNombreCompleto(empleadoDTO.getNombreCompleto());
        empleado.setEmail(empleadoDTO.getEmail());
        empleado.setDni(empleadoDTO.getDni());
        empleado.setEstado(empleadoDTO.getEstado() != null ? empleadoDTO.getEstado() : EstadoEmpleado.ACTIVO);
        empleado.setDepartamento(departamento);

        Empleado empleadoGuardado = empleadoRepository.save(empleado);
        return convertirADTO(empleadoGuardado);
    }

    @Transactional(readOnly = true)
    public List<EmpleadoDTO> obtenerTodosLosEmpleados() {
        return empleadoRepository.findAll().stream()
                .map(this::convertirADTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<EmpleadoDTO> obtenerTodosLosEmpleadosPaginado(Pageable pageable) {
        return empleadoRepository.findAll(pageable)
                .map(this::convertirADTO);
    }

    @Transactional(readOnly = true)
    public Page<EmpleadoDTO> obtenerEmpleadosPorEstado(EstadoEmpleado estado, Pageable pageable) {
        return empleadoRepository.findByEstado(estado, pageable)
                .map(this::convertirADTO);
    }

    @Transactional(readOnly = true)
    public Page<EmpleadoDTO> obtenerEmpleadosPorDepartamento(Long departamentoId, Pageable pageable) {
        return empleadoRepository.findByDepartamentoId(departamentoId, pageable)
                .map(this::convertirADTO);
    }

    @Transactional(readOnly = true)
    public EmpleadoDTO obtenerEmpleadoPorId(Long id) {
        Empleado empleado = empleadoRepository.findById(id)
                .orElseThrow(() -> new RecursoNoEncontradoException("Empleado", id));
        return convertirADTO(empleado);
    }

    public EmpleadoDTO actualizarEmpleado(Long id, EmpleadoDTO empleadoDTO) {
        Empleado empleado = empleadoRepository.findById(id)
                .orElseThrow(() -> new RecursoNoEncontradoException("Empleado", id));

        if (!empleado.getEmail().equals(empleadoDTO.getEmail())) {
            validarEmailUnico(empleadoDTO.getEmail());
        }

        if (empleadoDTO.getDni() != null && !empleadoDTO.getDni().equals(empleado.getDni())) {
            validarDniUnico(empleadoDTO.getDni());
        }

        if (!empleado.getDepartamento().getId().equals(empleadoDTO.getDepartamentoId())) {
            Departamento departamento = departamentoRepository.findById(empleadoDTO.getDepartamentoId())
                    .orElseThrow(() -> new RecursoNoEncontradoException("Departamento", empleadoDTO.getDepartamentoId()));
            empleado.setDepartamento(departamento);
        }

        empleado.setNombreCompleto(empleadoDTO.getNombreCompleto());
        empleado.setEmail(empleadoDTO.getEmail());
        empleado.setDni(empleadoDTO.getDni());
        empleado.setEstado(empleadoDTO.getEstado());

        Empleado empleadoActualizado = empleadoRepository.save(empleado);
        return convertirADTO(empleadoActualizado);
    }

    public void darDeBajaEmpleado(Long id) {
        Empleado empleado = empleadoRepository.findById(id)
                .orElseThrow(() -> new RecursoNoEncontradoException("Empleado", id));
        
        empleado.setEstado(EstadoEmpleado.INACTIVO);
        empleadoRepository.save(empleado);
    }

    private void validarEmailUnico(String email) {
        if (empleadoRepository.existsByEmail(email)) {
            throw new RegistroDuplicadoException("Ya existe un empleado con el email: " + email);
        }
    }

    private void validarDniUnico(String dni) {
        if (dni != null && empleadoRepository.existsByDni(dni)) {
            throw new RegistroDuplicadoException("Ya existe un empleado con el DNI: " + dni);
        }
    }

    private EmpleadoDTO convertirADTO(Empleado empleado) {
        EmpleadoDTO dto = new EmpleadoDTO();
        dto.setId(empleado.getId());
        dto.setNombreCompleto(empleado.getNombreCompleto());
        dto.setEmail(empleado.getEmail());
        dto.setDni(empleado.getDni());
        dto.setEstado(empleado.getEstado());
        dto.setDepartamentoId(empleado.getDepartamento().getId());
        dto.setDepartamentoNombre(empleado.getDepartamento().getNombre());
        return dto;
    }
}