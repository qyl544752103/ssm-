package cn.qyl.ssmcrud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.qyl.ssmcrud.dao.EmployeeMapper;
import cn.qyl.ssmcrud.pojo.Employee;
import cn.qyl.ssmcrud.pojo.EmployeeExample;
import cn.qyl.ssmcrud.pojo.EmployeeExample.Criteria;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;

	// 全部查询，不带条件。所以放入null
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDpet(null);
	}

	// 单个删除
	public void deleteById(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}

	// 批量删除
	public void deletAll(List<Integer> int_ids) {
		EmployeeExample example = new EmployeeExample();
		// 该条件等同sql中 delete from xxx where emp_id id(1,2,3)
		Criteria criteria = example.createCriteria().andEmpIdIn(int_ids);
		employeeMapper.deleteByExample(example);
	}

	public Employee selectById(Integer id) {
		return employeeMapper.selectByPrimaryKey(id);
	}

	// 更新
	public void updateById(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);

	}

	// 新增
	public void saveemp(Employee employee) {
		employeeMapper.insertSelective(employee);

	}

	// 判断用户名是否重复或者存在
	public boolean yanzhengUser(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		// 通过提供的方法判断是否有用户名一样的
		criteria.andEmpNameEqualTo(empName);
		// employeeMapper.countByExample(example)校验符合这个规则的数据有几个
		// >0 说明存在， =0 说明不存在
		long count = employeeMapper.countByExample(example);
		// 如果验证的结果==0 返回的就是true 说明用户名不存在
		return count == 0;
	}

	// 先判断模糊查询的结果，是否存在
	public boolean selectUser(String empName) {
		// 判断模糊查询到 结果
		// 根据模糊查询的list集合的长度进行判断
		EmployeeExample example = new EmployeeExample();
		example.createCriteria().andEmpNameLike("%" + empName + "%");

		List<Employee> list = employeeMapper.selectByExampleWithDpet(example);
		if (list.size() > 0) {
			// 说明存在数据，返回true
			return true;
		} else {
			return false;
		}
	}

	// 根据输入的name信息进行模糊查询。返回list集合
	public List<Employee> selectByName(String empName) {
		// 上接 controller中判断，模糊查询到 结果存在，获取模糊查询后的结果
		EmployeeExample example = new EmployeeExample();
		example.createCriteria().andEmpNameLike("%" + empName + "%");

		List<Employee> list = employeeMapper.selectByExampleWithDpet(example);
		return list;
	}

}
