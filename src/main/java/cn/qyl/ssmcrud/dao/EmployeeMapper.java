package cn.qyl.ssmcrud.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import cn.qyl.ssmcrud.pojo.Employee;
import cn.qyl.ssmcrud.pojo.EmployeeExample;

public interface EmployeeMapper {
	long countByExample(EmployeeExample example);

	int deleteByExample(EmployeeExample example);

	int deleteByPrimaryKey(Integer empId);

	int insert(Employee record);

	int insertSelective(Employee record);

	List<Employee> selectByExample(EmployeeExample example);

	Employee selectByPrimaryKey(Integer empId);

	// 带上部门信息的查询，需要自定义在mapper.xml文件中
	List<Employee> selectByExampleWithDpet(EmployeeExample example);

	Employee selectByPrimaryKeyWithDept(Integer empId);

	int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);

	int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);

	int updateByPrimaryKeySelective(Employee record);

	int updateByPrimaryKey(Employee record);
}