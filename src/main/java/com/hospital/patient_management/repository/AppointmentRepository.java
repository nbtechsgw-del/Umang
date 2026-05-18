package com.hospital.patient_management.repository;

import com.hospital.patient_management.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AppointmentRepository
        extends JpaRepository<Appointment, Integer> {

}