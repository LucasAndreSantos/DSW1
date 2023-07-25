package br.ufscar.dc.dsw.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.ufscar.dc.dsw.model.UsuarioCliente;
import br.ufscar.dc.dsw.repository.UsuarioClienteRepository;
import br.ufscar.dc.dsw.service.spec.IUsuarioClienteService;

@Service
@Transactional(readOnly = false)
public class UsuarioClienteService implements IUsuarioClienteService {

    @Autowired
    private UsuarioClienteRepository dao;

    public void atualizarDadosUsuario(String cpf, String sexo, String telefone, String dataNascimento) {
        dao.updateUsuarioClienteData(cpf, sexo, telefone, dataNascimento);
    }

    @Transactional(readOnly = true)
    public UsuarioCliente buscarPorCpf(String cpf) {
        return dao.findByCpf(cpf);
    }

    
}