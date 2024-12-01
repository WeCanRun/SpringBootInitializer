package cn.wecanrun.initializer.rigger.domain.model;

import org.springframework.beans.BeanUtils;

import java.net.URL;
import java.util.Arrays;

/**
 * 博客：https://bugstack.cn - 沉淀、分享、成长，让自己和他人都能有所收获！
 * 公众号：bugstack虫洞栈
 * Create by 小傅哥(fustack)
 */
public class ApplicationInfo extends ProjectInfo {

    private String packageName;
    private String className;

    private String src;

    private String resource;

    private String test;

    private String root;

    private String appName;

    public ApplicationInfo() {
    }

    public ApplicationInfo(String packageName) {
        this.packageName = packageName;
    }

    public ApplicationInfo(String packageName, String className) {
        this.packageName = packageName;
        this.className = className;
    }

    public ApplicationInfo(ProjectInfo projectInfo) {
        BeanUtils.copyProperties(projectInfo, this);

        this.packageName = projectInfo.getGroupId();
        this.className = buildClassName(projectInfo.getArtifactId());

        this.root = root();
        this.src = this.root + "/src/main/java/";
        this.resource = this.root + "/src/main/resources/";
        this.test = this.root + "/src/test/java/";

        this.appName = this.artifactId.replace("-", "").toLowerCase();
    }

    private String root() {
        URL resource = this.getClass().getResource("/");
        return String.format("%s/projects/%s", resource.getFile(), this.artifactId);
    }

    private String buildClassName(String artifactId) {
        //启动类名称
        String[] split = artifactId.split("-");
        StringBuffer applicationJavaName = new StringBuffer();
        Arrays.asList(split).forEach(s -> {
            applicationJavaName.append(s.substring(0, 1).toUpperCase() + s.substring(1));
        });
        applicationJavaName.append("Application");
        return applicationJavaName.toString();
    }


    public String getPackagePath() {
        return this.getPackageName().replace(".", "/") + "/";

    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getSrc() {
        return src;
    }

    public void setSrc(String src) {
        this.src = src;
    }

    public String getResource() {
        return resource;
    }

    public void setResource(String resource) {
        this.resource = resource;
    }

    public String getTest() {
        return test;
    }

    public void setTest(String test) {
        this.test = test;
    }

    public String getRoot() {
        return root;
    }

    public void setRoot(String root) {
        this.root = root;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }
}
