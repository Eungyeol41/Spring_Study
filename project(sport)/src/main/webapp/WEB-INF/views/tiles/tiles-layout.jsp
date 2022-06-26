<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="description" content="">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<title><tiles:insertAttribute name="title" /></title>
</head>

<body>
<div class='wrap'>
	<tiles:insertAttribute name="header" />
	<div class='content'>
		<div class="page_content">
			<tiles:insertAttribute name="body"/>
		</div>
	</div>
	<tiles:insertAttribute name="foot" />
</div>
</body>

</html>