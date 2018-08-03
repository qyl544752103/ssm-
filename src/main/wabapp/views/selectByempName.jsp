<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工姓名查询</title>
<%
	//将当前项目的路径上下文获取。 在下面需要路径的地方直接使用 不因为路径的改变而出错
	pageContext.setAttribute("APP_PATH", request.getContextPath());
	String name = request.getParameter("name");
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
<div class="container">
		<div class="row">
			<div class="col-md-12">
				<!-- 表格的表头信息是固定不变的，单独放起来 -->
				<h1>模糊查询</h1>
			</div>
			<!-- 按钮 -->
			<div class="row">
				<div class="col-md-2 col-md-offset-10">
					<!-- 技术有限。查询功能直接使用form表单进行跳转页面 -->
					<div>
						<form action="${APP_PATH }/views/welcome.jsp?pn=1">
							<button type="submit" class="btn btn-primary" id="welcome_btn">返回主页</button>
						</form>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-md-12">
					<table class="table table-striped" id="ByempName_empTable">
						<thead>
							<tr>
								<th>#</th>
								<th>empName</th>
								<th>gender</th>
								<th>email</th>
								<th>deptName</th>
								<th>操作</th>
								
							</tr>
						</thead>
						<tbody>
						<!-- 遍历后台传递的list集合中的employee对象 -->
							<c:forEach items="${pageInfo.list }" var="employee" >
								<tr>
									<td>${employee.empId }</td>
									<td>${employee.empName }</td>
									 <td>${employee.gender=="M"?"男":"女" }</td>
									<td>${employee.email }</td>
									<td>${employee.dept.deptName }</td>
									<!-- bootstrap提供的 特效。。 另外每个button的id和每个对象的id相等 -->
									<td><button class="btn btn-success btn-default btn-xs byname_edit_btn" byname_edit_id=${employee.empId }>
									<span class="glyphicon glyphicon-pencil" >编辑</span>
									</button>
									
									<button class="btn btn-danger btn-default btn-xs byname_del_btn" byname_del_id=${employee.empId }>
									<span class="glyphicon glyphicon-trash">删除</span>
									</button>
									</td>
								</tr>
							</c:forEach>
					</tbody>
					</table>
				</div>
			</div>
			<div class="row">
				<!-- 显示表格下面的分页条信息，分页数据 -->
				<div class="col-md-6" id="ByempName_page_info">
					当前${pageInfo.pageNum }页总${pageInfo.pages }页总${pageInfo.total }条记录
				</div>
				<div class="col-md-6" id="ByempName_page_nav">
				<nav aria-label="Page navigation">
					  <ul class="pagination">
					   <li>
					   <!-- empName=${name }是通过request的request.getParameter("name") 
					   		从后台获取到主页面的查询输入框的名字，这个页面的分页查询是有条件的，每次需要带上模糊查询的名字
					   		首页 上一页 中间页码 下一页 尾页 除了传递页码数 都要带上名字 
					   -->
					    <a href="${APP_PATH }/emps/selectByName?empName=${name }&pn=1">首页</a>
					    </li>
					    <li>
					      <a href="${APP_PATH }/emps/selectByName?empName=${name }&pn=${pageInfo.pageNum-1 }" aria-label="Previous">
					        <span aria-hidden="true">&laquo;</span>
					      </a>
					    </li>
					    <!-- 遍历页码数 -->
					    <c:forEach items="${pageInfo.navigatepageNums }" var="nums">
					    <li>
					    <a href="${APP_PATH }/emps/selectByName?empName=${name }&pn=${nums }" >${nums }</a>
					    </li>
					    </c:forEach>
					    <li>
					      <a href="${APP_PATH }/emps/selectByName?empName=${name }&pn=${pageInfo.pageNum+1 }" aria-label="Next">
					        <span aria-hidden="true">&raquo;</span>
					      </a>
					    </li>
					    <li>
					    <a href="${APP_PATH }/emps/selectByName?empName=${name }&pn=${pageInfo.pages }">末页</a>
					    </li>
					  </ul>
				</nav>
				</div>
			</div>
		</div>
	</div>

