package br.ufscar.dc.dsw.service.spec;

import br.ufscar.dc.dsw.model.UsuarioCliente;

public interface IUsuarioClienteService {

    UsuarioCliente buscarPorCpf(String cpf);

    void atualizarDadosUsuario(String cpf, String sexo, String telefone, String dataNascimento);

    void salvar(UsuarioCliente cliente);

    void excluir(UsuarioCliente cliente);
}