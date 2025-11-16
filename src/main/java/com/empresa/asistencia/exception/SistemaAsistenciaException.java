package com.empresa.asistencia.exception;

public class SistemaAsistenciaException extends RuntimeException {
    
    public SistemaAsistenciaException(String message) {
        super(message);
    }
    
    public SistemaAsistenciaException(String message, Throwable cause) {
        super(message, cause);
    }
}