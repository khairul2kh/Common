 /*
 *  Copyright 2009 Society for Health Information Systems Programmes, India (HISP India)
 *
 *  This file is part of Report module.
 *
 *  Report module is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  Report module is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Report module.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
/**
 * <p>
 * File: org.openmrs.module.report.web.controller.global.AjaxController.java
 * </p>
 * <p>
 * Project: standard-omod </p>
 * <p>
 * Copyright (c) 2011 HISP Technologies. </p>
 * <p>
 * All rights reserved. </p>
 * <p>
 * Author: Nguyen manh chuyen </p>
 * <p>
 * Email: chuyennmth@gmail.com</p>
 * <p>
 * Update by: Nguyen manh chuyen </p>
 * <p>
 * Version: $1.0 </p>
 * <p>
 * Create date: Mar 22, 2011 12:39:41 PM </p>
 * <p>
 * Update date: Mar 22, 2011 12:39:41 PM </p>
 *
 */
package org.openmrs.module.report.web.controller.ajax;



import java.util.List;
import org.openmrs.api.context.Context;
import org.openmrs.module.customreport.api.CustomReportService;
import org.openmrs.module.customreport.model.UserWiseBillingReport;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;


@Controller("ReportAjaxController")
public class AjaxController {



    @RequestMapping(value = "/module/customreport/userWiseBillingReport.htm", method = RequestMethod.GET)
    public String getUserWiseBillingReport(
            @RequestParam(value = "userName", required = false) String userName,
            @RequestParam("sDate") String sDate, @RequestParam("eDate") String eDate,@RequestParam(value = "selectedDepartment",required = false) String selectedDepartment, Model model) {

        CustomReportService reportService = Context.getService(CustomReportService.class);

        List<UserWiseBillingReport> rportList = reportService.getUserWiseBillingReport(userName, sDate, eDate);

         model.addAttribute("startDate",sDate);
        model.addAttribute("endDate",eDate);
        model.addAttribute("result", rportList);
        model.addAttribute("selectedDepartment",selectedDepartment);
     
        return "/module/customreport/ajax/userWiseBillingReport";
    }

//    private String getFormatedString(String userNames) {
//
//        if (userNames.isEmpty()) {
//            return "";
//        }
//
//        if (userNames.endsWith(",")) {
//            userNames = userNames.substring(0, userNames.length() - 1);
//        }
//        userNames = userNames.replaceAll(",", " OR ");
//
//        return userNames;
//    }

}
