package com.hospital.patient_management.controller;

import com.hospital.patient_management.model.MedicalRecord;
import com.hospital.patient_management.service.MedicalRecordService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/records")
@CrossOrigin("*")
public class MedicalRecordController {

    @Autowired
    private MedicalRecordService medicalRecordService;

    @PostMapping
    public MedicalRecord addRecord(
            @RequestBody MedicalRecord record) {

        return medicalRecordService.saveRecord(record);
    }

    @GetMapping
    public List<MedicalRecord> getAllRecords() {
        return medicalRecordService.getAllRecords();
    }
}