<%--
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
--%> 
<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>


<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery('#eDate, #sDate').datepicker({yearRange: 'c-30:c+30', dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true});


        document.getElementById('selectedUserList').ondblclick = function() {
            this.options[this.selectedIndex].remove();
        };
    });


    function callAutoComplete() {

        var stringArray = new Array();
    <c:forEach var="userName" items="${stringList}" varStatus="status">
        stringArray [${status.index}] = "${userName}";
    </c:forEach>
        $("#tags").autocomplete({
            source: stringArray,
            select: function(event, ui) {
                value = ui.item.value;
                previousValue = jQuery('#userName').val();

                if (previousValue != "") {
                    currentValue = previousValue + "," + value;
                    jQuery('#userName').val(currentValue);
                } else {
                    jQuery('#userName').val(value);
                }
            }
        });
    }

    function getPatientReport() {
        var arrayValues = $("#selectedUserList > option").map(function() {
            return this.text;
        }).get();
        // alert(arrayValues);


        var sDate = jQuery('#sDate').val();
        var eDate = jQuery('#eDate').val();

        var selectedDepartment = jQuery("#department option:selected").val();
        if (selectedDepartment == "Select") {
            selectedDepartment = "";
        }

        if (arrayValues == "" || sDate == "" || eDate == "") {

            alert("Please enter user name and date first");
            return;
        }
        var userNames = arrayValues.join();// return string from array
        $.ajax({
            type: "GET",
            url: "userWiseBillingReport.htm",
            data: ({
                userName: userNames,
                sDate: sDate,
                eDate: eDate,
                selectedDepartment: selectedDepartment
            }),
            success: function(data) {
                //alert("ss");
                // jQuery("#drugQuantity").val(data);		
                //  alert(data);
                jQuery("#patientReport").html(data);
                jQuery('#sDate').val("");
                jQuery('#eDate').val("");

                $('#selectedUserList option[value!="jQuery Reference"]').remove();// remove all but not jQuery Referendce
                //alert(x);
            },
            error: function() {
                alert("ERROR:");
            }
        });

    }

</script> 


<script type="text/javascript">
    $(function() {
        var stringArray = new Array();
    <c:forEach var="userName" items="${userList}" varStatus="status">
        stringArray [${status.index}] = {value: "${userName.userId}", label: "${userName.username}"};
    </c:forEach>

        $("#tags").autocomplete({
            source: stringArray,
            select: function(event, ui) {

                value = ui.item.value;
                label = ui.item.label;

                $("#tags").val("");

                if (isDuplicate(label)) {
                    //alert("true");
                    $("#selectedUserList").append('<option value="' + value + '">' + label + '</option>'); // sending data to the select box
                } else {
                    alert("Item already exists !");
                }
                return false;
            }
        });
    });


    function printReport() {
        $("#patientReport").printArea({
            mode: "popup",
            popClose: true
        });
    }

    function isDuplicate(currentValue) {
        var arrayValues = $("#selectedUserList > option").map(function() {
            return this.text;
        }).get();
        var text = "";
        var i;
        for (i = 0; i < arrayValues.length; i++) {
            text = arrayValues[i];
            //  alert(text);
            if (text == currentValue) {
                return false;
            }
        }
        return true;
    }


    //https://forums.digitalpoint.com/threads/javascript-form-validation-prevent-duplicate-entries-across-multiple-drop-downs.1374345/


//var itemExists = false;
    //$("#selectedUserList").each(function() {
    //alert($(this).text());
    // if ($(this).text() == $.trim(label)) {

    // itemExists = true;
    //}
    // });

    //if (!itemExists) {
    // $("#selectedUserList").append('<option value="' + value + '">' + label + '</option>'); // sending data to the select box
    //  }else{
    //  alert('Item already exists');
    ///}
</script>


<center><div class="boxHeader1">  <h2>Search Report</h2></div></center>
<div class="box1">

<div class="leftDiv">

 <span style="font-size:14px;  font-weight: bold;" > Search Users : </span> 
    <input class="inputField" id="tags" style="width: 300px"  placeholder="Please Enter User Name "/><br>
    <!--	<select
           class="userList"
           id="selectedUserList"  
           name="selectedUserList" multiple="multiple"
           placeholder="Selected User Name "
           style="min-width:150px;"
           >
   
       </select>
       style="width: 400px" -->
	   
	    <select
        class="userList"
        id="selectedUserList"  
        name="selectedUserList" multiple="multiple"
        placeholder="Selected User Name "
        style="min-width:300px;margin-left: 122px"
        >
    </select>

