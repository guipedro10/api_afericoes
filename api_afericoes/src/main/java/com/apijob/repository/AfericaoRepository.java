package com.apijob.repository;

import com.apijob.model.Afericao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AfericaoRepository extends JpaRepository<Afericao, Long> {
}

