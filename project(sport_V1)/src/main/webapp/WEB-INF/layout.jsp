<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:directive.include file="/WEB-INF/jsp/cmmn/incTagLib.jsp"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta id="mobileMeta" name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <title>SPORT</title>
    <script type="text/javascript" src="${pageContext.request.contextPath}/publish/eraser/js/jquery-1.11.3.min.js"></script>
    <!-- 하이차트 -->
    <script type="text/javascript" src="${pageContext.request.contextPath}/publish/eraser/js/highcharts.js"></script>
</head>

<body>
<div id="wrapper" class="eraser">
    <!-- header 시작 -->
    <tiles:insertAttribute name="header"/>
    <!--// header 끝 -->
    <!-- container 시작 -->
    <div id="container">
        <tiles:insertAttribute name="body"/>
    </div>
    <!--// container 끝 -->
    <!-- footer 시작 -->
    <tiles:insertAttribute name="footer"/>
    <!--// footer 끝 -->
</div>
</body>

</html>