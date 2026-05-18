package com.hospital.patient_management.service;

import com.hospital.patient_management.model.Patient;
import com.hospital.patient_management.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    public Patient savePatient(Patient patient) {
        return patientRepository.save(patient);
    }

    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    public Patient getPatientById(int id) {
        return patientRepository.findById(id).orElse(null);
    }

    public Patient searchPatientById(int id) {
        return patientRepository.findByPatientId(id);
    }

    public Patient updatePatient(int id, Patient updatedPatient) {

        Patient existingPatient = patientRepository.findById(id).orElse(null);

        if (existingPatient != null) {
            existingPatient.setFullName(updatedPatient.getFullName());
            existingPatient.setAge(updatedPatient.getAge());
            existingPatient.setGender(updatedPatient.getGender());
            existingPatient.setPhone(updatedPatient.getPhone());
            existingPatient.setAddress(updatedPatient.getAddress());
            existingPatient.setBloodGroup(updatedPatient.getBloodGroup());

            return patientRepository.save(existingPatient);
        }  
        return null;
    }

    public void deletePatient(int id) {
        patientRepository.deleteById(id);
    }
}