package ${packageName};

import ${groupId}.entity.${tableName};
import ${groupId}.repository.${tableName}Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ${tableName}Service {
    private final ${tableName}Repository ${tableNameLower}Repository;

    @Autowired
    public ${tableName}Service(${tableName}Repository ${tableNameLower}Repository) {
        this.${tableNameLower}Repository = ${tableNameLower}Repository;
    }

    public List<${tableName}> findAll() {
        return ${tableNameLower}Repository.findAll();
    }

    public ${tableName} save(${tableName} ${tableNameLower}) {
        return ${tableNameLower}Repository.save(${tableNameLower});
    }

    public ${tableName} findById(Long id) {
        Optional<${tableName}> optional${tableName} = ${tableNameLower}Repository.findById(id);
        return optional${tableName}.orElse(null);
    }

    public boolean deleteById(Long id) {
        Optional<${tableName}> optional${tableName} = ${tableNameLower}Repository.findById(id);
        if (optional${tableName}.isPresent()) {
            ${tableNameLower}Repository.deleteById(id);
            return true;
        }
        return false;
    }

    public ${tableName} update(${tableName} updated${tableName}) {
        Optional<${tableName}> optional${tableName} = ${tableNameLower}Repository.findById(updated${tableName}.getId());
        if (optional${tableName}.isPresent()) {
            return ${tableNameLower}Repository.save(updated${tableName});
        }
        return null;
    }
}