package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.UsuarioLocadora;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.repository.UsuarioLocadoraRepository;
import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import br.ufscar.dc.dsw.repository.LocacoesRepository;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class UsuarioLocadoraController {

    @Autowired
    private UsuarioLocadoraRepository usuarioLocadoraRepository;

    @Autowired
    private UsuarioGeralRepository usuarioGeralRepository;

    @Autowired
    private LocacoesRepository locacoesRepository;
        

    @GetMapping("/testeusuariolocadora")
    public String getAllUsuarios(Model model) {
        List<UsuarioLocadora> usuarios = usuarioLocadoraRepository.findAll();
        model.addAttribute("usuarios", usuarios);
        return "testeclientelocadora";
    }

    @GetMapping("/buscarcidades")
    public String getDistincntCity(Model model) {
        List<String> cidades = usuarioLocadoraRepository.findDistinctCidades();
        model.addAttribute("cidades", cidades);
        return "buscarcidades";
    }

    @PostMapping("/resultadocidades")
    public String resultadocidades(@RequestParam("cidade") String cidade, Model model) {
        List<String> users = usuarioLocadoraRepository.findUsernamesByCidade(cidade);
        model.addAttribute("cidade", cidade);
        model.addAttribute("users", users);
        return "resultadocidades";
    }

    @GetMapping("/registrarlocadora")
    public String registrarlocadora(Model model) {
        return "registrarlocadora";
    }

    @GetMapping("/readlocadora")
    public String getUserInfo(@RequestParam String usuariolocadora, Model model) {
        // Fetch the user by username from the repository
        UsuarioGeral user = usuarioGeralRepository.findByUsername(usuariolocadora);
        UsuarioLocadora locadora = usuarioLocadoraRepository.findByCnpj(user.getCpfCnpj());
        model.addAttribute("user", user);
        model.addAttribute("locadora", locadora);
        return "placeinfo"; // Return the name of the Thymeleaf template (userinfo.html)

    }

    @PostMapping("/Insertlocadora")
    public ModelAndView insertlocadora(@RequestParam String username,
                                      @RequestParam String cpf_cnpj,
                                      @RequestParam String email,
                                      @RequestParam String cidade,
                                      @RequestParam String senha) {

        boolean insertSuccess = true;
        int hierarquiafinal = 0;



        UsuarioGeral usuarioGeral = new UsuarioGeral();
        usuarioGeral.setUsername(username);
        usuarioGeral.setCpfCnpj(cpf_cnpj);
        usuarioGeral.setEmail(email);
        usuarioGeral.setHierarquia(hierarquiafinal);
        usuarioGeral.setSenha(senha);
        UsuarioLocadora usuarioLocadora = new UsuarioLocadora();
        usuarioLocadora.setCnpj(cpf_cnpj);
        usuarioLocadora.setCidade(cidade);
        if (usuarioLocadoraRepository.findByCnpj(cpf_cnpj) == null){
            usuarioGeralRepository.save(usuarioGeral);
            usuarioLocadoraRepository.save(usuarioLocadora);
            insertSuccess = true;
        }
        else{
            insertSuccess = false;
        }

        // If the code reaches this point, the insert was successful
        ModelAndView successModelAndView = new ModelAndView("insertlocadora");
        successModelAndView.addObject("insertSuccess", insertSuccess);
        return successModelAndView;
    }

    @GetMapping("/deleteLocadora")
    public ModelAndView deleteLocadora(@RequestParam String usuariolocadora) {

        boolean insertSuccess = false;

        // Find the existing UsuarioGeral and UsuarioCliente objects to update
        UsuarioGeral usuarioGeral = usuarioGeralRepository.findByUsername(usuariolocadora);
        UsuarioLocadora usuarioLocadora = usuarioLocadoraRepository.findByCnpj(usuarioGeral.getCpfCnpj());
        List<Locacoes> locacoesList = locacoesRepository.findByCnpj(usuarioGeral.getCpfCnpj());
        if (usuarioGeral != null && usuarioLocadora != null) {    
            for (Locacoes locacao : locacoesList) {
                locacoesRepository.delete(locacao);
            }
            usuarioLocadoraRepository.delete(usuarioLocadora);
            usuarioGeralRepository.delete(usuarioGeral);
            insertSuccess = true;
        }

        else {
            // If the user does not exist, handle the error (e.g., show an error message)
            insertSuccess = false;
        }

        // If the code reaches this point, the update was successful
        ModelAndView successModelAndView = new ModelAndView("insertcliente");
        successModelAndView.addObject("insertSuccess", insertSuccess);
        return successModelAndView;
    }

    @GetMapping("/editarlocadora")
    public String editarlocadora(@RequestParam String usuariolocadora, Model model) {
        // Fetch the user by username from the repository
        UsuarioGeral usuarioGeral = usuarioGeralRepository.findByUsername(usuariolocadora);
        UsuarioLocadora usuarioLocadora = usuarioLocadoraRepository.findByCnpj(usuarioGeral.getCpfCnpj());
        
        // Pass the existing client data to the view
        model.addAttribute("usuarioGeral", usuarioGeral);
        model.addAttribute("usuarioLocadora", usuarioLocadora);
        return "editarlocadora"; // Return the name of the Thymeleaf template (editarcliente.html)
    }

    @PostMapping("/UpdateLocadora")
    public ModelAndView updateLocadora(@RequestParam String username,
                                    @RequestParam String cpf_cnpj,
                                    @RequestParam String email,
                                    @RequestParam String cidade,
                                    @RequestParam String senha) {

        boolean insertSuccess = false;

        // Find the existing UsuarioGeral and UsuarioLocadora objects to update
        UsuarioGeral usuarioGeral = usuarioGeralRepository.findByCpfCnpj(cpf_cnpj);
        UsuarioLocadora usuarioLocadora = usuarioLocadoraRepository.findByCnpj(cpf_cnpj);

        if (usuarioGeral != null && usuarioLocadora != null) {
            // Update the UsuarioGeral and UsuarioLocadora objects with new data
            usuarioGeral.setUsername(username);
            usuarioGeral.setEmail(email);
            usuarioGeral.setSenha(senha);
            usuarioGeral.setHierarquia(0);

            usuarioLocadora.setCidade(cidade);

            usuarioGeralRepository.save(usuarioGeral);
            usuarioLocadoraRepository.save(usuarioLocadora);

            insertSuccess = true;
        } else {
            // If the locadora does not exist, handle the error (e.g., show an error message)
            insertSuccess = false;
        }
        // If the code reaches this point, the update was successful
        ModelAndView successModelAndView = new ModelAndView("insertlocadora");
        successModelAndView.addObject("insertSuccess", insertSuccess);
        return successModelAndView;
    }


}
