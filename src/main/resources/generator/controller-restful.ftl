package ${packageName};

import ${groupId}.entity.${tableName};
import ${groupId}.service.${tableName}Service;
import org.springframework.beans.factory.annotation.Autowired;
import ${groupId}.common.Result;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/${appName}/api/${version}/${tableNameLower}s")
public class ${tableName}Controller {
    private final ${tableName}Service ${tableNameLower}Service;

    @Autowired
    public ${tableName}Controller(${tableName}Service ${tableNameLower}Service) {
        this.${tableNameLower}Service = ${tableNameLower}Service;
    }

    @GetMapping
    public Result<List<${tableName}>> list() {
        List<${tableName}> ${tableNamePlural} = ${tableNameLower}Service.findAll();
        return Result.success(${tableNamePlural});
    }

    @PostMapping
    public Result<${tableName}> create(@RequestBody ${tableName} ${tableNameLower}) {
        ${tableName} saved${tableName} = ${tableNameLower}Service.save(${tableNameLower});
        return Result.success(saved${tableName});
    }

    @GetMapping("/{id}")
    public Result<${tableName}> getById(@PathVariable Long id) {
        ${tableName} ${tableNameLower} = ${tableNameLower}Service.findById(id);
        if (${tableNameLower} != null) {
            return Result.success(${tableNameLower});
        }
        return Result.notFound();
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteById(@PathVariable Long id) {
        boolean deleted = ${tableNameLower}Service.deleteById(id);
        if (deleted) {
            return Result.success();
        }
        return Result.notFound();

    }

    @PutMapping
    public Result<${tableName}> update(@RequestBody ${tableName} updated${tableName}) {
        ${tableName} updatedEntity = ${tableNameLower}Service.update(updated${tableName});
        if (updatedEntity != null) {
            return Result.success(updatedEntity);
        }
        return Result.notFound();
    }
}