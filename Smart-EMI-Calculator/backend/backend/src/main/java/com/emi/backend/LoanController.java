package com.emi.backend;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
public class LoanController {

    @Autowired
    private LoanRepository loanRepository;
    @Autowired
    private UserRepository userRepo;

    @GetMapping("/test")
    public String test() {
    return "Working";
    }
    
    @PostMapping("/saveLoan")
    public Loan saveLoan(@RequestBody Loan loan) {
        User user = userRepo.findByEmail(loan.getUser().getEmail());
        loan.setUser(user);
        return loanRepository.save(loan);
    }
    /*@PostMapping("/saveLoan")
    public Loan saveLoan(@RequestBody Loan loan) {

        double p = loan.getPrincipal();
        double r = loan.getRate()/12/100;
        int n = loan.getTime()*12;

        double emi = (p*r*Math.pow(1+r,n))/(Math.pow(1+r,n)-1);

        loan.setEmi(emi);

        return loanRepository.save(loan);
    }*/

    @DeleteMapping("/deleteLoan/{id}")
    public String deleteLoan(@PathVariable int id) {
        loanRepository.deleteById(id);
        return "Loan deleted successfully";
    }

    @GetMapping("/getLoans/{email}")
    public List<Loan> getLoans(@PathVariable String email) {
        return loanRepository.findByUserEmail(email);
    }

    @PutMapping("/updateLoan/{id}")
public Loan updateLoan(@PathVariable int id, @RequestBody Loan updatedLoan) {

    Loan loan = loanRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Loan not found"));

    loan.setName(updatedLoan.getName());
    loan.setPrincipal(updatedLoan.getPrincipal());
    loan.setRate(updatedLoan.getRate());
    loan.setTime(updatedLoan.getTime());

    double r = updatedLoan.getRate() / 12 / 100;
    int n = updatedLoan.getTime() * 12;

    double emi = (updatedLoan.getPrincipal() * r *
            Math.pow(1 + r, n)) /
            (Math.pow(1 + r, n) - 1);

    loan.setEmi(emi);

    return loanRepository.save(loan);
}
}