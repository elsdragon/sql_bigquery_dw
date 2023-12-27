


CREATE OR REPLACE FUNCTION keepcoding.fnc_clean_integer(n_int INT64) RETURNS INT64 AS
(( SELECT IFNULL(n_int, -999999)))
