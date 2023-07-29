package br.ufscar.dc.dsw.controller;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import br.ufscar.dc.dsw.model.Locacoes;
import br.ufscar.dc.dsw.model.UsuarioGeral;


//import br.ufscar.dc.dsw.repository.LocacoesRepository; 
//import br.ufscar.dc.dsw.repository.UsuarioLocadoraRepository;
//import br.ufscar.dc.dsw.repository.UsuarioGeralRepository;
import br.ufscar.dc.dsw.service.spec.ILocacoesService;
//import br.ufscar.dc.dsw.service.spec.IUsuarioLocadoraService; COLOQUEI AQUI MAS PERCEBI QUE NÃO É CHAMADO EM NENHUM MOMENTO, POR ISSO COMENTEI
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService;


import java.security.Principal;
import org.springframework.web.bind.annotation.RequestParam;
import java.time.LocalDateTime;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.time.Instant;
import java.util.Calendar;
import java.time.format.DateTimeFormatter;
import br.ufscar.dc.dsw.service.spec.IUsuarioGeralService; 

import javax.servlet.http.HttpSession;


@Controller
public class LocacoesController {

    @Autowired
    private ILocacoesService locacoesService;
    //private LocacoesRepository locacoesRepository;
    
    @Autowired
    private IUsuarioGeralService usuarioGeralService;
    //private UsuarioGeralRepository usuarioGeralRepository;

    //@Autowired
    //private IUsuarioLocadoraService usuarioLocadoraService;
    //private UsuarioLocadoraRepository usuarioLocadoraRepository;

    @GetMapping("/testelocacoes")
    public String getAllUsuarios(Model model) {
        //List<Locacoes> usuarios = locacoesRepository.findAll();
        List<Locacoes> usuarios = locacoesService.buscarTodos();
        model.addAttribute("usuarios", usuarios);
        return "testelocacoes";
    }


    @GetMapping("/locar")
    public String locar(Model model, HttpSession session, @RequestParam(name = "error", required = false) String error) {
        model.addAttribute("user", session.getAttribute("user"));
        // Retrieve the list of usernames from usuariogeral that match cnpj in usuariolocadora
        //List<UsuarioGeral> usuariosGeral = usuarioGeralRepository.findByCnpjInUsuarioLocadora(); //PRECISA IMPLEMENTAR NO DAO -> SERVICE -> ISERVICE -> TRAZER PARA CÁ
        List<UsuarioGeral> usuariosGeral = usuarioGeralService.buscarPorCnpjemUsuarioLocadora();
        model.addAttribute("usuariosGeral", usuariosGeral);
        model.addAttribute("error", error);
        return "cadastrarlocacao";
    }
    
    private LocalDateTime truncateToHour(LocalDateTime dateTime) {
        return dateTime.withMinute(0).withSecond(0).withNano(0);
    }

    @PostMapping("/CadastrarLocacao")
    public String cadastrarLocacao(@RequestParam String cidade,
                                @RequestParam String datetime,
                                HttpSession session) {

        UsuarioGeral user = (UsuarioGeral) session.getAttribute("user");
        if (user == null) {
            return "redirect:/loginpage";
        }
        //if (usuarioGeralRepository.existsByUsernameInUsuarioLocadora(user.getUsername())) {
        if (usuarioGeralService.existeNomeemUsuarioLocadora(user.getUsername())) {  
            // Handle the error (e.g., show a message to the user).
            // For simplicity, let's redirect back to the form with an error message.
            return "redirect:/locar?error=notAllowed";
        }

        // Convert datetime string to LocalDateTime object using a custom DateTimeFormatter
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime locacaoLocalDateTime = LocalDateTime.parse(datetime, formatter);

        if (locacaoLocalDateTime.isBefore(LocalDateTime.now())) {
            return "redirect:/locar?error=pastTime";
        }

        // Create the hourLocacao and hourDevolucao objects based on locacaoLocalDateTime
        LocalDateTime hourLocacao = truncateToHour(locacaoLocalDateTime);
        LocalDateTime hourDevolucao = hourLocacao.plusHours(1);

        // Convert LocalDateTime objects to Calendar objects
        Calendar locacaoCalendar = Calendar.getInstance();
        locacaoCalendar.setTime(Date.from(hourLocacao.atZone(ZoneId.systemDefault()).toInstant()));

        Calendar devolucaoCalendar = Calendar.getInstance();
        devolucaoCalendar.setTime(Date.from(hourDevolucao.atZone(ZoneId.systemDefault()).toInstant()));

        // Check if the user already has a rental during the selected hour
        //long count = locacoesRepository.countByCpfAndTimeRange(user.getCpfCnpj(), locacaoCalendar.getTime(), devolucaoCalendar.getTime());
        long count = locacoesService.contaPorCpf(user.getCpfCnpj(), locacaoCalendar.getTime(), devolucaoCalendar.getTime());
        if (count > 0) {
            return "redirect:/locar?error=alreadyRented";
        }

        // Retrieve the CNPJ of the locadora using the selected username
        String cnpj = cidade;

        // Check if the locadora already has a rental during the selected hour
        //count = locacoesRepository.countByCnpjAndTimeRange(cnpj, locacaoCalendar.getTime(), devolucaoCalendar.getTime());
        count = locacoesService.contaPorCnpj(cnpj, locacaoCalendar.getTime(), devolucaoCalendar.getTime());
        if (count > 0) {
            return "redirect:/locar?error=notAvailable";
        }

        // Save the Locacoes entity in the database
        Locacoes locacao = new Locacoes(user.getCpfCnpj(), cnpj, locacaoCalendar.getTime(), devolucaoCalendar.getTime());
        //locacoesRepository.save(locacao);
        locacoesService.salvar(locacao);

        // Redirect to a success page or any other desired page
        return "redirect:/locar?error=success"; // Replace "successPage" with the desired success page URL.
    }

}
