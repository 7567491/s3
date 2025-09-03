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
