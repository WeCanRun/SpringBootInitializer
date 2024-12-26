package ${packageName}.aop;

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class PrometheusAspect {

    Logger log = LoggerFactory.getLogger(PrometheusAspect.class);

    private final MeterRegistry meterRegistry;

    public PrometheusAspect(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    @Around("execution(* cn.wecanrun.demo..*Controller.*(..))")
    public Object monitorApi(ProceedingJoinPoint joinPoint) throws Throwable {
        // 获取接口名称和 HTTP 方法
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        String endpoint = className + "." + methodName;

        // 假设我们通过某种方式获取用户角色
        String userRole = "guest"; // 示例：可以通过 SecurityContextHolder 获取真实角色

        Timer.Sample sample = Timer.start(meterRegistry);
        long stop = 0;
        try {
            Object result = joinPoint.proceed();
            meterRegistry.counter("api.requests.total", "endpoint", endpoint, "status", "success", "role", userRole)
                    .increment();
            return result;
        } catch (Exception e) {
            meterRegistry.counter("api.requests.total", "endpoint", endpoint, "status", "error", "role", userRole)
                    .increment();
            throw e;
        } finally {
            stop = sample.stop(meterRegistry.timer("api.requests.timer", "endpoint", endpoint, "role", userRole));
            log.info("Request of {} took: {} ms", endpoint, stop / 1000 / 1000);
        }
    }
}