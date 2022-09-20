package com.xxl.job.admin.controller;

import com.xxl.job.admin.controller.annotation.PermissionLimit;
import com.xxl.job.admin.core.model.XxlJobGroup;
import com.xxl.job.admin.core.model.XxlJobInfo;
import com.xxl.job.admin.core.thread.JobTriggerPoolHelper;
import com.xxl.job.admin.core.trigger.TriggerTypeEnum;
import com.xxl.job.admin.dao.XxlJobGroupDao;
import com.xxl.job.admin.service.XxlJobService;
import com.xxl.job.core.biz.model.CommonResult;
import com.xxl.job.core.biz.model.ReturnT;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.Objects;

@RestController
@RequestMapping("/api")
public class JobRestController {

    @Resource
    private XxlJobService xxlJobService;

    @Resource
    private XxlJobGroupDao xxlJobGroupDao;

    @PostMapping("/job/add")
    @PermissionLimit(limit = false)
    public CommonResult<String> add(@RequestBody XxlJobInfo jobInfo) {
        return new CommonResult<>(xxlJobService.add(jobInfo));
    }

    @PutMapping("/job/update")
    @PermissionLimit(limit = false)
    public CommonResult<String> update(@RequestBody XxlJobInfo jobInfo) {
        return new CommonResult<>(xxlJobService.update(jobInfo));
    }

    @DeleteMapping("/job/{id}")
    @PermissionLimit(limit = false)
    public CommonResult<String> remove(@PathVariable Integer id) {
        return new CommonResult<>(xxlJobService.remove(id));
    }

    @PostMapping("/job/{id}/stop")
    @PermissionLimit(limit = false)
    public CommonResult<String> pause(@PathVariable Integer id) {
        return new CommonResult<>(xxlJobService.stop(id));
    }

    @PostMapping("/job/{id}/start")
    @PermissionLimit(limit = false)
    public CommonResult<String> start(@PathVariable Integer id) {
        return new CommonResult<>(xxlJobService.start(id));
    }

    @RequestMapping("/job/trigger")
    @PermissionLimit(limit = false)
    public CommonResult<String> triggerJob(int id, String executorParam, String addressList) {
        // force cover job param
        if (executorParam == null) {
            executorParam = "";
        }

        JobTriggerPoolHelper.trigger(id, TriggerTypeEnum.MANUAL, -1, null, executorParam, addressList);
        return new CommonResult<>(ReturnT.SUCCESS);
    }

    @PostMapping("/job/addAndStart")
    @PermissionLimit(limit = false)
    public CommonResult<String> addAndStart(@RequestBody XxlJobInfo jobInfo) {
        ReturnT<String> result = xxlJobService.add(jobInfo);
        if (ReturnT.SUCCESS_CODE==result.getCode()){
            xxlJobService.start(Integer.parseInt(result.getContent()));
        }
        return new CommonResult<>(result);
    }

    @PermissionLimit(limit = false)
    @GetMapping("/jobgroup/search")
    @ResponseBody
    public CommonResult<?> searchAppByName(String appName){
        XxlJobGroup xxlJobGroup = xxlJobGroupDao.findOneByAppName(appName);
        if (Objects.isNull(xxlJobGroup)){
            return new CommonResult<>(ReturnT.FAIL);
        }
        return new CommonResult<>(new ReturnT<>(xxlJobGroup.getId()));
    }
}
