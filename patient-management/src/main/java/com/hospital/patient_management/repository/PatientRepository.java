package com.hospital.patient_management.repository;

import com.hospital.patient_management.model.Patient;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PatientRepository
        extends JpaRepository<Patient, Integer> {

    List<Patient> findByFullNameContaining(String fullName);

    List<Patient> findByPhone(String phone);

    Patient findByPatientId(int patientId);
}