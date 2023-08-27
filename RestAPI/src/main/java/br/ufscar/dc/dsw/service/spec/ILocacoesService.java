package br.ufscar.dc.dsw.service.spec;

import java.util.Date;
import java.util.List;
import br.ufscar.dc.dsw.model.Locacoes;

public interface ILocacoesService {

    void salvar(Locacoes locacao);

    void excluir(Locacoes locacao);

    List<Locacoes> buscarPorCpf(String cpf);

    List<Locacoes> buscarPorCnpj(String cnpj);

    Locacoes buscarPorId(long id);

    List<Locacoes> buscarTodos();

    long contaPorCpf(String cpf, Date startTime, Date endTime);

    long contaPorCnpj(String cnpj, Date startTime, Date endTime);
    
    List<Locacoes> buscarPorCnpjouCpf(String document);
}