package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.UsuarioCliente;
import br.ufscar.dc.dsw.repository.UsuarioClienteRepository;
import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import org.springframework.dao.DataIntegrityViolationException;


@Controller
public class UsuarioClienteController {

    @Autowired
    private UsuarioClienteRepository usuarioClienteRepository;

    @Autowired
    private UsuarioGeralRepository usuarioGeralRepository;
        

    @GetMapping("/testeusuariocliente")
    public String getAllUsuarios(Model model) {
        List<UsuarioCliente> usuarios = usuarioClienteRepository.findAll();
        model.addAttribute("usuarios", usuarios);
        return "testecliente";
    }

    @GetMapping("/registrarcliente")
    public String registrarcliente(Model model) {
        return "registrarcliente";
    }
        
    @GetMapping("/user")
    public String getUserInfo(@RequestParam String usuariocliente, Model model) {
        // Fetch the user by username from the repository
        UsuarioGeral user = usuarioGeralRepository.findByUsername(usuariocliente);
        UsuarioCliente cliente = usuarioClienteRepository.findByCpf(user.getCpfCnpj());
        model.addAttribute("user", user);
        model.addAttribute("cliente", cliente);
        return "userinfo"; // Return the name of the Thymeleaf template (userinfo.html)

    }

    @PostMapping("/InsertCliente")
    public ModelAndView insertCliente(@RequestParam String username,
                                      @RequestParam String cpf_cnpj,
                                      @RequestParam String email,
                                      @RequestParam String datanascimento,
                                      @RequestParam String telefone,
                                      @RequestParam String Sexo,
                                      @RequestParam String hierarquia,
                                      @RequestParam String senha) {

        boolean insertSuccess = false;
        int hierarquiafinal = 0;

        if ("1".equals(hierarquia)){ 
            hierarquiafinal = 1;
        }

        LocalDate dataNascimento;
        try {
            dataNascimento = LocalDate.parse(datanascimento);
        } catch (DateTimeParseException ex) {
            // Handle the exception, e.g., show an error message to the user.
            return new ModelAndView("error"); // Replace "error" with the actual error view.
        }

        UsuarioGeral usuarioGeral = new UsuarioGeral();
        usuarioGeral.setUsername(username);
        usuarioGeral.setCpfCnpj(cpf_cnpj);
        usuarioGeral.setEmail(email);
        usuarioGeral.setHierarquia(hierarquiafinal);
        usuarioGeral.setSenha(senha);
        

        UsuarioCliente usuarioCliente = new UsuarioCliente();
        usuarioCliente.setCpf(cpf_cnpj);
        usuarioCliente.setSexo(Sexo);
        usuarioCliente.setTelefone(telefone);
        usuarioCliente.setDataDeNascimento(dataNascimento.toString());

    if (usuarioClienteRepository.findByCpf(cpf_cnpj) == null){
        usuarioGeralRepository.save(usuarioGeral);
        usuarioClienteRepository.save(usuarioCliente);
        insertSuccess = true;
    }
    else{
        insertSuccess = false;
    }
    // If the code reaches this point, the insert was successful
    ModelAndView successModelAndView = new ModelAndView("insertcliente");
    successModelAndView.addObject("insertSuccess", insertSuccess);
    return successModelAndView;
    }
}
