package com.empresa.asistencia.repository;

import com.empresa.asistencia.entity.RegistroAsistencia;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface RegistroAsistenciaRepository extends JpaRepository<RegistroAsistencia, Long> {
    
    Optional<RegistroAsistencia> findByEmpleadoIdAndFecha(Long empleadoId, LocalDate fecha);
    
    List<RegistroAsistencia> findByEmpleadoIdAndFechaBetween(Long empleadoId, LocalDate fechaDesde, LocalDate fechaHasta);
    
    @Query("SELECT ra FROM RegistroAsistencia ra JOIN ra.empleado e WHERE e.departamento.id = :departamentoId AND ra.fecha BETWEEN :fechaDesde AND :fechaHasta")
    List<RegistroAsistencia> findByDepartamentoIdAndFechaBetween(@Param("departamentoId") Long departamentoId, 
                                                                 @Param("fechaDesde") LocalDate fechaDesde, 
                                                                 @Param("fechaHasta") LocalDate fechaHasta);
    
    @Query("SELECT ra FROM RegistroAsistencia ra JOIN ra.empleado e WHERE e.departamento.id = :departamentoId")
    Page<RegistroAsistencia> findByDepartamentoId(@Param("departamentoId") Long departamentoId, Pageable pageable);
    
    @Query("SELECT ra FROM RegistroAsistencia ra WHERE ra.empleado.id = :empleadoId AND ra.fecha BETWEEN :fechaDesde AND :fechaHasta")
    Page<RegistroAsistencia> findByEmpleadoIdAndFechaBetween(@Param("empleadoId") Long empleadoId, 
                                                            @Param("fechaDesde") LocalDate fechaDesde, 
                                                            @Param("fechaHasta") LocalDate fechaHasta, 
                                                            Pageable pageable);
    
    @Query("SELECT COUNT(ra) FROM RegistroAsistencia ra WHERE ra.empleado.id = :empleadoId AND ra.fecha BETWEEN :fechaDesde AND :fechaHasta AND ra.estado = :estado")
    Long countByEmpleadoIdAndFechaBetweenAndEstado(@Param("empleadoId") Long empleadoId, 
                                                   @Param("fechaDesde") LocalDate fechaDesde, 
                                                   @Param("fechaHasta") LocalDate fechaHasta, 
                                                   @Param("estado") com.empresa.asistencia.entity.EstadoAsistencia estado);
}