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
public class GenerationCommon extends BaseModule {

    private Logger logger = LoggerFactory.getLogger(GenerationCommon.class);

    public void doGeneration(ProjectInfo projectInfo) throws TemplateException, IOException {

        ApplicationInfo appInfo = new ApplicationInfo(projectInfo);
        appInfo.setPackageName(projectInfo.getGroupId() + ".common");

        // 生成统一 Result
        File file = new File(appInfo.getSrc() + appInfo.getPackagePath(),"Result.java");
        super.writeFile(file, "result.ftl", appInfo);

        logger.info("生成 Result： {}", file.getPath());

        // 生成 Prometheus 埋点 AOP
        if (projectInfo.isEnablePrometheus()) {
            File prometheusAop = new File(appInfo.getSrc() + appInfo.getPackagePath() + "/aop","PrometheusAspect.java");
            super.writeFile(prometheusAop, "prometheus-aop.ftl", appInfo);
            logger.info("PrometheusAspect.java： {}", prometheusAop.getPath());
        }

        if (projectInfo.isEnablePrometheusBasicAuth()) {
            File prometheusAop = new File(appInfo.getSrc() + appInfo.getPackagePath() + "/filter","BasicAuthFilter.java");
            super.writeFile(prometheusAop, "basic-auth-filter.ftl", appInfo);
            logger.info("BasicAuthFilter.java： {}", prometheusAop.getPath());
        }

    }
}
