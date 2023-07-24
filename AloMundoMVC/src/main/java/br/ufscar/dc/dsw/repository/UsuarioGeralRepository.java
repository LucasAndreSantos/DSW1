package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import java.util.List; // Add this import for List
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import br.ufscar.dc.dsw.model.UsuarioGeral;
public interface UsuarioGeralRepository extends JpaRepository<UsuarioGeral, Long> {
    @Query(value = "SELECT u.username FROM usuariogeral u JOIN usuariolocadora ul ON u.cpf_cnpj  = ul.cnpj ", nativeQuery = true)
    List<String> comercialpartners();

    @Query(value = "SELECT u.username FROM usuariogeral u JOIN usuariocliente ul ON u.cpf_cnpj  = ul.cpf ", nativeQuery = true)
    List<String> allclients();

    UsuarioGeral findByUsername(String username);

}
