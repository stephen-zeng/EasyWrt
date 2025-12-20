<!--
SYNC IMPACT REPORT
Version: 1.0.0
Principles:
  + I. Code Quality & Maintainability (Renamed from 代码质量与可维护性)
  + II. Testing First (Renamed from 测试优先)
  + III. User Experience (UX) (Renamed from 用户体验)
  + IV. Performance (Renamed from 性能)
  + V. Standardized Interoperability (Renamed from 标准化互操作性)
  + VI. Documentation & Comments (Renamed from 文档与注释)
-->

# EasyWRT Constitution

## Core Principles

### I. Code Quality & Maintainability
Code must be clean, idiomatic, and sustainable. Standard style guides for the specific language (e.g., Effective Dart) must be strictly followed. Complexity should be minimized; refactoring is encouraged to prevent technical debt. "It works" is not enough; it must be "easy to read and maintain."

### II. Testing First
Testing is non-negotiable. All critical business logic must include unit tests. Where feasible, UI components should include Widget tests. A feature is considered complete only after passing tests that verify its primary success criteria.

### III. User Experience (UX)
User first. Technical convenience is never an excuse for poor user experience. Interfaces must be intuitive, responsive, and accessible. Performance stutters or confusing workflows are considered bugs.

### IV. Performance
Efficiency is a core requirement, not an afterthought. Operations must not block the main thread (UI). State management and build cycles must be optimized to ensure 60fps (or standard refresh rate) smoothness. Resource usage (memory, battery) must be minimized as much as possible.

### V. Standardized Interoperability
Modules must use standardized formats and contracts for data exchange to ensure scalability. Tight coupling between different modules is prohibited; communication should occur via defined interfaces or Data Transfer Objects (DTOs).

### VI. Documentation & Comments
Documentation is part of the code.
1. **Module Header Comments**: Each module/class must have a header comment describing its purpose, input parameters, and output data/side effects.
2. **Critical Logic**: Critical or complex algorithms must be commented to explain *Why* and *How*.
3. **Self-Documenting**: Variable and function names should be descriptive enough; inline comments should be reserved for explaining complex logic.

## Development Standards

### Documentation Requirements
To enforce Principle VI, all public APIs and major internal modules must follow this mandatory pattern:

```dart
/// Service/Component Name
/// 
/// Function: [Brief description of the component's function]
/// Inputs: 
///   - [Parameter Name]: [Description]
/// Outputs: 
///   - [Return Value]: [Description]
class MyComponent { ... }
```

### Data Exchange
To enforce Principle V, inter-module communication should avoid using raw Maps or unstructured data. Use typed classes, structs, or frozen data classes (e.g., Freezed in Dart, Pydantic in Python) to strictly define Schemas.

## Compliance & Review

All contributions are bound by this constitution.
1. **Automated Checks**: CI/CD pipelines must enforce Lint checks and test passing.
2. **Peer Review**: Reviewers must check documentation & comments (Principle VI) and UX impact (Principle III) before approval.
3. **Profiling**: If performance degradation is suspected, critical paths should be profiled.

## Governance

This constitution supersedes all other conflicting project practices.
- **Amendments**: Changes to these principles require a PR with justification and must be approved by project maintainers.
- **Versioning**: Follows Semantic Versioning. Major for breaking governance changes; Minor for new principles; Patch for clarifications.
- **Runtime Guidance**: Daily workflows use `.specify/templates`, but consistency with this constitution's principles is the final authority.

**Version**: 1.0.0 | **Ratified**: 2025-12-10 | **Last Amended**: 2025-12-10
