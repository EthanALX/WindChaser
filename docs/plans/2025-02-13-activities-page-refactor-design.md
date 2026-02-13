# Activities页面重构设计

**日期:** 2025-02-13
**状态:** 已批准
**作者:** Claude & 用户协作设计

---

## 概述

重构WindChaser iOS应用的Activities页面，参考设计稿实现全新的统计分析界面，删除Record页面，采用NavigationStack架构优化导航体验。

---

## 架构设计

### 整体架构

```
RunningOSApp (根)
  └── NavigationStack
      └── ActivitiesView (根视图)
          ├── ActivityDetailView (活动详情)
          ├── ActivitySearchFilterView (筛选搜索)
          └── ActivityEditView (编辑活动)
```

**关键变更：**
- ❌ 移除TabView结构
- ✅ 采用NavigationStack实现页面导航
- ❌ 删除Record页面及所有相关代码
- ✅ Activities作为应用根视图

---

## 页面布局设计

### 1. ActivitiesView（主页）

#### 顶部Header区域

**组件：** `ActivitiesHeaderView`

```
┌─────────────────────────────────────┐
│  记录              [数据授权] 👁     │ ← 标题 + 按钮
│                                     │
│  最近 ▼  本周  月  年  总           │ ← 时间周期选择器
└─────────────────────────────────────┘
```

**功能：**
- 页面标题："记录"
- 数据授权按钮（预留功能，点击显示授权设置）
- 时间周期选择器：5个选项（最近/本周/月/年/总）
- 使用Picker样式，当前选中项高亮显示

#### 图表区域

**组件：** `WeeklyBarChartView`

```
┌─────────────────────────────────────┐
│         周跑量统计                  │
│  24│                              │
│  20│     ███                      │ ← 绿色柱状图
│  16│     ███                      │
│  12│     ███      ███             │
│   8│     ███      ███             │
│   4│     ███      ███             │
│   0├────────────────────────       │
│      周一 周二 ... 周日            │
└─────────────────────────────────────┘
```

**功能：**
- 使用SwiftUI Charts库实现柱状图
- X轴：周一到周日
- Y轴：数值根据当前筛选维度动态调整
- 柱状图颜色：主色调绿色 `#34C759`
- 支持切换5个维度：距离/时长/配速/配速区间/心率区

#### 统计卡片网格

**组件：** `StatsGridView` (3x2 LazyVGrid)

```
┌──────────┬──────────┬──────────┐
│ 3:18:40  │   36.1   │  5'30"   │
│跑步时长   │总距离(km) │ 平均配速  │
├──────────┼──────────┼──────────┤
│    2     │   62     │  2302    │
│跑步次数   │总爬升(m)  │卡路里     │
├──────────┼──────────┼──────────┤
│   181    │   100    │          │
│平均步频   │平均步长   │          │
└──────────┴──────────┴──────────┘
```

**显示指标：**
- 跑步时长（HH:MM:SS格式）
- 总距离（km）
- 平均配速（mm:ss格式）
- 跑步次数
- 总爬升（m）
- 卡路里（kcal）
- 平均步频（steps/min）
- 平均步长（cm）

**数据计算：**
- 根据选择的时间周期动态计算
- 所有数据从本地Activity记录聚合

#### 筛选标签栏

**组件：** `StatDimensionSelector`

```
┌─────────────────────────────────────┐
│ [距离] [时长] [配速] [配速区间] [心率区] │
└─────────────────────────────────────┘
```

- 当前选中：白色背景 + 黑色文字
- 未选中：浅灰背景 + 灰色文字
- 切换时更新图表和统计数据

#### 最近活动列表

**组件：** `ActivitiesListView`

```
┌─────────────────────────────────────┐
│  最近               🔖 ⭐          │ ← section header
├─────────────────────────────────────┤
│ 📅 今天                           │
│ 🏃 晨间 · 半程马拉松              │
│    21.12 km                       │
├─────────────────────────────────────┤
│ 📅 周二                           │
│ 🏃 晨间 · 节奏跑                  │
│    20.26 km                       │
└─────────────────────────────────────┘
```

**卡片信息：**
- 日期（今天/昨天/周x）
- 活动类型图标（跑步/骑行等）
- 活动时段（晨间/午间/晚间）
- 活动类型名称（节奏跑/长距离跑等）
- 距离（km）

**交互：**
- 点击 → 导航到ActivityDetailView
- 长按 → 显示ActionSheet（编辑/删除/分享）
- 右上角图标：书签和收藏（预留功能）

---

## 数据模型设计

### 时间周期枚举

```swift
enum TimePeriod: String, CaseIterable, Identifiable {
    case recent = "最近"
    case thisWeek = "本周"
    case month = "月"
    case year = "年"
    case allTime = "总"

    var id: String { rawValue }
}
```

### 统计维度枚举

```swift
enum StatDimension: String, CaseIterable, Identifiable {
    case distance = "距离"
    case duration = "时长"
    case pace = "配速"
    case paceZone = "配速区间"
    case heartRateZone = "心率区"

    var id: String { rawValue }
}
```

### 活动数据模型

