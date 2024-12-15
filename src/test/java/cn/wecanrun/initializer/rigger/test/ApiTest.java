package cn.wecanrun.initializer.rigger.test;

import cn.wecanrun.initializer.rigger.application.IProjectGenerator;
import cn.wecanrun.initializer.rigger.domain.model.ProjectInfo;
import jakarta.annotation.Resource;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 * 博客：https://bugstack.cn - 沉淀、分享、成长，让自己和他人都能有所收获！
 * 公众号：bugstack虫洞栈
 * Create by 小傅哥(fustack)
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class ApiTest {

    private Logger log = LoggerFactory.getLogger(ApiTest.class);

    @Resource
    private IProjectGenerator iProjectGenerator;

    @Test
    public void test_IProjectGenerator() throws Exception {

        ProjectInfo projectInfo = new ProjectInfo(
                "cn.wecanrun.demo",
                "new-test",
                "v1",
                "new-test",
                "Demo project for Spring Boot",
                "WeCanRun",
                true,
                true,
                false,
                true,
                true
        );

        iProjectGenerator.generator(projectInfo);
    }

}
