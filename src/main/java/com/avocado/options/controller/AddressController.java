package com.avocado.options.controller;

import com.avocado.options.model.Address;
import com.avocado.options.model.AddressSearchCriteria;
import com.avocado.options.model.User;
import com.avocado.options.repository.AddressRepository;
import com.avocado.options.repository.BillingAddressDao;
import com.avocado.options.repository.UserRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class AddressController {
    private static final Logger logger = LogManager.getLogger(AddressController.class);
    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BillingAddressDao billingAddressDao;

    @RequestMapping("/add-billingAddress")
    public String showAddBillingAddress() {
        return "addBillingAddress";
    }

    @RequestMapping("/view-billingAddress")
    public String viewBillingAddress(HttpSession session, ModelMap modelMap) {
        try {
            String username = (String) session.getAttribute("username");
            User user = userRepository.findByUsername(username);
            List<Address> userAddresses = addressRepository.findByUserId(user.getId());
            modelMap.addAttribute("userAddressList", userAddresses);
        }catch (Exception e){
            logger.error("Failed to get billing addresses", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "viewBillingAddress";
    }

    @RequestMapping("/search-address")
    public String searchAddress(HttpSession session, ModelMap modelMap, AddressSearchCriteria addressSearchCriteria) {
        try{
            String username = (String) session.getAttribute("username");
            User user = userRepository.findByUsername(username);
            List<Address> addressList = billingAddressDao.searchAddress(user.getId(), addressSearchCriteria.getAddressLine());
            modelMap.addAttribute("userAddressList", addressList);
        }catch (Exception e){
            logger.error("Failed to search bank cards details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "viewBillingAddress";
    }

    @GetMapping("/users/{userId}/addresses")
    public List<Address> getAllAddressesByUserId(@PathVariable (value = "userId") Long userId,
                                                Pageable pageable) {
        return addressRepository.findByUserId(userId);
    }

    @PostMapping("/add-addresses")
    public String createAddress(Address address, HttpSession session, ModelMap modelMap){
        try {
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        address.setUser(user);
        Address savedAddress = addressRepository.save(address);
        modelMap.addAttribute("address", savedAddress);
    }catch (Exception e){
        logger.error("Failed to add billing addresses", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "redirect:/view-billingAddress";
    }

    @RequestMapping("/update-address/{address_id}")
    public String updateAddress(@PathVariable long address_id, ModelMap modelMap) {
        try {
        Address address = addressRepository.getById(address_id);
        if(address != null) {
            modelMap.addAttribute("userAddress", address);
        }
    }catch (Exception e){
        logger.error("Failed to get billing addresses", e);
        modelMap.addAttribute("message", "Unable to perform requested operation.");
    }
        return "updateAddress";
    }

    @RequestMapping(value = "/update-address-details/{address_id}", params = "update-address-details", method = RequestMethod.POST)
    public String updateAddressDetails(@PathVariable long address_id, Address address, HttpSession session, ModelMap modelMap) {
        try{
        Address existingAddress = addressRepository.getById(address_id);
        User user = userRepository.getById(existingAddress.getUser().getId());
        address.setId(existingAddress.getId());
        address.setUser(user);
        Address savedAddress = addressRepository.save(address);

        if(savedAddress == null) {
            modelMap.addAttribute("message", "Something went wrong try again");
        }
        }catch (Exception e){
            logger.error("Failed to update billing addresses", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "redirect:/view-billingAddress";
    }

    @RequestMapping("/delete-address/{address_id}")
    public String deleteProductDetails(@PathVariable long address_id, RedirectAttributes redirect, ModelMap modelMap) {
        try {
        addressRepository.deleteById(address_id);
        long count = addressRepository.countById(address_id);
        if(count > 0) {
            redirect.addFlashAttribute("msg", "Unable to delete address");
        }
        }catch (Exception e){
            logger.error("Failed to delete billing addresses", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "redirect:/view-billingAddress";
    }
}
