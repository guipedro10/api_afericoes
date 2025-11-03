package com.apijob.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * Classe utilitária para inicializar dados.
 * Em produção, isso deveria ser feito através de um serviço de usuários apropriado.
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private PasswordEncoder passwordEncoder;

    // HashMap estático para armazenar usuários (em produção, usar banco de dados)
    public static final Map<String, String> USUARIOS = new HashMap<>();

    @Override
    public void run(String... args) throws Exception {
        // Inicializar usuário padrão: admin / senha123
        // O hash será gerado automaticamente usando BCrypt
        String senhaHash = passwordEncoder.encode("senha123");
        USUARIOS.put("admin", senhaHash);
        
        System.out.println("Usuário padrão inicializado:");
        System.out.println("  Usuário: admin");
        System.out.println("  Senha: senha123");
    }
}

