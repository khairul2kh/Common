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

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
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
            @RequestParam("sDate") String sDate,
            @RequestParam("eDate") String eDate,
            @RequestParam(value = "sHour", required = false) String sHour,
            @RequestParam(value = "eHour", required = false) String eHour,
            @RequestParam(value = "sMin", required = false) String sMin,
            @RequestParam(value = "eMin", required = false) String eMin,
            @RequestParam(value = "eSecond", required = false) String eSecond,
            @RequestParam(value = "sSecond", required = false) String sSecond,
            @RequestParam(value = "sAmPm", required = false) String sAmPm,
            @RequestParam(value = "eAmPm", required = false) String eAmPm,
            @RequestParam(value = "selectedDepartment", required = false) String selectedDepartment,
            Model model) {

        try {
            // SELECT * FROM `billing_patient_service_bill_item` WHERE `created_date` ='2016-10-27 11:46:35'
            //"2016-10-27 01:01:01", "2016-10-27 23:59:59"
            CustomReportService reportService = Context.getService(CustomReportService.class);

            String startDateAndTime = getFormatedDateAndTime(sDate, sHour, sMin, sAmPm, sSecond);
            String endDateAndTime = getFormatedDateAndTime(eDate, eHour, eMin, eAmPm, eSecond);

            List<UserWiseBillingReport> rportList = reportService.getUserWiseBillingReport(userName, startDateAndTime, endDateAndTime);
            model.addAttribute("startDate", startDateAndTime);
            model.addAttribute("endDate", endDateAndTime);
            model.addAttribute("result", rportList);
            model.addAttribute("selectedDepartment", selectedDepartment);

        } catch (Exception e) {
            Logger.getLogger(AjaxController.class.getName()).log(Level.SEVERE, null, e);
        }

        return "/module/customreport/ajax/userWiseBillingReport";
    }

    private String getFormatedDateAndTime(String date, String hour, String min, String amPm, String second) {

        try {
            Calendar clEndDate = Calendar.getInstance();
            clEndDate.setTime(new SimpleDateFormat("yyyy-MM-dd").parse(date));

            Integer formatedHour = Integer.parseInt(hour);
            if (formatedHour == 12) {
                formatedHour = 0;
            }
            clEndDate.set(Calendar.HOUR, formatedHour);
            clEndDate.set(Calendar.MINUTE, Integer.parseInt(min));
            clEndDate.set(Calendar.SECOND, Integer.parseInt(second));

            if (Integer.parseInt(amPm) == 0) {
                clEndDate.set(Calendar.AM_PM, Calendar.AM);
                //clEndDate.add(Calendar.DAY_OF_YEAR, 1);
            } else {
                clEndDate.set(Calendar.AM_PM, Calendar.PM);
            }

            SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String formatted = format1.format(clEndDate.getTime());

            return formatted;

        } catch (ParseException e) {
            e.printStackTrace();
        }

        return null;

    }

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
