package cn.qyl.ssmcrud.pojo;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用返回的类。使用json字符串 将controller中的结果返回给前台 使用Ajax接收
 * 
 * @author Administrator
 *
 */
public class Msg {
	// 提示成功 100 或 失败 200 。 根据数字进行判断
	private int code;
	// 提示信息 成功 失败 或者错误提示信息
	private String msg;

	// 将controller方法中获取的数据放入到该map集合中，返回给前台用户
	private Map<String, Object> extend = new HashMap<String, Object>();

	// 设置静态的成功的提示方法
	public static Msg success() {
		Msg result = new Msg();
		result.setCode(100);
		result.setMsg("处理成功");
		return result;
	}

	// 设置静态的失败提示方法
	public static Msg fail() {
		Msg result = new Msg();
		result.setCode(200);
		result.setMsg("处理失败");
		return result;
	}

	// 该方法非静态，不能直接调用呢
	public Msg add(String key, Object value) {
		// 将那些数据放入map集合中，并将结果返回给调用该方法的对象本身
		this.getExtend().put(key, value);
		return this;
	}

	public Map<String, Object> getExtend() {
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

}
