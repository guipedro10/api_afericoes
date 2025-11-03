package com.apijob.controller;

import com.apijob.model.Afericao;
import com.apijob.service.AfericaoService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/afericoes")
public class AfericaoController {

    @Autowired
    private AfericaoService afericaoService;

    @GetMapping
    public ResponseEntity<List<Afericao>> listarTodas() {
        List<Afericao> afericoes = afericaoService.listarTodas();
        return ResponseEntity.ok(afericoes);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Afericao> buscarPorId(@PathVariable Long id) {
        Optional<Afericao> afericao = afericaoService.buscarPorId(id);
        
        if (afericao.isPresent()) {
            return ResponseEntity.ok(afericao.get());
        }
        
        return ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Afericao> criar(@Valid @RequestBody Afericao afericao) {
        Afericao novaAfericao = afericaoService.criar(afericao);
        return ResponseEntity.status(HttpStatus.CREATED).body(novaAfericao);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Afericao> atualizar(@PathVariable Long id, @Valid @RequestBody Afericao afericao) {
        Afericao afericaoAtualizada = afericaoService.atualizar(id, afericao);
        
        if (afericaoAtualizada != null) {
            return ResponseEntity.ok(afericaoAtualizada);
        }
        
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        boolean deletado = afericaoService.deletar(id);
        
        if (deletado) {
            return ResponseEntity.noContent().build();
        }
        
        return ResponseEntity.notFound().build();
    }
}

