package br.ufscar.dc.dsw.model;
import java.time.LocalDate;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.Table;
import java.sql.Date;

@Entity
@Table(name = "usuariocliente")
public class UsuarioCliente {

    @Id
    private String cpf;
    private String sexo;
    private String telefone;

    @Column(name = "data_de_nascimento")
    private Date dataDeNascimento;

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public Date getDataDeNascimento() {
        return dataDeNascimento;
    }

    public void setDataDeNascimento(String dataDeNascimento) {
        // Parse the input String to LocalDate
        LocalDate localDate = LocalDate.parse(dataDeNascimento);

        // Convert LocalDate to java.sql.Date
        this.dataDeNascimento = Date.valueOf(localDate);
    }
}
