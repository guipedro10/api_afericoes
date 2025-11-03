package com.apijob.controller;

import com.apijob.dto.AuthRequest;
import com.apijob.dto.AuthResponse;
import com.apijob.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping
    public ResponseEntity<?> autenticar(@Valid @RequestBody AuthRequest authRequest) {
        AuthResponse authResponse = authService.autenticar(authRequest);
        
        if (authResponse != null && authResponse.getToken() != null) {
            return ResponseEntity.ok(authResponse);
        }
        
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body("Credenciais inválidas");
    }
}

