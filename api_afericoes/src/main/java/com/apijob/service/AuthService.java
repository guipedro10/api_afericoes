package com.apijob.service;

import com.apijob.config.DataInitializer;
import com.apijob.dto.AuthRequest;
import com.apijob.dto.AuthResponse;
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

        // Verificar se o usuário existe
        String senhaHash = DataInitializer.USUARIOS.get(nomeUsuario);
        
        if (senhaHash == null || !passwordEncoder.matches(senha, senhaHash)) {
            return null; // Credenciais inválidas
        }

        // Gerar token JWT
        String token = jwtService.generateToken(nomeUsuario);
        
        return new AuthResponse(token);
    }
}

