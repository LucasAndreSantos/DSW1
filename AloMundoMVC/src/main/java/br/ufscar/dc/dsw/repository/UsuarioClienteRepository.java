package br.ufscar.dc.dsw.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import br.ufscar.dc.dsw.model.UsuarioCliente;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


public interface UsuarioClienteRepository extends JpaRepository<UsuarioCliente, Long> {
    UsuarioCliente findByCpf(String cpf);

    @Modifying
        @Query("UPDATE UsuarioCliente u SET u.sexo = :sexo, u.telefone = :telefone, u.dataDeNascimento = :dataNascimento WHERE u.cpf = :cpf")
        void updateUsuarioClienteData(@Param("cpf") String cpf, @Param("sexo") String sexo,
                                    @Param("telefone") String telefone, @Param("dataNascimento") String dataNascimento);
    
    void delete(UsuarioCliente cliente);

    
    UsuarioCliente save(UsuarioCliente cliente);
}
