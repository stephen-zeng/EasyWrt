<!--
SYNC IMPACT REPORT
Version: 1.0.0 -> 1.1.0
Change: Translated to Chinese and enforced Chinese language for all interactions.
Principles:
  + I. 代码质量与可维护性 (Renamed from Code Quality & Maintainability)
  + II. 测试优先 (Renamed from Testing First)
  + III. 用户体验 (UX) (Renamed from User Experience)
  + IV. 性能 (Renamed from Performance)
  + V. 标准化互操作性 (Renamed from Standardized Interoperability)
  + VI. 文档与注释 (Renamed from Documentation & Comments)
  + VII. 语言规范 (New: Enforces Chinese language)
Templates:
  - .specify/templates/plan-template.md: ⚠ Pending Translation (Content generation must now be Chinese)
  - .specify/templates/spec-template.md: ⚠ Pending Translation
  - .specify/templates/tasks-template.md: ⚠ Pending Translation
-->

# EasyWRT 宪章 (EasyWRT Constitution)

## 核心原则 (Core Principles)

### I. 代码质量与可维护性
代码必须整洁、符合惯用语且可持续。必须严格遵守特定语言的标准风格指南（例如 Effective Dart）。应尽量减少复杂性；鼓励重构以防止技术债务。仅“能运行”是不够的；必须做到“易于阅读和维护”。

### II. 测试优先
测试是不可协商的。所有关键业务逻辑必须包含单元测试。在可行的情况下，UI 组件应该包含 Widget 测试。只有在通过了验证其主要成功标准的测试后，功能才被视为完成。

### III. 用户体验 (UX)
用户至上。技术上的便利永远不能成为糟糕用户体验的借口。界面必须直观、响应迅速且易于访问。性能卡顿或令人困惑的工作流程被视为 Bug。

### IV. 性能
效率是核心要求，而非事后补救。操作不得阻塞主线程（UI）。必须优化状态管理和构建周期，以确保 60fps（或标准刷新率）的流畅度。必须尽可能减少资源使用（内存、电池）。

### V. 标准化互操作性
模块必须使用标准化的格式和契约进行数据交换，以确保可扩展性。禁止不同模块之间的紧密耦合；通信应通过定义的接口或数据传输对象（DTOs）进行。

### VI. 文档与注释
文档是代码的一部分。
1. **模块头注释**：每个模块/类必须有一个头注释，描述其用途、输入参数和输出数据/副作用。
2. **关键逻辑**：关键或复杂的算法必须添加注释，解释*为什么*（Why）和*怎么做*（How）。
3. **自文档化**：变量和函数名称应具有足够的描述性，行内注释仅保留用于解释复杂的逻辑。

### VII. 语言规范
所有项目文档、代码注释、规范说明以及与智能代理（Agent）的交互输入输出，均必须优先使用**中文**。旨在消除语言障碍，确保所有成员对项目有统一且准确的理解。

## 开发标准 (Development Standards)

### 文档要求
为执行原则 VI，所有公共 API 和主要内部模块必须遵循以下强制模式（注释内容需使用中文）：

```dart
/// 服务/组件名称
/// 
/// 功能: [简要描述该组件的功能]
/// 输入: 
///   - [参数名]: [描述]
/// 输出: 
///   - [返回值]: [描述]
class MyComponent { ... }
```

### 数据交换
为执行原则 V，模块间通信应避免使用原始 Map 或非结构化数据。使用类型化类、结构体或冻结数据类（例如 Dart 中的 Freezed，Python 中的 Pydantic）来严格定义 Schema。

## 合规与审查 (Compliance & Review)

所有贡献均受本宪章约束。
1. **自动化检查**：CI/CD 流程必须强制执行 Lint 检查和测试通过。
2. **同行评审**：审查者在批准前必须检查文档与注释（原则 VI）和用户体验影响（原则 III）。
3. **性能分析**：如果怀疑性能下降，应对关键路径进行性能分析。

## 治理 (Governance)

本宪章取代所有其他冲突的项目实践。
- **修订**：对这些原则的更改需要提交 PR 并说明理由，且必须获得项目维护者的批准。
- **版本控制**：遵循语义化版本控制。Major（主版本）用于破坏性的治理变更；Minor（次版本）用于新增原则；Patch（补丁版本）用于澄清说明。
- **运行时指导**：日常工作流程使用 `.specify/templates`，但与本宪章原则的一致性是最终权威。

**Version**: 1.1.0 | **Ratified**: 2025-12-10 | **Last Amended**: 2025-12-10
