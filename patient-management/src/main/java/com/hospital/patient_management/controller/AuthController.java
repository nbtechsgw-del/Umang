package com.hospital.patient_management.controller;

import com.hospital.patient_management.dto.LoginResponse;
import com.hospital.patient_management.model.User;
import com.hospital.patient_management.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@CrossOrigin("*")
public class AuthController {

    @Autowired
    private UserService userService;

    // Register API
    @PostMapping("/register")
    public String register(@RequestBody User user) {
    userService.registerUser(user);
    return "User Registered Successfully";
    }

    // Login API
    @PostMapping("/login")
    public LoginResponse login(@RequestParam String username, @RequestParam String password) {
        return userService.loginUser(username, password);
    }
}