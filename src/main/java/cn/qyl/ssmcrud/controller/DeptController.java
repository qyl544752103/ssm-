package cn.qyl.ssmcrud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.qyl.ssmcrud.pojo.Dept;
import cn.qyl.ssmcrud.pojo.Msg;
import cn.qyl.ssmcrud.service.DeptService;

@Controller
public class DeptController {

	@Autowired
	DeptService deptService;

	@RequestMapping("/depts")
	@ResponseBody
	public Msg selectAll() {
		List<Dept> depts = deptService.selectAll();
		return Msg.success().add("dept", depts);
	}

}
