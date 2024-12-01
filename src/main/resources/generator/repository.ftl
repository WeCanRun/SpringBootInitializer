package ${packageName};


import ${groupId}.entity.${tableName};
import org.springframework.data.jpa.repository.JpaRepository;

public interface ${tableName}Repository extends JpaRepository<${tableName}, Long> {
}