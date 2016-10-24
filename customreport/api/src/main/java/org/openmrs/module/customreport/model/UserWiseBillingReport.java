/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.openmrs.module.customreport.model;

/**
 *
 * @author Amir
 */
public class UserWiseBillingReport {
    
    private String serialNo;
    private String userName;
    private String totalPatient;
    private String freeBill;
    private String totalTaka;

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getTotalPatient() {
        return totalPatient;
    }

    public void setTotalPatient(String totalPatient) {
        this.totalPatient = totalPatient;
    }

    public String getFreeBill() {
        return freeBill;
    }

    public void setFreeBill(String freeBill) {
        this.freeBill = freeBill;
    }

    public String getTotalTaka() {
        return totalTaka;
    }

    public void setTotalTaka(String totalTaka) {
        this.totalTaka = totalTaka;
    }
    
   
}
