package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.UsuarioCliente;

public interface UsuarioClienteRepository extends JpaRepository<UsuarioCliente, Long> {
    UsuarioCliente findByCpf(String cpf);
}
