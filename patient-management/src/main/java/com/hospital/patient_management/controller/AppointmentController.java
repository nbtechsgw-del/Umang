package com.hospital.patient_management.controller;

import com.hospital.patient_management.model.Appointment;
import com.hospital.patient_management.service.AppointmentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/appointments")
@CrossOrigin("*")
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @PostMapping
    public Appointment addAppointment(
            @RequestBody Appointment appointment) {

        return appointmentService.saveAppointment(appointment);
    }

    @GetMapping
    public List<Appointment> getAllAppointments() {
        return appointmentService.getAllAppointments();
    }

    @DeleteMapping("/{id}")
    public String deleteAppointment(@PathVariable int id) {

        appointmentService.deleteAppointment(id);

        return "Appointment deleted successfully";
    }
}