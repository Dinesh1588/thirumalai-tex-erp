# Thirumalai Tex ERP — Client handover and recovery
## Data location
Production business data is in Supabase PostgreSQL. GitHub stores application code; Vercel hosts the frontend. Firebase is not needed.
## Backups (not yet automated)
1. In the Supabase project dashboard, check Database > Backups and confirm the plan's available backup schedule/retention.
2. Before every release, take a database backup through a trusted database admin workflow; do not store connection strings or passwords in the repository.
3. Test recovery into a separate non-production Supabase project. Check users, invoices, invoice_items, payments, contacts, employees, audit history and RLS.
4. Record the date, restore duration and responsible person. Never restore over live production data without an approved incident plan.
5. In Data & Security, export CSV datasets for additional human-readable records. CSV is not a full backup.
## Payment workflow
Use Payments to record money received for sales or paid for purchases. The database rejects payments above the remaining invoice balance. Do not also enter the same payment in the general credit/debit ledger or reports will double count.
## Invoice changes
Invoice writes use an atomic database RPC. Editing is restricted to invoices without recorded payments. Cancellation requires a reason and is blocked when payments exist. Cancelled invoices remain in history.
## Password recovery
Use Forgot password on the login screen. Configure Supabase Auth redirect URLs for the production domain and test email delivery. The reset link is sent to the configured admin email. Configure custom SMTP before client handover if Supabase's default email limits are unsuitable.
## Security and access
RLS protects all exposed business tables. Only approved admin accounts are authorized; role-based staff permissions are NOT implemented. Leaked password protection may need enabling in Supabase Auth security settings. Never publish service-role keys.
## Acceptance test checklist
- [ ] Administrator sign-in and password reset on production
- [ ] Create invoice, download PDF, edit unpaid invoice, cancel unpaid invoice
- [ ] Partial payment, final payment, and overpayment rejection
- [ ] Verify paid invoice cannot be cancelled/edited
- [ ] Add customer and supplier, export each CSV
- [ ] Date-based financial report and audit events
- [ ] Mobile bottom navigation, More sheet, forms and tables on real Android and iOS devices
- [ ] Confirm database backup and successful restore rehearsal
- [ ] Review access and approve client acceptance
