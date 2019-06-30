
create sequence seq_jobinfo;

CREATE TABLE xxl_job_info (
  id numeric (11,0)  PRIMARY KEY NOT NULL,
  job_group numeric (11,0) NOT NULL ,
  job_cron varchar2(128) NOT NULL,
  job_desc varchar2(255) NOT NULL,
  add_time timestamp DEFAULT NULL,
  update_time timestamp DEFAULT NULL,
  author varchar2(64) DEFAULT NULL,
  alarm_email varchar2(255) DEFAULT NULL,
  executor_route_strategy varchar2(50) DEFAULT NULL,
  executor_handler varchar2(255) DEFAULT NULL,
  executor_param varchar2(512) DEFAULT NULL,
  executor_block_strategy varchar2(50) DEFAULT NULL,
  executor_timeout numeric(11,0) DEFAULT 0  NOT NULL ,
  executor_fail_retry_count numeric (11,0) DEFAULT 0 NOT NULL,
  glue_type varchar2(50) NOT NULL ,
  glue_source clob ,
  glue_remark varchar2(128) DEFAULT NULL ,
  glue_updatetime timestamp DEFAULT NULL ,
  child_jobid varchar2(255) DEFAULT NULL ,
  trigger_status numeric(4) DEFAULT 0  NOT NULL ,
  trigger_last_time numeric(13) DEFAULT 0 NOT NULL ,
  trigger_next_time numeric(13) DEFAULT 0 NOT NULL
) ;

COMMENT on column xxl_job_info.id is '执行器主键ID';
COMMENT on column xxl_job_info.job_cron is '任务执行CRON';
COMMENT on column xxl_job_info.author is '作者';
COMMENT on column xxl_job_info.alarm_email is '报警邮件';
COMMENT on column xxl_job_info.executor_route_strategy is '执行器路由策略';
COMMENT on column xxl_job_info.executor_handler is '执行器任务handler';
COMMENT on column xxl_job_info.executor_param is '执行器任务参数';
COMMENT on column xxl_job_info.executor_block_strategy is '阻塞处理策略';
COMMENT on column xxl_job_info.executor_timeout is '任务执行超时时间，单位秒';
COMMENT on column xxl_job_info.executor_fail_retry_count is '失败重试次数';
COMMENT on column xxl_job_info.glue_type is 'GLUE类型';
COMMENT on column xxl_job_info.glue_source is 'GLUE源代码';
COMMENT on column xxl_job_info.glue_remark is 'GLUE备注';
COMMENT on column xxl_job_info.glue_updatetime is 'GLUE更新时间';
COMMENT on column xxl_job_info.child_jobid is '子任务ID，多个逗号分隔';
COMMENT on column xxl_job_info.trigger_status is '调度状态：0-停止，1-运行';
COMMENT on column xxl_job_info.trigger_last_time is '上次调度时间';
COMMENT on column xxl_job_info.trigger_next_time is '下次调度时间';

create sequence seq_joblog;

CREATE TABLE xxl_job_log (
  id numeric (11,0)  PRIMARY KEY NOT NULL,
  job_group numeric (11,0) NOT NULL ,
  job_id numeric (11,0) NOT NULL ,
  executor_address varchar2(255) DEFAULT NULL ,
  executor_handler varchar2(255) DEFAULT NULL ,
  executor_param varchar2(512) DEFAULT NULL ,
  executor_sharding_param varchar2(20) DEFAULT NULL ,
  executor_fail_retry_count numeric (11,0) DEFAULT 0 NOT NULL,
  trigger_time timestamp DEFAULT NULL,
  trigger_code numeric (11,0) NOT NULL,
  trigger_msg CLOB ,
  handle_time timestamp DEFAULT NULL,
  handle_code numeric (11,0) NOT NULL,
  handle_msg CLOB ,
  alarm_status numeric(4) DEFAULT 0 NOT NULL
) ;

CREATE INDEX JOBLOG_TRIGGERTIME_INDEX ON xxl_job_log(trigger_time);
CREATE INDEX JOBLOG_HANDLECODE_INDEX ON xxl_job_log(handle_code);

