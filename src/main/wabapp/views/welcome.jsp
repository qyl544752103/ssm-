<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 引入其他的jsp，将不同的方法分开。查增删改 -->
<c:import url="selectEmp.jsp"></c:import>
<c:import url="insertEmp.jsp"></c:import>
<c:import url="updateEmp.jsp"></c:import>
<%@ include file="deleteEmp.jsp"%>
<%--  <jsp:include page="deleteEmp.jsp"></jsp:include> --%>
<%-- <c:import url="deleteEmp.jsp"></c:import>  --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工信息</title>
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
	<!-- Bootstrap 需要为页面内容和栅格系统包裹一个 .container 容器。
我们提供了两个作此用处的类。注意，由于 padding 等属性的原因，
这两种 容器类不能互相嵌套 -->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<!-- 表格的表头信息是固定不变的，单独放起来 -->
				<h1>SSM_CRUD</h1>
			</div>
			<!-- 按钮 -->
			<div class="row">
				<div class="col-md-4 col-md-offset-8">
					<!-- 技术有限。查询功能直接使用form表单进行跳转页面 -->
					<div>
						<form action="${APP_PATH }/emps/selectByName?pn=1" method="post" id="selectByName_form">
							<input type="text" id="selectByName_input" name="empName">
							<button type="button" class="btn btn-primary" id="select_btn" onclick="panduan()">查询</button>
						</form>
					</div>
					<div>
						<button type="button" class="btn btn-success" id="add_btn">新增</button>
						<button type="button" class="btn btn-danger" id="delete_btn">删除</button>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-md-12">
					<table class="table table-striped" id="empTable">
						<thead>
							<tr>
								<th><input type="checkbox" id="checkbox_all"></th>
								<th>#</th>
								<th>empName</th>
								<th>gender</th>
								<th>email</th>
								<th>deptName</th>
								<th>操作</th>
								
							</tr>
						</thead>
						<tbody>

						</tbody>
					</table>
				</div>
			</div>
			<div class="row">
				<!-- 显示表格下面的分页条信息，分页数据 -->
				<div class="col-md-6" id="page_info"></div>
				<div class="col-md-6" id="page_nav"></div>
			</div>
		</div>
	</div>

	<!-- 员工新增的模态框 -->
	<div class="modal fade" tabindex="-1" role="dialog"
		id="emp_add_Model">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">员工添加</h4>
				</div>
				<div class="modal-body">
					<!-- 主体 -->
					<form class="form-horizontal" id="emp_add_form">
						<div class="form-group">
							<label  class="col-sm-2 control-label">empName</label>
							<div class="col-sm-6">
								<!--  name="empName"  和pojo类中的属性一致。可自动绑定参数传递 -->
								<input type="text" class="form-control" name="empName" id="empName_add_input"
									placeholder="empName">
									<!-- 添加状态提示框  作用:提示用户输入名字可用或不可用的提示 -->
									<span  class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label  class="col-sm-2 control-label">email</label>
							<div class="col-sm-6">
						
								<input type="text" class="form-control" name="email" id="email_add_input"
									placeholder="Email">
									<span  class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="radio_nan" value="M" checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="radio_nv" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">deptName</label>
							<div class="col-sm-4">
								<select class="form-control" name="dId">
									<!-- <option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option> -->
								</select>
							</div>
						</div>
					</form>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="emp_add_btn">保存</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 员工修改的模态框 -->
	<div class="modal fade" tabindex="-1" role="dialog"
		id="emp_update_Model">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">员工修改</h4>
				</div>
				<div class="modal-body">
					<!-- 主体 -->
					<form class="form-horizontal" id="emp_update_form">
						<div class="form-group">
							<label  class="col-sm-2 control-label">empName</label>
							<div class="col-sm-6">
								<input type="text" name="empName" class="form-control" id="empName_update_input"
									placeholder="empName" disabled="disabled">
							</div>
						</div>
						<div class="form-group">
							<label  class="col-sm-2 control-label">email</label>
							<div class="col-sm-6">
								<input type="text" name="email" class="form-control" id="email_update_input"
									placeholder="Email">
									<span  class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-2 col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="radio_nan" value="M"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="radio_nv" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">deptName</label>
							<div class="col-sm-4">
								<select class="form-control" name="dId">
									<!-- <option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option> -->
								</select>
							</div>
						</div>
					</form>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
					</div>
				</div>
			</div>
		</div>
	</div>
		<script type="text/javascript">
			/*
				这里写下增删改的功能。使用ajax功能实现。和 非ajax功能直接页面跳转。两种方法进行尝试。熟悉下操作
				查询不使用Ajax 直接 action页面跳转到其他页面
			 */
			$(function() {
				//去首页 传入定参数1
				to_page(1);
			});

			//获取员工信息，使用分页插件进行页面的 分页信息的展示
			function to_page(pn) {
				$.ajax({
					url : "${APP_PATH}/emps/selectAll",
					//pn是传递过去的当前页码
					data : "pn=" + pn,
					type : "GET",
					success : function(result) {
						//ajax请求成功以后，返回的操作
						//展示页面信息，分页条数据 页码信息
						//分别使用三个方法来实现
						build_page_table(result);
						build_page_info(result);
						build_page_nav(result);

					}

				});

			}
			//获取部门信息
			function getDept(ele) {
				//清除每次打开的下拉列表
				$(ele).empty();
				//将获取到的dept数据 遍历出来。放入到下拉列表中
				$.ajax({
					url : "${APP_PATH}/depts",
					type : "GET",
					success : function(result) {
						$.each(result.extend.dept, function(index,item) {
							var optionEle = $("<option></option>").append(
									item.deptName).attr("value",
											item.deptId);
							optionEle.appendTo(ele);
						});
					}

				});
			}

			//制作一个校验提示模板。
			//三个参数分别代表：调用校验的对象，校验结果，校验提示信息
				function show_jiaoyan_msg(ele,status,msg){
					//每次清空校验状态和提示信息
					$(ele).parent().removeClass("has-success has-error");
					$(ele).next("span").text("");
					if(status=="success"){
						$(ele).parent().addClass("has-success");
						$(ele).next("span").text(msg);
					}else if(status=="error"){
						$(ele).parent().addClass("has-error");
						$(ele).next("span").text(msg);
					}
					
				}
			
			//模糊查询输入框
				function panduan(){
					if($("#selectByName_input").val()==0 || $.trim($("#selectByName_input").val)==""){
						alert("请输入名字。。。。。。");
						$("#selectByName_input").val("");
						return false;
					}else if($("#selectByName_input").val()!=""){
						//去掉空格 
							var tel = $("#selectByName_input").val();
							$("#selectByName_input").val($.trim(tel));
						 document.getElementById("selectByName_form").submit();
						return true;
					}
				
				}	 
		</script>
</body>
</html>