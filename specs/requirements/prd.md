# Expense Claims — PRD

## Problem Statement

Employees who pay for business expenses out of pocket today rely on ad hoc
methods — emails, spreadsheets, paper receipts handed to a manager — to get
reimbursed. Managers have no consistent queue to review and approve these
claims, and finance has to manually chase down what was approved before it can
be paid out through payroll. This is slow, error-prone, and leaves no clear
audit trail of what was claimed, approved, or paid.

## Solution

A web application where employees submit expense claims with the supporting
details and a receipt, managers review and approve or reject claims submitted
by their reports, and finance exports the approved claims as a file ready to
feed into payroll processing — replacing the informal, untracked process with
a single system of record.

## Actors

- **Employee** — submits expense claims, tracks their status, and can edit or
correct a claim before it is reviewed.
- **Manager** — reviews the expense claims submitted by the employees who
report to them, and approves or rejects each one.
- **Finance** — views all approved claims across the organization and exports
them for payroll processing.

## User Stories

1. As an Employee, I want to submit an expense claim with an amount, category,
 date, description, and a receipt attachment, so that I can be reimbursed
 for a business expense.
2. As an Employee, I want to view the status of my submitted claims (pending,
 approved, rejected), so that I know where each one stands.
3. As an Employee, I want to edit or withdraw a claim while it is still
 pending, so that I can fix a mistake before my manager reviews it.
4. As an Employee, I want to see why a claim was rejected and resubmit a
 corrected version, so that I can still get reimbursed for a valid expense.
5. As a Manager, I want to see a queue of the pending claims submitted by the
 employees who report to me, so that I know what needs my review.
6. As a Manager, I want to approve a pending claim, so that it becomes ready
 for finance to process through payroll.
7. As a Manager, I want to reject a pending claim with a reason, so that the
 employee understands what needs to change.
8. As Finance, I want to view all approved claims across the organization, so
 that I can see what is ready for payroll.
9. As Finance, I want to export approved claims as a downloadable file (e.g.
 CSV), so that I can import them into the payroll system.
10. As Finance, I want exported claims to be marked as exported, so that I
 never export the same claim twice.

## Product Decisions

- Users sign in via SSO through Thunder, the platform identity provider
(org default).
- The web app is a TypeScript + React single-page app; backend services are
built in Ballerina (org default stack).
- A claim captures: amount, category, date incurred, a free-text description,
and a receipt attachment.
- Each employee has exactly one designated manager, set up per employee, and
every claim they submit routes to that manager for approval.
- Finance's payroll handoff is a downloadable export file (CSV), not a live
integration with a named payroll provider.
- Claims support a single currency across the organization. *assumed*
- Receipt attachments accept common image formats and PDF. *assumed*
- Expense categories come from a fixed, predefined list (e.g. Travel, Meals,
Lodging, Office Supplies, Other) rather than free-form text. *assumed*
- A rejected claim can be edited and resubmitted by the employee, re-entering
the pending queue for the same manager. *assumed*
- No automated notifications (email or otherwise) are sent on status changes
in this version — actors check status by visiting the app. *assumed*

## Out of Scope

- Multi-level or delegated approval chains (a claim always resolves with one
manager's decision).
- Multi-currency claims and currency conversion.
- Direct API integration with a specific payroll provider.
- Mileage or per-diem calculators — claims are entered as flat amounts.
- A native mobile app.

## Open Questions

(none currently — all decisions above were either specified by the user or
assumed with a recommended default; see the *assumed* tags above for anything
still open to being overridden.)

## Further Notes

None.