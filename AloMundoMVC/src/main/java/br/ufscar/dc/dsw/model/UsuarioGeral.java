package br.ufscar.dc.dsw.model;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Column;
import javax.persistence.Table;

@Entity
@Table(name = "usuariogeral")
public class UsuarioGeral {

    @Id
    private String cpf_cnpj;
    private String username;
    private String email;
    private int hierarquia;
    private String senha;

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getCpfCnpj() {
        return cpf_cnpj;
    }

    public void setCpfCnpj(String cpf_cnpj) {
        this.cpf_cnpj = cpf_cnpj;
    }

    public int isHierarquia() {
        return hierarquia;
    }

    public void setHierarquia(int hierarquia) {
        this.hierarquia = hierarquia;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }
}
