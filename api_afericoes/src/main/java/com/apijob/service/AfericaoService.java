package com.apijob.service;

import com.apijob.model.Afericao;
import com.apijob.repository.AfericaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AfericaoService {

    @Autowired
    private AfericaoRepository afericaoRepository;

    public List<Afericao> listarTodas() {
        return afericaoRepository.findAll();
    }

    public Optional<Afericao> buscarPorId(Long id) {
        return afericaoRepository.findById(id);
    }

    public Afericao criar(Afericao afericao) {
        return afericaoRepository.save(afericao);
    }

    public Afericao atualizar(Long id, Afericao afericaoAtualizada) {
        Optional<Afericao> afericaoExistente = afericaoRepository.findById(id);
        
        if (afericaoExistente.isPresent()) {
            Afericao afericao = afericaoExistente.get();
            afericao.setIdSensor(afericaoAtualizada.getIdSensor());
            afericao.setUnidade(afericaoAtualizada.getUnidade());
            afericao.setValor(afericaoAtualizada.getValor());
            return afericaoRepository.save(afericao);
        }
        
        return null;
    }

    public boolean deletar(Long id) {
        if (afericaoRepository.existsById(id)) {
            afericaoRepository.deleteById(id);
            return true;
        }
        return false;
    }
}

