#!/bin/bash

# www项目一键启动监控系统
PROJECT_DIR="/home/www/www"

echo "🚀 启动 www 项目监控系统..."

# 创建监控脚本的简化版本
cat > "$PROJECT_DIR/monitor-service.sh" << 'EOF'
#!/bin/bash

SERVICE_PORT=15080
PROJECT_DIR="/home/www/www"

check_service() {
    if ss -tlnp | grep -q ":$SERVICE_PORT "; then
        return 0
    else
        return 1
    fi
}

start_service() {
    echo "[$(date)] 检测到www项目服务停止，正在重启..."
    cd "$PROJECT_DIR"
    
    # 杀掉可能存在的进程
    pkill -f "vite.*15080" 2>/dev/null || true
    sleep 2
    
    # 后台启动服务
    nohup npm run dev > /tmp/www-bucket-viewer-auto.log 2>&1 &
    
    echo "[$(date)] www项目服务重启完成"
}

# 检查服务状态
if ! check_service; then
    echo "[$(date)] www项目服务未运行，启动服务..."
    start_service
else
    echo "[$(date)] www项目服务运行正常"
fi
EOF

chmod +x "$PROJECT_DIR/monitor-service.sh"

# 添加到crontab
echo "* * * * * $PROJECT_DIR/monitor-service.sh >> /tmp/www-service-monitor.log 2>&1" | crontab -

echo "✅ www项目监控系统已启用！"
echo "📍 监控脚本: $PROJECT_DIR/monitor-service.sh"
echo "📝 日志文件: /tmp/www-service-monitor.log"
echo "⏱️  检查频率: 每分钟一次"
echo ""
echo "🎯 使用方法："
echo "  查看监控日志: tail -f /tmp/www-service-monitor.log"
echo "  手动检查状态: $PROJECT_DIR/monitor-service.sh"
echo "  停用监控: crontab -r"