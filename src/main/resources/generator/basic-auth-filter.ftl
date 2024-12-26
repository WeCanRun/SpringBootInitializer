package ${packageName}.filter;

import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Base64;

public class BasicAuthFilter extends OncePerRequestFilter {


    private static final String USERNAME = "admin";
    private static final String PASSWORD = "admin";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        if ("/actuator/prometheus".equals(path)) {
            String authHeader = request.getHeader("Authorization");

            if (authHeader == null || !authHeader.startsWith("Basic ")) {
                response.setHeader("WWW-Authenticate", "Basic realm=\"Access to the staging site\"");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            String base64Credentials = authHeader.substring("Basic ".length()).trim();
            String credentials = new String(Base64.getDecoder().decode(base64Credentials));
            String[] values = credentials.split(":", 2);

            String username = values[0];
            String password = values[1];

            // 检查用户名和密码（这里使用简单示例，建议使用更安全的方式）
            if (!USERNAME.equals(username) || !PASSWORD.equals(password)) {
                // 设置 WWW-Authenticate 头部
                response.setHeader("WWW-Authenticate", "Basic realm=\"Access to the staging site\"");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
        }

        filterChain.doFilter(request, response);
    }
}