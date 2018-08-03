package cn.qyl.ssmcrud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.qyl.ssmcrud.dao.DeptMapper;
import cn.qyl.ssmcrud.pojo.Dept;

@Service
public class DeptService {
	@Autowired
	DeptMapper deptMapper;

	public List<Dept> selectAll() {
		return deptMapper.selectByExample(null);
	}

}
