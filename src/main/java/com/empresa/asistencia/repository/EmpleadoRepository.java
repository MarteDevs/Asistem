package com.empresa.asistencia.repository;

import com.empresa.asistencia.entity.Empleado;
import com.empresa.asistencia.entity.EstadoEmpleado;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface EmpleadoRepository extends JpaRepository<Empleado, Long> {
    
    boolean existsByEmail(String email);
    
    boolean existsByDni(String dni);
    
    Optional<Empleado> findByEmail(String email);
    
    Optional<Empleado> findByDni(String dni);
    
    Page<Empleado> findByEstado(EstadoEmpleado estado, Pageable pageable);
    
    Page<Empleado> findByDepartamentoIdAndEstado(Long departamentoId, EstadoEmpleado estado, Pageable pageable);
    
    @Query("SELECT e FROM Empleado e WHERE e.departamento.id = :departamentoId")
    Page<Empleado> findByDepartamentoId(@Param("departamentoId") Long departamentoId, Pageable pageable);
}