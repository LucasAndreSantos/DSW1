package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.Locacoes;
import java.util.List;

public interface LocacoesRepository extends JpaRepository<Locacoes, Long> {
    List<Locacoes> findByCpf(String cpf);

    List<Locacoes> findByCnpj(String cnpj);
}
