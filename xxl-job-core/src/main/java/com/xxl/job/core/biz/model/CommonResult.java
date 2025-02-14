package com.xxl.job.core.biz.model;

public class CommonResult<T> {

    private Integer code;

    private String msg;

    private T data;

    public CommonResult() {
    }

    public CommonResult(Integer code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public CommonResult(ReturnT<T> returnT){
        this.code =returnT.getCode();
        this.msg = returnT.getMsg();
        this.data = returnT.getContent();
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}