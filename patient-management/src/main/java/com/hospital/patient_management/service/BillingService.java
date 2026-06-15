package com.hospital.patient_management.service;

import com.hospital.patient_management.model.Billing;
import com.hospital.patient_management.repository.BillingRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BillingService {

    @Autowired
    private BillingRepository billingRepository;

    public Billing createBill(Billing billing) {
        String invoiceId = "HMS-" + System.currentTimeMillis();
        billing.setInvoiceId(invoiceId);
        return billingRepository.save(billing);
    }

    public List<Billing> getAllBills() {
        return billingRepository.findAll();
    }

    public Billing getBillById(int id) {
        return billingRepository.findById(id).orElse(null);
    }

    public Billing updateBill(int id, Billing billingDetails) {

        Billing billing =
                billingRepository.findById(id).orElse(null);

        if (billing != null) {

            billing.setAmount(
                    billingDetails.getAmount());

            billing.setPaymentStatus(
                    billingDetails.getPaymentStatus());

            billing.setPaymentMethod(
                    billingDetails.getPaymentMethod());

            billing.setBillingDate(
                    billingDetails.getBillingDate());

            return billingRepository.save(billing);
        }

        return null;
    }

    public void deleteBill(int id) {
        billingRepository.deleteById(id);
    }
}