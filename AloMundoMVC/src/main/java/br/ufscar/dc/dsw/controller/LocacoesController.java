package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.repository.LocacoesRepository; //PRECISO CRIAR O SERVICE DESSE AINDA

import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
//import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService; -> Esse que está comentado pois o método utilizado aqui ainda não está implementado no service


import javax.servlet.http.HttpSession;


@Controller
public class LocacoesController {

    @Autowired
    private LocacoesRepository LocacoesRepository;
    
    @Autowired
    private UsuarioGeralRepository usuarioGeralRepository;
    //private IUsuarioGeralService usuarioGeralService;

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
        List<UsuarioGeral> usuariosGeral = usuarioGeralRepository.findByCnpjInUsuarioLocadora(); //PRECISA IMPLEMENTAR NO DAO -> SERVICE -> ISERVICE -> TRAZER PARA CÁ
        model.addAttribute("usuariosGeral", usuariosGeral);

        return "cadastrarlocacao";
    }
}
