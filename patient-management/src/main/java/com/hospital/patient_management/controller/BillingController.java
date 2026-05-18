package com.hospital.patient_management.controller;

import com.hospital.patient_management.model.Billing;
import com.hospital.patient_management.service.BillingService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/billing")
@CrossOrigin("*")
public class BillingController {

    @Autowired
    private BillingService billingService;

    @PostMapping
    public Billing createBill(@RequestBody Billing billing) {
        return billingService.createBill(billing);
    }

    @GetMapping
    public List<Billing> getAllBills() {

        return billingService.getAllBills();
    }

    @GetMapping("/{id}")

    public Billing getBillById(@PathVariable int id) {
        return billingService.getBillById(id);
    }

    @PutMapping("/{id}")
    public Billing updateBill(
            @PathVariable int id,
            @RequestBody Billing billing) {

        return billingService.updateBill(id, billing);
    }

    @DeleteMapping("/{id}")
    public String deleteBill(@PathVariable int id) {

        billingService.deleteBill(id);

        return "Bill Deleted Successfully";
    }
}