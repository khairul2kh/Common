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
        $("#sHour,#eHour,#sMin,#eMin").keydown(function(e) {
            // Allow: backspace, delete, tab, escape, enter and .
            if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
                    // Allow: Ctrl+A, Command+A
                            (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                            // Allow: home, end, left, right, down, up
                                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                        // let it happen, don't do anything
                        return;
                    }

                    // Ensure that it is a number and stop the keypress
                    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                        e.preventDefault();
                    }
                });


        $("#sHour,#eHour,#sMin,#eMin").keyup(function(e) {

            var sHour = jQuery('#sHour').val();
            var eHour = jQuery('#eHour').val();
            var sMin = jQuery('#sMin').val();
            var eMin = jQuery('#eMin').val();

            if (sHour > 12) {
                var newValue = sHour.substring(0, sHour.length - 1);
                jQuery('#sHour').val(newValue);
            } else if (eHour > 12) {
                var newValue = eHour.substring(0, eHour.length - 1);
                jQuery('#eHour').val(newValue);

            } else if (sMin > 59) {
                var newValue = sMin.substring(0, sMin.length - 1);
                jQuery('#sMin').val(newValue);

            } else if (eMin > 59) {
                var newValue = eMin.substring(0, eMin.length - 1);
                jQuery('#eMin').val(newValue);

            }
        });

        $("#sHour,#eHour,#sMin,#eMin").keypress(function(e) {

            var sHour = jQuery('#sHour').val();
            var eHour = jQuery('#eHour').val();
            var sMin = jQuery('#sMin').val();
            var eMin = jQuery('#eMin').val();

            if (sHour > 12) {
                var newValue = sHour.substring(0, sHour.length - 1);
                jQuery('#sHour').val(newValue);
            } else if (eHour > 12) {
                var newValue = eHour.substring(0, eHour.length - 1);
                jQuery('#eHour').val(newValue);

            } else if (sMin > 59) {
                var newValue = sMin.substring(0, sMin.length - 1);
                jQuery('#sMin').val(newValue);

            } else if (eMin > 59) {
                var newValue = eMin.substring(0, eMin.length - 1);
                jQuery('#eMin').val(newValue);

            }
        });

        jQuery('#eDate, #sDate').datepicker({yearRange: 'c-30:c+30', dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true});

        $("#department").val('Select 0');
        $('#sAmPm').val(0);
        $('#eAmPm').val(1);

        $("#usersField").val("");
        jQuery('#sDate').val("");
        jQuery('#eDate').val("");
        jQuery('#eHour').val("");
        jQuery('#eMin').val("");
        jQuery('#sMin').val("");
        jQuery('#sHour').val("");

        document.getElementById('selectedUserList').ondblclick = function() {
            this.options[this.selectedIndex].remove();
        };
    });

    function callAutoComplete() {

        var stringArray = new Array();
    <c:forEach var="userName" items="${stringList}" varStatus="status">
        stringArray [${status.index}] = "${userName}";
    </c:forEach>
        $("#usersField").autocomplete({
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
        var sHour = jQuery('#sHour').val();
        var sMin = jQuery('#sMin').val();
        var eHour = jQuery('#eHour').val();
        var eMin = jQuery('#eMin').val();

        var sAmPm = $('#sAmPm').find(":selected").val();
        var eAmPm = $('#eAmPm').find(":selected").val();

        var selectedDepartment = jQuery("#department option:selected").val();
        if (selectedDepartment == "Select") {
            selectedDepartment = "";
        }

        if (sHour == '') {
            sHour = 0;
        }
        if (sMin == '') {
            sMin = 0;
        }
        if (eHour == '') {
            eHour = 11;
        }
        if (eMin == '') {
            eMin = 59;
        }

        //var sDateTime =sDate+" "+sHour+":"+sMin+":"+sAmPm;
        //	var eDateTime =eDate+" "+eHour+":"+eMin+":"+eAmPm;

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
                sHour: sHour,
                eHour: eHour,
                sMin: sMin,
                eMin: eMin,
                sSecond: "0",
                eSecond: "59",
                sAmPm: sAmPm,
                eAmPm: eAmPm,
                selectedDepartment: selectedDepartment
            }),
            success: function(data) {
                jQuery("#patientReport").html(data);
                jQuery('#sDate').val("");
                jQuery('#eDate').val("");
                jQuery('#eHour').val("");
                jQuery('#eMin').val("");
                jQuery('#sMin').val("");
                jQuery('#sHour').val("");

                $('#selectedUserList option[value!="jQuery Reference"]').remove();// remove all but not jQuery Referendce
                $("#department").val('Select 0');
                $('#sAmPm').val(0);
                $('#eAmPm').val(1);
            },
            error: function(e, ts, et) {
                alert(ts)
            }
        });

    }


    $(function() {
        var stringArray = new Array();
    <c:forEach var="userName" items="${userList}" varStatus="status">
        stringArray [${status.index}] = {value: "${userName.userId}", label: "${userName.username}"};
    </c:forEach>

        $("#usersField").autocomplete({
            source: stringArray,
            select: function(event, ui) {

                value = ui.item.value;
                label = ui.item.label;

                $("#usersField").val("");

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
            &nbsp;<input class="inputField" id="usersField" style="width: 300px"  placeholder="Please Enter User Name "/><br>

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

            &nbsp;&nbsp;&nbsp;<span style="font-size:14px; font-weight: bold;"> Start Date  &nbsp;:</span> 
            <input class="inputField" type="text" placeholder="Please Enter Start Date " id="sDate" name="sDate" style="width:250px;"/>


            &nbsp;&nbsp;&nbsp;<input type="number" min="1" max="12"  class="inputField" id="sHour"  style="width:70px"  placeholder="HH" />
            <span style="font-size:18px; font-weight: bold;">:</span> 
            <input  type="number" min="1" max="59" class="inputField" id="sMin"  style="width:70px"  placeholder="mm" maxlength="2" />
            <select id="sAmPm"  style="height:30px;margin: 0px" class="inputField">
                <option value="0">AM</option>
                <option value="1">PM</option>
            </select><br>

            &nbsp;&nbsp;&nbsp; <span style="font-size:14px; font-weight: bold;"> End Date &nbsp;&nbsp; : </span>  
            <input class="inputField" type="text" placeholder="Please Enter End Date " id="eDate" name="eDate" style="width:250px;"/>

            &nbsp;&nbsp;&nbsp;<input type="number" min="1" max="12" class="inputField" id="eHour"  style="width:70px"  placeholder="HH" />
            <span style="font-size:18px; font-weight: bold;">:</span> 
            <input type="number" min="1" max="59" class="inputField" id="eMin"  style="width:70px"  placeholder="mm" />
            <select id="eAmPm" style="height:30px;margin: 0px" class="inputField">
                <option value="0">AM</option>
                <option value="1">PM</option>
            </select><br>

            &nbsp;&nbsp;&nbsp; <span style="font-size:14px; font-weight: bold;"> Department: </span>
            <select id="department" class="inputField" >
                <option selected>Select</option>
                <c:forEach var="item" items="${depertmentList}">
                    <option>${item.name}</option>
                </c:forEach>

            </select>
            <input  type="button" value="Get View" onclick="getPatientReport()" class="button"  />
            <input type="button" class="button"  value="Print" onclick="printReport()"/><br>
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
        //width: 200px;
        height:30px;
        border-radius: 3px;
        padding-left: 5px;
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

    .button {
        display: inline-block;
        padding: 5px 10px;
        font-size: 16px;
        cursor: pointer;
        text-align: center;
        text-decoration: none;
        font-weight: bold;
        outline: none;
        color: #000080;
        background-color:#D3D3D3;
        border: none;
        border-radius: 5px;
        // box-shadow: 0 9px #999;
    }

    .button:hover {background-color: white;
                   color:#3e8e41;
                   box-shadow: 1px 1px 2px 1px #4CAF50;
    }

    .button:active {
        background-color: #3e8e41;
        box-shadow: 0 5px #666;
        transform: translateY(4px);
    }


</style>
<%@ include file="/WEB-INF/template/footer.jsp" %>


