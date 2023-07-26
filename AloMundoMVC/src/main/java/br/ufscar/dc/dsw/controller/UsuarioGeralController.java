package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import javax.servlet.http.HttpSession;

@Controller
public class UsuarioGeralController {

    @Autowired
    private UsuarioGeralRepository usuarioGeralRepository;

    @GetMapping("/testeusuariogeral")
    public String getAllUsuarios(Model model) {
        List<UsuarioGeral> usuarios = usuarioGeralRepository.findAll();
        model.addAttribute("usuarios", usuarios);
        return "teste";
    }

    @GetMapping("/adm")
    public String adm(Model model,HttpSession session) {
        if (session.getAttribute("user") == null) {
                model.addAttribute("message", "You are not logged in.");
                return "login";
        }
        else{
            if ((Integer) session.getAttribute("hierarquia") == 1) {
                List<String> commercialpartners = usuarioGeralRepository.comercialpartners();
                List<String> allclients = usuarioGeralRepository.allclients();

                model.addAttribute("commercialpartners", commercialpartners);
                model.addAttribute("allclients", allclients);
                return "adm";
            } else {
                model.addAttribute("message", "You are logged in as a user.");
                return "login";
                
            }
        }    
    }


    @GetMapping("/comercialpartners")
    public String getComercialPartners(Model model) {
        List<String> usernames = usuarioGeralRepository.comercialpartners();
        model.addAttribute("usernames", usernames);
        return "comercialpartners";
    }
}
