package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.repository.LocacoesRepository;

@Controller
public class LocacoesController {

    @Autowired
    private LocacoesRepository LocacoesRepository;

    @GetMapping("/testelocacoes")
    public String getAllUsuarios(Model model) {
        List<Locacoes> usuarios = LocacoesRepository.findAll();
        model.addAttribute("usuarios", usuarios);
        return "testelocacoes";
    }
}
