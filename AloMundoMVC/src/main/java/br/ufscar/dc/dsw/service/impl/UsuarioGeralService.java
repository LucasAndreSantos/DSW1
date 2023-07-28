package br.ufscar.dc.dsw.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;

@Service
@Transactional(readOnly = false)
public class UsuarioGeralService implements IUsuarioGeralService {

    @Autowired
    private UsuarioGeralRepository dao;

    public void atualizarDadosUsuario(String cpfCnpj, String username, String email, int hierarquia, String senha) {
        dao.updateUsuarioGeralData(cpfCnpj, username, email, hierarquia, senha);
    }

    public void salvar(UsuarioGeral usuario) {
		dao.save(usuario);
	}

	public void excluir(UsuarioGeral usuario) {
		dao.delete(usuario);
	}


    @Transactional(readOnly = true)
    public List<UsuarioGeral> buscarTodosUsuarios() {
        return dao.findAll();
    }

    @Transactional(readOnly = true)
    public List<String> buscarParceirosComerciais() {
        return dao.comercialpartners();
    }

    @Transactional(readOnly = true)
    public List<String> buscarTodosClientes() {
        return dao.allclients();
    }


    @Transactional(readOnly = true)
    public UsuarioGeral buscarPorNome(String username) {
        return dao.findByUsername(username);
    }

    @Transactional(readOnly = true)
    public UsuarioGeral buscarPorCpfCnpj(String cpfCnpj) {
        return dao.findByCpfCnpj(cpfCnpj);
    }
}