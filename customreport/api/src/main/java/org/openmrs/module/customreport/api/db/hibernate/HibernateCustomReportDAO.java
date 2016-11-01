/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.customreport.api.db.hibernate;

import java.util.ArrayList;
import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.openmrs.api.db.DAOException;
import org.openmrs.module.customreport.api.db.CustomReportDAO;
import org.openmrs.module.customreport.model.UserWiseBillingReport;

/**
 * It is a default implementation of  {@link CustomReportDAO}.
 */
public class HibernateCustomReportDAO implements CustomReportDAO {
	protected final Log log = LogFactory.getLog(this.getClass());
	
	private SessionFactory sessionFactory;
	
	/**
     * @param sessionFactory the sessionFactory to set
     */
    public void setSessionFactory(SessionFactory sessionFactory) {
	    this.sessionFactory = sessionFactory;
    }
    
	/**
     * @return the sessionFactory
     */
    public SessionFactory getSessionFactory() {
	    return sessionFactory;
    }
    
    public List<UserWiseBillingReport> getUserWiseBillingReport(String userName, String sDate, String eDate) throws DAOException {

        String formatedString = getFormatedString(userName);
        
        System.out.println(formatedString);

        Session session = sessionFactory.getCurrentSession();
        Transaction tx = session.beginTransaction();

        SQLQuery query = session.createSQLQuery("SELECT pn.`given_name`,pn.`family_name` ,COUNT(bpsbi.`patient_service_bill_id`)AS total_patient,SUM(bpsb.`free_bill`)AS free,SUM(bpsbi.`actual_amount`)AS total_taka\n"
                + "FROM `billing_billable_service` AS bbs\n"
                + "INNER JOIN `billing_patient_service_bill_item` AS bpsbi\n"
                + "ON bbs.`service_id`=bpsbi.`service_id`\n"
                + "INNER JOIN `billing_patient_service_bill` AS bpsb ON bpsbi.`patient_service_bill_id`=bpsb.`patient_service_bill_id`\n"
                + "INNER JOIN patient_search AS ps ON bpsb.`patient_id`=ps.`patient_id`\n"
                + "\n"
                + "INNER JOIN users AS u ON bpsb.`creator`=u.`user_id`\n"
                + "INNER JOIN `person_name`AS pn ON pn.`person_id`=u.`person_id`\n"
                + "WHERE bpsbi.voided='0' AND "+ formatedString +" AND bpsbi.`created_date` BETWEEN '" + sDate + "' AND '" + eDate + "'\n"
                + "GROUP BY u.`username`");

        List<Object[]> rows = query.list();

        List<UserWiseBillingReport> reports = new ArrayList();

        for (Object[] row : rows) {
            UserWiseBillingReport obj = new UserWiseBillingReport();
            obj.setUserName(row[0].toString());
            obj.setTotalPatient(row[2].toString());
            obj.setFreeBill(row[3].toString());
            obj.setTotalTaka(row[4].toString());
            reports.add(obj);
        }

        return reports;
    }

    private String getFormatedString(String userNames) {

        if (userNames.isEmpty()) {
            return "";
        }

        if (userNames.endsWith(",")) {
            userNames = userNames.substring(0, userNames.length() - 1);
        }
       // System.out.println(userNames);

        String[] nameArray = userNames.split(",");

        String formatedUserNames = "";

        for (int i = 0; i < nameArray.length; i++) {
            String userName = nameArray[i];
            formatedUserNames += " u.`username`='" + userName + "' OR";
        }

        if (formatedUserNames.endsWith("OR")) {
            formatedUserNames = formatedUserNames.substring(0, formatedUserNames.length() - 2);
        }

        return formatedUserNames;
    }

}