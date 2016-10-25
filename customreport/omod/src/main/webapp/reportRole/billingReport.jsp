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

        $("#department").val('Select 0');
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
                jQuery("#patientReport").html(data);
                jQuery('#sDate').val("");
                jQuery('#eDate').val("");

                $('#selectedUserList option[value!="jQuery Reference"]').remove();// remove all but not jQuery Referendce
                $("#department").val('Select 0');
            },
            error: function() {
                alert("ERROR:");
            }
        });

    }


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

</script> 


<center><div class="boxHeader1">  <h3>Multi User Collected Amount Report</h3></div></center>
<div class="box1">
    <div class ="mainContent">
        <div class="leftDiv">

            <span style="font-size:14px;  font-weight: bold;" > Search Users &nbsp;&nbsp;&nbsp;:</span> 
            &nbsp;<input class="inputField" id="tags" style="width: 300px"  placeholder="Please Enter User Name "/><br>

            <label style="font-size:14px;  font-weight: bold;" >Selected Users :</label>
            <select
                class="userList"
                id="selectedUserList"  
                name="selectedUserList" multiple="multiple"
                placeholder="Selected User Name "
                style="min-width:300px;margin-left: 0px"
                >
            </select>

        </div>
        <div class="rightDiv">

            &nbsp;&nbsp;&nbsp;<span style="font-size:14px; font-weight: bold;"> Start Date :</span> 
            <input class="inputField" type="text" placeholder="Please Enter Start Date " id="sDate" name="sDate" style="width:250px;"/> &nbsp;&nbsp;&nbsp;

            <span style="font-size:14px; font-weight: bold;"> End Date &nbsp; : </span>  
            <input class="inputField" type="text" placeholder="Please Enter End Date " id="eDate" name="eDate" style="width:250px;"/><br>

            &nbsp;&nbsp;&nbsp; <span style="font-size:14px; font-weight: bold;"> Department &nbsp; : </span>
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
</div>
<div id="patientReport">

</div>

<style>
    #patientReport{
        margin-top: 30px; 
        padding-bottom: 18px;
        //width:70%;
    } 

    .mainContent{
        margin: auto;
        width: 90%;
    } 
    .box1{
        width:100%;
    }
    .leftDiv{
        float:left;
    }
    .rightDiv{
        margin-left: 70px;
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
        height:70px;
        width:100%;
        background-color: #eee;

    }


</style>
<%@ include file="/WEB-INF/template/footer.jsp" %>


