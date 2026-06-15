package com.hospital.patient_management.service;

import com.hospital.patient_management.model.User;
import com.hospital.patient_management.dto.LoginResponse;
import com.hospital.patient_management.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(User user) {
        user.setPassword(
        passwordEncoder.encode(user.getPassword())
        );
        return userRepository.save(user);
    }

    public LoginResponse loginUser(String username, String password) {

    User user = userRepository.findByUsername(username);

    if(user != null &&
       passwordEncoder.matches(password, user.getPassword())) {

        return new LoginResponse(

            "Login Successful",

            user.getRole()
        );
    }

    return new LoginResponse(

        "Invalid Username or Password",

        null
    );
}
}