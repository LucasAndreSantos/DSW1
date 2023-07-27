package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.repository.LocacoesRepository;
import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import javax.servlet.http.HttpSession;


@Controller
public class LocacoesController {

    @Autowired
    private LocacoesRepository LocacoesRepository;
    
    @Autowired
    private UsuarioGeralRepository usuarioGeralRepository;

    @GetMapping("/testelocacoes")
    public String getAllUsuarios(Model model) {
        List<Locacoes> usuarios = LocacoesRepository.findAll();
        model.addAttribute("usuarios", usuarios);
        return "testelocacoes";
    }


    @GetMapping("/locar")
    public String locar(Model model, HttpSession session) {
        model.addAttribute("user", session.getAttribute("user"));
        // Retrieve the list of usernames from usuariogeral that match cnpj in usuariolocadora
        List<UsuarioGeral> usuariosGeral = usuarioGeralRepository.findByCnpjInUsuarioLocadora();
        model.addAttribute("usuariosGeral", usuariosGeral);

        return "cadastrarlocacao";
    }
}
