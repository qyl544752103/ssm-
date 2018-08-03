<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%
	//将当前项目的路径上下文获取。 在下面需要路径的地方直接使用 不因为路径的改变而出错
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
 <script>
        var count = 2;
        var t;
        function writeTip(){           
            document.getElementById("d").innerHTML = "<a href='${APP_PATH}/views/welcome.jsp'>欢迎来到员工信息系统，页面将在"+(count--)+"秒内跳转</a>";   
            if(count==0){
                window.clearInterval(t);
                window.location = "${APP_PATH}/views/welcome.jsp";               
            }
        }


        t = window.setInterval("writeTip()",1000);
    </script>
</head>
<body>
	<!--  欢迎来到员工信息系统。。。。。。-->
   <div id="d">
       <a href='${APP_PATH}/views/welcome.jsp'>欢迎来到员工信息系统，页面将在3秒内跳转</a>
    </div>
</body>
</html>