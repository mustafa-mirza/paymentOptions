package com.avocado.options.controller;

import com.avocado.options.repository.EWalletRepository;
import com.avocado.options.model.EWallet;
import com.avocado.options.model.User;
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
public class EWalletController {
    private static final Logger logger = LogManager.getLogger(EWalletController.class);
    @Autowired
    private EWalletRepository eWalletRepository;

    @Autowired
    private UserRepository userRepository;

    @RequestMapping("/add-eWallet")
    public String redirectToAddEWallet() {
        return "addEWallet";
    }

    @RequestMapping("/view-eWallets")
    public String viewBillingEWallet(HttpSession session, ModelMap modelMap) {
        try{
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        List<EWallet> userEWallet = eWalletRepository.findByUserId(user.getId());
        modelMap.addAttribute("userEWalletList", userEWallet);
    }catch (Exception e){
        logger.error("Failed to get eWallet details", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "viewEWallets";
    }

    @PostMapping("/add-eWallet")
    public String createEWallet(EWallet eWallet, HttpSession session, ModelMap modelMap){
        try{
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        eWallet.setUser(user);
        EWallet savedEWallet = eWalletRepository.save(eWallet);
        modelMap.addAttribute("eWallet", savedEWallet);
    }catch (Exception e){
        logger.error("Failed to add eWallet details", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "redirect:/view-eWallets";
    }

    @RequestMapping("/update-eWallet/{eWalletId}")
    public String updateEWallet(@PathVariable long eWalletId, ModelMap modelMap) {
        try{
        EWallet eWallet = eWalletRepository.getById(eWalletId);
        if(eWallet != null) {
            modelMap.addAttribute("userEWallet", eWallet);
        }
    }catch (Exception e){
        logger.error("Failed to get eWallet details", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "updateEWallet";
    }

    @RequestMapping(value = "/update-eWallet-details/{eWalletId}", params = "update-eWallet-details", method = RequestMethod.POST)
    public String updateEWalletDetails(@PathVariable long eWalletId, EWallet eWallet, HttpSession session, ModelMap modelMap) {
        try {
            EWallet existingEWallet = eWalletRepository.getById(eWalletId);
            User user = userRepository.getById(existingEWallet.getUser().getId());
            eWallet.setId(existingEWallet.getId());
            eWallet.setUser(user);
            EWallet savedEWallet = eWalletRepository.save(eWallet);

            if (savedEWallet == null) {
                modelMap.addAttribute("message", "Unable to update eWallet.");
            }
        }catch (Exception e){
        logger.error("Failed to update eWallet details", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "redirect:/view-eWallets";
    }

    @RequestMapping("/delete-eWallet/{eWalletId}")
    public String deleteEWallet(@PathVariable long eWalletId, RedirectAttributes redirect, ModelMap modelMap) {
        try{
        eWalletRepository.deleteById(eWalletId);
        long count = eWalletRepository.countById(eWalletId);
        if(count > 0) {
            redirect.addFlashAttribute("msg", "Unable to delete eWallet");
        }
        }catch (Exception e){
            logger.error("Failed to delete eWallet details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "redirect:/view-eWallets";
    }
}
