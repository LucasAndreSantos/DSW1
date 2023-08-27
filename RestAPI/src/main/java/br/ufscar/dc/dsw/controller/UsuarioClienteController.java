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
import java.util.Arrays;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
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

    private boolean isValidDataNascimentoFormat(String dataNascimento) {
        // Define a regular expression pattern for date of birth validation (YYYY-MM-DD)
        String dataNascimentoPattern = "\\d{4}-\\d{2}-\\d{2}";

        // Use the matches() method to check if the date of birth matches the pattern
        return dataNascimento.matches(dataNascimentoPattern);
    }

    private boolean isValidDataNascimento(String dataNascimento) {
        // Assuming that dates in the future are not allowed, you can implement a check here
        // to ensure that the provided date of birth is not in the future.
        // You might also want to check the age to ensure it's within a valid range.

        // For example, if you want to validate that the provided date of birth is not in the future:
        LocalDate currentDate = LocalDate.now();
        LocalDate providedDate = LocalDate.parse(dataNascimento);

        return !providedDate.isAfter(currentDate);
    }


    private boolean isValidTelefoneFormat(String telefone) {
        // Define a regular expression pattern for telephone number validation
        String telefonePattern = "\\d{11}";

        // Use the matches() method to check if the telephone number matches the pattern and has the right length
        return telefone.matches(telefonePattern);
    }

    private boolean isValidSexoInput(String sexo) {
        // Define valid sexo values (assuming "Masculino" and "Feminino" are the only valid inputs)
        String[] validSexoValues = {"Masculino", "Feminino"};

        // Use Arrays.asList() to convert the array into a List for easy validation
        List<String> validSexoList = Arrays.asList(validSexoValues);

        // Check if the provided sexo input is valid
        return validSexoList.contains(sexo);
    }

    private boolean isValidCpfFormat(String cpf) {
        // Define a regular expression pattern for CPF validation
        String cpfPattern = "\\d{11}";

        // Use the matches() method to check if the CPF matches the pattern and has the right length
        return cpf.matches(cpfPattern);
    }

    private boolean isValidEmailFormat(String email) {
        // Define a regular expression pattern for email validation
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";

        // Use the matches() method to check if the email matches the pattern
        return email.matches(emailPattern);
    }

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
    public ResponseEntity<String> updateClienteApi(@RequestBody Map<String, String> requestData) {
        String username = requestData.get("username");
        String cpf = requestData.get("cpf");
        String email = requestData.get("email");
        String sexo = requestData.get("sexo");
        String telefone = requestData.get("telefone");
        String dataNascimento = requestData.get("dataNascimento");
        String senha = requestData.get("senha");
        boolean insertSuccess = false;
        int hierarquiafinal = 0;

        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf);
        UsuarioCliente usuarioCliente = usuarioClienteService.buscarPorCpf(cpf);

        if (!isValidDataNascimentoFormat(dataNascimento)) {
            return new ResponseEntity<>("Invalid dataNascimento format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided dataNascimento is valid (not in the future)
        if (!isValidDataNascimento(dataNascimento)) {
            return new ResponseEntity<>("Invalid dataNascimento", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided telefone is in a valid format
        if (!isValidTelefoneFormat(telefone)) {
            return new ResponseEntity<>("Invalid telefone format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided sexo input is valid
        if (!isValidSexoInput(sexo)) {
            return new ResponseEntity<>("Invalid sexo input", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided email is in a valid format
        if (!isValidEmailFormat(email)) {
            return new ResponseEntity<>("Invalid email format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided CPF is in a valid format and has the right length
        if (!isValidCpfFormat(cpf)) {
            return new ResponseEntity<>("Invalid CPF format", HttpStatus.BAD_REQUEST);
        }

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
            return new ResponseEntity<>("CPF or Username aleready in use", HttpStatus.BAD_REQUEST);
        }

        if (insertSuccess) {
            return new ResponseEntity<>("Insert successful", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Insert failed", HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/cliente")
    public ResponseEntity<String> insertClienteApi(@RequestBody Map<String, String> requestData) {
        String username = requestData.get("username");
        String cpf = requestData.get("cpf");
        String email = requestData.get("email");
        String sexo = requestData.get("sexo");
        String telefone = requestData.get("telefone");
        String dataNascimento = requestData.get("dataNascimento");
        String senha = requestData.get("senha");
        boolean insertSuccess = false;
        int hierarquiafinal = 0;

        if (!isValidDataNascimentoFormat(dataNascimento)) {
            return new ResponseEntity<>("Invalid dataNascimento format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided dataNascimento is valid (not in the future)
        if (!isValidDataNascimento(dataNascimento)) {
            return new ResponseEntity<>("Invalid dataNascimento", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided telefone is in a valid format
        if (!isValidTelefoneFormat(telefone)) {
            return new ResponseEntity<>("Invalid telefone format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided sexo input is valid
        if (!isValidSexoInput(sexo)) {
            return new ResponseEntity<>("Invalid sexo input", HttpStatus.BAD_REQUEST);
        }

        
        // Check if the provided email is in a valid format
        if (!isValidEmailFormat(email)) {
            return new ResponseEntity<>("Invalid email format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided CPF is in a valid format and has the right length
        if (!isValidCpfFormat(cpf)) {
            return new ResponseEntity<>("Invalid CPF format", HttpStatus.BAD_REQUEST);
        }

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
            return new ResponseEntity<>("CPF or Username aleready in use", HttpStatus.BAD_REQUEST);
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