使用现有的 `AppActivity` 模型，确保包含：
- 基础信息：id, type, date, distance, duration
- 运动数据：pace, heartRate, cadence, elevation
- 元数据：steps, calories, splits

---

## 页面导航流程

### 主要导航路径

```
ActivitiesView
    │
    ├─→ ActivityDetailView
    │     ├─→ 编辑按钮 → ActivityEditView
    │     ├─→ 分享按钮 → ShareSheet
    │     └─→ 地图显示（后续扩展）
    │
    ├─→ 搜索按钮 → ActivitySearchFilterView
    │     ├─→ 搜索：按关键词
    │     ├─→ 筛选：活动类型、日期范围
    │     └─→ 排序：日期、距离、时长
    │
    └─→ 长按活动卡片 → ActionSheet
          ├─→ 编辑 → ActivityEditView
          ├─→ 删除 → 确认对话框
          └─→ 分享 → ShareSheet
```

### NavigationStack配置

**根视图：** `ActivitiesView`
**导航绑定：** `@NavigationPath` 或视图层次结构

---

## UI/UX规范

### 颜色方案

```swift
enum AppColor {
    static let primary = Color(hex: "#34C759")      // 主色调（绿色）
    static let background = Color.white             // 背景色
    static let cardBackground = Color(hex: "#F2F2F7") // 卡片背景
    static let textPrimary = Color.black            // 主要文本
    static let textSecondary = Color(hex: "#8E8E93") // 次要文本
    static let border = Color.gray.opacity(0.2)     // 边框
}
```

### 字体规范

```swift
enum AppTypography {
    static let pageTitle = Font.largeTitle.bold
    static let sectionTitle = Font.title3.bold
    static let statValue = Font.title.bold
    static let statLabel = Font.caption
    static let bodyText = Font.body
    static let caption = Font.caption2
}
```

### 间距规范

```swift
enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
}
```

### 交互反馈

- **页面切换：** 淡入淡出动画（0.3s）
- **数据加载：** Skeleton screen或ProgressView
- **长按反馈：** 触觉震动（UIImpactFeedbackGenerator）
- **按钮点击：** 缩放动画（0.9x → 1.0x）

---

## 组件层次结构

```
ActivitiesView
├── ActivitiesHeaderView
│   ├── Title ("记录")
│   └── DataAuthButton
├── TimePeriodSelector (Picker)
├── WeeklyBarChartView
├── StatDimensionSelector (Tab bar)
├── StatsGridView
│   └── StatCard (x6)
└── ActivitiesListView
    └── ActivityListCard (ForEach)
```

---

## 功能范围

### Phase 1（本次实现）

✅ 核心功能：
- NavigationStack架构搭建
- ActivitiesView主页面实现
- 时间周期选择器
- 柱状图可视化（Charts库）
- 统计卡片网格
- 活动列表展示
- 活动详情页（基础版）

✅ 交互功能：
- 点击活动跳转详情
- 长按显示操作菜单
- 编辑活动信息
- 删除活动（带确认）

❌ 暂不实现：
- 数据授权功能（UI预留）
- 书签/收藏功能
- 高级筛选搜索（可后续添加）
- 地图轨迹显示（需等待地图集成）

---

## 数据存储策略

### 本地数据源

**当前方案：**
- 内存数组存储（sample data）
- 静态mock数据用于开发和测试

**未来扩展：**
- Core Data持久化
- SwiftData（iOS 17+）
- UserDefaults轻量级缓存

### 数据同步

**Phase 1：** 仅本地数据
**Phase 2：** HealthKit集成
**Phase 3：** 外部平台同步（Garmin/Wahoo）

---

## 技术栈

- **UI框架：** SwiftUI
- **导航：** NavigationStack (iOS 16+)
- **图表：** Swift Charts (iOS 16+)
- **数据：** Combine框架
- **最低版本：** iOS 16.0

---

## 删除清单

### 需要删除的文件/代码

1. **RecordView相关：**
   - `RecordView` struct及其所有子视图
   - `RecordStatBox` 组件
   - `ActivityTypePicker` 视图

2. **TabView相关：**
   - `ContentView`中的TabView结构
   - TabItem配置

3. **相关State管理：**
   - `isRecording` 状态
   - Timer相关逻辑
   - 实时数据更新逻辑

---

## 成功标准

- [ ] NavigationStack架构正常工作
- [ ] 时间周期切换正确更新图表和统计数据
- [ ] 统计维度切换正确显示对应数据
- [ ] 活动列表正确展示所有活动
- [ ] 点击活动可跳转到详情页
- [ ] 长按活动显示操作菜单
- [ ] 编辑和删除功能正常工作
- [ ] UI符合设计稿规范
- [ ] 动画流畅自然
- [ ] 无内存泄漏或性能问题

---

## 后续优化方向

1. **性能优化：**
   - 大量活动时的虚拟化加载
   - 图表渲染性能优化

2. **功能扩展：**
   - 高级筛选和搜索
   - 数据导出（CSV/GPX）
   - 活动对比功能

3. **UI增强：**
   - 暗黑模式支持
   - 自定义主题色
   - 动态字体大小支持

---

**下一步：** 使用writing-plans skill创建详细实现计划。
