package com.hospital.patient_management.repository;

import com.hospital.patient_management.model.MedicalRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MedicalRecordRepository
        extends JpaRepository<MedicalRecord, Integer> {

}