</div>
<div class="rightDiv">

   


    &nbsp;&nbsp;&nbsp;<span style="font-size:14px; font-weight: bold;"> Start Date : </span> 
    <input class="inputField" type="text" placeholder="Please Enter Start Date " id="sDate" name="sDate" style="width:250px;"/> &nbsp;&nbsp;&nbsp;

    <span style="font-size:14px; font-weight: bold;"> End Date &nbsp; : </span>  
    <input class="inputField" type="text" placeholder="Please Enter End Date " id="eDate" name="eDate" style="width:250px;"/>

    <span style="font-size:14px; font-weight: bold;"> Department &nbsp; : </span>
    <select id="department" class="">
        <option selected>Select</option>
        <c:forEach var="item" items="${depertmentList}">
            <option>${item.name}</option>
        </c:forEach>

    </select>



   

    <input  type="button" value="Get View" onclick="getPatientReport()" class="bu-normal" style="margin-top:15px; margin-left:20px;"  /> &nbsp;
    <input type="button" class="bu-normal"  value="Print" onclick="printReport()"/><br><br><br>
</div>
</div>

<div id="patientReport">

</div>
<!--
<div id="reportPrintArea">
    <center><h2>User Wise Daily Billing Report</h2>

        <span><h5>Start Date:  <b>${startDate}</b> &nbsp;&nbsp;&nbsp; End Date: <b>${endDate} </b></h5></span>

    </center><br>
    

    <center><table border="1px"  style="width:90%;"  class="table_data ">
            <thead>
                <tr>
                    <th style="text-align: center;">SL NO.</th>
                    <th style="text-align: center;">Username</th>
                    <th style="text-align: center;">Total Patient</th>
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
    <td>
        <h4> Total amount</h4>
    </td>
    <td><h4><c:out value="${totalAmout }" /></h4></td>
</tr>
</table>
</center>

</div>
-->

<style>
    #patientReport{
        margin-top: 30px; 
        padding-bottom: 18px;
    } 

    .mainContent{
        //  background-color:red;
        margin: auto;
        width: 100%;
        height:200px;
        // border: 3px solid #73AD21;
        // padding: 10px;
    } 
	.box1{
		//background-color:orange;
		//height: 600px;
		width:100%;
	}
    .leftDiv{
        // background-color:blue;
        float:left;
        //  margin-right: 50%;
    }
    .rightDiv{
         // background-color:green;
       // float:right;
        margin-left: 70px;
	// padding-left:20px;
	//width:100%;
    }

    .inputField  { 
        appearance: none;
        outline: 0;
        border: 1px solid #04B431;
        background-color: #A4A4A4;
        width: 200px;
        height:30px;
        border-radius: 3px;
        padding: 2px 10px;
        margin: 10px auto 10px auto;
        text-align: left;
        font-size: 16px;
        color: #fff;
        -webkit-transition-duration: 0.25s;
        transition-duration: 0.25s;
        font-weight: 200;
    }
    .inputField:hover {
        background-color: rgba(255, 255, 255, 0.4);
        color:#04B431;
    }

    .userList{
        background-color: #A4A4A4;
        color:white;
    }

    .userList:hover{
        background-color: rgba(255, 255, 255, 0.4);
        color:#04B431;
    }

    .boxHeader1{
        height:80px;
		width:100%;
        background-color: #eee;

    }
	
	
</style>

<!-- 

<div class="container">
  <h2>User wise daily reports</h2>

    <div class="form-group">
      <label for="tags">Search Users :</label>
       <input class="form-control" id="tags"   placeholder="Please Enter User Name "/>
    </div>
	
	
   <div class="form-group">
   
      <label for="sel2">Selected users:</label>
      <select multiple class="form-control" id="selectedUserList" style="height:100px">
  
      </select>
   </div>
   
     <div class="form-group">
      <label for="sDate">Start Date : </label>
      <input type="text" class="form-control" id="sDate" placeholder="Please Enter Start Date ">
    </div>
	
	<div class="form-group">
      <label for="eDate">End Date : </label>
      <input type="text" class="form-control" id="eDate" placeholder="Please Enter End Date ">
    </div>
	
	  <div class="form-group">
	  <label >Select Department:</label>
      <select class="form-control" id="department">
      <option selected>Select</option>
	         <c:forEach var="item" items="${depertmentList}">
            <option>${item.name}</option>
        </c:forEach>
      </select>
	</div>

	

  
    <button type="button" class="btn btn-default"  onclick="getPatientReport()">Submit</button>
	<button type="button" class="btn btn-default"   onclick="printReport()">Print</button>

</div>
-->
<%@ include file="/WEB-INF/template/footer.jsp" %>


