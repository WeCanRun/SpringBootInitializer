package ${packageName};

import jakarta.annotation.Resource;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;

@SpringBootTest
public class ElasticsearchConnectionTest {

    private Logger log = LoggerFactory.getLogger(ElasticsearchConnectionTest.class);

    @Resource
    private RestHighLevelClient restHighLevelClient;

    @Test
    public void testConnection() throws IOException {
        log.info("Connected to Elasticsearch cluster: {}", restHighLevelClient.info(RequestOptions.DEFAULT).getClusterName());
    }
}
