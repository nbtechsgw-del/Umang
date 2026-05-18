package com.hospital.patient_management.service;

import com.hospital.patient_management.model.MedicalRecord;
import com.hospital.patient_management.repository.MedicalRecordRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MedicalRecordService {

    @Autowired
    private MedicalRecordRepository medicalRecordRepository;

    public MedicalRecord saveRecord(MedicalRecord record) {
        return medicalRecordRepository.save(record);
    }

    public List<MedicalRecord> getAllRecords() {
        return medicalRecordRepository.findAll();
    }
}