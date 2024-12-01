package ${packageName};

import com.google.gson.Gson;
import org.springframework.http.HttpStatus;

/**
 * 统一API响应结果封装
 */
public class Result<T> {
    private int code;
    private String message;
    private T data;

    private Result() {
    }

    private Result(HttpStatus code) {
        this.code = code.value();
        this.message = code.getReasonPhrase();
    }

    private Result(HttpStatus code, T data) {
        this.code = code.value();
        this.message = code.getReasonPhrase();
        this.data = data;
    }

    private Result(HttpStatus code, String message) {
        this.code = code.value();
        this.message = message;
    }


    private Result(HttpStatus code, String message, T data) {
        this.code = code.value();
        this.message = message;
        this.data = data;
    }

    public static <T> Result<T> success() {
        return new Result<T>(HttpStatus.OK);
    }

    public static <T> Result<T> success(T data) {
        return new Result<T>(HttpStatus.OK, data);
    }

    public static <T> Result<T> error() {
        return new Result<T>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    public static <T> Result<T> error(String msg) {
        return new Result<T>(HttpStatus.INTERNAL_SERVER_ERROR, msg);
    }

    public static <T> Result<T> notFound() {
        return new Result<T>(HttpStatus.NOT_FOUND);
    }

    public static <T> Result<T> builder(HttpStatus code, String message, T data) {
        return new Result<T>(code, message, data);
    }
    public static <T> Result<T> builder(HttpStatus code, String message) {
        return new Result<T>(code, message);
    }

    public Result setCode(HttpStatus resultCode) {
        this.code = resultCode.value();
        return this;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public Result setMessage(String message) {
        this.message = message;
        return this;
    }

    public T getData() {
        return data;
    }

    public Result setData(T data) {
        this.data = data;
        return this;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
