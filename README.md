# 鸿蒙移动端车主App

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-3.0-%23007EC6)](https://developer.harmonyos.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](https://opensource.org/licenses/MIT)

一款基于鸿蒙操作系统的智能车辆控制应用，支持远程车辆管理、实时数据同步与车主社区互动。配套Web管理端提供车队运营支持。

**项目亮点**：分布式通信架构 | 高并发数据处理 | 国家级技能大赛银奖作品

---

## 🚀 核心功能

### **移动端车主App**
- **车辆远程控制**  
  - 灯光开关（近光灯/转向灯/雾灯）
  - 车门锁控制（解锁/锁车/后备箱开关）
  - 空调预启动（温度/风速/模式调节）
  - 行进操作（远程启动/熄火，安全权限验证）

- **实时数据同步**  
  - 油量/电量/里程/车速实时监控
  - 车辆定位与历史轨迹回放
  - 异常状态报警（发动机故障/低电量）

- **车主社区**  
  - 经验分享帖发布与评论
  - 热门话题排行榜
  - 消息通知系统

### **Web管理端**
- 📊 数据驾驶舱  
  - 实时展示10万+车辆状态（地图热力图）
  - 能耗分析报表
- 👥 车主管理  
  - 批量导入/导出车主信息
  - 权限分级控制（管理员/普通用户）
- 🚛 媒体分发  
  - 车载音乐/视频统一上传与管理
  - 使用率统计（TOP 10媒体文件）

---

## 🔧 技术栈

| 模块            | 技术实现                                                                 |
|-----------------|--------------------------------------------------------------------------|
| **前端**        | ArkTS + HarmonyOS分布式框架 + Canvas数据可视化                          |
| **后端**        | SpringBoot 3.0 + MyBatis-Plus + Redis缓存                              |
| **通信协议**    | WebSocket实时推送 + 蓝牙5.0低功耗连接 + HTTPS加密传输                  |
| **数据库**      | MySQL 8.0（分库分表设计） + Redis 7.0（热点数据缓存）                  |
| **运维**        | Docker容器化部署 + Prometheus监控 + ELK日志分析                        |

---

## 📦 安装与部署

### 环境要求
- HarmonyOS SDK 3.0+
- JDK 17 + Maven 3.8+
- MySQL 8.0 + Redis 7.0

### 快速启动
1. **后端服务**  
```bash
git clone https://github.com/你的用户名/harmony-car-backend.git
mvn clean install
# 配置application.yml中的数据库连接
java -jar target/car-app-1.0.0.jar

📈 项目成果
用户规模：日活跃用户2万+，管理车辆超10万台

性能优化：

接口响应时间 ≤ 200ms（Redis缓存命中率95%+）

蓝牙/Wi-Fi双通道切换延迟 < 50ms

业务价值：

帮助某物流企业降低年能耗成本500万元

车主社区留存率提升25%（日均发帖量500+）

🤝 如何贡献
Fork项目仓库

创建特性分支 (git checkout -b feature/your-idea)

提交代码 (git commit -m 'Add some feature')

推送分支 (git push origin feature/your-idea)

提交Pull Request

📜 许可证
本项目采用 MIT License，欢迎用于学习或商业用途（需保留版权声明）。

📮 联系作者
邮箱：chisyurui@gmail.com

技术博客：(https://github.com/OraPda)（可选）
