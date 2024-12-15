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

<#if enableRedis?? && enableRedis == true>
  redis:
    <#if redisClusterEnabled?? && redisClusterEnabled == true>
      cluster:
        nodes: localhost:7000,localhost:7001,localhost:7002
    <#else>
      host: localhost
      port: 6379
    </#if>
</#if>

<#if enableES?? && enableES == true>
  elasticsearch:
    rest:
      uris: http://localhost:9200
</#if>

<#if enableKafka?? && enableKafka == true>
  kafka:
    bootstrap-servers: localhost:9092
    consumer:
      group-id: my-group
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.apache.kafka.common.serialization.StringSerializer
</#if>

