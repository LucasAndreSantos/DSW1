package br.ufscar.dc.dsw.service.spec;

import java.util.List;

import br.ufscar.dc.dsw.model.UsuarioGeral;

public interface IUsuarioGeralService {

    List<UsuarioGeral> buscarTodosUsuarios();

    List<String> buscarParceirosComerciais();

    List<String> buscarTodosClientes();

    void atualizarDadosUsuario(String cpfCnpj, String username, String email, int hierarquia, String senha);

    UsuarioGeral buscarPorNome(String username);

    UsuarioGeral buscarPorCpfCnpj(String cpfCnpj);

    void excluir(UsuarioGeral usuario);

    void salvar(UsuarioGeral usuario);

    List<UsuarioGeral> buscarPorCnpjInUsuarioLocadora();

    boolean existeNomeemUsuarioLocadora(String username);

    String encontrarCnpjPorNome(String username);
}