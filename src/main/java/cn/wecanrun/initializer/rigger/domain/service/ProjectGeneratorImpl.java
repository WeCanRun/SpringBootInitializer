package cn.wecanrun.initializer.rigger.domain.service;

import cn.wecanrun.initializer.rigger.application.IProjectGenerator;
import cn.wecanrun.initializer.rigger.domain.model.ProjectInfo;
import cn.wecanrun.initializer.rigger.domain.service.module.impl.*;
import jakarta.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Arrays;

/**
 * 博客：https://bugstack.cn - 沉淀、分享、成长，让自己和他人都能有所收获！
 * 公众号：bugstack虫洞栈
 * Create by 小傅哥(fustack)
 */
@Service
public class ProjectGeneratorImpl implements IProjectGenerator {

    private Logger logger = LoggerFactory.getLogger(ProjectGeneratorImpl.class);

    @Resource
    private GenerationApplication generationApplication;
    @Resource
    private GenerationYml generationYml;
    @Resource
    private GenerationPom generationPom;
    @Resource
    private GenerationTest generationTest;
    @Resource
    private GenerationIgnore generationIgnore;
    @Resource
    private GenerationPackageInfo generationPackageInfo;

    @Resource
    private GenerationRestful generationRestful;

    @Resource
    private GenerationResult generationResult;

    @Resource
    private GenerationConfigClass generationConfigClass;

    @Override
    public void generator(ProjectInfo projectInfo) throws Exception {

        // 1. 创建  Application.java
        generationApplication.doGeneration(projectInfo);

        // 2. 生成 application.yml
        generationYml.doGeneration(projectInfo);

        // 3. 生成 pom.xml
        generationPom.doGeneration(projectInfo);

        // 4. 创建测试类 ApiTest.java
        generationTest.doGeneration(projectInfo);

        // 5. 生成 .gitignore
        generationIgnore.doGeneration(projectInfo);

        // 6. 生成业务代码
        generationRestful.doGeneration(projectInfo, Arrays.asList("article"));

        // 7. 生成 Result
        generationResult.doGeneration(projectInfo);

        // 8. 生成配置类
        generationConfigClass.doGeneration(projectInfo);

    }

}
