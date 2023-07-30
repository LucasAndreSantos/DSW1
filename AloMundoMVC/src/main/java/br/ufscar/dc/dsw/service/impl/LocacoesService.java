package br.ufscar.dc.dsw.service.impl;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.repository.LocacoesRepository;
import br.ufscar.dc.dsw.service.spec.ILocacoesService;

@Service
@Transactional(readOnly = false)
public class LocacoesService implements ILocacoesService {

    @Autowired
    private LocacoesRepository dao;

    public void salvar(Locacoes locacao) {
		dao.save(locacao);
	}

    public void excluir(Locacoes locacao) {
		dao.delete(locacao);
	}

    @Transactional(readOnly = true)
    public List<Locacoes> buscarPorCpf(String cpf) {
        return dao.findByCpf(cpf);
    }

    @Transactional(readOnly = true)
    public List<Locacoes> buscarPorCnpj(String cnpj) {
        return dao.findByCnpj(cnpj);
    }

    @Transactional(readOnly = true)
    public List<Locacoes> buscarTodos() {
        return dao.findAll();
    }

    @Transactional(readOnly = true)
    public long contaPorCpf(String cpf, Date startTime, Date endTime) {
        return dao.countByCpfAndTimeRange(cpf, startTime, endTime);
    }

    @Transactional(readOnly = true)
    public long contaPorCnpj(String cnpj, Date startTime, Date endTime) {
        return dao.countByCnpjAndTimeRange(cnpj, startTime, endTime);
    }

    @Transactional(readOnly = true)
    public List<Locacoes> buscarPorCnpjouCpf(String document){
        return dao.findByCpfOrCnpj(document);
    }

}