package ${packageName};

import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.RestClients;
import org.springframework.data.elasticsearch.config.AbstractElasticsearchConfiguration;

import java.time.Duration;

/*
* 配置es的连接
*/
@Configuration
public class ElasticsearchConfig extends AbstractElasticsearchConfiguration  {

    private String hosts = "localhost:9200";

    @Override
    public RestHighLevelClient elasticsearchClient() {
        final ClientConfiguration clientConfiguration = ClientConfiguration.builder()
                .connectedTo(hosts.split(","))
                // 设置连接超时为10秒
                .withConnectTimeout(Duration.ofSeconds(10))
                // 设置套接字超时为30秒
                .withSocketTimeout(Duration.ofSeconds(30))
                .build();

        return RestClients.create(clientConfiguration).rest();
    }
}
