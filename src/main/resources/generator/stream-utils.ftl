package ${packageName}.utils;

import org.reactivestreams.Publisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;

import java.util.Map;
import java.util.function.Function;

public class StreamUtils {
    private static final Logger log = LoggerFactory.getLogger(StreamUtils.class);

    private static final WebClient webClient = WebClient.builder()
            .build();


    public static <T> Flux<ServerSentEvent<String>> postStream(String url, Map<String, String> headers, T body) {
        return webClient.post()
                .uri(url)
                .headers(httpHeaders -> headers.forEach(httpHeaders::set))
                .header("Accept", "text/event-stream;charset=UTF-8")
                .bodyValue(body)
                .accept(MediaType.TEXT_EVENT_STREAM)
                .retrieve()
                .bodyToFlux(String.class)
                .flatMap(data -> Flux.just(ServerSentEvent.builder(data).build()));
    }

    public static <T> Flux<ServerSentEvent<String>> postStream(String url, Map<String, String> headers, T body, Function<String, Publisher<ServerSentEvent<String>>> callback) {
        return webClient.post()
                .uri(url)
                .headers(httpHeaders -> headers.forEach(httpHeaders::set))
                .header("Accept", "text/event-stream;charset=UTF-8")
                .bodyValue(body)
                .accept(MediaType.TEXT_EVENT_STREAM)
                .retrieve()
                .bodyToFlux(String.class)
                .flatMap(callback);
    }

    public static Flux<ServerSentEvent<String>> get(String url, Map<String, String> headers, MultiValueMap<String, String> queryParams) {

        return webClient.get()
                .uri(url, uriBuilder -> uriBuilder.queryParams(queryParams).build())
                .headers(httpHeaders -> headers.forEach(httpHeaders::set))
                .header("Accept", "text/event-stream;charset=UTF-8")
                .accept(MediaType.TEXT_EVENT_STREAM)
                .retrieve()
                .bodyToFlux(String.class)
                .flatMap(data -> Flux.just(ServerSentEvent.builder(data).build()));
    }

    public static Flux<ServerSentEvent<String>> get(String url, Map<String, String> headers, MultiValueMap<String, String> queryParams, Function<String, Publisher<ServerSentEvent<String>>> callback) {

        return webClient.get()
                .uri(url, uriBuilder -> uriBuilder.queryParams(queryParams).build())
                .headers(httpHeaders -> headers.forEach(httpHeaders::set))
                .header("Accept", "text/event-stream;charset=UTF-8")
                .accept(MediaType.TEXT_EVENT_STREAM)
                .retrieve()
                .bodyToFlux(String.class)
                .flatMap(callback);
    }
}
