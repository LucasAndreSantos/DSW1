package br.ufscar.dc.dsw.controller;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.UsuarioLocadora;
import br.ufscar.dc.dsw.model.UsuarioGeral;
import br.ufscar.dc.dsw.model.Locacoes;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import br.ufscar.dc.dsw.service.spec.IUsuarioLocadoraService;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;
import br.ufscar.dc.dsw.service.spec.ILocacoesService;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequestMapping("/api")
public class UsuarioLocadoraController {

    private final IUsuarioLocadoraService usuarioLocadoraService;
    private final IUsuarioGeralService usuarioGeralService;
    private final ILocacoesService locacoesService;

    private boolean isValidEmailFormat(String email) {
        // Define a regular expression pattern for email validation
        String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";

        // Use the matches() method to check if the email matches the pattern
        return email.matches(emailPattern);
    }

    private boolean isValidCnpjFormat(String cnpj) {
        // Define a regular expression pattern for CNPJ validation
        String cnpjPattern = "\\d{14}";

        // Use the matches() method to check if the CNPJ matches the pattern and has the right length
        return cnpj.matches(cnpjPattern);
    }

    @Autowired
    public UsuarioLocadoraController(IUsuarioLocadoraService usuarioLocadoraService,
                                     IUsuarioGeralService usuarioGeralService,
                                     ILocacoesService locacoesService) {
        this.usuarioLocadoraService = usuarioLocadoraService;
        this.usuarioGeralService = usuarioGeralService;
        this.locacoesService = locacoesService;
    }

    @GetMapping("/locadora")
    public ResponseEntity<List<Map<String, Object>>> getCombinedUserInfo() {
        List<UsuarioLocadora> cidades = usuarioLocadoraService.buscarTodos();
        List<Map<String, Object>> combinedUserInfos = new ArrayList<>();

        for (UsuarioLocadora cidadeInfo : cidades) {
            String cnpj = cidadeInfo.getCnpj();
            UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cnpj);

            Map<String, Object> combinedUserInfo = new HashMap<>();
            combinedUserInfo.put("cpfCnpj", usuarioGeral.getCpfCnpj());
            combinedUserInfo.put("username", usuarioGeral.getUsername());
            combinedUserInfo.put("email", usuarioGeral.getEmail());
            combinedUserInfo.put("hierarquia", usuarioGeral.isHierarquia());
            combinedUserInfo.put("senha", usuarioGeral.getSenha());
            combinedUserInfo.put("cidade", cidadeInfo.getCidade());

            combinedUserInfos.add(combinedUserInfo);
        }

