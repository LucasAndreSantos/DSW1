package br.ufscar.dc.dsw.service.spec;

import java.util.Date;
import java.util.List;
import br.ufscar.dc.dsw.model.Locacoes;

public interface ILocacoesService {

    void salvar(Locacoes locacao);

    List<Locacoes> buscarPorCpf(String cpf);

    List<Locacoes> buscarPorCnpj(String cnpj);

    List<Locacoes> buscarTodos();

    void contaPorCpf(String cpf, Date startTime, Date endTime);

    void contaPorCnpj(String cnpj, Date startTime, Date endTime);
}