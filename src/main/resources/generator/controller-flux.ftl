package ${packageName}.controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import jakarta.servlet.http.HttpServletResponse;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import reactor.core.publisher.Flux;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.Duration;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import ${packageName}.utils.HttpUtils;




@RestController
@RequestMapping("/${appName}/api/${version}/stream")
public class StreamController {
     Logger log = LoggerFactory.getLogger(StreamController.class);

        private final ExecutorService executor = Executors.newSingleThreadExecutor();

        private static final String DEFAULT_API_URL = "http://localhost:11434/v1/chat/completions";


        @GetMapping(value = "", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
        public Flux<String> flux(HttpServletResponse response) {
            response.setCharacterEncoding("UTF-8");
            return Flux.interval(Duration.ofSeconds(1))
                    .map(sequence -> "中文测试乱码不: " + sequence)
                    .take(10)
                    .doOnCancel(System.out::println)
                    .doOnError(System.out::println);
        }


        @GetMapping(value = "/flux", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
        public Flux<ServerSentEvent<String>> streamFlux(HttpServletResponse response, @RequestParam String prompt) {
            response.setCharacterEncoding("UTF-8");
            return chatStream(prompt);
        }

        private Flux<ServerSentEvent<String>> chatStream(String prompt) {
            // 创建请求体的 HashMap
            HashMap<String, Object> requestBodyMap = new HashMap<>();
            requestBodyMap.put("model", "llama3.1");
            requestBodyMap.put("messages", List.of(Map.of("role", "user", "content", prompt + "?")));
            requestBodyMap.put("temperature", 0.0);
            requestBodyMap.put("stream", true);

            Map<String, String> headers = new HashMap<>();

            // 使用 StreamUtils 中的静态方法
            return StreamUtils.postStream(DEFAULT_API_URL, headers, requestBodyMap, data -> {
                String res = data;
                if (!data.equals("[DONE]")) {
                    JsonElement jsonElement = JsonParser.parseString(data);
                    res = jsonElement.getAsJsonObject()
                            .getAsJsonArray("choices")
                            .get(0).getAsJsonObject()
                            .getAsJsonObject("delta").toString();
                }
                ServerSentEvent<String> event =  ServerSentEvent.builder(res).build();
                return Flux.just(event);
            });
        }

    @GetMapping(value = "/sse", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamSSE(HttpServletResponse response, @RequestParam String prompt) {
        response.setCharacterEncoding("UTF-8");
        SseEmitter emitter = new SseEmitter();
        executor.execute(() -> {
            chatStream(prompt, emitter);
        });

        return emitter;
    }

    private void chatStream(String prompt, SseEmitter emitter) {
        try {
            // 创建请求体的 HashMap
            HashMap<String, Object> requestBodyMap = new HashMap<>();
            requestBodyMap.put("model", "llama3.1");
            requestBodyMap.put("temperature", 0.0);
            requestBodyMap.put("stream", true);

            List<HashMap<String, String>> messages = new ArrayList<>();
            HashMap<String, String> message = new HashMap<>();
            message.put("role", "user");
            message.put("content", prompt + "?");
            messages.add(message);
            requestBodyMap.put("messages", messages);

            Map<String, String> headers = new HashMap<>();
            headers.put("Content-Type", "application/json");
            headers.put("Accept", "text/event-stream;charset=UTF-8");
            headers.put("Authorization", "Bearer ");


            HttpUtils.asyncPost(DEFAULT_API_URL, requestBodyMap, headers, new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {
                    emitter.complete();
                    log.error("出现错误: {}", e.getMessage());
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    if (!response.isSuccessful()) {
                        emitter.completeWithError(new IOException("Unexpected code " + response));
                        return;
                    }

                    try (okhttp3.ResponseBody responseBody = response.body()) {
                        if (responseBody == null) {
                            emitter.completeWithError(new IOException("Empty response body"));
                            return;
                        }

                        BufferedReader reader = new BufferedReader(new InputStreamReader(responseBody.byteStream()));
                        String line;
                        while ((line = reader.readLine()) != null) {
                            if (!line.trim().isEmpty()) {
                                String data = line.substring("data: ".length());
                                if (data.equals("[DONE]")) {
                                    emitter.send(data);
                                    break;
                                }
                                JsonElement jsonElement = JsonParser.parseString(data);
                                JsonArray choices = jsonElement.getAsJsonObject().getAsJsonArray("choices");
                                emitter.send(SseEmitter.event().data(choices.toString()));
                            }
                        }
                    }
                    emitter.complete();
                }
            });
        } catch (Exception e) {
            emitter.completeWithError(e);
        }
    }

}






