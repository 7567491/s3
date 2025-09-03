# www项目维护文档

## 项目概述

www项目是基于lincon项目创建的专用存储桶查看器，运行在15080端口，专注于显示www存储桶内容。

## 维护清单

### 日常检查
- [ ] 检查服务运行状态：`./scripts/service-manager.sh status`
- [ ] 查看监控日志：`tail -f /tmp/www-service-monitor.log`
- [ ] 检查错误日志：`cat /var/log/www-bucket-viewer*.log`

### 每周检查
- [ ] 运行`npm outdated`检查依赖更新
- [ ] 运行`npm audit`检查安全漏洞
- [ ] 运行健康检查：`./scripts/health-check.sh`
- [ ] 检查磁盘空间使用情况

### 每月检查
- [ ] 运行完整健康检查脚本
- [ ] 审查依赖更新，计划升级
- [ ] 检查工具链版本兼容性
- [ ] 清理日志文件

## 运维机制组件

### 核心脚本
- **服务管理器**: `scripts/service-manager.sh` - 统一服务管理接口
- **服务监控器**: `scripts/service-monitor.sh` - 自动监控和故障恢复
- **健康检查**: `scripts/health-check.sh` - 完整项目健康检查
- **一键监控**: `start-monitoring.sh` - 快速启用监控系统

### 配置文件
- **PM2配置**: `ecosystem.config.js` - 进程管理参数
- **systemd服务**: `www-bucket-viewer.service` - 系统级服务定义

## 自动监控系统

### 监控参数
- **检查频率**: 每分钟1次
- **故障检测**: <1分钟
- **自动恢复**: <30秒
- **服务端口**: 15080

### 启用监控
```bash
# 一键启用
./start-monitoring.sh

# 手动检查
./monitor-service.sh

# 查看监控日志
tail -f /tmp/www-service-monitor.log
```

### 监控内容
- 端口15080监听状态
- HTTP健康检查
- 进程存活状态
- 自动故障恢复

## 依赖升级流程

### 准备工作
1. 备份当前工作状态
2. 运行健康检查确保基线正常
3. 查看依赖CHANGELOG和破坏性变更

### 升级步骤
1. 逐个升级并测试
2. 更新配置文件（如需要）
3. 运行完整测试套件
4. 提交变更并标注升级内容

### 验证检查
- `npm run type-check` - TypeScript类型检查
- `npm run lint` - 代码质量检查
- `npm run build` - 构建测试
- `npm run test:all` - 完整测试套件

## 常见问题解决

### 服务启动失败
**症状**: 服务无法启动或立即退出
**排查步骤**:
1. 检查端口占用：`ss -tlnp | grep 15080`
2. 检查依赖安装：`npm ci`
3. 检查环境变量配置
4. 查看启动日志：`cat /var/log/www-bucket-viewer*.log`

### 频繁重启
**症状**: PM2显示重启次数增加
**排查步骤**:
1. 检查内存使用：`free -h`
2. 检查磁盘空间：`df -h`
3. 查看错误日志定位问题
4. 检查代码语法错误：`npm run lint`

### 监控失效
**症状**: 服务停止后未自动恢复
**排查步骤**:
1. 检查cron任务：`crontab -l`
2. 检查监控脚本权限：`ls -la monitor-service.sh`
3. 手动运行监控脚本测试
4. 检查监控日志：`tail -f /tmp/www-service-monitor.log`

### 构建失败
**症状**: `npm run build` 失败
**解决方案**:
1. 清理并重新安装依赖：`rm -rf node_modules package-lock.json && npm install`
2. 检查TypeScript配置：`npm run type-check`
3. 检查ESLint配置：`npm run lint`
4. 检查环境变量配置

## 性能优化

### 构建优化
- 启用代码分割（vendor、api chunks）
- 压缩静态资源
- 优化依赖包大小

### 运行优化
- 设置内存限制（500M）
- 启用PM2集群模式（如需要）
- 配置nginx反向代理（生产环境）

## 部署最佳实践

### 开发环境
```bash
# 快速启动
./scripts/service-manager.sh start

# 启用监控
./start-monitoring.sh
```

### 生产环境
```bash
# PM2部署
./scripts/service-manager.sh pm2

# 设置自动监控
./scripts/service-manager.sh monitor
```

### 系统级部署
```bash
# systemd服务
sudo ./scripts/service-manager.sh systemd

# 启用开机自启
sudo systemctl enable www-bucket-viewer
```

## 安全考虑

### 环境变量管理
- 使用`.env`文件存储敏感配置
- 不要将API密钥提交到代码库
- 定期轮换访问密钥

### 权限设置
- 服务运行使用非root用户
- 限制文件系统访问权限
- 启用systemd安全特性

## 备份策略

### 代码备份
- 定期提交到Git仓库
- 重要变更创建标签
- 维护开发和生产分支

### 配置备份
- 备份环境变量文件
- 备份服务配置文件
- 记录运维脚本变更

## 更新记录

### 2025-09-02: 初始运维机制建立
- 创建完整的服务管理脚本套件
- 建立自动监控和故障恢复系统
- 配置PM2和systemd部署方案
- 编写运维文档和故障排除指南

## 联系和支持

### 故障处理流程
1. 运行状态检查：`./scripts/service-manager.sh status`
2. 运行健康检查：`./scripts/health-check.sh`
3. 查看相关日志文件
4. 根据问题类型选择解决方案
5. 记录问题和解决过程

### 日志位置
- 服务日志：`/var/log/www-bucket-viewer*.log`
- 监控日志：`/tmp/www-service-monitor.log`
- 系统日志：`journalctl -u www-bucket-viewer`