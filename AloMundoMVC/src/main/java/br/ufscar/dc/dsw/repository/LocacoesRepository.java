package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.Locacoes;

public interface LocacoesRepository extends JpaRepository<Locacoes, Long> {
    // You can add custom query methods here if needed
}
