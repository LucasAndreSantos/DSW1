package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import java.util.List; // Add this import for List
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import br.ufscar.dc.dsw.model.UsuarioGeral;
public interface UsuarioGeralRepository extends JpaRepository<UsuarioGeral, Long> {
    @Query(value = "SELECT u.username FROM usuariogeral u JOIN usuariolocadora ul ON u.cpf_cnpj  = ul.cnpj ", nativeQuery = true)
    List<String> comercialpartners();

    @Query(value = "SELECT u.username FROM usuariogeral u JOIN usuariocliente ul ON u.cpf_cnpj  = ul.cpf ", nativeQuery = true)
    List<String> allclients();

    @Modifying
    @Query("UPDATE UsuarioGeral u SET u.username = :username, u.email = :email, u.hierarquia = :hierarquia, u.senha = :senha WHERE u.cpf_cnpj = :cpfCnpj")
    void updateUsuarioGeralData(@Param("cpfCnpj") String cpfCnpj, @Param("username") String username, @Param("email") String email,
                                @Param("hierarquia") int hierarquia, @Param("senha") String senha);

    UsuarioGeral findByUsername(String username);

    @Query("SELECT u FROM UsuarioGeral u WHERE u.cpf_cnpj = :cpfCnpj")
    UsuarioGeral findByCpfCnpj(@Param("cpfCnpj") String cpfCnpj);

    @Query("SELECT DISTINCT u FROM UsuarioGeral u JOIN UsuarioLocadora l ON u.cpf_cnpj = l.cnpj")
    List<UsuarioGeral> findByCnpjInUsuarioLocadora();

    @Query("SELECT COUNT(l) > 0 FROM UsuarioGeral u JOIN UsuarioLocadora l ON u.cpf_cnpj = l.cnpj WHERE u.username = :username")
    boolean existsByUsernameInUsuarioLocadora(@Param("username") String username);


    @Query("SELECT u.cpf_cnpj FROM UsuarioGeral u WHERE u.username = :username")
    String findCnpjByUsername(@Param("username") String username);

    void delete(UsuarioGeral usuario);

    // Add the saveUsuarioLGeral method
    UsuarioGeral save(UsuarioGeral usuario);


}
