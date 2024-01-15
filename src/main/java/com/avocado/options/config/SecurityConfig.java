package com.avocado.options.config;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import javax.sql.DataSource;


@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
	@Autowired
	private DataSource dataSource;

	@Autowired
	private AuthenticationSuccessHandler authenticationSuccessHandler;
	
	@Bean
	public BCryptPasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public DaoAuthenticationProvider authenticationProvider() {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(userDetailsService());
		authProvider.setPasswordEncoder(passwordEncoder());
		return authProvider;
	}

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.authenticationProvider(authenticationProvider());
		
		auth.
			jdbcAuthentication().dataSource(dataSource).passwordEncoder(passwordEncoder())
			.usersByUsernameQuery("select username,password,active from users where username=?")
			.authoritiesByUsernameQuery("select username,role from users where username =?");
		
		/*
		 * Authentication authentication =
		 * SecurityContextHolder.getContext().getAuthentication(); String c =
		 * authentication.getName(); System.out.println("Username :"+c);
		 */
	}

    @Override
    protected void configure(HttpSecurity http) throws Exception {
    	http
	    	.csrf().disable()
	        .authorizeRequests()
	        .antMatchers("/login","/register","/register-user","/forgetpassword", "/insertsampledata").permitAll()
	        .antMatchers("/products","/updateProduct/**","/update-product-details/**",
	        		"delete-product","/add-product","/add-products","/cancel-order/**",
	        		"/deliver-oredr/**","/order-received","/complaint-box","/order-received").hasRole("ADMIN")
			 .antMatchers("/add-to-cart","/cart","/home","/user-details","/bill-details","/order",
					 "/change-details").hasRole("USER")
	        .anyRequest()
	        .authenticated()
	        .and()
	       // .rememberMe()
	       // .and()
	        .formLogin()
	        .loginPage("/login").successHandler(authenticationSuccessHandler).permitAll()
			.failureUrl("/login?error=true")
	        .and()
	        .sessionManagement()
	        .invalidSessionUrl("/login")
	        .maximumSessions(1)
	        .maxSessionsPreventsLogin(false)   
	     ;
    }
}
