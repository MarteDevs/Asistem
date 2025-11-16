package com.empresa.asistencia.exception;

public class RecursoNoEncontradoException extends SistemaAsistenciaException {
    
    public RecursoNoEncontradoException(String message) {
        super(message);
    }
    
    public RecursoNoEncontradoException(String recurso, Long id) {
        super(recurso + " con ID " + id + " no encontrado");
    }
}