package br.ufscar.dc.dsw.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.service.spec.ILocacoesService;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;

import java.util.List;

@RestController
@RequestMapping("/api/locacoes")
public class LocacoesController {

    @Autowired
    private ILocacoesService locacoesService;

    @Autowired
    private IUsuarioGeralService usuarioGeralService;

    @GetMapping
    public List<Locacoes> getAllLocacoes() {
        return locacoesService.buscarTodos();
    }

    @GetMapping("/{id}")
    public Locacoes getLocacaoById(@PathVariable String id) {
        try {
            Long locacaoId = Long.parseLong(id);
            return locacoesService.buscarPorId(locacaoId);
        } catch (NumberFormatException e) {
            // Handle invalid ID format
            throw new IllegalArgumentException("Invalid ID format");
        }
    }

    @GetMapping("/clientes/{id}")
    public List<Locacoes> getLocacoesByClienteId(@PathVariable String id) {
        return locacoesService.buscarPorCpf(id);
    }

    @GetMapping("/locadoras/{id}")
    public List<Locacoes> getLocacoesByLocadoraId(@PathVariable String id) {
        return locacoesService.buscarPorCnpj(id);
    }

    // Other methods...

    // You can include other REST API endpoints as needed...

}
