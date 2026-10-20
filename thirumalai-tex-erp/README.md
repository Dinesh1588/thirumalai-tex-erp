# Thirumalai Tex ERP — Phase 1

Responsive, two-color textile company billing and management dashboard.

## Modules
- Dashboard, sales and purchases, auto-calculated item totals
- Printable PDF invoices with company branding
- Credit/debit ledger, basic employee directory, company settings
- Username/password admin sign-in (username `admin`) backed by Supabase Auth and database RLS
- Light and dark modes; two-color SVG brand mark

## Setup
1. Create a **new** Supabase project in the appropriate organization.
2. Open SQL Editor and execute `supabase/schema.sql` once on the **new project only**.
3. In Supabase Authentication > Users, create an admin user. In SQL Editor, approve the user with:
   `insert into public.admin_users(user_id) values ('AUTH-USER-UUID');`
4. In Supabase Authentication > Users, create/confirm the admin account using an email and a strong password. The login screen username is `admin`; the app uses the configured email internally.
5. In Supabase Project Settings / Connect, copy project URL and **publishable** key (never a secret/service-role key).
6. Set `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`, and `VITE_ADMIN_LOGIN_EMAIL` (the email of that approved admin account) in `.env.local` for local development and in Vercel Project Settings > Environment Variables for Preview and Production.
7. In SQL Editor, approve the admin user's Auth UUID using `insert into public.admin_users(user_id) values ('PASTE-USER-UUID-HERE');` (replace the placeholder with the real UUID from Authentication > Users).
8. Run `npm install` and `npm run dev`.
9. Push changes to GitHub and wait for Vercel to deploy. Redeploy after changing Vercel environment variables.

## Notes / production checklist
- Phase 1 MVP, not certified accounting software. GST-compliant invoices require proper tax details, validation and review by an accountant before production use.
- **Invoice totals are currently calculated in the browser**. Before handling real financial records, move invoice creation into a transactional server/database function that recalculates and validates every line and total; generate sequential invoice numbers server-side.
- Sales/purchase entries and cash ledger entries are independent in this MVP; do not assume cash ledger equals invoice receipts.
- Current invoice number uses timestamp and is not a statutory sequential invoice sequence.
- For real-world invoices, implement immutable issued records, corrections via credit notes, full audit history, backups, tested restoration and access policies per employee role.
- The generated PDF uses basic Latin fonts. Currency amounts use INR text for reliable PDF rendering.
- Do not add service-role keys to frontend environment variables.
- Add real-time stock, payroll, invoice adjustments, and accounting integration in later phases.
