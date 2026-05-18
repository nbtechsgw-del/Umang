package com.hospital.patient_management.service;

import com.hospital.patient_management.model.Doctor;
import com.hospital.patient_management.repository.DoctorRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DoctorService {

    @Autowired
    private DoctorRepository doctorRepository;

    public Doctor addDoctor(Doctor doctor) {

        return doctorRepository.save(doctor);
    }

    public List<Doctor> getAllDoctors() {

        return doctorRepository.findAll();
    }

    public void deleteDoctor(int id) {

        doctorRepository.deleteById(id);
    }
}