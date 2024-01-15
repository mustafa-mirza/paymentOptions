package com.avocado.options.controller;

import com.avocado.options.repository.BankCardRepository;
import com.avocado.options.repository.EWalletRepository;
import com.avocado.options.repository.UserRepository;
import com.avocado.options.exception.ResourceNotFoundException;
import com.avocado.options.model.User;
import com.avocado.options.repository.AddressRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.math.BigInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
public class UserController {
    private static final Logger logger = LogManager.getLogger(UserController.class);
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private BankCardRepository bankCardRepository;

    @Autowired
    private EWalletRepository eWalletRepository;

    @GetMapping("/login")
    public String showLoginForm(@RequestParam(value = "error",defaultValue = "false") boolean loginError , ModelMap map) {
        if(loginError) {
            String message = "Invalid username or password";
            map.addAttribute("message", message);
        }
        return "login";
    }

    @GetMapping("/register")
    public String showRegisterForm() {
        return "register";
    }

    @GetMapping("/users")
    public Page<User> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @GetMapping("/view-homeDashboard")
    public String viewHomeDashboard(HttpSession session, ModelMap modelMap) {
        try{
        String username = (String) session.getAttribute("username");
        User user = userRepository.findByUsername(username);
        long addressCount = addressRepository.countByUserId(user.getId());
        long bankCardCount = bankCardRepository.countByUserId(user.getId());
        long eWalletCount = eWalletRepository.countByUserId(user.getId());
        modelMap.addAttribute("addressCount", addressCount);
        modelMap.addAttribute("bankCardCount", bankCardCount);
        modelMap.addAttribute("eWalletCount", eWalletCount);
        }catch (Exception e){
            logger.error("Failed to get dashboard details", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "homeDashboard";
    }

    @PostMapping(value = "/register-user")
    public String createUser(User user, ModelMap modelMap, HttpSession session) {
        String message = "";
        try {
            Pattern special= Pattern.compile("[^a-z0-9 ]", Pattern.CASE_INSENSITIVE);
            Matcher matcher = special.matcher(user.getUsername());
            boolean containSpecialCharacters = matcher.find();
            if(containSpecialCharacters){
                logger.error(user.getUsername());
                throw new Exception("Invalid username "+ user.getUsername());
            }

            String regex = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$";
            boolean correctEmail = user.getEmail().matches(regex);
            String password = user.getPassword();
            String confirmPassword = user.getConfirmPassword();
            int passwordLength = password.length();
            int confirmPasswordLength = confirmPassword.length();
            boolean correctPassword = user.getPassword().equals(user.getConfirmPassword());

            if (passwordLength < 8 && confirmPasswordLength < 8) {
                message = "Please Enter 8 Character Password";
                modelMap.addAttribute("message", message);
                correctPassword = user.getPassword().equals(user.getConfirmPassword());
            }

            if (user.getUsername() != null && correctEmail == true && correctPassword == true
                    && user.getPassword().length() >= 8 && user.getConfirmPassword().length() >= 8) {
                BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder(8);
                String encodedPassword = passwordEncoder.encode(user.getPassword());
                user.setPassword(encodedPassword);

                session.setAttribute("email", user.getEmail());
                String email = session.getAttribute("email").toString();
                user.setActive(true);
                user.setRole("ROLE_USER");
                User existingUser = userRepository.findByUsername(user.getUsername());
                if(existingUser != null){
                    message = "Username already exist";
                    modelMap.addAttribute("message", message);
                }else {
                    User user1 = userRepository.save(user);

                    if (user1 != null) {
                        message = "Successfully registered ";
                        modelMap.addAttribute("message", message);
                    }
                }

            }
            if (correctEmail != true) {
                message = "Please enter correct email";
                modelMap.addAttribute("message", message);
                //modelMap.addAttribute("userDataE", user);
            }
            if (correctPassword != true) {
                message = "Confirm password is not matching with password.";
                modelMap.addAttribute("message", message);
                //modelMap.addAttribute("userDataP", user);
            }
        }catch (Exception e){
            logger.error("Failed to register user", e);
            modelMap.addAttribute("message", e.getMessage());
        }
        return "register";
    }

    @PutMapping("/users/{userId}")
    public User updateUser(@PathVariable Long userId, @Valid @RequestBody User userRequest) {
        return userRepository.findById(userId).map(user -> {
            user.setUsername(userRequest.getUsername());
            user.setEmail(userRequest.getUsername());
            user.setRole(userRequest.getUsername());
            user.setPassword(userRequest.getUsername());
            user.setMobile(userRequest.getUsername());
            user.setActive(userRequest.isActive());

            return userRepository.save(user);
        }).orElseThrow(() -> new ResourceNotFoundException("UserId " + userId + " not found"));
    }


    @DeleteMapping("/users/{userId}")
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        return userRepository.findById(userId).map(user -> {
            userRepository.delete(user);
            return ResponseEntity.ok().build();
        }).orElseThrow(() -> new ResourceNotFoundException("UserId " + userId + " not found"));
    }

    @GetMapping("/forgetpassword")
    public String showForgetPassword() {
        return "forgetPassword";
    }


    @RequestMapping(value = "/forgetpassword", params = "forgetpassword")
    public String forgetPassword(User user, ModelMap modelMap) {
        try{
        BigInteger result = userRepository.isValidUsernameAndEmail(user.getUsername(), user.getEmail());
        String message ="";
        if (result.intValue() > 0) {
            if (user.getPassword().length() < 8 && user.getConfirmPassword().length() < 8) {
                message = "Please enter 8 character password";
                modelMap.addAttribute("message", message);
            } else if (user.getPassword().equals(user.getConfirmPassword())) {
                String password = user.getPassword();
                String confirmPassword = user.getConfirmPassword();

                BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
                String encodedPassword = passwordEncoder.encode(password);
                user.setPassword(encodedPassword);
                user.setConfirmPassword(confirmPassword);

                Integer value = userRepository.updateUserPassword(user.getPassword(), user.getUsername(), user.getEmail());
                if (value.intValue() > 0) {
                    message = "Password updated successfully.";
                    modelMap.addAttribute("message", message);
                } else {
                    message = "Failed to update Password";
                    modelMap.addAttribute("message", message);
                }
            }
            else {
                message = "Confirm password is not matching with password.";
                modelMap.addAttribute("message", message);
            }
        } else {
            message = "You not registered before on this application";
            modelMap.addAttribute("message", message);
            //modelMap.addAttribute("userData", user);
        }
        }catch (Exception e){
            logger.error("Failed to reset user password", e);
            modelMap.addAttribute("message", "Unable to perform requested operation.");
        }
        return "forgetPassword";
    }
}
