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
REPORT={
		checkValue : function()
		{
			var form = jQuery("#form");
			if( jQuery("input[type='checkbox']:checked",form).length > 0 )
			{ 
				if(confirm("Are you sure?"))
				{
					form.submit();
				}
			}
			else
			{
				alert("Please choose objects for deleting");
				return false;
			}
		},
		search : function(thiz){
			var searchName = jQuery("#searchName").val();
			var fromDate = jQuery("#fromDate").val();
			var toDate = jQuery("#toDate").val();
			ACT.go("reportList.form?searchName="+searchName+"&fromDate="+fromDate+"&toDate="+toDate);
		},
		viewReport : function(thiz)
		{
			var xmlFile = jQuery("#xmlFile").val();
			if(xmlFile != null && xmlFile !=''){
				jQuery("#sourceFileReportForm").attr('action','saveTempFileReport.form');
				jQuery("#sourceFileReportForm").submit();
			}
			else{
				alert('No content!');
			}
		},
		deleteReportType : function(id, reportId)
		{
			if(confirm("Are you sure?"))
			{
				ACT.go("deleteReportType.form?id="+id+"&reportId="+reportId);
			}
		},
		downloadReportType : function(id)
		{
			ACT.go("downloadReportType.form?id="+id);
		},
		onChangeRole : function(thiz)
		{
			var x= jQuery(thiz).val();
			if(x != null && x!='')
			{
				ACT.go("reportRole.form?roleId="+x);
			}
		},
		addRemoveReportToRole : function(thiz){
			
			// 0 is remove, 1 is add
			var role = jQuery("#roleId").val();
			if(role == '' || role == null){
				alert('Please choose role first!');
				return false;
			}
			var report = jQuery(thiz).val();
			var action = jQuery(thiz).is(':checked') ? 1 : 0;
			if(role != null && role !='' && report != null && report != '' && (action == 0 || action == 1) ){
				var data = jQuery.ajax(
						{
							type:"POST"
							,url: "addRemoveReportToRole.form"
							,data: ({roleId :role,reportId: report,action: action })	
							,async: false
							, cache : false
						}).responseText;
				
			}
			
			
		}
};

