package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.Locacoes;
import java.util.List;
import java.time.LocalDateTime;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;
import java.util.Date;

public interface LocacoesRepository extends JpaRepository<Locacoes, Long> {
    List<Locacoes> findByCpf(String cpf);

    List<Locacoes> findByCnpj(String cnpj);

    List<Locacoes> findAll();

    // Count the number of rentals for a given CPF that overlap with the specified time range
    @Query("SELECT COUNT(*) FROM Locacoes WHERE cpf = :cpf AND (horalocacao < :endTime AND horadevolucao > :startTime)")
    long countByCpfAndTimeRange(@Param("cpf") String cpf,
                                @Param("startTime") Date startTime,
                                @Param("endTime") Date endTime);

    @Query("SELECT COUNT(*) FROM Locacoes WHERE cnpj = :cnpj AND (horalocacao < :endTime AND horadevolucao > :startTime)")
    long countByCnpjAndTimeRange(@Param("cnpj") String cnpj,
                                 @Param("startTime") Date startTime,
                                 @Param("endTime") Date endTime);
}
