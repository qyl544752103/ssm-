<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:import url="selectEmp.jsp"></c:import>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工删除</title>
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
			删除分两种：
				单个删除
				批量删除，通过checkbox 多选框组成的集合组 进行删除
			删除 和 编辑按钮事件绑定问题
			
			html页面在打开的时候，js页面中的事件都已经加载完成了。而页面中的员工数据显示的表单
			是在页面加载完后发送的Ajax请求获取并显示的 。在整体页面的加载完成后，传统的
			按钮绑定事件$("#del_btn").click(function(){});就是在js页面加载完成后就执行了。
			员工的数据展示却在他后面，造成事件绑定无效。
			解决方法：
				1.在删除按钮创建的时候，直接绑定事件。然而麻烦，耦合度也太高 弃用之
				2.使用on咯 $(document).on("事件","按钮",function(){})
		 */
		//单个删除
		$(document).on("click", ".del_btn", function() {
			//删除前，确认是否删除.显示要删除的 名字
			//jQuery中的方法。
			//alert($(this).parents("tr").find("td:eq(2)").text());
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del_id");
			if (confirm("确认要删除【" + empName + "】吗？")) {
				$.ajax({
					url : "${APP_PATH}/emps/emp/" + empId,
					type : "DELETE",
					success : function(result) {
						//返回成功提示
						alert(result.msg);
						//返回当前操作页面
						to_page(dangqian);
					}
				})
			}

		})

		//批量删除，利用checkbox 来进行操作。利用checkbox的长度来判断是否全选
		//不能生效   jsp页面根据功能拆分后 不能使用下面的click方法  只能用on("事件","对象",function(){})
		/* $("#checkbox_all").click(function() {
			//alert($(this).prop("checked"));

			$(".check_item").prop("checked", $(this).prop("checked"));
		}) */
		//prop同attr 不过attr只能对自定义属性生效。所以使用dom原生态prop
		//alert($(this).prop("checked"));显示的true和false  true是点中。false没点中
		//通过alert弹窗获取具体状态。
		//按钮checked的状态是boolean类型。true说明选中。false说明未选中
		//让所有的复选框按钮的checked属性和表单最上面的checkbox复选框的checked属性状态一致，可实现全选/全部选操作
		$(document).on("click","#checkbox_all",function(){
			$(".check_item").prop("checked", $(this).prop("checked"));
		})
		$(document).on("click",".check_item",function(){
			//下面多个复选框如果全部选中。最上面的全选按钮也要跟着选中
			//通过判断当前被选中的多个复选框的长度 是否 和当前页面的复选框的总长度相等来判断
			var falg = $(".check_item:checked").length==$(".check_item").length;
			$("#checkbox_all").prop("checked",falg);
		
		})
		//批量删除操作
		 $(document).on("click","#delete_btn",function(){
			//两个变量。名字组   id组
			var empNames="";
			var empIds = "";
			//获取名字组  id组的值
			//将被选中的复选框进行遍历。将他们的名字和id组合成一个字符串。传递给后台
			$.each($(".check_item:checked"),function(){
				//jQuery中的方法 取出表格中的名字，并将他们想连接  显示在删除确认窗口中
				empNames += $(this).parents("tr").find("td:eq(2)").text()+"，";
				//取出每一个id 将他们连接 。在后台service中进行批量删除操作   作为一个条件传进去
				empIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			//去除多余的, 和 - 号  
			
			empNames = empNames.substring(0, empNames.length-1);
			//去除删除的id多余的-
			empIds = empIds.substring(0, empIds.length-1);
		if(empNames.length==0){
			alert("请选择要删除的员工。。。");
		}else{
			if(confirm("确定要删除【"+empNames+"】吗？")){
				//点确认进行下一步
				//ajax请求发送至后台
				$.ajax({
					url:"${APP_PATH}/emps/emp/"+empIds,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(dangqian);
						//取消全选按钮的点中状态。
						$("#checkbox_all").prop("checked",false);
					}
					
				});
			}
			
		}
	 });
		
	</script>
</body>
</html>