package ${groupId}.utils;

import ${groupId}.entity.${tableName};
import com.google.gson.Gson;
import okhttp3.*;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

public class HttpUtils {

    private static final OkHttpClient client = new OkHttpClient.Builder()
                                                  .connectTimeout(100, TimeUnit.SECONDS)  // 设置连接超时时间为 100 秒
                                                  .readTimeout(3000, TimeUnit.SECONDS)     // 设置读取超时时间为 3000 秒
                                                  .writeTimeout(1500, TimeUnit.SECONDS)    // 设置写入超时时间为 1500 秒
                                                  .build();
    private static final Gson gson = new Gson();

    // GET 请求（支持查询字符串）
    public static String get(String url, Map<String, String> headers, Map<String, String> queryParams) throws IOException {
        HttpUrl.Builder urlBuilder = HttpUrl.parse(url).newBuilder();
        if (queryParams != null) {
            for (Map.Entry<String, String> param : queryParams.entrySet()) {
                urlBuilder.addQueryParameter(param.getKey(), param.getValue());
            }
        }

        Request.Builder requestBuilder = new Request.Builder().url(urlBuilder.build());
        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                requestBuilder.addHeader(header.getKey(), header.getValue());
            }
        }

        Request request = requestBuilder.build();
        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                return response.body().string();
            } else {
                throw new IOException("Unexpected code " + response);
            }
        }
    }

    // POST 请求（泛型版本）
    public static <T> String post(String url, T body, Map<String, String> headers) throws IOException {
        MediaType JSON = MediaType.get("application/json; charset=utf-8");
        String json = gson.toJson(body);
        RequestBody requestBody = RequestBody.create(json, JSON);

        Request.Builder requestBuilder = new Request.Builder().url(url).post(requestBody);
        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                requestBuilder.addHeader(header.getKey(), header.getValue());
            }
        }

        Request request = requestBuilder.build();
        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                return response.body().string();
            } else {
                throw new IOException("Unexpected code " + response);
            }
        }
    }

    // 文件上传
    public static String uploadFile(String url, File file, Map<String, String> headers) throws IOException {
        RequestBody requestBody = new MultipartBody.Builder()
                .setType(MultipartBody.FORM)
                .addFormDataPart("file", file.getName(),
                        RequestBody.create(file, MediaType.parse("application/octet-stream")))
                .build();

        Request.Builder requestBuilder = new Request.Builder().url(url).post(requestBody);
        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                requestBuilder.addHeader(header.getKey(), header.getValue());
            }
        }

        Request request = requestBuilder.build();
        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                return response.body().string();
            } else {
                throw new IOException("Unexpected code " + response);
            }
        }
    }

    // 文件下载
    public static void downloadFile(String url, String outputFilePath, Map<String, String> headers) throws IOException {
        Request.Builder requestBuilder = new Request.Builder().url(url);
        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                requestBuilder.addHeader(header.getKey(), header.getValue());
            }
        }

        Request request = requestBuilder.build();
        try (Response response = client.newCall(request).execute()) {
            if (response.isSuccessful()) {
                ResponseBody responseBody = response.body();
                if (responseBody != null) {
                    InputStream inputStream = responseBody.byteStream();
                    try (FileOutputStream outputStream = new FileOutputStream(outputFilePath)) {
                        byte[] buffer = new byte[2048];
                        int bytesRead;
                        while ((bytesRead = inputStream.read(buffer)) != -1) {
                            outputStream.write(buffer, 0, bytesRead);
                        }
                        outputStream.flush();
                    }
                }
            } else {
                throw new IOException("Unexpected code " + response);
            }
        }
    }

    // 异步 GET 请求（支持查询字符串）
    public static void asyncGet(String url, Map<String, String> headers, Map<String, String> queryParams, Callback callback) {
        HttpUrl.Builder urlBuilder = HttpUrl.parse(url).newBuilder();
        if (queryParams != null) {
            for (Map.Entry<String, String> param : queryParams.entrySet()) {
                urlBuilder.addQueryParameter(param.getKey(), param.getValue());
            }
        }

        Request.Builder requestBuilder = new Request.Builder().url(urlBuilder.build());
        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                requestBuilder.addHeader(header.getKey(), header.getValue());
            }
        }

        Request request = requestBuilder.build();
        client.newCall(request).enqueue(callback);
    }

    // 异步 POST 请求（泛型版本）
    public static <T> void asyncPost(String url, T body, Map<String, String> headers, Callback callback) {
        MediaType JSON = MediaType.get("application/json; charset=utf-8");
        String json = gson.toJson(body);
        RequestBody requestBody = RequestBody.create(json, JSON);

        Request.Builder requestBuilder = new Request.Builder().url(url).post(requestBody);
        if (headers != null) {
            for (Map.Entry<String, String> header : headers.entrySet()) {
                requestBuilder.addHeader(header.getKey(), header.getValue());
            }
        }

        Request request = requestBuilder.build();
        client.newCall(request).enqueue(callback);
    }

    public static void main(String[] args) {
        // 示例实体对象
        ${tableName} ${tableNameLower} = new ${tableName}();
        // ${tableNameLower}.setTitle("Test ${tableName}");
        // ${tableNameLower}.setContent("This is a test ${tableName}.");

        // 请求头
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");

        // 查询参数
        Map<String, String> queryParams = new HashMap<>();
        queryParams.put("id", "1");

        try {
            // GET 请求示例
            String getResponse = get("http://localhost:8080/${appName}/api/${version}/${tableNameLower}s", headers, queryParams);
            System.out.println("GET Response: " + getResponse);

            // POST 请求示例
            String postResponse = post("http://localhost:8080/${appName}/api/${version}/${tableNameLower}s", ${tableNameLower}, headers);
            System.out.println("POST Response: " + postResponse);

            // 异步 GET 请求示例
            asyncGet("http://localhost:8080/${appName}/api/${version}/${tableNameLower}s", headers, queryParams, new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {
                    e.printStackTrace();
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    if (response.isSuccessful()) {
                        System.out.println("Async GET Response: " + response.body().string());
                    } else {
                        System.out.println("Request failed: " + response.code());
                    }
                }
            });

            // 异步 POST 请求示例
            asyncPost("http://localhost:8080/${appName}/api/${version}/${tableNameLower}s", ${tableNameLower}, headers, new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {
                    e.printStackTrace();
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    if (response.isSuccessful()) {
                        System.out.println("Async POST Response: " + response.body().string());
                    } else {
                        System.out.println("Request failed: " + response.code());
                    }
                }
            });

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
