package ${packageName};

import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class KafkaTest {

    private Logger log = LoggerFactory.getLogger(KafkaTest.class);

    @Resource
    private KafkaProducer kafkaProducer;

    @Test
    public void testProducer(){
        kafkaProducer.sendMessage("my-topic", "hello world");
    }

}
