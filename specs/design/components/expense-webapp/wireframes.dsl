screen MyClaims "Employee's list of their own expense claims"
  navbar "Expense Claims | My Claims -> MyClaims | Submit Claim -> SubmitClaim"
  row
    heading "My Claims"
    right
    button "Submit Claim" primary -> SubmitClaim
  table "Date | Category | Amount | Status | Receipt" -> ClaimDetail
    row "2026-08-01 | Travel | 240.00 | Pending | receipt.pdf"
    row "2026-07-20 | Meals | 35.50 | Approved | receipt.jpg"
    row "2026-07-10 | Lodging | 410.00 | Rejected | receipt.pdf"

screen SubmitClaim "Employee fills out a new expense claim"
  navbar "Expense Claims | My Claims -> MyClaims | Submit Claim -> SubmitClaim"
  heading "Submit Expense Claim"
  input "Amount"
  select "Category (Travel / Meals / Lodging / Office Supplies / Other)"
  input "Date Incurred"
  textarea "Description"
  image "Receipt attachment"
  row
    right
    button "Cancel" -> MyClaims
    button "Submit" primary -> MyClaims

screen ClaimDetail "Details of one claim, including rejection reason and edit/withdraw"
  navbar "Expense Claims | My Claims -> MyClaims | Submit Claim -> SubmitClaim"
  heading "Claim Detail"
  badge "Rejected" danger
  text "Amount: 410.00 | Category: Lodging | Date: 2026-07-10"
  text "Description: Hotel for client visit"
  image "Receipt attachment"
  card "Rejection Reason"
    text "Missing itemized hotel folio"
  row
    right
    button "Withdraw" danger -> MyClaims
    button "Edit & Resubmit" primary -> SubmitClaim

screen ApprovalQueue "Manager's queue of pending claims from direct reports"
  navbar "Expense Claims | Approval Queue -> ApprovalQueue"
  heading "Approval Queue"
  table "Employee | Date | Category | Amount | Status" -> ClaimReview
    row "J. Smith | 2026-08-01 | Travel | 240.00 | Pending"
    row "A. Lee | 2026-08-02 | Meals | 62.00 | Pending"

screen ClaimReview "Manager reviews one pending claim and decides"
  navbar "Expense Claims | Approval Queue -> ApprovalQueue"
  heading "Review Claim"
  text "Employee: J. Smith | Amount: 240.00 | Category: Travel | Date: 2026-08-01"
  text "Description: Client site visit travel"
  image "Receipt attachment"
  textarea "Rejection reason (required if rejecting)"
  row
    right
    button "Reject" danger -> ApprovalQueue
    button "Approve" primary -> ApprovalQueue

screen ApprovedClaims "Finance's list of approved claims ready for payroll export"
  navbar "Expense Claims | Approved Claims -> ApprovedClaims"
  row
    heading "Approved Claims"
    right
    button "Export CSV" primary -> ExportResult
  table "Employee | Date | Category | Amount | Exported"
    row "J. Smith | 2026-07-20 | Meals | 35.50 | No"
    row "A. Lee | 2026-07-15 | Travel | 180.00 | No"
    row "M. Chen | 2026-07-01 | Lodging | 300.00 | Yes"

screen ExportResult "Confirmation after exporting approved claims to CSV"
  navbar "Expense Claims | Approved Claims -> ApprovedClaims"
  heading "Export Complete"
  badge "Success" success
  text "12 claims exported to payroll_export_2026-08-03.csv"
  row
    right
    button "Back to Approved Claims" primary -> ApprovedClaims

flow "Submit and track claims"
  role "Employee"
  description "An employee submits a claim, tracks its status, and resubmits a rejected one"
  MyClaims
  SubmitClaim
  ClaimDetail

flow "Approval queue"
  role "Manager"
  description "A manager reviews pending claims from their reports and approves or rejects them"
  ApprovalQueue
  ClaimReview

flow "Export to payroll"
  role "Finance"
  description "Finance reviews approved claims and exports them as a payroll-ready CSV"
  ApprovedClaims
  ExportResult
