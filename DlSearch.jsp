<%@ include file="commonForJquery3.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=stylesheetPath + staticParameter%>" type="text/css" rel="stylesheet">
<script language="JavaScript" type="text/javascript" src="<%=jsPath%>constants.js<%=staticParameter%>"></script>
<script language="JavaScript" type="text/javascript" src="<%=jsPath%>common.js<%=staticParameter%>"></script>
<!-- multiselect lib -->
<link href="<%=stylesheetRootPath%>multipleSelect.css<%=staticParameter%>" type="text/css" rel="stylesheet"/>
<script language="JavaScript" type="text/javascript" src="<%=jsPath%>multipleSelect.js<%=staticParameter%>"></script>
<title>DL 검색</title>
</head>
<script>
//for jquery 3.0.0.0
$(document).ready(function(){
	//검색어 엔터 ev
	 $("#searchWord").on('keydown', function(e) { 
		    var code = e.which; // recommended to use e.which, it's normalized across browsers
		    if(code==13)e.preventDefault();
		    if(code==32||code==13||code==188||code==186){
		    	if ( $("#searchWord").val()== ''){
		    		alert("검색어를입력하세여");
		    		return false;
		    	}
		    	$('#btnDlSearch').trigger("click");
		    } 
	 });
	
	 $('#btnGetSelected').on('click', function() {
		 getSelectedValues();
	 });
	

	 $('#btnDlSearch').on('click', function() {
		if ( $("#searchWord").val()== ''){
    		alert("검색어를입력하세여");
    		return false;
    	}

		$('#loadingImg2').show();
		$.ajax({
			url : "/getJsonDlList.nhn",
			type : 'post',
			dataType : 'json',
			data : {
				searchWord : $("#searchWord").val()
			},
			success : function(	data) {
				
				var htmlEl= "<select id='dlList' multiple='multiple' style='width:800'>";
				$.each(data.dlList, function(index, value) {
					htmlEl += "<option value='"+value.dl_cd + "'>"+value.dl_nm + "</option>";
				});
				
				htmlEl +="</select>";
				$("#dlListDiv").empty();
				$("#dlListDiv").append(htmlEl);
			
				//멀티셀렉트 렌더링
				$("#dlList").multipleSelect({
		            filter: true,
		            multiple: true,
		            width: 786,
		            minimumCountSelected:10,
		            multipleWidth:200,
		            placeholder:"dl값을 선택하세요",
		            isOpen :true
		        });
				
				$('#loadingImg2').hide();

			},
			error : function(data) {
				alert("dl list fetch error");
			}
		});
	}); //btnDlSearchEnd
	
}); 


var arraySelectedDl= [];

function getSelectedValues(){
	var arrSelectedValue = $('select').multipleSelect('getSelects');
	var arrSelectedText =$('select').multipleSelect('getSelects', 'text');
	
	for (var i=0 ;  i < arrSelectedValue.length ; i++){
		var htmlEl = "<div id=selectedDlList[] name=selectedDlList[] class=removeLine value='"+arrSelectedValue[i]  + "' dlName='"+ arrSelectedText[i]+ "'><img  src='/template/img/btn_del_red.gif' width='5' height='5' alt='' />&nbsp;" + arrSelectedText[i]+ "</div>";
		
		//########
		//증복체크
		//########
		/* if ( arrSelectedValue.length> 0 && duplicationCheckInArray(arraySelectedDl,arrSelectedValue[i] )){
			break;
		} */
		$("#selectedDlListDiv").append(htmlEl);
		arraySelectedDl.push(arrSelectedValue[i]);
			
	}
	
	console.log("arraySelectedDl-->"+ arraySelectedDl.toString());
	 
	 
	$('.removeLine').on('click', function() {
 		var dl_cd = $(this).attr("value");
 		//alert(dl_cd);
 		
 		$(this).closest("div").remove();
 		//remove  dlElement in array
 		var index = arraySelectedDl.indexOf(dl_cd);
		if (index > -1) {
			arraySelectedDl.splice(index,1);
		}
		console.log("arraySelectedDl-->"+ arraySelectedDl.toString());
	});
	
	//적용버튼 ev
 	$('#applyDlList').on('click', function() {
		 
		 var arrayDlCdList = $("div[name='selectedDlList[]']").map(function(){return $(this).attr("value");}).get();
		 var arrayDlNameList = $("div[name='selectedDlList[]']").map(function(){return $(this).attr("dlName");}).get();
		 
		 for (var i=0 ;  i < arrayDlCdList.length ; i++){
				var htmlEl= "<span style='width:44px;'><a class=dlDetailView value='"+arrayDlCdList[i] + "' href='#'>"+ arrayDlNameList[i]+ "</a> <img class=removeLine src='/template/img/btn_del_red.gif' width='5' height='5' style='margin:0 3px 2px 3px; cursor:pointer;'></span>"
				arraySelectedDl.push(arrayDlCdList[i])
				//opener's element 
				$("#dlUserMulti",opener.document).append(htmlEl);	
				self.close();
			
		 }
		 
		 console.log("arraySelectedDl--->"+ arraySelectedDl.toString());
	 });
}

