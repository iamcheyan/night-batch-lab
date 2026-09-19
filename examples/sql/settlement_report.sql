-- Training fixture: reporting query for the night-batch result.

WITH successful_transactions AS (
    SELECT account_id, amount
    FROM settlement_transactions
    WHERE business_date = :business_date
      AND status = 'OK'
)
SELECT
    COUNT(*) AS success_count,
    COALESCE(SUM(amount), 0) AS success_total
FROM successful_transactions;
