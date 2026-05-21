# Galgame Station - GitHub Pages 部署指南

## 📁 优化后的文件结构

```
/
├── index.html                 # 主入口文件（由 galgame-station-api.html 复制）
├── galgame-station-api.html   # 原始文件
├── _config.yml               # Jekyll 配置
├── _headers                  # HTTP 响应头配置
├── .nojekyll                 # 禁用 Jekyll 处理
└── optimize.sh               # 优化脚本
```

## 🚀 部署到 GitHub Pages 的三种方式

### 方式一：直接部署（最简单）

1. 将所有文件推送到 GitHub 仓库
2. 进入仓库 **Settings** → **Pages**
3. **Source** 选择 **Deploy from a branch**
4. 选择 **main** 或 **master** 分支，文件夹选择 **/(root)**
5. 点击 **Save**，等待几分钟即可访问

### 方式二：使用 gh-pages 分支

```bash
# 创建并切换到 gh-pages 分支
git checkout --orphan gh-pages

# 只保留需要的文件
git rm -rf .
cp galgame-station-api.html index.html
cp _config.yml .
cp _headers .
touch .nojekyll

# 提交并推送
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
```

### 方式三：使用 GitHub Actions 自动部署

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
      
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

## ⚡ 性能优化说明

### 已应用的优化

1. **`.nojekyll`** - 禁用 Jekyll 处理，加快部署速度
2. **`_config.yml`** - 配置 Jekyll 排除不需要的文件
3. **`_headers`** - 设置 HTTP 缓存头，优化加载性能
4. **`index.html`** - 标准入口文件名

### 缓存策略

- HTML 文件：`max-age=0`（总是获取最新版本）
- CSS/JS/图片：`max-age=31536000`（1年长期缓存）

### 安全头

- `X-Frame-Options: DENY` - 防止点击劫持
- `X-Content-Type-Options: nosniff` - 防止 MIME 类型嗅探
- `Referrer-Policy` - 控制 referrer 信息

## 📊 文件大小分析

- 主文件：`galgame-station-api.html` (764KB)
- 总行数：17,493 行
- 建议：如果可能，将 CSS 和 JS 分离到单独文件以利用缓存

## 🔧 进一步优化建议

### 1. 分离 CSS 和 JS（推荐）

将内联的 `<style>` 和 `<script>` 分离到单独文件：

```
/
├── index.html
├── css/
│   └── style.css      # 提取所有 CSS
├── js/
│   └── app.js         # 提取所有 JS
└── ...
```

这样可以利用浏览器缓存，更新时只需修改变化的文件。

### 2. 使用 CDN 加速

将静态资源（Font Awesome、图片等）使用 CDN：

```html
<!-- 当前 -->
<link rel="stylesheet" href="./css/font-awesome.css">

<!-- 优化后 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
```

### 3. 启用 Gzip 压缩

GitHub Pages 自动启用 Gzip，无需额外配置。

### 4. 图片优化

- 使用 WebP 格式替代 PNG/JPG
- 懒加载图片
- 使用适当的图片尺寸

## 🌐 自定义域名（可选）

1. 在仓库根目录创建 `CNAME` 文件
2. 文件内容填写你的域名：
   ```
   galgame.yourdomain.com
   ```
3. 在域名 DNS 设置中添加 CNAME 记录指向 `yourusername.github.io`

## 📝 注意事项

1. GitHub Pages 有 **1GB** 存储限制
2. 每月 **100GB** 带宽限制
3. 部署后可能需要 **5-10 分钟** 生效
4. 如果更改未生效，尝试清除浏览器缓存或使用无痕模式

## 🔗 相关链接

- [GitHub Pages 文档](https://docs.github.com/en/pages)
- [Jekyll 配置选项](https://jekyllrb.com/docs/configuration/)
- [HTTP Headers 最佳实践](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers)

---

**当前版本**: v2.0  
**最后更新**: 2026-05-21
