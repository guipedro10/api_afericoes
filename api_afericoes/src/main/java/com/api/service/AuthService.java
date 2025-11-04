package com.api.service;

import com.api.config.DataInitializer;
import com.api.dto.AuthRequest;
import com.api.dto.AuthResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public AuthResponse autenticar(AuthRequest authRequest) {
        String nomeUsuario = authRequest.getNomeDeUsuario();
        String senha = authRequest.getSenha();

        String senhaHash = DataInitializer.USUARIOS.get(nomeUsuario);
        
        if (senhaHash == null || !passwordEncoder.matches(senha, senhaHash)) {
            return null; 
        }

        String token = jwtService.generateToken(nomeUsuario);
        
        return new AuthResponse(token);
    }
}

