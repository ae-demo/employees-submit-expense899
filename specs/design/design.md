# Expense Claims — Design

Employees submit expense claims with a receipt through the Expense Claims
Portal; the Expense Claims API stores claims, routes each one to the
employee's designated manager for approval, and lets finance export approved
claims as a payroll-ready CSV. Receipts are stored in object storage, and
sign-in for all three roles is handled by the platform identity provider.

## Context (C1)

```mermaid
graph TD
  Employee((Employee))
  Manager((Manager))
  Finance((Finance))
  System[Expense Claims System]
  Storage[(Receipt Storage - S3)]
  Auth[Thunder Auth]

  Employee -->|submits / tracks claims| System
  Manager -->|approves / rejects claims| System
  Finance -->|exports approved claims| System
  System -->|stores receipt files| Storage
  System -->|sign-in| Auth
```

## Domain model (ER)

```mermaid
erDiagram
  EMPLOYEE {
    string id
    string name
    string email
    string managerId
  }
  EXPENSE_CLAIM {
    string id
    string employeeId
    number amount
    string category
    string dateIncurred
    string description
    string receiptUrl
    string status
    string rejectionReason
    string exportedAt
    string createdAt
    string updatedAt
  }

  EMPLOYEE ||--o{ EXPENSE_CLAIM : submits
  EMPLOYEE ||--o{ EMPLOYEE : manages
```

`status` is one of `pending`, `approved`, `rejected`. `category` is one of
Travel, Meals, Lodging, Office Supplies, Other. `exportedAt` is set once
finance includes the claim in a CSV export.

## Key flows

### Submit and approve a claim

```mermaid
sequenceDiagram
  participant E as Employee
  participant W as Expense Webapp
  participant A as Expense API
  participant S as Receipt Storage
  participant M as Manager

  E->>W: Fill claim form + attach receipt
  W->>A: Request presigned upload URL
  A->>S: Presign PutObject
  S-->>A: Presigned URL
  A-->>W: Presigned URL
  W->>S: Upload receipt directly
  W->>A: POST /expense-claims
  A-->>W: Claim created (status: pending)
  M->>W: Open approval queue
  W->>A: GET /expense-claims?status=pending&managerId=me
  A-->>W: Pending claims for my reports
  M->>W: Approve or reject (with reason)
  W->>A: POST /expense-claims/{id}/approve or /reject
  A-->>W: Updated claim
```

### Resubmit a rejected claim

```mermaid
sequenceDiagram
  participant E as Employee
  participant W as Expense Webapp
  participant A as Expense API

  E->>W: View rejected claim + reason
  E->>W: Edit claim details
  W->>A: PUT /expense-claims/{id}
  A-->>W: Claim updated, status reset to pending
```

### Export approved claims to payroll

```mermaid
sequenceDiagram
  participant F as Finance
  participant W as Expense Webapp
  participant A as Expense API

  F->>W: Open approved claims list
  W->>A: GET /expense-claims?status=approved&exported=false
  A-->>W: Unexported approved claims
  F->>W: Click Export CSV
  W->>A: POST /expense-claims/export
  A-->>W: CSV file + marks claims exported
```

