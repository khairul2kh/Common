/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.customreport.web.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.ConceptName;
import org.openmrs.User;
import org.openmrs.api.UserService;
import org.openmrs.api.context.Context;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author Amir
 */
@Controller("UserWiseBillingReportController")
@RequestMapping("/module/customreport/userWiseBillingReportController.htm")
public class UserWiseBillingReportController {

    @RequestMapping(method = RequestMethod.GET)
    public String viewBillingReport(
            Model model) {

        UserService userService = Context.getService(UserService.class);
        List<User> userList = userService.getAllUsers();
        model.addAttribute("userList", userList);

        Concept serviceOrderConcept = Context.getConceptService().getConceptByName("SERVICES ORDERED");
        List<ConceptAnswer> serviceConceptList = (serviceOrderConcept != null ? new ArrayList<ConceptAnswer>(serviceOrderConcept.getAnswers()) : null);
        List<ConceptName> depertmentList = new ArrayList();
        
        if(serviceConceptList!=null && !serviceConceptList.isEmpty()){
        for (ConceptAnswer conceptAnswer : serviceConceptList) {
            Collection<ConceptAnswer> individualConceptAnswers = conceptAnswer.getAnswerConcept().getAnswers();
            for (ConceptAnswer con : individualConceptAnswers) {
                // System.out.println("individual concept name: "+con.getAnswerConcept().getName());
                depertmentList.add(con.getAnswerConcept().getName());
            }
           // System.out.println("Ans concept name: "+conceptAnswer.getAnswerConcept().getName());
        }
        }
        
        
        model.addAttribute("depertmentList", depertmentList);
        return "/module/customreport/reportRole/billingReport";
    }
}
