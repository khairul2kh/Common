
<%@ include file="/WEB-INF/template/include.jsp" %>
<center><h2>User Wise Billing Report</h2>
 <c:choose>
        <c:when test="${not empty selectedDepartment}">
            <center><h4>Department: ${selectedDepartment}</h4>
        </c:when>
    </c:choose>
<span><h5>Start Date:  <b>${startDate}</b> &nbsp;&nbsp;&nbsp; End Date: <b>${endDate} </b></h5></span>

<br>
    <c:choose>
        <c:when test="${not empty result}">
           <table border="1px"  style="width:100%;"  class="table_data ">
	            <thead>
                <tr>
                    <th style="text-align: center;">SL NO.</th>
                    <th style="text-align: center;">Username</th>
                    <th style="text-align: center;">Total Tests</th>
                    <th style="text-align: center;">Free Bill</th>
                    <th style="text-align: center;">Total Taka</th>
                </tr>
				</thead>
                <c:set var="totalAmout" value="${0}"/>
                <c:forEach items="${result}" var="report" varStatus="varStatus">
                    <tr align="center" class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow" } '>


                        <td><c:out value="${varStatus.count }"/></td>	
                        <td>${report.userName}</td>
                        <td>${report.totalPatient}</td>
                        <td>
                            ${report.freeBill}
                        </td>

                        <td>${report.totalTaka}</td>

                        <c:set var="totalAmout" value="${totalAmout + report.totalTaka}"/>
                    </tr>



                </c:forEach>
                <tr align="center"  >
                    <td></td>	
                    <td></td>
                    <td></td>
                 <th style="text-align: center;">
                  Total amount
                </th>
                <th style="text-align: center;"><c:out value="${totalAmout }" /></th>
                </tr>
            </table>
			
        </c:when>
        <c:otherwise>
            No reports found.
        </c:otherwise>
    </c:choose>
	
	</center>






