package cn.wecanrun.initializer.rigger.domain.service.module.impl;

import cn.wecanrun.initializer.rigger.domain.model.ApplicationInfo;
import cn.wecanrun.initializer.rigger.domain.model.ProjectInfo;
import cn.wecanrun.initializer.rigger.domain.service.module.BaseModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.File;

/**
 * 博客：https://bugstack.cn - 沉淀、分享、成长，让自己和他人都能有所收获！
 * 公众号：bugstack虫洞栈
 * Create by 小傅哥(fustack)
 */
@Service
public class GenerationApplication extends BaseModule {

    private Logger logger = LoggerFactory.getLogger(GenerationApplication.class);

    public void doGeneration(ProjectInfo projectInfo) throws Exception {

        ApplicationInfo applicationInfo = new ApplicationInfo(projectInfo);

        String packagePath = applicationInfo.getPackagePath();

        File file = new File(applicationInfo.getSrc() + packagePath,
                applicationInfo.getClassName() + ".java");

        // 写入文件
        super.writeFile(file, "application.ftl", applicationInfo);

        logger.info("创建主入口类 Application.java {}", file.getPath());
    }

}
