package ${packageName};

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;

import java.time.Duration;


@RestController
@RequestMapping("/${appName}/api/${version}/flux")
public class FluxController {

    private WebClient webClient;

    public FluxController(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.baseUrl("http://localhost:11434/v1").build();
    }

    @GetMapping(value = "", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> flux(HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        return Flux.interval(Duration.ofSeconds(1))
                .map(sequence -> "中文测试乱码不: " + sequence)
                .take(10)
                .doOnCancel(System.out::println)
                .doOnError(System.out::println);
    }


    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<String> streamFlux(HttpServletResponse response, @RequestParam String prompt) {
        response.setCharacterEncoding("UTF-8");
        return chatStream(prompt);
    }

    private Flux<String> chatStream(String prompt) {
        String requestBody = String.format("{\n" +
                "    \"model\": \"llama3.1\",\n" +
                "    \"messages\": [\n" +
                "        {\n" +
                "            \"role\": \"user\",\n" +
                "            \"content\": \"%s?\"\n" +
                "        }\n" +
                "    ],\n" +
                "    \"temperature\": 0.0,\n" +
                "    \"stream\": true\n" +
                "}\n", prompt);

        Flux<String> flux = webClient.mutate()
                .build()
                .post()
                .uri("/chat/completions")
                // 确保替换为你的API密钥
                .header("Authorization", "Bearer ")
                // 指定接受的字符集
                .header("Accept", "text/event-stream;charset=UTF-8")
                .bodyValue(requestBody)
                .accept(MediaType.TEXT_EVENT_STREAM)
                .retrieve()
                .bodyToFlux(String.class)
                .map(data -> {
                    if (data.equals("[DONE]")) {
                        return data;
                    }
                    JsonElement jsonElement = JsonParser.parseString(data);
                    JsonArray choices = jsonElement.getAsJsonObject().getAsJsonArray("choices");
                    return choices.toString();
                })
                .doOnError(System.out::println);
        return flux;
    }
}






