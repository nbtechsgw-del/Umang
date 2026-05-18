package com.hospital.patient_management.controller;

import com.hospital.patient_management.model.Patient;
import com.hospital.patient_management.service.PatientService;
import com.hospital.patient_management.repository.PatientRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/patients")
@CrossOrigin("*")
public class PatientController {

    @Autowired
    private PatientService patientService;
    private PatientRepository patientRepository;

    @PostMapping
    public Patient addPatient(@RequestBody Patient patient) {
        return patientService.savePatient(patient);
    }

    @GetMapping
    public List<Patient> getAllPatients() {
        return patientService.getAllPatients();
    }

    @GetMapping("/{id}")
    public Patient getPatientById(@PathVariable int id) {
        return patientService.getPatientById(id);
    }

    @GetMapping("/id/{id}")
    public Patient searchPatientById(@PathVariable int id) {
        return patientService.searchPatientById(id);
    }

    @PutMapping("/{id}")
    public Patient updatePatient(@PathVariable int id, @RequestBody Patient patient) {
        return patientService.updatePatient(id, patient);
    }

    @DeleteMapping("/{id}")
    public String deletePatient(@PathVariable int id) {
        patientService.deletePatient(id);
        return "Patient deleted successfully";
    }

    @GetMapping("/search/name/{name}")
    public List<Patient> searchByName(@PathVariable String name) {
        return patientRepository.findByFullNameContaining(name);
    }

    @GetMapping("/search/phone/{phone}")
    public List<Patient> searchByPhone(@PathVariable String phone) {
        return patientRepository.findByPhone(phone);
    }
}