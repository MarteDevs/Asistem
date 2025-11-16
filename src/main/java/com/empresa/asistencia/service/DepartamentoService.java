package com.empresa.asistencia.service;

import com.empresa.asistencia.dto.DepartamentoDTO;
import com.empresa.asistencia.entity.Departamento;
import com.empresa.asistencia.exception.RecursoNoEncontradoException;
import com.empresa.asistencia.exception.RegistroDuplicadoException;
import com.empresa.asistencia.repository.DepartamentoRepository;
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
public class DepartamentoService {

    private final DepartamentoRepository departamentoRepository;

    public DepartamentoDTO crearDepartamento(DepartamentoDTO departamentoDTO) {
        if (departamentoRepository.existsByNombre(departamentoDTO.getNombre())) {
            throw new RegistroDuplicadoException("Ya existe un departamento con el nombre: " + departamentoDTO.getNombre());
        }

        Departamento departamento = new Departamento();
        departamento.setNombre(departamentoDTO.getNombre());

        Departamento departamentoGuardado = departamentoRepository.save(departamento);
        return convertirADTO(departamentoGuardado);
    }

    @Transactional(readOnly = true)
    public List<DepartamentoDTO> obtenerTodosLosDepartamentos() {
        return departamentoRepository.findAll().stream()
                .map(this::convertirADTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<DepartamentoDTO> obtenerTodosLosDepartamentosPaginado(Pageable pageable) {
        return departamentoRepository.findAll(pageable)
                .map(this::convertirADTO);
    }

    @Transactional(readOnly = true)
    public DepartamentoDTO obtenerDepartamentoPorId(Long id) {
        Departamento departamento = departamentoRepository.findById(id)
                .orElseThrow(() -> new RecursoNoEncontradoException("Departamento", id));
        return convertirADTO(departamento);
    }

    public DepartamentoDTO actualizarDepartamento(Long id, DepartamentoDTO departamentoDTO) {
        Departamento departamento = departamentoRepository.findById(id)
                .orElseThrow(() -> new RecursoNoEncontradoException("Departamento", id));

        if (!departamento.getNombre().equals(departamentoDTO.getNombre()) && 
            departamentoRepository.existsByNombre(departamentoDTO.getNombre())) {
            throw new RegistroDuplicadoException("Ya existe un departamento con el nombre: " + departamentoDTO.getNombre());
        }

        departamento.setNombre(departamentoDTO.getNombre());
        Departamento departamentoActualizado = departamentoRepository.save(departamento);
        return convertirADTO(departamentoActualizado);
    }

    public void eliminarDepartamento(Long id) {
        if (!departamentoRepository.existsById(id)) {
            throw new RecursoNoEncontradoException("Departamento", id);
        }
        departamentoRepository.deleteById(id);
    }

    private DepartamentoDTO convertirADTO(Departamento departamento) {
        DepartamentoDTO dto = new DepartamentoDTO();
        dto.setId(departamento.getId());
        dto.setNombre(departamento.getNombre());
        return dto;
    }
}