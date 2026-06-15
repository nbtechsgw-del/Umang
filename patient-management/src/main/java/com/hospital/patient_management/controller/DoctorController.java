package com.hospital.patient_management.controller;

import com.hospital.patient_management.model.Doctor;
import com.hospital.patient_management.service.DoctorService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/doctors")

@CrossOrigin(origins = "*")
public class DoctorController {

    @Autowired
    private DoctorService doctorService;

    @PostMapping
    public Doctor addDoctor(
    @RequestBody Doctor doctor) {

        return doctorService.addDoctor(doctor);
    }

    @GetMapping
    public List<Doctor> getAllDoctors() {

        return doctorService.getAllDoctors();
    }

    @DeleteMapping("/{id}")
    public String deleteDoctor(
    @PathVariable int id) {

        doctorService.deleteDoctor(id);

        return "Doctor Deleted Successfully";
    }
}