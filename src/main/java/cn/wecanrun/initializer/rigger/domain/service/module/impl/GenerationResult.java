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
public class GenerationResult extends BaseModule {

    private Logger logger = LoggerFactory.getLogger(GenerationResult.class);

    public void doGeneration(ProjectInfo projectInfo) throws TemplateException, IOException {

        ApplicationInfo appInfo = new ApplicationInfo(projectInfo);
        appInfo.setPackageName(projectInfo.getGroupId() + ".common");

        File file = new File(appInfo.getSrc() + appInfo.getPackagePath(),"Result.java");
        super.writeFile(file, "result.ftl", appInfo);

        logger.info("生成 Result： {}", file.getPath());

    }
}
