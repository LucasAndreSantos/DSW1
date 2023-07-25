package br.ufscar.dc.dsw.service.spec;

import java.util.List;

import br.ufscar.dc.dsw.model.Locacoes;

public interface ILocacoesService {

    List<Locacoes> buscarPorCpf(String cpf);

    List<Locacoes> buscarPorCnpj(String cnpj);
}