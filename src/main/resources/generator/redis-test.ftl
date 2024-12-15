package ${packageName};

import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.RedisTemplate;

@SpringBootTest
public class RedisServiceTest {

    private Logger log = LoggerFactory.getLogger(RedisServiceTest.class);

    @Resource
    private RedisTemplate<String, Object> redisTemplate;

    @Test
    void setValue() {
        redisTemplate.opsForValue().set("key", "value");
    }

    @Test
    void getValue() {
        Object value = redisTemplate.opsForValue().get("key");
        log.info("value: {}", value);
    }

    @Test
    void deleteValue() {
        redisTemplate.delete("key");
    }
}