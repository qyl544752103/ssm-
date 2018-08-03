package cn.qyl.ssmcrud.test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.qyl.ssmcrud.dao.EmployeeMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class MbgTest {

	@Autowired
	@Qualifier("employeeMapper")
	EmployeeMapper employeeMapper;

	// @Autowired(required = false)
	// @Qualifier("employee")
	// Employee employee;

	@Test
	public void testCRUD() {
		// ApplicationContext ioc = new
		// ClassPathXmlApplicationContext("applicationContext.xml");
		// 2、从容器中获取mapper
		// EmployeeMapper bean = ioc.getBean(EmployeeMapper.class);
		// EmployeeMapper bean1 = ioc.getBean(EmployeeMapper.class);
		// System.out.println(bean);
		// System.out.println(bean1);
		System.out.println(employeeMapper);

		// Employee employee = new Employee();
		// employee.setEmpName("曹晓茜");
		// employee.setEmail("liya@qq.cmo");
		// employee.setGender("女");
		// employee.setdId(2);
		// System.out.println(employee);
		// employeeMapper.insertSelective( employee);
		// employeeMapper.insertSelective(new Employee(null, "king", "男", "king@qq.com",
		// 1));
		// System.out.println("执行完毕");
		System.out.println(employeeMapper.selectByPrimaryKeyWithDept(1));
	}
}
