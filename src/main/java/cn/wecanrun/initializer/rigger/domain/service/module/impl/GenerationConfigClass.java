package cn.wecanrun.initializer.rigger.domain.service.module.impl;

import cn.wecanrun.initializer.rigger.domain.model.ApplicationInfo;
import cn.wecanrun.initializer.rigger.domain.model.ProjectInfo;
import cn.wecanrun.initializer.rigger.domain.service.module.BaseModule;
import freemarker.template.TemplateException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;

@Service
public class GenerationConfigClass extends BaseModule {

    private Logger logger = LoggerFactory.getLogger(GenerationConfigClass.class);

    public void doGeneration(ProjectInfo projectInfo) throws TemplateException, IOException {

        ApplicationInfo appInfo = new ApplicationInfo(projectInfo);
        appInfo.setPackageName(projectInfo.getGroupId() + ".config");

        if (projectInfo.isEnableRedis()) {
            File file = new File(appInfo.getSrc() + appInfo.getPackagePath(),"RedisConfig.java");
            super.writeFile(file, "redis-config.ftl", appInfo);
            logger.info("生成 RedisConfig.java: {}", file.getPath());

            file = new File(appInfo.getTest() + appInfo.getPackagePath(),"RedisServiceTest.java");
            super.writeFile(file, "redis-test.ftl", appInfo);
            logger.info("生成 RedisServiceTest.java: {}", file.getPath());
        }

        if (projectInfo.isEnableES()) {
            File file = new File(appInfo.getSrc() + appInfo.getPackagePath(),"ElasticsearchConfig.java");
            super.writeFile(file, "es-config.ftl", appInfo);
            logger.info("生成 ElasticsearchConfig.java: {}", file.getPath());
            file = new File(appInfo.getTest() + appInfo.getPackagePath(),"ElasticsearchConnectionTest.java");
            super.writeFile(file, "es-test.ftl", appInfo);
            logger.info("生成 ElasticsearchConnectionTest.java: {}", file.getPath());
        }

        if (appInfo.isEnableKafka()) {
            appInfo.setPackageName(projectInfo.getGroupId() + ".service");

            File file = new File(appInfo.getSrc() + appInfo.getPackagePath(),"KafkaProducer.java");
            super.writeFile(file, "kafka-producer.ftl", appInfo);
            logger.info("生成 KafkaConfig.java: {}", file.getPath());

            file = new File(appInfo.getSrc() + appInfo.getPackagePath(),"KafkaConsumer.java");
            super.writeFile(file, "kafka-consumer.ftl", appInfo);
            logger.info("生成 KafkaConsumer.java: {}", file.getPath());

            file = new File(appInfo.getTest() + appInfo.getPackagePath(),"KafkaTest.java");
            super.writeFile(file, "kafka-test.ftl", appInfo);
            logger.info("生成 KafkaTest.java: {}", file.getPath());
        }

        if (appInfo.isEnableWebFlux()) {
            appInfo.setPackageName(projectInfo.getGroupId());
            File file = new File(appInfo.getSrc() + appInfo.getPackagePath() + "/controller","StreamController.java");
            super.writeFile(file, "controller-flux.ftl", appInfo);
            logger.info("生成 StreamController.java: {}", file.getPath());

            file = new File(appInfo.getSrc() + appInfo.getPackagePath() + "/utils","StreamUtils.java");
            super.writeFile(file, "stream-utils.ftl", appInfo);
            logger.info("生成 StreamUtils.java: {}", file.getPath());
        }
    }
}
