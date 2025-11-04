package com.api.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;


@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private PasswordEncoder passwordEncoder;

    public static final Map<String, String> USUARIOS = new HashMap<>();

    @Override
    public void run(String... args) throws Exception {
        String senhaHash = passwordEncoder.encode("senha123");
        USUARIOS.put("admin", senhaHash);
        
        System.out.println("Usuário padrão inicializado:");
        System.out.println("  Usuário: admin");
        System.out.println("  Senha: senha123");
    }
}

