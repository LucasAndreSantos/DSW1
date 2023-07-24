package br.ufscar.dc.dsw.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "locacoes")
public class Locacoes {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String cpf;
    private String cnpj;
    private Date horalocacao;
    private Date horadevolucao;

    // Constructors, Getters, and Setters

    public Locacoes() {
        // Default constructor (required by JPA)
    }

    public Locacoes(String cpf, String cnpj, Date horalocacao, Date horadevolucao) {
        this.cpf = cpf;
        this.cnpj = cnpj;
        this.horalocacao = horalocacao;
        this.horadevolucao = horadevolucao;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public Date getHoralocacao() {
        return horalocacao;
    }

    public void setHoralocacao(Date horalocacao) {
        this.horalocacao = horalocacao;
    }

    public Date getHoradevolucao() {
        return horadevolucao;
    }

    public void setHoradevolucao(Date horadevolucao) {
        this.horadevolucao = horadevolucao;
    }
}
