/*
# XXL-JOB v2.3.0
# Copyright (c) 2015-present, xuxueli.

*/

CREATE TABLE xxl_job_info (
  id serial,
  job_group int NOT NULL,
  job_desc varchar(255) NOT NULL,
  add_time timestamp DEFAULT NULL,
  update_time timestamp DEFAULT NULL,
  author varchar(64) DEFAULT NULL ,
  alarm_email varchar(255) DEFAULT NULL ,
  schedule_type varchar(50) NOT NULL DEFAULT 'NONE',
  schedule_conf varchar(128) DEFAULT NULL,
  misfire_strategy varchar(50) NOT NULL DEFAULT 'DO_NOTHING',
  executor_route_strategy varchar(50) DEFAULT NULL,
  executor_handler varchar(255) DEFAULT NULL,
  executor_param varchar(512) DEFAULT NULL ,
  executor_block_strategy varchar(50) DEFAULT NULL ,
  executor_timeout int NOT NULL DEFAULT '0',
  executor_fail_retry_count int NOT NULL DEFAULT '0' ,
  glue_type varchar(50) NOT NULL ,
  glue_source text,
  glue_remark varchar(128) DEFAULT NULL,
  glue_updatetime timestamp DEFAULT NULL ,
  child_jobid varchar(255) DEFAULT NULL ,
  trigger_status smallint NOT NULL DEFAULT '0',
  trigger_last_time bigint NOT NULL DEFAULT '0',
  trigger_next_time bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (id)
);
comment on column xxl_job_info.glue_updatetime is 'GLUE更新时间';
comment on column xxl_job_info.child_jobid is '子任务ID，多个逗号分隔';
comment on column xxl_job_info.trigger_status is '度状态：0-停止，1-运行';
comment on column xxl_job_info.trigger_last_time is '上次调度时间';
comment on column xxl_job_info.trigger_next_time is '下次调度时间';


CREATE TABLE xxl_job_log (
  id bigserial NOT NULL,
  job_group int NOT NULL,
  job_id int NOT NULL,
  executor_address varchar(255) DEFAULT NULL,
  executor_handler varchar(255) DEFAULT NULL,
  executor_param varchar(512) DEFAULT NULL,
  executor_sharding_param varchar(20) DEFAULT NULL,
  executor_fail_retry_count int NOT NULL DEFAULT '0',
  trigger_time timestamp DEFAULT NULL,
  trigger_code int NOT NULL,
  trigger_msg text,
  handle_time timestamp DEFAULT NULL,
  handle_code int NOT NULL,
  handle_msg text,
  alarm_status smallint NOT NULL DEFAULT '0',
  PRIMARY KEY (id)
);

comment on column xxl_job_log.trigger_time is '调度-时间';
comment on column xxl_job_log.trigger_code is '调度-结果';
comment on column xxl_job_log.trigger_msg is '调度-日志';
comment on column xxl_job_log.handle_time is '执行-时间';
comment on column xxl_job_log.handle_code is '执行-状态';

create index I_trigger_time on xxl_job_log(trigger_time);
create index I_handle_code on xxl_job_log(handle_code);


CREATE TABLE xxl_job_log_report (
  id serial NOT NULL,
  trigger_day timestamp DEFAULT NULL,
  running_count int NOT NULL DEFAULT '0',
  suc_count int NOT NULL DEFAULT '0',
  fail_count int NOT NULL DEFAULT '0',
  update_time timestamp DEFAULT NULL,
  PRIMARY KEY (id)
);

create unique index i_trigger_day on xxl_job_log_report(trigger_day);

CREATE TABLE xxl_job_logglue (
  id serial NOT NULL,
  job_id int NOT NULL,
  glue_type varchar(50) DEFAULT NULL,
  glue_source text,
  glue_remark varchar(128) NOT NULL,
  add_time timestamp DEFAULT NULL,
  update_time timestamp DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE xxl_job_registry (
  id serial NOT NULL,
  registry_group varchar(50) NOT NULL,
  registry_key varchar(255) NOT NULL,
  registry_value varchar(255) NOT NULL,
  update_time timestamp DEFAULT NULL,
  PRIMARY KEY (id)
);

create index i_g_k_v on xxl_job_registry(registry_group,registry_key,registry_value);


CREATE TABLE xxl_job_group (
  id serial NOT NULL,
  app_name varchar(64) NOT NULL,
  title varchar(12) NOT NULL ,
  address_type smallint NOT NULL DEFAULT '0',
  address_list text,
  update_time timestamp DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE xxl_job_user (
  id serial NOT NULL,
  username varchar(50) NOT NULL,
  password varchar(50) NOT NULL,
  role smallint NOT NULL,
  permission varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);

create unique index i_username on xxl_job_user(username);

CREATE TABLE xxl_job_lock (
  lock_name varchar(50) NOT NULL,
  PRIMARY KEY (lock_name)
);

INSERT INTO xxl_job_group(app_name, title, address_type, address_list, update_time) VALUES ('xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31' );
INSERT INTO xxl_job_info(job_group, job_desc, add_time, update_time, author, alarm_email, schedule_type, schedule_conf, misfire_strategy, executor_route_strategy, executor_handler, executor_param, executor_block_strategy, executor_timeout, executor_fail_retry_count, glue_type, glue_source, glue_remark, glue_updatetime, child_jobid) VALUES (1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *', 'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', '2018-11-03 22:21:31', '');
INSERT INTO xxl_job_user( username, password, role, permission) VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO xxl_job_lock ( lock_name) VALUES ( 'schedule_lock');

commit;

