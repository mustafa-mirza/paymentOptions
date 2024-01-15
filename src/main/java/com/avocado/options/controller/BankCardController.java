package com.avocado.options.controller;

import com.avocado.options.model.BankCard;
import com.avocado.options.model.BankCardSearchCriteria;
import com.avocado.options.model.User;
import com.avocado.options.repository.BankCardDao;
import com.avocado.options.repository.BankCardRepository;
import com.avocado.options.repository.UserRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class BankCardController {
    private static final Logger logger = LogManager.getLogger(BankCardController.class);
    @Autowired
    private BankCardRepository bankCardRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BankCardDao bankCardDao;

    @RequestMapping("/add-bankCard")
    public String redirectToAddBankCard() {
        return "addBankCard";
    }

    @RequestMapping("/view-bankCards")
    public String viewBankCard(HttpSession session, ModelMap modelMap) {
        try{
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        List<BankCard> bankCards = bankCardRepository.findByUserId(user.getId());
        modelMap.addAttribute("userBankCardList", bankCards);
        }catch (Exception e){
            logger.error("Failed to get bank cards details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "viewBankCards";
    }

    @RequestMapping("/search-bankCards")
    public String searchBankCards(HttpSession session, ModelMap modelMap, BankCardSearchCriteria bankCardSearchCriteria) {
        try{
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        List<BankCard> bankCards = bankCardDao.searchBankCardByType(user.getId(), bankCardSearchCriteria.getSearchByType());
        modelMap.addAttribute("userBankCardList", bankCards);
    }catch (Exception e){
        logger.error("Failed to search bank cards details", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "viewBankCards";
    }


    @PostMapping("/add-bankCard")
    public String createBankCard(BankCard bankCard, HttpSession session, ModelMap modelMap){
        try{
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        bankCard.setUser(user);
        BankCard savedBankCard = bankCardRepository.save(bankCard);
        modelMap.addAttribute("bankCard", savedBankCard);
        }catch (Exception e){
            logger.error("Failed to add bank cards details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "redirect:/view-bankCards";
    }

    @RequestMapping("/update-bankCard/{bankCardId}")
    public String updateBankCard(@PathVariable long bankCardId, ModelMap modelMap) {
        try{
        BankCard bankCard = bankCardRepository.getById(bankCardId);
        if(bankCard != null) {
            modelMap.addAttribute("userBankCard", bankCard);
        }
        }catch (Exception e){
            logger.error("Failed to get bank cards details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "updateBankCard";
    }

    @RequestMapping(value = "/update-bankCard-details/{bankCardId}", params = "update-bankCard-details", method = RequestMethod.POST)
    public String updateBankCardDetails(@PathVariable long bankCardId, BankCard bankCard, HttpSession session, ModelMap modelMap) {
        try{
        BankCard existingBankCard = bankCardRepository.getById(bankCardId);
        User user = userRepository.getById(existingBankCard.getUser().getId());
        bankCard.setId(existingBankCard.getId());
        bankCard.setUser(user);
        BankCard savedBankCard = bankCardRepository.save(bankCard);

        if(savedBankCard == null) {
            modelMap.addAttribute("message", "Unable to update bank card details");
        }
        }catch (Exception e){
            logger.error("Failed to update bank cards details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "redirect:/view-bankCards";
    }

    @RequestMapping("/delete-bankCard/{bankCardId}")
    public String deleteBankCardDetails(@PathVariable long bankCardId, RedirectAttributes redirect, ModelMap modelMap) {
        try {
        bankCardRepository.deleteById(bankCardId);
        long count = bankCardRepository.countById(bankCardId);
        if(count > 0) {
            redirect.addFlashAttribute("msg", "Unable to delete Bank Card");
        }
        }catch (Exception e){
            logger.error("Failed to delete bank cards details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "redirect:/view-bankCards";
    }
}
