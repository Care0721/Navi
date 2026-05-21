# DNS配置指南 - www.laingal.top

## 配置步骤

### 1. 登录你的域名服务商

登录你购买 `laingal.top` 域名的网站（如阿里云、腾讯云、Namecheap等）

### 2. 添加DNS解析记录

进入域名管理 → DNS解析/域名解析，添加以下记录：

| 记录类型 | 主机记录 | 记录值 | TTL |
|---------|---------|--------|-----|
| CNAME | www | Care0721.github.io | 默认 |
| A | @ | 185.199.108.153 | 默认 |
| A | @ | 185.199.109.153 | 默认 |
| A | @ | 185.199.110.153 | 默认 |
| A | @ | 185.199.111.153 | 默认 |

### 3. 说明

- **CNAME记录**：将 `www.laingal.top` 指向 GitHub Pages
- **A记录**：将根域名 `laingal.top` 指向 GitHub Pages 的IP（可选，如果需要不带www访问）

### 4. 等待生效

DNS解析通常需要 **10分钟到24小时** 生效，一般10-30分钟即可。

### 5. 验证配置

```bash
# 在命令行中运行
nslookup www.laingal.top

# 应该显示类似：
# 名称:    Care0721.github.io
# Addresses:  185.199.108.153
```

### 6. 启用HTTPS

1. 打开 https://github.com/Care0721/Navi/settings/pages
2. 找到 "Custom domain" 部分
3. 输入 `www.laingal.top`
4. 勾选 "Enforce HTTPS"
5. 等待几分钟，GitHub会自动申请SSL证书

## 常见问题

### Q: 域名访问显示404？
A: 检查CNAME文件是否存在且内容为 `www.laingal.top`

### Q: HTTPS证书申请失败？
A: 等待24小时，确保DNS解析已完全生效后再试

### Q: 访问显示"域名未配置"？
A: 在GitHub仓库Settings -> Pages中重新输入域名并保存

## 配置完成后的访问地址

- ✅ https://www.laingal.top （推荐）
- ✅ https://Care0721.github.io/Navi （GitHub Pages地址）
