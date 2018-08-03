<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工查询</title>
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
		
		//获取员工信息，使用分页插件进行页面的 分页信息的展示
		//获取遍历表格的数据
		//设置两个全局变量。后面返回被操作页面，或者到新增数据页面有用
		var zongjilu,dangqian
		function build_page_table(result){
			//每次获取table数据的时候进行清理，避免数据残留
			$("#empTable tbody").empty();
			//取出后台传递的参数的map集合中的所放的pageinfo的list集合数据
			var emps = result.extend.pageInfo.list;
			//进行遍历
			$.each(emps,function(index,item){
				var checkboxTd = $("<td><input type='checkbox' class='check_item'></td>");
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(item.gender=='M'?'男':'女');
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.dept.deptName);
			//添加两个按钮
			//编辑按钮
			   var editBtn = $("<button></button>").addClass("btn btn-success btn-default btn-xs edit_btn")
			   .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				//设置下编辑按钮的id 每一个id通过获取每个用户的id来设置
				//用一个自定义的 属性，来标记id
				editBtn.attr("edit_id",item.empId);
				//删除按钮
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-default btn-xs del_btn").append(
						$("<span></apan>").addClass("glyphicon glyphicon-trash")).append("删除");
				delBtn.attr("del_id",item.empId);
			
				 var btnTd  = $("<td></td>").append(editBtn).append("  ").append(delBtn);
				
				//将获取到的每一行数据加入岛table的tbdy中 在放入div中 页面展示数据
				$("<tr></tr>").append(checkboxTd)
				.append(empIdTd)
				.append(empNameTd)
				.append(genderTd)
				.append(emailTd)
				.append(deptNameTd)
				.append(btnTd)
				.appendTo("#empTable tbody");
				
			});
			
		}
		//获取页面信息条
		 function build_page_info(result){
			//清理数据避免残留
			$("#page_info").empty();
			$("#page_info").append(
			"当前"+result.extend.pageInfo.pageNum+"页总"
			+result.extend.pageInfo.pages+"页总"+result.extend.pageInfo.total
			+"条记录");
			zongjilu = result.extend.pageInfo.total;
			dangqian = result.extend.pageInfo.pageNum;
		}
		 function build_page_nav(result){
			 $("#page_nav").empty();
			 //添加分页条特效 
			 var ul = $("<ul></ul>").addClass("pagination");
			 //首页
			 var firstpageLi = $("<li></li>").append(
					 $("<a></a>").append("首页").attr("herf","#"));
			 //上一页
			 var prepageLi = $("<li></li>").append(
					 $("<a></a>").append("&laquo;"));
			 //设置当是第一页的时候 首页和上一页不能点击
			 //pageinfo提供的一个参数hasPreviousPage，当没有上一页的时候为false
			 if(result.extend.pageInfo.hasPreviousPage==false){
				 firstpageLi.addClass("disabled");
				 prepageLi.addClass("disabled");
			 }else{
				 //添加点击翻页事件 使用click 单击事件
				 firstpageLi.click(function(){
					 to_page(1);
				 });
				 prepageLi.click(function(){
					 to_page(tesult.extend.pageInfo.pageNum-1);
				 });
			 }
			 //将首页和上一页的li标签加入到ul标签中
			 ul.append(firstpageLi).append(prepageLi);
						 
			 //中间页码
			 $.each(result.extend.pageInfo.navigatepageNums,function(index,item){
				 var numLi = $("<li></li>").append($("<a></a>").append(item));
				 //当前页面设置高亮显示
				 if(result.extend.pageInfo.pageNum == item){
					 numLi.addClass("active");
				 }
				 //跳转其他页面调用上面的 页面跳转的方法
				 numLi.click(function(){
					 to_page(item);
				 })
				 //将li标签加入岛ul标签中
				 ul.append(numLi);
			 });
			 
			 //下一页
			var nextpageLi = $("<li></li>").append(
					$("<a></a>").append("&raquo;"));
			 
			 //末页
			 var lastpageLi = $("<li></li>").append(
					 $("<a></a>").append("末页").attr("herf","#"));
		 	//同样设置，在最后一页，下一页和末页不能点击
		 	if(result.extend.pageInfo.hasNextPage==false){
		 		nextpageLi.addClass("disabled");
		 		lastpageLi.addClass("disabled");
		 	}else{
		 		nextpageLi.click(function(){
		 			to_page(result.extend.pageInfo.pageNum+1);
		 		})
		 		
		 		lastpageLi.click(function(){
		 			to_page(result.extend.pageInfo.pages);
		 		})
		 	}
		 	
		 	ul.append(nextpageLi).append(lastpageLi);
		 	var nav = $("<nav></nav>").append(ul);
		 	nav.appendTo("#page_nav");			 
		
		} 
		 
	</script>
</body>
</html>