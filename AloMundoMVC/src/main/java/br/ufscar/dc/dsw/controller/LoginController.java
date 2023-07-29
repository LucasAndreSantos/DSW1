package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.repository.LocacoesRepository; //PRECISO CRIAR O SERVICE DESSE AINDA

//import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;

import javax.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.UsuarioGeral;

@Controller
public class LoginController {

    @Autowired
    private IUsuarioGeralService usuarioGeralService;
    //private UsuarioGeralRepository usuarioGeralRepository;

    @GetMapping("/loginpage")
    public String getAllUsuarios(Model model) {
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username, 
                        @RequestParam String password, 
                        HttpSession session) {

        // Find the user by username from the repository
        //UsuarioGeral user = usuarioGeralRepository.findByUsername(username);
        UsuarioGeral user = usuarioGeralService.buscarPorNome(username);

        if (user != null && user.getSenha().equals(password)) {
            // Authentication successful, store the user in the session
            int hierarquia = user.isHierarquia();

            // Create a UserSession object with the user and hierarquia

            session.setAttribute("user", user);
            session.setAttribute("hierarquia", hierarquia);
            return "redirect:/"; // Redirect to the home page or any other authenticated page
        } else {
            // Authentication failed, handle the error (e.g., show an error message)
            return "redirect:/login?error=true"; // Redirect back to the login page with an error parameter
        }
    }
}