package com.example.MyVPNCentral.MyException;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;


import java.time.LocalDateTime;

@ControllerAdvice
public class MyExceptionHandler {

    @ExceptionHandler(Exception.class)
    public final ResponseEntity<Object> myhandleException(Exception ex, WebRequest request) throws Exception {
        MyErrorDetails myErrorDetails=new MyErrorDetails(LocalDateTime.now(),ex.getMessage(), request.getDescription(false));
        return new ResponseEntity<>(myErrorDetails, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(AppRuntimeException.class)
    public final ResponseEntity<Object> myhandleException2(Exception ex, WebRequest request) throws Exception {
        MyErrorDetails myErrorDetails=new MyErrorDetails(LocalDateTime.now(),ex.getMessage(), request.getDescription(false));
        return new ResponseEntity<>(myErrorDetails, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
