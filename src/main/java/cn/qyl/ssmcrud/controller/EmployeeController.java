package cn.qyl.ssmcrud.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.qyl.ssmcrud.pojo.Employee;
import cn.qyl.ssmcrud.pojo.Msg;
import cn.qyl.ssmcrud.service.EmployeeService;

@Controller
@RequestMapping("/emps")
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;

	@RequestMapping("/selectAll")
	@ResponseBody // json字符串 注解
	public Msg getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 调用分页插件
		PageHelper.startPage(pn, 5);
		// 查询数据
		List<Employee> emps = employeeService.getAll();
		// 数据进行分页操作，连续展示5页的数据
		PageInfo info = new PageInfo<>(emps, 5);

		// success()是静态方法，add()是非静态方法，不能直接调用add()方法
		return Msg.success().add("pageInfo", info);
	}

	// 新增用户
	// 测试用。。。。功能简单
	// @RequestMapping(value = "/insertemp1", method = RequestMethod.POST)
	//
	// @ResponseBody
	// public Msg insertemp(Employee employee) {
	// String empName = employee.getEmpName();
	// boolean b = employeeService.yanzhengUser(empName);
	// if (b) {
	//
	// employeeService.saveemp(employee);
	// return Msg.success();
	// } else {
	// return Msg.fail().add("yz_msg", "用户名重复");
	// }
	// }

	// 验证前台用户名是否重复
	@RequestMapping(value = "/checkuser", method = RequestMethod.POST)
	@ResponseBody
	public Msg change(@RequestParam("empName") String empName) {
		// 首先验证下是否符合规范，和在前台有些许不同
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		// String 自带的验证方法
		// 验证有两种的结果。一种是就不符合命名规则，另一种是符合，但是用户名重复
		// 最后才是用户名可用
		if (!empName.matches(regx)) {
			return Msg.fail().add("yz_msg", "用户名必须是2-5中文或者6-16英文字母和数字组合");
		}
		// 验证用户名是否重复。创建一个方法，调用mapper中提供的方法，有一样的名字，即重复，返回false 不重复返回false
		boolean b = employeeService.yanzhengUser(empName);
		if (b) {

			return Msg.success();
		} else {
			return Msg.fail().add("yz_msg", "用户名重复");
		}
	}

	/**
	 * jsr303校验 避免前台的漏洞 绕过了前台的校验 BindingResult jsr303提供的方法
	 * 
	 * @param ids
	 * @return
	 */
	// 新增用户
	@RequestMapping("/insertemp2")

	@ResponseBody
	public Msg jsr303(@Valid Employee employee, BindingResult result) {
		// 在javabean中 EmpLoyee中的使用的jsr303校验校验如果失败，应该返回失败信息，在模态框中显示校验失败的提示信息
		// 如果校验失败 // 封装提示信息 前台获取使用
		change(employee.getEmpName());
		if (result.hasErrors()) {
			Map<String, Object> map = new HashMap<String, Object>();
			// 获取在Employee里面 校验失败的信息 result.getFieldErrors();
			List<FieldError> error = result.getFieldErrors();
			// 遍历每一个错误信息
			for (FieldError fieldError : error) {
				// 将错误的字段名 和 错误信息 都打印出来 System.out.println("错误字段名：" +fieldError.getField());
				// System.out.println("错误信息：" +fieldError.getDefaultMessage());
				// 将每一个错误的字段名 和 错误信息 放入map集合种
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		} else {
			employeeService.saveemp(employee);
			return Msg.success();
		}
	}

	// 单个删除
	/*
	 * 批量删除功能做好后不再使用该方法
	 * 
	 * @RequestMapping(value = "/emp/{empId}", method = RequestMethod.DELETE)
	 * 
	 * @ResponseBody // @PathVariable 将路径中的/emp/{empId} 的empid值拿到手 public Msg
	 * deletebyId(@PathVariable("empId") Integer id) {
	 * employeeService.deleteById(id); return Msg.success(); }
	 */

	// 批量删除
	@RequestMapping(value = "/emp/{empIds}", method = RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteAll(@PathVariable("empIds") String ids) {
		// 将请求路径中的ids字符串进行拆分，获取被删除的id值
		// 如果包含- 说明是多个id值组合
		// 要将一个字符串ids拆分为字符串数组。再将每个字符串格式化为integer装入list集合中，作为条件传入service中
		if (ids.contains("-")) {
			List<Integer> int_ids = new ArrayList<Integer>();
			String[] string_ids = ids.split("-");
			for (String string : string_ids) {
				int_ids.add(Integer.parseInt(string));
			}
			employeeService.deletAll(int_ids);

		} else {
			// 否则调用单个删除的方法
			Integer id = Integer.parseInt(ids);
			employeeService.deleteById(id);
		}
		return Msg.success();
	}

	// 单个查询，将员工数据传回去，进行修改用
	@RequestMapping(value = "/emp/{empId}", method = RequestMethod.GET)
	@ResponseBody
	public Msg getById(@PathVariable("empId") Integer id) {
		Employee employee = employeeService.selectById(id);
		return Msg.success().add("emp", employee);
	}

	// 修改
	@RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
	@ResponseBody
	// 更新前台传递的对象。通过id确认对象
	public Msg updateById(Employee employee) {
		employeeService.updateById(employee);
		return Msg.success();
	}

	// 查询 模糊查询
	@RequestMapping("/selectByName")
	public String getByempName(@RequestParam(value = "empName", required = false) String empName,
			@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model, HttpServletRequest req,
			HttpServletResponse resp) throws IOException, ServletException {
		// 判断传递过来的用户名是否存在，分两步走 因为模糊查询，名字输入可能不规范。不适合直接调用上面的验证用户名是否重复的验证方法
		req.setAttribute("name", empName);
		boolean bs = employeeService.selectUser(empName);
		// 如果bs==true;说明用户名存在 调用模糊查询方法。和 分页插件 返回前台进行数据展示
		if (bs) {
			// 进行分页
			PageHelper.startPage(pn, 5);
			List<Employee> empByName = employeeService.selectByName(empName);
			PageInfo info = new PageInfo<>(empByName, 5);
			model.addAttribute("pageInfo", info);
			return "selectByempName";
		} else {
			// 用户不存在，返回提示用户不存在
			return "error";
		}
	}

	/**
	 * 使用分页插件， 获取后才员工信息，将分页设置信息和员工信息一起传递给前台
	 * 
	 * @return 返回员工list信息，和分页设置信息
	 */
	/*
	 * public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer
	 * pn, Model model) { // 调用分页插件 PageHelper.startPage(pn, 5); // 查询数据
	 * List<Employee> emps = employeeService.getAll(); // 数据进行分页操作，连续展示5页的数据
	 * PageInfo info = new PageInfo<>(emps, 5); model.addAttribute("info", info);
	 * return "查询页面"; }
	 */

}
