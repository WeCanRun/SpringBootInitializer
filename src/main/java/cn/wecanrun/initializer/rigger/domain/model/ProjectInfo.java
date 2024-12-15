package cn.wecanrun.initializer.rigger.domain.model;

/**
 * 博客：https://bugstack.cn - 沉淀、分享、成长，让自己和他人都能有所收获！
 * 公众号：bugstack虫洞栈
 * Create by 小傅哥(fustack)
 */
public class ProjectInfo {

    protected String groupId;
    protected String artifactId;
    protected String version;
    protected String name;
    protected String description;
    private String author;

    protected boolean enableRedis;
    protected boolean redisClusterEnabled;
    protected boolean enableES;
    protected boolean enableKafka;
    protected boolean enableWebFlux;


    public ProjectInfo() {
    }

    public ProjectInfo(String groupId, String artifactId, String version, String name, String description, String author) {
        this.groupId = groupId;
        this.artifactId = artifactId;
        this.version = version;
        this.name = name;
        this.description = description;
        this.author = author;

    }

    public ProjectInfo(String groupId, String artifactId, String version, String name, String description, String author,
                       boolean enableWebFlux, boolean enableRedis, boolean redisClusterEnabled,
                       boolean enableES, boolean enableKafka) {
        this.groupId = groupId;
        this.artifactId = artifactId;
        this.version = version;
        this.name = name;
        this.description = description;
        this.author = author;
        this.enableWebFlux = enableWebFlux;
        this.enableRedis = enableRedis;
        this.redisClusterEnabled = redisClusterEnabled;
        this.enableES = enableES;
        this.enableKafka = enableKafka;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getArtifactId() {
        return artifactId;
    }

    public void setArtifactId(String artifactId) {
        this.artifactId = artifactId;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isEnableRedis() {
        return enableRedis;
    }

    public void setEnableRedis(boolean enableRedis) {
        this.enableRedis = enableRedis;
    }

    public boolean isEnableES() {
        return enableES;
    }

    public void setEnableES(boolean enableES) {
        this.enableES = enableES;
    }

    public boolean isEnableKafka() {
        return enableKafka;
    }

    public void setEnableKafka(boolean enableKafka) {
        this.enableKafka = enableKafka;
    }

    public boolean isRedisClusterEnabled() {
        return redisClusterEnabled;
    }

    public void setRedisClusterEnabled(boolean redisClusterEnabled) {
        this.redisClusterEnabled = redisClusterEnabled;
    }

    public boolean isEnableWebFlux() {
        return enableWebFlux;
    }

    public void setEnableWebFlux(boolean enableWebFlux) {
        this.enableWebFlux = enableWebFlux;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }
}
