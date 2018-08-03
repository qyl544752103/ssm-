<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
 <c:import url="selectEmp.jsp"></c:import> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工增加</title>
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
	/**
		做一个员工增加的模块功能。
		关键点：
			1.在新增的模态框中需要提前获取部门信息。展示在下拉列表中。
			2.做好新增验证信息
				a.用户名，邮箱名规则验证
				b.输入框的状态提示信息
				c.输入框的颜色变化
			3.验证有命名规则，用户名重复验证
			4.前台验证，jsr303验证
			5.提取共同的校验提示信息，减少工作量
			5.新增成功后，直接跳转到新增页面的。最后一页
	*/		

	
	//每次打开新增的模态框也要清空里面的各种信息
	function clean_add_modal(ele){
		/*
		如果单纯需要采用JavaScript来重置，可以采用 document.getElementById('emp_add_form').reset() 来实现，
		使用jQuery则使用 $('#emp_add_form')[0].reset() 
		或者 $('#emp_add_form').trigger("reset") 
		*/			
		document.getElementById("emp_add_form").reset();
		//$(ele)[0].reset();
		//清除校验状态 绿色框  红色框 bootstrap自带的
		$(ele).find("*").removeClass("has-error has-success ");
		//清除校验提示信息
		$(ele).find(".help-block").text("");
		
	} 
	
	$(document).on("click","#add_btn",function(){
		//清理每次打开新增模态框中的form表单信息。
		clean_add_modal("#emp_add_form");
		//获取部门信息
		getDept("#emp_add_Model select");
		$("#emp_add_Model").modal({
			backdrop:"static"
		});
		
	});	
	 
	
	 //校验表单数据 是否符合要求
	 function jiaoyan_add_form(){
		 //需要验证是否符合要求
		 var empName = $("#empName_add_input").val();
		 var  regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
		 if(!regName.test(empName)){
			/*  $("#empName_add_input").parent().addClass("has-error");
			 $("#empName_add_input").next("span").text("用户名必须是2-5中文或者6-16英文字母和数字组合"); */
			 show_jiaoyan_msg("#empName_add_input","error","用户名必须是2-5中文或者6-16英文字母和数字组合");
			return false;
		 }else{
			 show_jiaoyan_msg("#empName_add_input","success","用户名可用");
		 }
		 var email = $("#email_add_input").val();
		 var regemail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		 if(!regemail.test(email)){
			/*  $("#email_add_input").parent().addClass("has-error");
			 $("#email_add_input").next("span").text("邮箱格式不正确"); */
			 show_jiaoyan_msg("#email_add_input","error","邮箱格式不正确");
			 return false;
		 }else{
			 show_jiaoyan_msg("#email_add_input","success","邮箱可用");
		 }
		 return true;
	 };
	 //校验用户名是否重复
 	  $(document).on("change","#empName_add_input",function(){
	// $("#empName_add_input").change(function(){}
		 //发送ajax请求，验证用户名是否重复   $(this).val() == this.value;
		 var empName = this.value;
		 $.ajax({
			 url:"${APP_PATH}/emps/checkuser",
			 data:"empName="+empName, 
			 //empName只能通过data传递校验是否重复。放在url中，中文的字符编码有问题。验证不能通过
			 //empName可放到url中  通过@PathVariable获取 
			 //通过data的话 可使用@RequestParam来获取
			 type:"POST",
			 success:function(result){
				if(result.code==100){
					show_jiaoyan_msg("#empName_add_input","success","用户名可用");
					 $("#emp_add_btn").attr("ajax_yz","success");
				 }else if(result.code==200){
					 show_jiaoyan_msg("#empName_add_input","error",result.extend.yz_msg);
					 //return false;
					 //这个是个变化事件。不是函数 无法调用  所以 return 返回值无法使用，就设置一个属性来判断罢
					 //更新按钮的状态设置为error  当是error的时候false 不能点击生效
					 $("#emp_add_btn").attr("ajax_yz","error");
				 }
			}
			 
		 });
		 
	 });  
	 //暂时有个小bug  名字重复状态时，点击保存按钮虽然保存操作不会生效。但是状态提示会变成用户名可用
	 $(document).on("click","#emp_add_btn",function(){
		 //进行验证
		 //如果校验方法不通过， 返回的结果是false，那么return false
 	   	if(!jiaoyan_add_form()){
			 return false;
		 }  
		  
		 //用户名重复校验
	  	if($(this).attr("ajax_yz")=="error"){
			return false;
		}  
		 //serialize(), 可将表单中的数据自动格式化。
		 $.ajax({
				url:"${APP_PATH}/emps/insertemp2",
				type :"POST",
				data:$("#emp_add_Model form").serialize(),
				success:function(result){
					if(result.code == 100){
						alert("保存成功");
						//关闭模态框
						$("#emp_add_Model").modal('hide');
						//来到保存新信息的最后一页
						to_page(zongjilu);
					} else {
						//console.log(result);
						//alert(result.extend.errorFields.empName);
						//alert(result.extend.errorFields.email);
						//show_jiaoyan_msg("#empName_add_input", "error", result.extend.yz_msg);
						//展示错误的提示信息
						if(result.extend.errorFields.empName !=  undefined){
							show_jiaoyan_msg("#empName_add_input", "error",result.extend.errorFields.empName);
						} 
						if(result.extend.errorFields.email != undefined){
							//获取map集合中的errors中的email字段的错误信息
							show_jiaoyan_msg("#email_add_input", "error", result.extend.errorFields.email);
						}
						
					} 
					
				}
				
			});
		 
	 });
	 
 
	
		
	</script>
</body>
</html>