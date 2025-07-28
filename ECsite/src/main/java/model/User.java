package model;


public class User {
	private String u_no;
	private String u_name;
	private String u_id;
	private String u_pw;
	private String u_birth;
	private String u_email;
	private String u_phone;
	private String u_addr;
	private int u_grade;
	private String u_deleteun;
	
	public User() {}
	
	
	
	public User(String u_no, String u_name, String u_id, String u_pw, String u_birth, String u_email, 
				String u_phone, String u_addr, int u_grade, String u_deleteun) {
		this.u_no = u_no;
		this.u_name = u_name;
		this.u_id = u_id;
		this.u_pw = u_pw;
		this.u_birth = u_birth;
		this.u_email = u_email;
		this.u_phone = u_phone;
		this.u_addr = u_addr;
		this.u_grade = u_grade;
		this.u_deleteun = u_deleteun;
	}
	
	public String getUDeleteun() {
	    return u_deleteun;
	}
	
	//	get-------------------------------------------------------------------
	public String getU_no() {
		return u_no;
	}

	public String getU_name() {
		return u_name;
	}
	
	public String getU_id() {
		return u_id;
	}
	
	public String getU_pw() {
		return  u_pw;
	}
	
	public String getU_birth() {
		return u_birth;
	}
	
	public String getU_email() {
		return u_email;
	}
	
	public String getU_phone() {
		return u_phone;
	}
	
	public String getU_addr() {
		return u_addr;
	}
	
	public int getU_grad() {
		return u_grade;
	}
	
	public String getU_deleteun() {
		return u_deleteun;
	}
	
	//set ----------------------------------------------------------------------------
	public void setU_no(String u_no) {
		this.u_no =  u_no;
	}

	public void setU_name(String u_name) {
		this.u_name = u_name;
	}
	
	public void setU_id(String u_id) {
		this.u_id = u_id;
	}
	
	public void setU_pw(String u_pw) {
		this.u_pw =  u_pw;
	}
	
	public void setU_birth(String u_birth) {
		this.u_birth = u_birth;
	}
	
	public void setU_email(String u_email) {
		this.u_email = u_email;
	}
	
	public void setU_phone(String u_phone) {
		this.u_phone = u_phone;
	}
	
	public void setU_addr(String u_addr) {
		this.u_addr = u_addr;
	}
	
	public void setU_grad(int u_grade) {
		this.u_grade = u_grade;
	}
	
	public void setU_deleteun(String u_deleteun) {
		this.u_deleteun = u_deleteun;
	}
	
}