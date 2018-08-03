<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <c:import url="selectEmp.jsp"></c:import> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工修改</title>
<%
	//将当前项目的路径上下文获取。 在下面需要路径的地方直接使用 不因为路径的改变而出错
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- 引入jQuery -->
<script type="text/javascript"
	src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入bootstrap 参照官方文档的例子-->
<link
	href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
	
	<script type="text/javascript">
	function getEmp(id) {
		$.ajax({
			url : "${APP_PATH}/emps/emp/" + id,
			type : "GET",
			success : function(result) {
				//将获取到的员工信息，填充到修改模态框中
				var empData = result.extend.emp;
				//填入用户名 邮箱
				$("#empName_update_input").val(empData.empName);
				$("#email_update_input").val(empData.email);
				//填入性别，下拉列表。使用另外的方法
				$("#emp_update_Model input[name=gender]").val(
						[ empData.gender ]);
				$("#emp_update_Model select").val([ empData.dId ]);

			}

		});

	}

	$(document).on("click", ".edit_btn", function() {
		//获取部门信息
		getDept("#emp_update_Model select");
		//获取每个要修改的员工id 并将员工信息展示在修改的模态框中
		getEmp($(this).attr("edit_id"));
		//将用户的id值 通过修改按钮传递到更新按钮。统一id  传到后台使用	
		$("#emp_update_btn").attr("edit_id",$(this).attr("edit_id"))
		$("#emp_update_Model").modal({
			backdrop : "static"
		})

	})
	//更新
	$(document).on("click","#emp_update_btn",function(result){
		//用户名设置不能操作。
		//邮箱更改后需要做一个验证校验  
		 var email = $("#email_update_input").val();
		 var regemail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		 if(!regemail.test(email)){
			 show_jiaoyan_msg("#email_update_input","error","邮箱格式不正确");
			 return false;
		 }else{
			 show_jiaoyan_msg("#email_update_input","success","邮箱可用");
				
				$.ajax({
					url:"${APP_PATH}/emps/emp/"+$(this).attr("edit_id"),
					type:"PUT",
					data:$("#emp_update_Model form").serialize(),
					success:function(result){
						$("#emp_update_Model").modal('hide');
						to_page(dangqian); 
					}
					
				});
		 }
		
	});
	
		
		
	
	</script>
</body>
</html>