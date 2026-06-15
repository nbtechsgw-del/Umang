package com.hospital.patient_management.repository;

import com.hospital.patient_management.model.Billing;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BillingRepository
        extends JpaRepository<Billing, Integer> {
}