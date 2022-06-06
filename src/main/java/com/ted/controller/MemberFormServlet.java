package com.ted.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ted.model.MembersBean;
import com.ted.model.MembersService;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

@WebServlet(name = "MemberServlet", value = "/MemberServlet")
public class MemberFormServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private SimpleDateFormat sFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private MembersService membersService;
	@Override
	public void init() {
		ServletContext application = this.getServletContext();
		ApplicationContext context = (ApplicationContext) application.getAttribute(
				WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
		membersService = context.getBean("membersService", MembersService.class);
	}
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
//接收資料
		request.setCharacterEncoding("UTF-8");
		response.setHeader("Content-type", "text/html;charset=UTF-8");
		response.setHeader("Access-Control-Allow-Origin","*");
		response.setCharacterEncoding("UTF-8");
		String memberIdTemp = request.getParameter("memberId");
		String memberAccouuntTemp = request.getParameter("memberAccouunt");
		String memberPasswordTemp = request.getParameter("memberPassword");
		String memberLastnameTemp = request.getParameter("memberLastname");
		String memberFirstnameTemp = request.getParameter("memberFirstname");
		String memberGenderTemp = request.getParameter("gender");
		String memberNicknameTemp = request.getParameter("memberNickname");
		String memberEmailTemp = request.getParameter("memberEmail");
		String memberTelTemp = request.getParameter("memberTel");
		String memberAddrTemp = request.getParameter("memberAddr");
		String memberBirthTemp = request.getParameter("memberBirth");
		String createUserTemp = request.getParameter("createUser");
		String createDateTemp = request.getParameter("createDate");
		String updateUserTemp = request.getParameter("updateUser");
		String updateDateTemp = request.getParameter("updateDate");
		String memberAction = request.getParameter("memberAction");
		
//驗證資料
		Map<String, String> errors = new HashMap<>();
		request.setAttribute("errors", errors);
		
		if(memberAction!=null) {
			if(memberAction.equals("Insert") || memberAction.equals("Update") || memberAction.equals("Delete")) {
				if(memberIdTemp==null || memberIdTemp.length()==0) {
					errors.put("memberId", "Please enter memberId for "+memberAction);
				}
			}
		}
//轉換資料
		int memberId = 0;
		if(memberIdTemp!=null && memberIdTemp.length()!=0) {
			try {
				memberId = Integer.parseInt(memberIdTemp);
			} catch (NumberFormatException e) {
				e.printStackTrace();
				System.out.println("memberId must be an integer");
				errors.put("memberId", "memberId must be an integer");	
			}
		}
		String memberAccouunt = "";
		if(memberAccouuntTemp!=null && memberAccouuntTemp.length()!=0) {
			try {
				memberAccouunt = memberAccouuntTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberAccouunt has something wrong");
				errors.put("memberAccouunt", "memberAccouunt has something wrong");
			}
		}else {
			errors.put("memberAccouunt", "帳戶不可以為空值");
		}
		String memberPassword = "";
		if(memberPasswordTemp!=null && memberPasswordTemp.length()!=0) {
			try {
				memberPassword = memberPasswordTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberPassword has something wrong");
				errors.put("memberPassword", "memberPassword has something wrong");
			}
		}else {
			errors.put("memberPassword", "密碼不可以為空值");
		}
		String memberLastname = "";
		if(memberLastnameTemp!=null && memberLastnameTemp.length()!=0) {
			try {
				memberLastname = memberLastnameTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberLastname has something wrong");
				errors.put("memberLastname", "memberLastname has something wrong");
			}
		}else {
			errors.put("memberLastname", "姓氏不可以為空值");
		}
		String memberFirstname = "";
		if(memberFirstnameTemp!=null && memberFirstnameTemp.length()!=0) {
			try {
				memberFirstname = memberFirstnameTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberFirstname has something wrong");
				errors.put("memberFirstname", "memberFirstname has something wrong");
			}
		}else {
			errors.put("memberFirstname", "名字不可以為空值");
		}
		String memberGender = "";
		if(memberGenderTemp!=null && memberGenderTemp.length()!=0) {
			try {
				memberGender = memberGenderTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberGender has something wrong");
				errors.put("memberGender", "memberGender has something wrong");
			}
		}
		String memberNickname = "";
		if(memberNicknameTemp!=null && memberNicknameTemp.length()!=0) {
			try {
				memberNickname = memberNicknameTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberNickname has something wrong");
				errors.put("memberNickname", "memberNickname has something wrong");
			}
		}
		String memberEmail = "";
		if(memberEmailTemp!=null && memberEmailTemp.length()!=0) {		
			if(patternMatches(memberEmailTemp)) {
				memberEmail = memberEmailTemp;
			}
			else {
				System.out.println("please input valid Email address!!!");
				errors.put("memberEmail", "Email必須是有效的格式");
			}		
		}else {
			errors.put("memberEmail", "Email為必填欄位");
		}
		String memberAddr = "";
		if(memberAddrTemp!=null && memberAddrTemp.length()!=0) {
			try {
				memberAddr = memberAddrTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("memberAddr has something wrong");
				errors.put("memberAddr", "memberAddr has something wrong");
			}
		}
		String createUser = "";
		if(createUserTemp!=null && createUserTemp.length()!=0) {
			try {
				createUser = createUserTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("createUser has something wrong");
				errors.put("createUser", "createUser has something wrong");
			}
		}
		String updateUser = "";
		if(updateUserTemp!=null && updateUserTemp.length()!=0) {
			try {
				updateUser = updateUserTemp;
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("updateUser has something wrong");
				errors.put("updateUser", "updateUser has something wrong");
			}
		}
		int memberTel = 0;
		if(memberTelTemp !=null && memberTelTemp.length()!=0) {
			try {
				memberTel = Integer.parseInt(memberTelTemp);
			} catch (NumberFormatException e) {
				e.printStackTrace();
				System.out.println("電話號碼必須是數字");
				errors.put("memberTel", "memberTel must be a number");	
			}
		}
		Date memberBirth = new Date(82, 8, 11);
		if(memberBirthTemp!=null && memberBirthTemp.length()!=0) {
			try {
				memberBirth = sFormat.parse(memberBirthTemp);			
			} catch (ParseException e) {
				e.printStackTrace();
				errors.put("memberBirth", "日期格式必須為YYYY-MM-DD");
			}
		}
		Date createDate = Calendar.getInstance().getTime();
		Date updateDate = Calendar.getInstance().getTime();
		
		//有錯誤，再丟入填寫頁面顯示
		if(errors!=null && !errors.isEmpty()) {
			System.out.println("有錯誤，再丟入填寫頁面顯示"+errors.size());
//			request.getRequestDispatcher(
//					"/pages/register/registerForm.jsp").forward(request, response);
		}
//呼叫Model	
		MembersBean bean = new MembersBean();
		bean.setMemberId(memberId);
		bean.setMemberAccouunt(memberAccouunt);
		bean.setMemberPassword(memberPassword);
		bean.setMemberLastname(memberLastname);
		bean.setMemberFirstname(memberFirstname);
		bean.setMemberGender(memberGender);
		bean.setMemberNickname(memberNickname);
		bean.setMemberEmail(memberEmail);
		bean.setMemberTel(memberTel+"");
		bean.setMemberAddr(memberAddr);
		bean.setMemberBirth(memberBirth);
		bean.setCreateUser(createUser);
		bean.setCreateDate(createDate);
		bean.setUpdateUser(updateUser);
		bean.setUpdateDate(updateDate);

		var out = response.getWriter();
//根據Model執行結果導向View
		if(memberAction!=null && memberAction.equals("Select")) {
			List<MembersBean> result = membersService.select(bean);
			request.setAttribute("select", result);
			request.getRequestDispatcher(
					"/pages/displayMembersForm.jsp").forward(request, response);
		} else if(memberAction!=null && memberAction.equals("SelectAll")) {
			List<MembersBean> result = membersService.select(bean);
			if(result==null) {
				out.print("找不到資料");
				out.close();
			} else {
				out.print(result);
				out.close();
			}
		}else if(memberAction!=null && memberAction.equals("提交")) {
			MembersBean result = membersService.insert(bean);
			if(result==null) {
				errors.put("action", "Insert fail");
			} else {
				request.setAttribute("insert", result);
			}
			request.getRequestDispatcher(
					"/pages/register/registerForm.jsp").forward(request, response);
		} else if(memberAction!=null && memberAction.equals("Update")) {
			MembersBean result = membersService.update(bean);
			if(result==null) {
				errors.put("action", "Update fail");
			} else {
				request.setAttribute("update", result);
			}
			request.getRequestDispatcher(
					"/pages/register/registerForm.jsp").forward(request, response);
		}else  {
			errors.put("action", "Unknown Action:"+memberAction);
			request.getRequestDispatcher(
					"/pages/register/registerForm.jsp").forward(request, response);
		}
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doGet(req, resp);
	}	
	//Email Regex Function
	public static boolean patternMatches(String emailAddress) {
		String regexPattern = "^(.+)@(\\S+)$";
	    return Pattern.compile(regexPattern).matcher(emailAddress).matches();
	}
	
}
