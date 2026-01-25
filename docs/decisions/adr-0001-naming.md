# ADR-0001: Naming Convention

## Status
Accepted

## Context
We need consistent naming for resources to support readability and automation.

## Decision
- Use `var.name` as the base name/prefix for primary resources
- Append suffixes for sub-resources (e.g., `-logs`, `-policy`)

## Consequences
- Predictable resource names
- Easier cross-module composition

