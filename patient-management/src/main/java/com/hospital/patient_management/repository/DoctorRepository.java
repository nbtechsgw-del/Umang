package com.hospital.patient_management.repository;

import com.hospital.patient_management.model.Doctor;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DoctorRepository
extends JpaRepository<Doctor, Integer> {

}