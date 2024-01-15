package com.avocado.options.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collection;

@Component
public class CustomSuccessHandler implements AuthenticationSuccessHandler {
     
	@Autowired
	 HttpSession session;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
	
		String redirectUrl = null;
		
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		
		 String username = authentication.getName();
		 session.setAttribute("username", username);

		redirectUrl = "/view-homeDashboard";

		new DefaultRedirectStrategy().sendRedirect(request, response, redirectUrl);
	}

}
