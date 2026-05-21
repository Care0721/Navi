#!/bin/bash
# ============================================
# 全自动部署脚本
# 配置信息：
#   - GitHub: Care0721/Navi
#   - 域名: www.laingal.top
#   - 图标: Navi.png
# ============================================

echo "🚀 开始全自动部署..."
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查Git是否安装
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ 错误: 未安装Git${NC}"
    echo "请先安装Git: https://git-scm.com/downloads"
    exit 1
fi

# 检查是否在Git仓库中
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  初始化Git仓库...${NC}"
    git init
    git remote add origin https://github.com/Care0721/Navi.git
fi

# 检查远程仓库
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$REMOTE_URL" != "https://github.com/Care0721/Navi.git" ]; then
    echo -e "${YELLOW}⚠️  设置远程仓库...${NC}"
    git remote remove origin 2>/dev/null
    git remote add origin https://github.com/Care0721/Navi.git
fi

# 检查Navi.png是否存在
if [ ! -f "Navi.png" ]; then
    echo -e "${RED}⚠️  警告: 未找到 Navi.png 图标文件${NC}"
    echo "请确保图标文件 Navi.png 放在仓库根目录"
fi

# 同步index.html
echo -e "${YELLOW}📄 同步 index.html...${NC}"
cp galgame-station-api.html index.html

# 添加所有文件
echo -e "${YELLOW}📦 添加文件到Git...${NC}"
git add .

# 检查是否有更改
if git diff --cached --quiet; then
    echo -e "${GREEN}✅ 没有需要提交的更改${NC}"
else
    # 提交更改
    echo -e "${YELLOW}💾 提交更改...${NC}"
    git commit -m "🚀 自动部署: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 推送到GitHub
    echo -e "${YELLOW}📤 推送到GitHub...${NC}"
    if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
        echo -e "${GREEN}✅ 推送成功！${NC}"
    else
        echo -e "${RED}❌ 推送失败${NC}"
        echo "请检查:"
        echo "  1. 是否已配置GitHub SSH密钥或输入了正确的用户名密码"
        echo "  2. 仓库 Care0721/Navi 是否存在"
        echo "  3. 网络连接是否正常"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}🎉 部署完成！${NC}"
echo ""
echo "📋 部署信息:"
echo "  • GitHub仓库: https://github.com/Care0721/Navi"
echo "  • GitHub Pages: https://Care0721.github.io/Navi"
echo "  • 自定义域名: https://www.laingal.top"
echo ""
echo "⏱️  等待1-2分钟后访问:"
echo "  • https://www.laingal.top"
echo ""
echo "💡 提示:"
echo "  • 首次部署后需要等待1-2分钟生效"
echo "  • 如果域名无法访问，请检查DNS解析是否指向GitHub Pages"
echo "  • 在GitHub仓库Settings -> Pages查看部署状态"
