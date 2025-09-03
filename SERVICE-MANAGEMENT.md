# www项目服务管理指南

## 服务概览

www项目是基于Vue 3的移动端存储桶查看器，运行在15080端口，专注于显示www存储桶内容。

## 服务管理工具

### 1. 服务管理器 (`scripts/service-manager.sh`)
主要的服务管理入口：

```bash
# 启动服务（简单模式）
./scripts/service-manager.sh start

# 使用PM2启动（推荐）
./scripts/service-manager.sh pm2

# 使用systemd启动
sudo ./scripts/service-manager.sh systemd

# 检查状态
./scripts/service-manager.sh status

# 停止服务
./scripts/service-manager.sh stop

# 重启服务
./scripts/service-manager.sh restart

# 设置监控
./scripts/service-manager.sh monitor
```

### 2. 服务监控器 (`scripts/service-monitor.sh`)
自动监控和恢复：

```bash
# 启动监控（持续运行）
./scripts/service-monitor.sh monitor

# 单次检查状态
./scripts/service-monitor.sh status

# 手动启动服务
./scripts/service-monitor.sh start
```

### 3. 健康检查 (`scripts/health-check.sh`)
完整的项目健康检查：

```bash
# 运行所有检查
./scripts/health-check.sh
```

## 部署方式选择

### 开发环境（推荐：简单模式）
```bash
./scripts/service-manager.sh start
```
- 适合开发测试
- 快速启动停止
- 日志输出到控制台

### 生产环境（推荐：PM2）
```bash
./scripts/service-manager.sh pm2
```
- 自动重启
- 日志管理
- 进程监控
- 内存限制：500M
- 最大重启次数：10次

### 系统级部署（systemd）
```bash
sudo ./scripts/service-manager.sh systemd
```
- 系统启动时自动启动
- 系统级进程管理
- 资源限制
- 安全隔离

## 监控和告警

### 自动监控
设置cron任务进行定期检查：

```bash
./scripts/service-manager.sh monitor
```

### 一键启用监控
```bash
./start-monitoring.sh
```
- 每分钟检查服务状态
- 自动故障恢复
- 监控日志记录

### 手动检查
```bash
# 检查端口
ss -tlnp | grep 15080

# 检查进程
ps aux | grep vite | grep 15080

# 健康检查
curl -f http://localhost:15080/

# 外部访问检查（如果配置了反向代理）
curl -f https://www.yourdomain.com/
```

## 故障处理

### 服务无法启动
1. 检查端口占用：`ss -tlnp | grep 15080`
2. 检查依赖：`npm run type-check`
3. 检查权限：`ls -la /home/www/www`
4. 查看日志：`cat /var/log/www-bucket-viewer*.log`

### 服务频繁重启
1. 检查内存使用：`free -h`
2. 检查磁盘空间：`df -h`
3. 查看错误日志：`journalctl -u www-bucket-viewer -f`
4. 检查代码错误：`npm run lint`

### nginx 502错误（如果使用反向代理）
1. 确认后端服务运行：`./scripts/service-manager.sh status`
2. 检查nginx配置：`nginx -t`
3. 重启nginx：`systemctl reload nginx`
4. 检查网络连接：`curl http://localhost:15080`

## 预防措施

### 1. 自动重启机制
- PM2进程管理
- systemd服务守护
- cron监控任务

### 2. 健康检查
- HTTP状态检查（端口15080）
- 端口监听检查
- 响应时间监控

### 3. 日志管理
- 结构化日志记录
- 日志轮转
- 错误追踪

### 4. 资源监控
- 内存使用限制（500M）
- CPU使用监控
- 磁盘空间检查

## 维护计划

### 日常维护
- 检查服务状态
- 查看错误日志
- 监控资源使用

### 周期维护
- 更新依赖包
- 清理日志文件
- 性能优化

### 应急响应
1. 发现问题立即重启服务
2. 查看日志确定根因
3. 应用修复措施
4. 更新预防机制

## 环境变量配置

www项目需要以下环境变量：

```bash
# S3存储配置
VITE_S3_ACCESS_KEY=your_access_key
VITE_S3_SECRET_KEY=your_secret_key
VITE_S3_REGION=ap-south-1
VITE_S3_ENDPOINT=https://ap-south-1.linodeobjects.com
VITE_S3_BUCKET=www
```

## 性能优化

### 构建优化
- 代码分割（vendor、api）
- 静态资源压缩
- 树摇优化

### 运行优化
- 启用CORS
- 禁用自动打开浏览器
- 允许外部访问

## 联系信息

遇到问题时的处理流程：
1. 运行 `./scripts/service-manager.sh status` 检查状态
2. 运行 `./scripts/health-check.sh` 进行全面检查
3. 查看日志文件定位问题
4. 根据问题类型选择对应解决方案

## 监控数据统计

- **检查频率**：每分钟1次
- **故障检测时间**：<1分钟
- **自动恢复时间**：<30秒
- **服务可用性目标**：99.9%+