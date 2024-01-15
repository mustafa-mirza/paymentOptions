package com.avocado.options.controller;

import com.avocado.options.repository.EWalletRepository;
import com.avocado.options.model.Address;
import com.avocado.options.model.BankCard;
import com.avocado.options.model.User;
import com.avocado.options.repository.AddressRepository;
import com.avocado.options.repository.BankCardRepository;
import com.avocado.options.repository.UserRepository;
import com.github.javafaker.Faker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Controller
public class SampleDataController {

    @Autowired
    private EWalletRepository eWalletRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private BankCardRepository bankCardRepository;

    @RequestMapping("/insertsampledata")
    public String insertSampleData(ModelMap modelMap) {
        try {
        int count = 50;
        if(count > 0) {
            Faker faker = new Faker();
            List<User> usersList = new ArrayList<>();
            //Add avocado user
            User avocadoUser = new User();
            avocadoUser.setUsername("avocado");
            avocadoUser.setEmail("avocado@sample.com");
            avocadoUser.setPassword("avocado2022");
            avocadoUser.setMobile("faker.phoneNumber().cellPhone()");
            avocadoUser.setRole("ROLE_USER");
            avocadoUser.setActive(true);
            BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(8);
            String encodedPassword = passwordEncoder.encode(avocadoUser.getPassword());
            avocadoUser.setPassword(encodedPassword);
            avocadoUser = userRepository.save(avocadoUser);
            usersList.add(avocadoUser);


            for(int i=0; i<count; i++){
                User user = new User();
                String username = faker.address().firstName().toLowerCase();
                user.setUsername(username);
                user.setEmail(username + "@" + "sample.com");
                user.setPassword(username + "2022");
                user.setMobile(faker.phoneNumber().cellPhone());
                user.setRole("ROLE_USER");
                user.setActive(true);
//                BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(8);
                encodedPassword = passwordEncoder.encode(user.getPassword());
                user.setPassword(encodedPassword);
                try {
                    user = userRepository.save(user);
                }
                catch (Exception e){
                   i--;
                }
                usersList.add(user);
            }
            Random rnd = new Random();
            String[] addressTypes = {"Home", "Office", "Other"};
            for(User user: usersList){
                for(String addressType: addressTypes) {
                    Address address = new Address();
                    address.setType(addressType);
                    address.setAddressLine(faker.address().buildingNumber() + ", " + faker.address().streetAddress());
                    address.setCity(faker.address().city());
                    address.setState(faker.address().state());
                    address.setCountry(faker.address().country());
                    address.setZipCode(rnd.nextInt(999999));
                    address.setUser(user);
                    addressRepository.save(address);
                }
            }

            String[] types = {"Credit Card", "Debit Card"};
            for(User user: usersList) {
                String userLastName = faker.name().lastName();
                for (String type : types) {
                    BankCard bankCard = new BankCard();
                    bankCard.setBank(faker.company().name() + " Bank");
                    bankCard.setType(type);
                    bankCard.setCardType(faker.business().creditCardType());
                    bankCard.setCardNumber(faker.business().creditCardNumber());
                    bankCard.setExpiryMonth("April");
                    bankCard.setExpiryYear(2023);
                    bankCard.setNameOnCard(user.getUsername() + " " + userLastName);
                    bankCard.setUser(user);
                    bankCardRepository.save(bankCard);
                }
            }

            List<User> userList = userRepository.findAll();
            for(User user: userList){
                user.setPassword(user.getUsername()+"2022");
            }
            modelMap.addAttribute("message", "Sample data inserted successfully.");
            modelMap.addAttribute("userList", userList);
        }
        }catch (DataIntegrityViolationException e){
            modelMap.addAttribute("message", "Sample data already exist.");
            List<User> userList = userRepository.findAll();
            for(User user: userList){
                user.setPassword(user.getUsername()+"2022");
            }
            modelMap.addAttribute("userList", userList);
        }catch (Exception e){
            modelMap.addAttribute("message", "Failed to insert sample data. Reason: " + e.getMessage());
        }

        return "sampleData";
    }


}