        return ResponseEntity.ok(combinedUserInfos);
    }

    @GetMapping("/locadora/{id}")
    public ResponseEntity<Map<String, Object>> getLocadoraById(@PathVariable String id) {
        UsuarioLocadora usuarioLocadora = usuarioLocadoraService.buscarPorCnpj(id);
        if (usuarioLocadora != null) {
            UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(id);

            Map<String, Object> combinedUserInfo = new HashMap<>();
            combinedUserInfo.put("cpfCnpj", usuarioGeral.getCpfCnpj());
            combinedUserInfo.put("username", usuarioGeral.getUsername());
            combinedUserInfo.put("email", usuarioGeral.getEmail());
            combinedUserInfo.put("hierarquia", usuarioGeral.isHierarquia());
            combinedUserInfo.put("senha", usuarioGeral.getSenha());
            combinedUserInfo.put("cidade", usuarioLocadora.getCidade());

            return ResponseEntity.ok(combinedUserInfo);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/locadora/cidades/{id}")
    public ResponseEntity<List<Map<String, Object>>> getCombinedLocadoraById(@PathVariable String id) {
        List<UsuarioLocadora> cidades = usuarioLocadoraService.buscarPorCidade(id);
        List<Map<String, Object>> combinedUserInfos = new ArrayList<>();

        for (UsuarioLocadora cidadeInfo : cidades) {
            String cnpj = cidadeInfo.getCnpj();
            UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cnpj);

            Map<String, Object> combinedUserInfo = new HashMap<>();
            combinedUserInfo.put("cpfCnpj", usuarioGeral.getCpfCnpj());
            combinedUserInfo.put("username", usuarioGeral.getUsername());
            combinedUserInfo.put("email", usuarioGeral.getEmail());
            combinedUserInfo.put("hierarquia", usuarioGeral.isHierarquia());
            combinedUserInfo.put("senha", usuarioGeral.getSenha());
            combinedUserInfo.put("cidade", cidadeInfo.getCidade());

            combinedUserInfos.add(combinedUserInfo);
        }

        return ResponseEntity.ok(combinedUserInfos);
    }


    @PostMapping("/locadora/{cpf_cnpj}")
    public ResponseEntity<String> updateLocadoraApi(@RequestBody Map<String, String> requestData) {
        String username = requestData.get("username");
        String cpf_cnpj = requestData.get("cpfCnpj");
        String email = requestData.get("email");
        String cidade = requestData.get("cidade");
        String senha = requestData.get("senha");
        boolean insertSuccess = true;
        int hierarquiafinal = 0;

        // Find the existing UsuarioGeral and UsuarioLocadora objects to update
        //UsuarioGeral usuarioGeral = usuarioGeralRepository.findByCpfCnpj(cpf_cnpj);
        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(cpf_cnpj);
        //UsuarioLocadora usuarioLocadora = usuarioLocadoraRepository.findByCnpj(cpf_cnpj);
        UsuarioLocadora usuarioLocadora = usuarioLocadoraService.buscarPorCnpj(cpf_cnpj);

            // Check if the provided email is in a valid format
        if (!isValidEmailFormat(email)) {
            return new ResponseEntity<>("Invalid email format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided CNPJ is in a valid format and has the right length
        if (!isValidCnpjFormat(cpf_cnpj)) {
            return new ResponseEntity<>("Invalid CNPJ format", HttpStatus.BAD_REQUEST);
        }

        if (usuarioGeral != null && usuarioLocadora != null) {
            if ((usuarioGeral.getUsername() != username && usuarioGeralService.buscarPorNome(username) == null) || usuarioGeral.getUsername().equalsIgnoreCase(username)){
                // Update the UsuarioGeral and UsuarioLocadora objects with new data
                usuarioGeral.setUsername(username);
                usuarioGeral.setEmail(email);
                usuarioGeral.setSenha(senha);
                usuarioGeral.setHierarquia(0);

                usuarioLocadora.setCidade(cidade);

                //usuarioGeralRepository.save(usuarioGeral);
                usuarioGeralService.salvar(usuarioGeral);
                //usuarioLocadoraRepository.save(usuarioLocadora);
                usuarioLocadoraService.salvar(usuarioLocadora);

                insertSuccess = true;
            }
            else{
                insertSuccess = false;
            }    
        } else {
            // If the locadora does not exist, handle the error (e.g., show an error message)
            insertSuccess = false;
        }

        if (insertSuccess) {
            return new ResponseEntity<>("Insert successful", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Insert failed", HttpStatus.BAD_REQUEST);
        }
    }    

    @PostMapping("/locadora")
    public ResponseEntity<String> insertLocadoraApi(@RequestBody Map<String, String> requestData) {
        String username = requestData.get("username");
        String cpf_cnpj = requestData.get("cpfCnpj");
        String email = requestData.get("email");
        String cidade = requestData.get("cidade");
        String senha = requestData.get("senha");
        boolean insertSuccess = true;
        int hierarquiafinal = 0;

            // Check if the provided email is in a valid format
        if (!isValidEmailFormat(email)) {
            return new ResponseEntity<>("Invalid email format", HttpStatus.BAD_REQUEST);
        }

        // Check if the provided CNPJ is in a valid format and has the right length
        if (!isValidCnpjFormat(cpf_cnpj)) {
            return new ResponseEntity<>("Invalid CNPJ format", HttpStatus.BAD_REQUEST);
        }

        UsuarioGeral usuarioGeral = new UsuarioGeral();
        usuarioGeral.setUsername(username);
        usuarioGeral.setCpfCnpj(cpf_cnpj);
        usuarioGeral.setEmail(email);
        usuarioGeral.setHierarquia(hierarquiafinal);
        usuarioGeral.setSenha(senha);
        UsuarioLocadora usuarioLocadora = new UsuarioLocadora();
        usuarioLocadora.setCnpj(cpf_cnpj);
        usuarioLocadora.setCidade(cidade);
        //if (usuarioLocadoraRepository.findByCnpj(cpf_cnpj) == null){
        if (usuarioLocadoraService.buscarPorCnpj(cpf_cnpj) == null && usuarioGeralService.buscarPorNome(username) == null){
            //usuarioGeralRepository.save(usuarioGeral);
            usuarioGeralService.salvar(usuarioGeral);
            //usuarioLocadoraRepository.save(usuarioLocadora);
            usuarioLocadoraService.salvar(usuarioLocadora);
            insertSuccess = true;
        }
        else{
            insertSuccess = false;
        }

        if (insertSuccess) {
            return new ResponseEntity<>("Insert successful", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Insert failed", HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("/locadora/{usuariolocadora}")
    public ResponseEntity<String> deleteLocadoraApi(@PathVariable String usuariolocadora) {

        boolean deleteSuccess = false;

        // Find the existing UsuarioGeral and UsuarioLocadora objects to delete
        UsuarioGeral usuarioGeral = usuarioGeralService.buscarPorCpfCnpj(usuariolocadora);
        UsuarioLocadora usuarioLocadora = usuarioLocadoraService.buscarPorCnpj(usuarioGeral.getCpfCnpj());

        if (usuarioGeral != null && usuarioLocadora != null) {
            // Find and delete related Locacoes entries
            List<Locacoes> locacoesList = locacoesService.buscarPorCnpj(usuarioGeral.getCpfCnpj());
            for (Locacoes locacao : locacoesList) {
                locacoesService.excluir(locacao);
            }

            // Delete UsuarioLocadora and UsuarioGeral
            usuarioLocadoraService.excluir(usuarioLocadora);
            usuarioGeralService.excluir(usuarioGeral);

            deleteSuccess = true;
        } else {
            // If the user does not exist, return a not found response
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        // If the code reaches this point, the delete was successful
        if (deleteSuccess) {
            return ResponseEntity.ok("Delete successful");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Delete failed");
        }
    }



    // ... other API endpoints ...

    // Handle other API endpoints here...

}
