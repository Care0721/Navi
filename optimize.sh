#!/bin/bash
# GitHub Pages 优化脚本
# 使用方法: bash optimize.sh

echo "🚀 开始优化 GitHub Pages 部署..."

# 1. 检查文件大小
echo "📊 当前文件大小:"
du -h *.html

# 2. 创建优化目录
mkdir -p dist

# 3. 复制主文件
cp galgame-station-api.html dist/index.html

# 4. 复制配置文件
cp _config.yml dist/
cp _headers dist/
cp .nojekyll dist/

# 5. 创建 CNAME 文件（如果需要自定义域名）
# echo "your-domain.com" > dist/CNAME

echo "✅ 优化完成！"
echo ""
echo "📁 优化后的文件在 dist/ 目录中"
echo "📝 请将 dist/ 目录的内容部署到 GitHub Pages"
echo ""
echo "💡 部署步骤:"
echo "   1. 将 dist/ 目录的内容推送到 gh-pages 分支"
echo "   2. 或在仓库设置中启用 GitHub Pages"
echo "   3. 选择 main/master 分支的根目录"