COMMENT on column xxl_job_log.id is '执行器主键ID';
COMMENT on column xxl_job_log.job_group is '任务组';
COMMENT on column xxl_job_log.job_id is '任务，主键ID';
COMMENT on column xxl_job_log.executor_address is '执行器地址，本次执行的地址';
COMMENT on column xxl_job_log.executor_handler is '执行器任务handler';
COMMENT on column xxl_job_log.executor_param is '执行器任务参数';
COMMENT on column xxl_job_log.executor_sharding_param is '执行器任务分片参数，格式如 1/2';
COMMENT on column xxl_job_log.executor_fail_retry_count is '失败重试次数';
COMMENT on column xxl_job_log.trigger_time is '调度-时间';
COMMENT on column xxl_job_log.trigger_code is '调度-结果';
COMMENT on column xxl_job_log.trigger_msg is '调度-日志';
COMMENT on column xxl_job_log.handle_code is '执行-状态';
COMMENT on column xxl_job_log.handle_msg is '执行-日志';
COMMENT on column xxl_job_log.alarm_status is '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';

create sequence seq_joblogglue;

CREATE TABLE xxl_job_logglue (
  id numeric (11,0)  PRIMARY KEY NOT NULL,
  job_id numeric (11,0) NOT NULL ,
  glue_type varchar2(50) DEFAULT NULL ,
  glue_source clob ,
  glue_remark varchar2(128) NOT NULL ,
  add_time timestamp DEFAULT NULL,
  update_time timestamp DEFAULT NULL
) ;

COMMENT ON column xxl_job_logglue.job_id is '任务，主键ID';
COMMENT ON column xxl_job_logglue.glue_type is 'GLUE类型';
COMMENT ON column xxl_job_logglue.glue_source is 'GLUE源代码';
COMMENT ON column xxl_job_logglue.glue_remark is 'GLUE备注';

create SEQUENCE seq_jobregistry;

CREATE TABLE xxl_job_registry (
  id numeric (11,0)  PRIMARY KEY NOT NULL,
  registry_group varchar2(255) NOT NULL,
  registry_key varchar2(255) NOT NULL,
  registry_value varchar2(255) NOT NULL,
  update_time timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
) ;

CREATE INDEX JOBREGISTRY_GROUP_KEY_VALUE_INDEX ON xxl_job_registry(registry_group,registry_key,registry_value);
CREATE INDEX JOBREGISTRY_UPDATETIME_INDEX ON xxl_job_registry(update_time);


create sequence seq_jobgroup;

CREATE TABLE xxl_job_group (
  id numeric (11,0) PRIMARY KEY NOT NULL,
  app_name varchar2(64) NOT NULL ,
  title varchar2(32) NOT NULL ,
  "ORDER" numeric(4) DEFAULT 0 NOT NULL ,
  address_type numeric(4) DEFAULT 0 NOT NULL ,
  address_list varchar2(512) DEFAULT NULL
) ;
COMMENT ON column xxl_job_group.app_name is '执行器AppName';
COMMENT ON column xxl_job_group.title is '执行器名称';
COMMENT ON column xxl_job_group."ORDER" is '排序';
COMMENT ON column xxl_job_group.address_type is '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON column xxl_job_group.address_list is '执行器地址列表，多地址逗号分隔';

Create SEQUENCE seq_jobuser;
CREATE TABLE xxl_job_user (
  id numeric (11,0) PRIMARY KEY NOT NULL,
  username varchar2(50) NOT NULL ,
  password varchar2(50) NOT NULL ,
  role numeric(4,0) NOT NULL ,
  permission varchar2(255) DEFAULT NULL
) ;

CREATE UNIQUE INDEX  JOBUSER_USERNAME_UINDEX ON xxl_job_user(username);

COMMENT ON COLUMN xxl_job_user.username is '账号';
COMMENT ON COLUMN xxl_job_user.username is '密码';
COMMENT ON COLUMN xxl_job_user.username is '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN xxl_job_user.username is '权限：执行器ID列表，多个逗号分割';


CREATE TABLE xxl_job_lock (
  lock_name varchar2(50) PRIMARY KEY NOT NULL
);
COMMENT ON COLUMN xxl_job_lock.lock_name is '锁名称';

INSERT INTO xxl_job_group(id, app_name, title, "ORDER", address_type, address_list) VALUES (SEQ_JOBGROUP.nextval, 'xxl-job-executor-sample', '示例执行器', 1, 0, NULL);
INSERT INTO xxl_job_user(id, username, password, role, permission) VALUES (SEQ_JOBUSER.nextval, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO xxl_job_lock ( lock_name) VALUES ( 'schedule_lock');

commit;