//pArray에 중복값이 있는지를 체크 (중복일경우 true return)
function duplicationCheckInArray(pArray, checkValue) {
	var isDulicate = false;
	$.each(pArray, function (idx, el) {
	    // alert(pArray[idx]);
	     //중복값이 있을경우.
	     if ( pArray[idx] == checkValue){
	    	 alert("이미 선택된 DL이 있습니다.");
	    	 //중복인 경우.
	    	 isDulicate= true;
	     }
	     
	});
	return isDulicate;
}
</script>
<style>
.ms-parent {
 width: 700
}

div #loadingImg2 {
	overflow: hidden;
	position: absolute;
	top: 80px;
	left: 350;
	z-index: 10;
}
</style>
<body>
<form name="frm" id="frm" action="memberSearch.nhn?m=searchMember" method="post" onsubmit="return false;">

	<div id="pop">
		<div class="pop_tit">
			<h1 >
				DL검색
			</h1>
		</div>
		
		<div class="pop_cont" style="padding-top:5px;">
 
		    <table cellpadding="0" cellspacing="0" border="0" class="search_unit" width="100%" style="margin-bottom:3px;">
				<tr>
					<td width="20%">
		               	DL명
		            </td>
		            
		            <td>
						<input type="text"  id="searchWord" name="searchWord" value="TF" /> 
								
					</td>
					<td>
						<a href="#" id="btnDlSearch" class="btn_s03"><span class="l"></span><span class="c"><lucy:message key="button.search"/></span><span class="r"></span></a>
						
						<a href="#" id="btnGetSelected" class="btn_s03"><span class="l"></span><span class="c">체크값 선택</span><span class="r"></span></a>
					</td>
				</tr>
			</table>
			<!--// 검색 -->

			<!-- multiselect start -->	
			<div id="dlListDiv" class="common_search_outer01" style="border: 0px;">
			</div>
			<!-- multiselect End -->
			
			<div class="b" style="padding:6px 0 5px 5px;width:300px">선택한 DL</div>
				<div id="selectedDlListDiv" class="common_search_outer01" style="border: 0px;">
			</div>
			
			<div id=loadingImg2 style="display: none">
				<img id="imgloadingImg2" src="/template/img/progress_bar7.gif">
			</div>
			<div class="btmline" style="margin-top:2px;">
			  <div class="line"></div>
			</div>
		    <div class="pop_btm">		
				<div>						
					<table align="center" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<html:button id="applyDlList" functionName="">
									<lucy:message key="button.apply" />
								</html:button>
								<html:button functionName="self.window.close();">
									<lucy:message key="button.close" />
								</html:button>
							</td>
						</tr>
					</table>								
				</div>
		    </div>
		       
		</div>
	</div>

</div>
  
</form>
</body>
</html>