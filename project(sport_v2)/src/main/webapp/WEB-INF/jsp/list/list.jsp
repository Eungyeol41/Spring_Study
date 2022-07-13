<%--@elvariable id="searchVO" type="com.ini.sport.list.service.ListVO"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:directive.include file="/WEB-INF/jsp/common/tagLib.jsp" />

<script>
	$.ajax({
		method: "POST"
		, url: "addList.do"
		, dataType: "html"
		, data: $("#defaultFrm").serialize()
		, success: function (data) {
            $(".add-list").html(data)
		}, error: function (err, msg) {
            alert("ERROR - " + err + msg);
            console.log(err + " " + msg);
		}
	});
</script>
<div>
	<div>LIST PAGE</div>
	<div class="add-list"></div>
</div>