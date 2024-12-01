server:
  port: 8080

spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/blog?useSSL=false&serverTimezone=UTC
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver

  jpa:
    hibernate:
      ddl-auto: update  # 可选的值：none, update, create, create-drop
    show-sql: true
