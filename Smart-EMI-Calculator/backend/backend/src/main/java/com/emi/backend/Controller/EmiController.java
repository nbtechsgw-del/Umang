package com.emi.backend.Controller;

import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*") // allow React
public class EmiController {

    @GetMapping("/calculate")
    public double calculateEmi(
            @RequestParam double principal,
            @RequestParam double rate,
            @RequestParam int time) {

        double r = rate / 12 / 100;
        int n = time * 12;

        double emi = (principal * r * Math.pow(1 + r, n)) /
                (Math.pow(1 + r, n) - 1);

        return emi;
    }
}