package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.UsuarioCliente;

//import br.ufscar.dc.dsw.repository.UsuarioClienteRepository;
import br.ufscar.dc.dsw.repository.LocacoesRepository;
//import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import br.ufscar.dc.dsw.service.spec.IUsuarioClienteService;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;


import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.model.Locacoes;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import org.springframework.dao.DataIntegrityViolationException;
import br.ufscar.dc.dsw.service.impl.UsuarioClienteService;



@Controller
public class UsuarioClienteController {

    @Autowired
    private IUsuarioClienteService usuarioClienteService;
    //private UsuarioClienteRepository usuarioClienteRepository;

    @Autowired
    private IUsuarioGeralService usuarioGeralService;
    //private UsuarioGeralRepository usuarioGeralRepository;

    @Autowired
    private LocacoesRepository locacoesRepository;

    //@Autowired
    //private UsuarioClienteService service;    

    @GetMapping("/testeusuariocliente")
    public String getAllUsuarios(Model model) {
        //NÃO COLOQUEI DO SERVICE PORQUE PRECISA TER O FINDALL NO DAO DE CLIENTE
        List<UsuarioCliente> usuarios = usuarioClienteRepository.findAll();
        model.addAttribute("usuarios", usuarios);
        return "testecliente";
    }

    @GetMapping("/editarcliente")
    public String editarcliente(@RequestParam String usuariocliente, Model model) {
        // Fetch the user by username from the repository
        //UsuarioGeral usuarioGeral = usuarioGeralRepository.findByUsername(usuariocliente);
        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorNome(usuariocliente);
        //UsuarioCliente usuarioCliente = usuarioClienteRepository.findByCpf(usuarioGeral.getCpfCnpj());
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(usuarioGeral.getCpfCnpj());
        
        // Pass the existing client data to the view
        model.addAttribute("usuarioGeral", usuarioGeral);
        model.addAttribute("usuarioCliente", usuarioCliente);
        return "editarcliente"; // Return the name of the Thymeleaf template (editarcliente.html)
    }


    @GetMapping("/registrarcliente")
    public String registrarcliente(Model model) {
        return "registrarcliente";
    }
        
    @GetMapping("/user")
    public String getUserInfo(@RequestParam String usuariocliente, Model model) {
        // Fetch the user by username from the repository
        //UsuarioGeral user = usuarioGeralRepository.findByUsername(usuariocliente);
        UsuarioGeral user = usuarioGeralService.buscarPorNome(usuariocliente);
        //UsuarioCliente cliente = service.buscarPorCpf(user.getCpfCnpj());
        UsuarioCliente cliente = usuarioClienteService.buscarPorCpf(user.getCpfCnpj());
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

    //if (usuarioClienteRepository.findByCpf(cpf_cnpj) == null){
    if (usuarioClienteService.buscarPorCpf(cpf_cnpj) == null){
        //usuarioGeralRepository.save(usuarioGeral);
        usuarioGeralService.salvar(usuarioGeral);
        //usuarioClienteRepository.save(usuarioCliente);
        usuarioClienteService.salvar(usuarioCliente);
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

    @PostMapping("/UpdateCliente")
    public ModelAndView updateCliente(@RequestParam String username,
                                    @RequestParam String cpf_cnpj,
                                    @RequestParam String email,
                                    @RequestParam String datanascimento,
                                    @RequestParam String telefone,
                                    @RequestParam String sexo,
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

        // Find the existing UsuarioGeral and UsuarioCliente objects to update
        //UsuarioGeral usuarioGeral = usuarioGeralRepository.findByCpfCnpj(cpf_cnpj);
        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf_cnpj);
        //UsuarioCliente usuarioCliente = usuarioClienteRepository.findByCpf(usuarioGeral.getCpfCnpj());
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(usuarioGeral.getCpfCnpj());

        if (usuarioGeral != null && usuarioCliente != null) {
            // Update the UsuarioGeral and UsuarioCliente objects with new data
            usuarioGeral.setUsername(username);
            usuarioGeral.setEmail(email);
            usuarioGeral.setHierarquia(hierarquiafinal);
            usuarioGeral.setSenha(senha);

            usuarioCliente.setSexo(sexo);
            usuarioCliente.setTelefone(telefone);
            usuarioCliente.setDataDeNascimento(dataNascimento.toString());

            //usuarioGeralRepository.save(usuarioGeral);
            usuarioGeralService.salvar(usuarioGeral);
            //usuarioClienteRepository.save(usuarioCliente);
            usuarioClienteService.salvar(usuarioCliente);

            insertSuccess = true;
        } else {
            // If the user does not exist, handle the error (e.g., show an error message)
            insertSuccess = false;
        }
        // If the code reaches this point, the update was successful
        ModelAndView successModelAndView = new ModelAndView("insertcliente");
        successModelAndView.addObject("insertSuccess", insertSuccess);
        return successModelAndView;
    }

    @GetMapping("/deletecliente")
    public ModelAndView DeleteCliente(@RequestParam String usuariocliente) {

        boolean insertSuccess = false;

        // Find the existing UsuarioGeral and UsuarioCliente objects to update
        //UsuarioGeral usuarioGeral = usuarioGeralRepository.findByUsername(usuariocliente);
        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorNome(usuariocliente);
        //UsuarioCliente usuarioCliente = usuarioClienteRepository.findByCpf(usuarioGeral.getCpfCnpj());
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(usuarioGeral.getCpfCnpj());
        List<Locacoes> locacoesList = locacoesRepository.findByCpf(usuarioGeral.getCpfCnpj());
        if (usuarioGeral != null && usuarioCliente != null) {    
            for (Locacoes locacao : locacoesList) {
                locacoesRepository.delete(locacao);
            }
            //usuarioClienteRepository.delete(usuarioCliente);
            usuarioClienteService.excluir(usuarioCliente);
            //usuarioGeralRepository.delete(usuarioGeral);
            usuarioGeralService.excluir(usuarioGeral);
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

}
