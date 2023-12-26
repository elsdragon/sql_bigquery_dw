CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH identification AS (
    SELECT DISTINCT detail.calls_ivr_id AS ivr_id
    , detail.document_type AS document_type
    , detail.document_identification AS document_identification
  FROM `keepcoding.ivr_detail` detail 
  WHERE ( detail.document_type<>'UNKNOWN' and detail.document_identification<>'UNKNOWN')
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(ivr_id AS STRING) ORDER BY document_identification DESC, document_type) = 1
  
)

, phone_identification
AS(SELECT DISTINCT detail.calls_ivr_id as ivr_id
        , detail.customer_phone as customer_phone
  
    FROM `keepcoding.ivr_detail` detail 
    WHERE customer_phone <> 'UNKNOWN'
    QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(ivr_id AS STRING) ORDER BY customer_phone DESC) = 1
    )

, bill_acc_identification 
AS(SELECT DISTINCT detail.calls_ivr_id as ivr_id
    , detail.billing_account_id as billing_account_id
  
  FROM `keepcoding.ivr_detail` detail 
  WHERE billing_account_id <> 'UNKNOWN'
  QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(ivr_id AS STRING) ORDER BY billing_account_id DESC) = 1
  )
, next_prev_call
AS (SELECT ivr_id
     , phone_number
     , start_date
     , LAG(start_date) OVER (PARTITION BY phone_number ORDER BY ivr_id) AS prev_call
     , LEAD(start_date) OVER (PARTITION BY phone_number ORDER BY ivr_id) AS next_call
     , TIMESTAMP_DIFF(start_date, LAG(start_date) OVER (PARTITION BY phone_number ORDER BY ivr_id), HOUR) AS diff_prev_call
     , TIMESTAMP_DIFF(LEAD(start_date) OVER (PARTITION BY phone_number ORDER BY ivr_id), start_date, HOUR) AS diff_next_call
  FROM `keepcoding.ivr_calls`
  WHERE phone_number <> 'UNKNOWN'

      )

SELECT DISTINCT detail.calls_ivr_id AS ivr_id
     , detail.calls_phone_number AS phone_number
     , detail.calls_ivr_result AS ivr_result
     , CASE WHEN detail.calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
            WHEN detail.calls_vdn_label LIKE 'TECH%' THEN 'TECH'
            WHEN detail.calls_vdn_label LIKE 'ABSORPTION' THEN 'ABSORPTION'
            ELSE 'RESTO'
        END AS vdn_aggregation     
     , detail.calls_start_date AS start_date
     , detail.calls_end_date AS end_date
     , detail.calls_total_duration AS total_duration
     , detail.calls_customer_segment AS customer_segment
     , detail.calls_ivr_language AS ivr_language
     , detail.calls_steps_module AS steps_module
     , detail.calls_module_aggregation AS module_aggregation
     , IFNULL(identification.document_type, 'UNKNOWN') AS document_type
     , IFNULL(identification.document_identification, 'UNKNOWN') AS document_identification
     , IFNULL(phone_identification.customer_phone, 'UNKNOWN') AS customer_phone
     , IFNULL(bill_acc_identification.billing_account_id,'UNKNOWN' ) AS billing_account_id
     , MAX(IF(detail.module_name = 'AVERIA_MASIVA', 1, 0)) AS masiva_lg
     , MAX(IF(detail.step_name = 'CUSTOMERINFOBYPHONE.TX' AND detail.step_description_error = 'UNKNOWN', 1,0))   AS info_by_phone_lg
     , MAX(IF(detail.step_name = 'CUSTOMERINFOBYDNI.TX' AND detail.step_description_error = 'UNKNOWN', 1,0))   AS info_by_dni_lg
     , IF(next_prev_call.diff_prev_call <= 24, 1, 0) AS repeated_phone_24H
     , IF(next_prev_call.diff_next_call <= 24, 1, 0) AS cause_recall_phone
     
    
     
FROM `keepcoding.ivr_detail` detail
LEFT JOIN identification
 ON identification.ivr_id = detail.calls_ivr_id

LEFT JOIN phone_identification
 ON phone_identification.ivr_id = detail.calls_ivr_id

LEFT JOIN bill_acc_identification
 ON bill_acc_identification.ivr_id = detail.calls_ivr_id

LEFT JOIN next_prev_call
 ON next_prev_call.ivr_id = detail.calls_ivr_id

GROUP BY ivr_id
     , phone_number
     , ivr_result
     , vdn_aggregation     
     , start_date
     , end_date
     , total_duration
     , customer_segment
     , ivr_language
     , steps_module
     , module_aggregation
     , document_type
     , document_identification
     , customer_phone
     , billing_account_id
     ,repeated_phone_24H
     , cause_recall_phone

ORDER BY phone_number
    , ivr_id
