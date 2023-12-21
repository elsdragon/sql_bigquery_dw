CREATE OR REPLACE TABLE keepcoding.ivr_detail AS

SELECT  calls.ivr_id AS calls_ivr_id
      , calls.phone_number AS calls_phone_number
      , calls.ivr_result AS calls_ivr_result
      , calls.vdn_label AS calls_vdn_label
      , calls.start_date AS calls_start_date
      , CAST(FORMAT_DATE('%Y%m%d', calls.start_date) AS int64)AS calls_start_date_id
      , calls.end_date AS calls_end_date
      , CAST(FORMAT_DATE('%Y%m%d', calls.end_date) AS int64) AS calls_end_date_id
      , calls.total_duration AS calls_total_duration
      , calls.customer_segment AS calls_customer_segment
      , calls.ivr_language AS calls_ivr_language
      , calls.steps_module AS calls_steps_module
      , calls.module_aggregation AS calls_module_aggregation
      , IFNULL(module.module_sequece, -999999) AS module_sequece
      , IFNULL(module.module_name, 'UNKNOWN') AS module_name
      , IFNULL(module.module_duration, -999999) AS module_duration
      , IFNULL(module.module_result, 'UNKNOWN') AS module_result
      , IFNULL(step.step_sequence, -999999) AS step_sequence
      , IFNULL(step.step_name,'UNKNOWN') AS step_name
      , IFNULL(step.step_result,'UNKNOWN') AS step_result
      , IFNULL(step.step_description_error, 'UNKNOWN') AS step_description_error
      , IFNULL(step.document_type, 'UNKNOWN') AS document_type
      , IFNULL(step.document_identification, 'UNKNOWN') AS document_identification
      , IFNULL(step.customer_phone, 'UNKNOWN') AS customer_phone
      , IFNULL(step.billing_account_id, 'UNKNOWN') AS billing_account_id
FROM `keepcoding.ivr_calls` calls
LEFT JOIN `keepcoding.ivr_modules` module
  ON module.ivr_id = calls.ivr_id
LEFT JOIN `keepcoding.ivr_steps` step
  ON step.ivr_id = calls.ivr_id
;
