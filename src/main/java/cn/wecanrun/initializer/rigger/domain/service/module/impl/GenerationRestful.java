package cn.wecanrun.initializer.rigger.domain.service.module.impl;

import cn.wecanrun.initializer.rigger.domain.model.ApplicationInfo;
import cn.wecanrun.initializer.rigger.domain.model.ProjectInfo;
import cn.wecanrun.initializer.rigger.domain.service.module.BaseModule;
import freemarker.template.TemplateException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 博客：https://bugstack.cn - 沉淀、分享、成长，让自己和他人都能有所收获！
 * 公众号：bugstack虫洞栈
 * Create by 小傅哥(fustack)
 * <p>
 * 生成描述文件 package-info.java
 */
@Service
public class GenerationRestful extends BaseModule {

    @Value("${spring.datasource.url}")
    private String url;
    @Value("${spring.datasource.username}")
    private String username;
    @Value("${spring.datasource.password}")
    private String password;

    private Logger logger = LoggerFactory.getLogger(GenerationRestful.class);

    public void doGeneration(ProjectInfo projectInfo, List<String> tableNames) {
        ApplicationInfo applicationInfo = new ApplicationInfo(projectInfo);

        try {
            for (String tableName : tableNames) {
                List<String> columnNames = getColumnsForTable(tableName);

                Map<String, Object> dataModel = new HashMap<>();
                dataModel.put("groupId", projectInfo.getGroupId());
                dataModel.put("appName", applicationInfo.getAppName());
                dataModel.put("version", "v1");
                dataModel.put("packageName", applicationInfo.getPackageName() + ".entity");
                dataModel.put("tableName", capitalizeFirstLetter(tableName));
                dataModel.put("fields", generateFields(columnNames));
                dataModel.put("gettersAndSetters", generateGettersAndSetters(columnNames));
                dataModel.put("tableNameLower", tableName.toLowerCase());
                dataModel.put("tableNamePlural", tableName + "s");
                dataModel.put("author", "generated");
                dataModel.put("date", LocalDate.now());

                applicationInfo.setPackageName(projectInfo.getGroupId() + ".entity");
                File file = new File(applicationInfo.getSrc() + applicationInfo.getPackagePath(),
                        capitalizeFirstLetter(tableName) + ".java");
                super.writeFile(file, "entity.ftl", dataModel);
                logger.info("生成 entity： {}", file.getPath());

                applicationInfo.setPackageName(projectInfo.getGroupId() + ".repository");
                file = new File(applicationInfo.getSrc() + applicationInfo.getPackagePath(),
                        capitalizeFirstLetter(tableName) + "Repository.java");
                dataModel.put("packageName", applicationInfo.getPackageName());
                super.writeFile(file, "repository.ftl", dataModel);
                logger.info("生成 Repository： {}", file.getPath());

                applicationInfo.setPackageName(projectInfo.getGroupId() + ".service");
                file = new File(applicationInfo.getSrc() + applicationInfo.getPackagePath(),
                capitalizeFirstLetter(tableName) + "Service.java");
                dataModel.put("packageName", applicationInfo.getPackageName());
                super.writeFile(file, "service.ftl", dataModel);
                logger.info("生成 Service： {}", file.getPath());

                applicationInfo.setPackageName(projectInfo.getGroupId() + ".controller");
                file = new File(applicationInfo.getSrc() + applicationInfo.getPackagePath(),
                capitalizeFirstLetter(tableName) + "Controller.java");
                dataModel.put("packageName", applicationInfo.getPackageName());
                super.writeFile(file, "controller-restful.ftl", dataModel);
                logger.info("生成 Controller： {}", file.getPath());

            }
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
        }
    }

    private static String generateFields(List<String> columnNames) {
        StringBuilder fields = new StringBuilder();
        for (String columnName : columnNames) {
            if ("id".equals(columnName)) {
                continue;
            }
            fields.append("private String ").append(convertSnakeToCamel(columnName)).append(";\n    ");
        }
        return fields.toString();
    }

    private static String generateGettersAndSetters(List<String> columnNames) {
        StringBuilder gettersAndSetters = new StringBuilder();
        for (String columnName : columnNames) {
            if ("id".equals(columnName)) {
                continue;
            }
            // 大驼峰
            String toPascal = convertSnakeToPascal(columnName);
            // 小驼峰
            String toCamel = convertSnakeToCamel(columnName);

            gettersAndSetters.append("public String get").append(toPascal).append("() {\n    ");
            gettersAndSetters.append("    return this.").append(toCamel).append(";\n    ");
            gettersAndSetters.append("}\n\n    ");
            gettersAndSetters.append("public void set").append(toPascal).append("(String ").append(toCamel).append(") {\n    ");
            gettersAndSetters.append("    this.").append(toCamel).append(" = ").append(toCamel).append(";\n    ");
            gettersAndSetters.append("}\n\n    ");
        }
        return gettersAndSetters.toString();
    }

    private static String capitalizeFirstLetter(String str) {
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }

    /**
     * 将下划线格式转换为大驼峰格式
     *
     * @param snakeCase 字符串，格式为下划线分隔
     * @return 转换后的大驼峰格式字符串
     */
    public static String convertSnakeToPascal(String snakeCase) {
        if (snakeCase == null || snakeCase.isEmpty()) {
            return snakeCase; // 处理空字符串或 null
        }

        StringBuilder pascalCase = new StringBuilder();
        // 分割字符串
        String[] parts = snakeCase.split("_");

        for (String part : parts) {
            if (!part.isEmpty()) {
                // 将每个部分的首字母大写，并追加到结果中
                pascalCase.append(Character.toUpperCase(part.charAt(0)));
                pascalCase.append(part.substring(1).toLowerCase());
            }
        }

        return pascalCase.toString();
    }

    /**
     * 将下划线格式的字符串转换为小驼峰格式
     *
     * @param snakeCase 下划线格式的字符串
     * @return 小驼峰格式的字符串
     */
    public static String convertSnakeToCamel(String snakeCase) {
        String pascalCase = convertSnakeToPascal(snakeCase);
        return Character.toLowerCase(pascalCase.charAt(0)) + pascalCase.substring(1);
    }

    private List<String> getColumnsForTable(String tableName) {
        List<String> columnNames = new ArrayList<>();
        try {
            Connection connection = DriverManager.getConnection(url, username, password);
            DatabaseMetaData metaData = connection.getMetaData();
            ResultSet resultSet = metaData.getColumns(null, null, tableName, null);
            while (resultSet.next()) {
                columnNames.add(resultSet.getString("COLUMN_NAME"));
            }
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return columnNames;
    }

}
