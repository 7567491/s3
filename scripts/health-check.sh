#!/bin/bash

# www项目健康检查脚本
set -e

echo "🔍 开始 www 项目健康检查..."

# 检查Node.js版本
echo "📦 检查Node.js版本..."
node --version
npm --version

# 安装依赖
echo "📦 安装依赖..."
npm ci

# TypeScript类型检查
echo "🔍 TypeScript类型检查..."
npm run type-check

# 代码格式检查
echo "🎨 代码格式检查..."
npm run format

# 代码质量检查
echo "✨ 代码质量检查..."
npm run lint

# 构建测试
echo "🏗️ 构建测试..."
npm run build

# 运行单元测试
echo "🧪 运行单元测试..."
npm run test:run

# 运行E2E测试
echo "🎭 运行E2E测试..."
npm run test:e2e

# 安全审计
echo "🔒 安全审计..."
npm audit --audit-level=moderate

# 检查端口占用
echo "🌐 检查端口15080状态..."
if ss -tlnp | grep -q ":15080 "; then
    echo "⚠️  端口15080已被占用"
    ss -tlnp | grep ":15080"
else
    echo "✅ 端口15080空闲"
fi

# 检查服务健康（如果正在运行）
echo "🏥 检查服务健康状态..."
if curl -f -s http://localhost:15080/ >/dev/null 2>&1; then
    echo "✅ 服务运行正常"
else
    echo "⚠️  服务未运行或不健康"
fi

echo "✅ www项目健康检查完成！"