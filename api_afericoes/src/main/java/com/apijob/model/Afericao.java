package com.apijob.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "afericoes")
public class Afericao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "ID do sensor é obrigatório")
    @Column(name = "id_sensor", nullable = false)
    private String idSensor;

    @NotBlank(message = "Unidade é obrigatória")
    @Column(nullable = false)
    private String unidade;

    @NotBlank(message = "Valor é obrigatório")
    @Column(nullable = false)
    private String valor;

    // Construtores
    public Afericao() {
    }

    public Afericao(String idSensor, String unidade, String valor) {
        this.idSensor = idSensor;
        this.unidade = unidade;
        this.valor = valor;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getIdSensor() {
        return idSensor;
    }

    public void setIdSensor(String idSensor) {
        this.idSensor = idSensor;
    }

    public String getUnidade() {
        return unidade;
    }

    public void setUnidade(String unidade) {
        this.unidade = unidade;
    }

    public String getValor() {
        return valor;
    }

    public void setValor(String valor) {
        this.valor = valor;
    }
}

