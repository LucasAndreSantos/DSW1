package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import br.ufscar.dc.dsw.model.UsuarioCliente;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



//import br.ufscar.dc.dsw.repository.UsuarioClienteRepository; 
//import br.ufscar.dc.dsw.repository.LocacoesRepository; 
//import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import br.ufscar.dc.dsw.service.spec.IUsuarioClienteService;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;
import br.ufscar.dc.dsw.service.spec.ILocacoesService;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.model.Locacoes;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import org.springframework.dao.DataIntegrityViolationException;
import br.ufscar.dc.dsw.service.impl.UsuarioClienteService;
import java.util.List;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.ufscar.dc.dsw.model.UsuarioCliente;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.service.spec.IUsuarioClienteService;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;
import br.ufscar.dc.dsw.service.spec.ILocacoesService;

@RestController
@RequestMapping("/api")
public class UsuarioClienteController {

    private final IUsuarioClienteService usuarioClienteService;
    private final IUsuarioGeralService usuarioGeralService;

    @Autowired
    public UsuarioClienteController(IUsuarioClienteService usuarioClienteService, IUsuarioGeralService usuarioGeralService) {
        this.usuarioClienteService = usuarioClienteService;
        this.usuarioGeralService = usuarioGeralService;
    }

    @GetMapping("/cliente")
    public ResponseEntity<List<Map<String, Object>>> getCombinedClienteInfo() {
        List<UsuarioCliente> clientes = usuarioClienteService.buscarTodos();
        List<Map<String, Object>> combinedClientInfos = new ArrayList<>();

        for (UsuarioCliente clienteInfo : clientes) {
            String cpf = clienteInfo.getCpf();
            UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf);

            Map<String, Object> combinedClientInfo = new HashMap<>();
            combinedClientInfo.put("cpfCnpj", usuarioGeral.getCpfCnpj());
            combinedClientInfo.put("username", usuarioGeral.getUsername());
            combinedClientInfo.put("email", usuarioGeral.getEmail());
            combinedClientInfo.put("hierarquia", usuarioGeral.isHierarquia());
            combinedClientInfo.put("senha", usuarioGeral.getSenha());
            combinedClientInfo.put("sexo", clienteInfo.getSexo());
            combinedClientInfo.put("telefone", clienteInfo.getTelefone());
            combinedClientInfo.put("dataNascimento", clienteInfo.getDataDeNascimento());

            combinedClientInfos.add(combinedClientInfo);
        }

        return ResponseEntity.ok(combinedClientInfos);
    }

    // ... other endpoints ...

    @PostMapping("/cliente/{cpf}")
    public ResponseEntity<String> updateClienteApi(@RequestParam String username,
                                                   @PathVariable String cpf,
                                                   @RequestParam String email,
                                                   @RequestParam String sexo,
                                                   @RequestParam String telefone,
                                                   @RequestParam String dataNascimento,
                                                   @RequestParam String senha) {

        boolean insertSuccess = true;
        int hierarquiafinal = 0;

        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf);
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(cpf);

        if (usuarioGeral != null && usuarioCliente != null) {
            if ((usuarioGeral.getUsername() != username && usuarioGeralService.buscarPorNome(username) == null) || usuarioGeral.getUsername().equalsIgnoreCase(username)){
                usuarioGeral.setUsername(username);
                usuarioGeral.setEmail(email);
                usuarioGeral.setSenha(senha);
                usuarioGeral.setHierarquia(0);

                usuarioCliente.setSexo(sexo);
                usuarioCliente.setTelefone(telefone);
                usuarioCliente.setDataDeNascimento(dataNascimento);

                usuarioGeralService.salvar(usuarioGeral);
                usuarioClienteService.salvar(usuarioCliente);

                insertSuccess = true;
            }
            else{
                insertSuccess = false;
            }    
        } else {
            insertSuccess = false;
        }

        if (insertSuccess) {
            return new ResponseEntity<>("Insert successful", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Insert failed", HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/cliente")
    public ResponseEntity<String> insertClienteApi(@RequestParam String username,
                                                   @RequestParam String cpf,
                                                   @RequestParam String email,
                                                   @RequestParam String sexo,
                                                   @RequestParam String telefone,
                                                   @RequestParam String dataNascimento,
                                                   @RequestParam String senha) {

        boolean insertSuccess = true;
        int hierarquiafinal = 0;

        UsuarioGeral usuarioGeral = new UsuarioGeral();
        usuarioGeral.setUsername(username);
        usuarioGeral.setCpfCnpj(cpf);
        usuarioGeral.setEmail(email);
        usuarioGeral.setHierarquia(hierarquiafinal);
        usuarioGeral.setSenha(senha);

        UsuarioCliente usuarioCliente = new UsuarioCliente();
        usuarioCliente.setCpf(cpf);
        usuarioCliente.setSexo(sexo);
        usuarioCliente.setTelefone(telefone);
        usuarioCliente.setDataDeNascimento(dataNascimento);

        if (usuarioClienteService.buscarPorCpf(cpf) == null && usuarioGeralService.buscarPorNome(username) == null) {
            usuarioGeralService.salvar(usuarioGeral);
            usuarioClienteService.salvar(usuarioCliente);
            insertSuccess = true;
        } else {
            insertSuccess = false;
        }

        if (insertSuccess) {
            return new ResponseEntity<>("Insert successful", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Insert failed", HttpStatus.BAD_REQUEST);
        }
    }


    @GetMapping("/cliente/{cpf}")
    public ResponseEntity<Map<String, Object>> getCombinedClienteByCpf(@PathVariable String cpf) {
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(cpf);
        if (usuarioCliente != null) {
            UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf);

            Map<String, Object> combinedClientInfo = new HashMap<>();
            combinedClientInfo.put("cpfCnpj", usuarioGeral.getCpfCnpj());
            combinedClientInfo.put("username", usuarioGeral.getUsername());
            combinedClientInfo.put("email", usuarioGeral.getEmail());
            combinedClientInfo.put("hierarquia", usuarioGeral.isHierarquia());
            combinedClientInfo.put("senha", usuarioGeral.getSenha());
            combinedClientInfo.put("sexo", usuarioCliente.getSexo());
            combinedClientInfo.put("telefone", usuarioCliente.getTelefone());
            combinedClientInfo.put("dataNascimento", usuarioCliente.getDataDeNascimento());

            return ResponseEntity.ok(combinedClientInfo);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/cliente/{cpf}")
    public ResponseEntity<String> deleteClienteApi(@PathVariable String cpf) {

        boolean deleteSuccess = false;

        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf);
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(cpf);

        if (usuarioGeral != null && usuarioCliente != null) {
            // Delete UsuarioCliente and UsuarioGeral
            usuarioClienteService.excluir(usuarioCliente);
            usuarioGeralService.excluir(usuarioGeral);

            deleteSuccess = true;
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        if (deleteSuccess) {
            return ResponseEntity.ok("Delete successful");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Delete failed");
        }
    }

    // ... other endpoints ...
}