<!-- 员工修改的模态框 -->
	<div class="modal fade" tabindex="-1" role="dialog"
		id="ByempName_update_Model">
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
					<form class="form-horizontal" id="ByempName_update_form">
						<div class="form-group">
							<label  class="col-sm-2 control-label">empName</label>
							<div class="col-sm-6">
								<input type="text" name="empName" class="form-control" id="ByempName_empName_update_input"
									placeholder="empName" disabled="disabled">
							</div>
						</div>
						<div class="form-group">
							<label  class="col-sm-2 control-label">email</label>
							<div class="col-sm-6">
								<input type="text" name="email" class="form-control" id="ByempName_email_update_input"
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
						<button type="button" class="btn btn-primary" id="ByempName_update_btn">更新</button>
					</div>
				</div>
			</div>
		</div>
	</div>
		<script type="text/javascript">
		/**
			思路: 在查询form表单中填入名字，不做规则验证
				直接传递后台分两步：
					1.先查询是否存在该员工名字。
					2.如果存在，进行模糊查询。
					3.模糊查询的结果是list集合。
					4。使用分页插件做一个分页展示
					5.可编辑，删除  返回主页面
					
					该页面功能不引用其他页面的方法。所有方法直接写在页面内
		*/
		//获取页面信息条
		
		function getDept() {
			//清楚每次打开的下拉列表
			$("#ByempName_update_Model select").empty();
			//将获取到的dept数据 遍历出来。放入到下拉列表中
			$.ajax({
				url : "${APP_PATH}/depts",
				type : "GET",
				success : function(result) {
					//var depts = result.extend.dept;
					$.each(result.extend.dept, function(index,item) {
						var optionEle = $("<option></option>").append(
								item.deptName).attr("value",
										item.deptId);
						optionEle.appendTo("#ByempName_update_Model select");
					});
				}

			});
		}

		//制作一个校验提示模板。 名字不能修改，就修改验证个邮箱。功能有点多余
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
		
		function getEmp(id) {
			$.ajax({
				url : "${APP_PATH}/emps/emp/" + id,
				type : "GET",
				success : function(result) {
					//将获取到的员工信息，填充到修改模态框中
					var empData = result.extend.emp;
					//填入用户名 邮箱
					$("#ByempName_empName_update_input").val(empData.empName);
					$("#ByempName_email_update_input").val(empData.email);
					//填入性别，下拉列表。使用另外的方法
					$("#ByempName_update_Model input[name=gender]").val(
							[ empData.gender ]);
					$("#ByempName_update_Model select").val([ empData.dId ]);

				}

			});

		}
		
		//编辑
		
			$(document).on("click", ".byname_edit_btn", function() {
				getDept();
				getEmp($(this).attr("byname_edit_id")); 
				//通过和编辑按钮的id值相等 拿到要修改的员工的id
				$("#ByempName_update_btn").attr("byname_edit_id",$(this).attr("byname_edit_id"))
				$("#ByempName_update_Model").modal({
					backdrop:"static"
				});
			})
		//删除	
		$(document).on("click", ".byname_del_btn", function() {
			//删除前，确认是否删除.显示要删除的 名字
			//jQuery中的方法。
			//alert($(this).parents("tr").find("td:eq(2)").text());
			var empName = $(this).parents("tr").find("td:eq(1)").text();
			var empId = $(this).attr("byname_del_id");
			if (confirm("确认要删除【" + empName + "】吗？")) {
				$.ajax({
					url : "${APP_PATH}/emps/emp/" + empId,
					type : "DELETE",
					success : function(result) {
						//返回成功提示
						alert(result.msg);
						//返回当前操作页面 非Ajax请求
						 window.location.href="${APP_PATH }/emps/selectByName?empName=${name }&pn=${pageInfo.pageNum }";
					}
				})
			}

		})
		
		//更新
	$(document).on("click","#ByempName_update_btn",function(result){
		//用户名设置不能操作。
		//邮箱更改后需要做一个验证校验  
		 var email = $("#ByempName_email_update_input").val();
		 var regemail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		 if(!regemail.test(email)){
			 show_jiaoyan_msg("#ByempName_email_update_input","error","邮箱格式不正确");
			 return false;
		 }else{
			 show_jiaoyan_msg("#ByempName_email_update_input","success","邮箱可用");
				
				$.ajax({
					url:"${APP_PATH}/emps/emp/"+$(this).attr("byname_edit_id"),
					type:"PUT",
					data:$("#ByempName_update_Model form").serialize(),
					success:function(result){
						$("#ByempName_update_Model").modal('hide');
						//做了一次请求跳转。。。。。非ajax
						window.location.href="${APP_PATH }/emps/selectByName?empName=${name }&pn=${pageInfo.pageNum }";
					}
					
				});
		 }
		
	});
		
		
		
	</script>


</body>
</html>