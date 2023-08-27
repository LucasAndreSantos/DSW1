package br.ufscar.dc.dsw.service.spec;

import java.util.List;

import br.ufscar.dc.dsw.model.UsuarioLocadora;

public interface IUsuarioLocadoraService {

    List<String> buscarCidades();

    List<String> buscarNomePorCidade(String cidade);

    List<UsuarioLocadora> buscarPorCidade(String cidade);

    UsuarioLocadora buscarPorCnpj(String cnpj);

    void excluir(UsuarioLocadora locadora);

    void salvar(UsuarioLocadora locadora);

    List<UsuarioLocadora> buscarTodos();
}