package br.ufscar.dc.dsw.repository;

import java.util.List; // Import List from java.util
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import br.ufscar.dc.dsw.model.UsuarioLocadora;

public interface UsuarioLocadoraRepository extends JpaRepository<UsuarioLocadora, Long> {
    @Query(value = "SELECT DISTINCT cidade FROM usuariolocadora", nativeQuery = true)
    List<String> findDistinctCidades();

    @Query(value = "SELECT username FROM usuariogeral JOIN usuariolocadora ul ON cpf_cnpj = ul.cnpj WHERE ul.cidade  = ?1", nativeQuery = true)
    List<String> findUsernamesByCidade(String cidade);

    
    UsuarioLocadora findByCnpj(String cnpj);

    
    void delete(UsuarioLocadora locadora);

    
    UsuarioLocadora save(UsuarioLocadora locadora);
}

