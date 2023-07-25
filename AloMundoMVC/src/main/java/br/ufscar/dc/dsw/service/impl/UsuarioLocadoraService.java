package br.ufscar.dc.dsw.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.ufscar.dc.dsw.model.UsuarioLocadora;
import br.ufscar.dc.dsw.repository.UsuarioLocadoraRepository;
import br.ufscar.dc.dsw.service.spec.IUsuarioLocadoraService;

@Service
@Transactional(readOnly = false)
public class UsuarioLocadoraService implements IUsuarioLocadoraService {

    @Autowired
    private UsuarioLocadoraRepository dao;

    @Transactional(readOnly = true)
    public List<String> buscarCidades() {
        return dao.findDistinctCidades();
    }

    @Transactional(readOnly = true)
    public List<String> buscarNomePorCidade(String cidade) {
        return dao.findUsernamesByCidade(cidade);
    }

    @Transactional(readOnly = true)
    public UsuarioLocadora buscarPorCnpj(String cnpj) {
        return dao.findByCnpj(cnpj);
    }
}