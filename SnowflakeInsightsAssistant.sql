/***
1. create  database to host the agnts related objects
****/

-- create a database and schema
create database if not exists SNOWFLAKE_INSIGHTS;
create schema if not exists SNOWFLAKE_INSIGHTS.AGENTS;
-- create dedicated WH to run the Agent
create or replace warehouse SNOWFLAKE_INSIGHTS_WH
with
	warehouse_type='STANDARD'
	warehouse_size='X-Small'
	auto_suspend=60
	initially_suspended=TRUE
;

use schema SNOWFLAKE_INSIGHTS.AGENTS;

/***
2. Create a Semantic View for ACCONUNT_USAGE views
****/
create
or replace semantic view SNOWFLAKE_INSIGHTS.AGENTS.SNOWFLAKE_USAGE_ASSISTANT_SV tables (
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY,
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY,
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY,
    SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
) facts (
    QUERY_ATTRIBUTION_HISTORY.CREDITS_ATTRIBUTED_COMPUTE as CREDITS_ATTRIBUTED_COMPUTE comment = 'The amount of credits attributed to a compute resource, representing the portion of total credits consumed by that resource.',
    QUERY_ATTRIBUTION_HISTORY.CREDITS_USED_QUERY_ACCELERATION as CREDITS_USED_QUERY_ACCELERATION comment = 'The total amount of credits used for query acceleration.',
    QUERY_ATTRIBUTION_HISTORY.WAREHOUSE_ID as WAREHOUSE_ID comment = 'Unique identifier for the warehouse associated with the attribution history record.',
    QUERY_HISTORY.BYTES_DELETED as BYTES_DELETED comment = 'The total number of bytes deleted from the database as a result of a query.',
    QUERY_HISTORY.BYTES_READ_FROM_RESULT as BYTES_READ_FROM_RESULT comment = 'The total number of bytes read from the result set of a query.',
    QUERY_HISTORY.BYTES_SCANNED as BYTES_SCANNED comment = 'The total number of bytes scanned by the query.',
    QUERY_HISTORY.BYTES_SENT_OVER_THE_NETWORK as BYTES_SENT_OVER_THE_NETWORK comment = 'The total amount of data transmitted over the network during query execution, measured in bytes.',
    QUERY_HISTORY.BYTES_SPILLED_TO_LOCAL_STORAGE as BYTES_SPILLED_TO_LOCAL_STORAGE comment = 'The total amount of data (in bytes) that was spilled to local storage during query execution, indicating the amount of data that exceeded the available memory and had to be written to disk.',
    QUERY_HISTORY.BYTES_SPILLED_TO_REMOTE_STORAGE as BYTES_SPILLED_TO_REMOTE_STORAGE comment = 'The total amount of data (in bytes) that was spilled to remote storage during query execution, indicating the amount of data that exceeded the available memory and had to be written to disk.',
    QUERY_HISTORY.BYTES_WRITTEN as BYTES_WRITTEN comment = 'The total amount of data written to disk in bytes for a query.',
    QUERY_HISTORY.BYTES_WRITTEN_TO_RESULT as BYTES_WRITTEN_TO_RESULT comment = 'The total number of bytes written to the result set of a query.',
    QUERY_HISTORY.CHILD_QUERIES_WAIT_TIME as CHILD_QUERIES_WAIT_TIME comment = 'The total wait time in milliseconds for child queries to complete, indicating the time spent waiting for dependent queries to finish before the main query can proceed.',
    QUERY_HISTORY.CLUSTER_NUMBER as CLUSTER_NUMBER comment = 'Unique identifier for the cluster where the query was executed.',
    QUERY_HISTORY.COMPILATION_TIME as COMPILATION_TIME comment = 'The time taken to compile a query, measured in milliseconds.',
    QUERY_HISTORY.CREDITS_USED_CLOUD_SERVICES as CREDITS_USED_CLOUD_SERVICES comment = 'The total amount of credits used by cloud services for a query.',
    QUERY_HISTORY.DATABASE_ID as DATABASE_ID comment = 'Unique identifier for the database where the query was executed.',
    QUERY_HISTORY.EXECUTION_TIME as EXECUTION_TIME comment = 'The time taken to execute a query, measured in milliseconds.',
    QUERY_HISTORY.EXTERNAL_FUNCTION_TOTAL_INVOCATIONS as EXTERNAL_FUNCTION_TOTAL_INVOCATIONS comment = 'The total number of times an external function was invoked during query execution.',
    QUERY_HISTORY.EXTERNAL_FUNCTION_TOTAL_RECEIVED_BYTES as EXTERNAL_FUNCTION_TOTAL_RECEIVED_BYTES comment = 'Total number of bytes received by external functions during query execution.',
    QUERY_HISTORY.EXTERNAL_FUNCTION_TOTAL_RECEIVED_ROWS as EXTERNAL_FUNCTION_TOTAL_RECEIVED_ROWS comment = 'Total number of rows received by the external function.',
    QUERY_HISTORY.EXTERNAL_FUNCTION_TOTAL_SENT_BYTES as EXTERNAL_FUNCTION_TOTAL_SENT_BYTES comment = 'Total number of bytes sent by external functions.',
    QUERY_HISTORY.EXTERNAL_FUNCTION_TOTAL_SENT_ROWS as EXTERNAL_FUNCTION_TOTAL_SENT_ROWS comment = 'Total number of rows sent to external functions for processing.',
    QUERY_HISTORY.FAULT_HANDLING_TIME as FAULT_HANDLING_TIME comment = 'The total time taken to handle faults or errors in the system, measured in seconds.',
    QUERY_HISTORY.INBOUND_DATA_TRANSFER_BYTES as INBOUND_DATA_TRANSFER_BYTES comment = 'The total number of bytes transferred into the system from an external source.',
    QUERY_HISTORY.LIST_EXTERNAL_FILES_TIME as LIST_EXTERNAL_FILES_TIME comment = 'The time it takes to list external files, in seconds, with values representing the minimum, average, and maximum times, respectively.',
    QUERY_HISTORY.OUTBOUND_DATA_TRANSFER_BYTES as OUTBOUND_DATA_TRANSFER_BYTES comment = 'The total number of bytes transferred out of the system during a query.',
    QUERY_HISTORY.PARTITIONS_SCANNED as PARTITIONS_SCANNED comment = 'The number of partitions scanned by the query.',
    QUERY_HISTORY.PARTITIONS_TOTAL as PARTITIONS_TOTAL comment = 'Total number of partitions in the query.',
    QUERY_HISTORY.PERCENTAGE_SCANNED_FROM_CACHE as PERCENTAGE_SCANNED_FROM_CACHE comment = 'The percentage of data that was retrieved from the cache instead of being re-computed or re-retrieved from the original data source, indicating the efficiency of the query''s data retrieval process.',
    QUERY_HISTORY.QUERY_ACCELERATION_BYTES_SCANNED as QUERY_ACCELERATION_BYTES_SCANNED comment = 'The total amount of data scanned from the query acceleration cache, in bytes.',
    QUERY_HISTORY.QUERY_ACCELERATION_PARTITIONS_SCANNED as QUERY_ACCELERATION_PARTITIONS_SCANNED comment = 'The number of partitions scanned by the query accelerator to retrieve data.',
    QUERY_HISTORY.QUERY_ACCELERATION_UPPER_LIMIT_SCALE_FACTOR as QUERY_ACCELERATION_UPPER_LIMIT_SCALE_FACTOR comment = 'The scale factor used to determine the upper limit of query acceleration, with higher values allowing for more aggressive acceleration.',
    QUERY_HISTORY.QUERY_HASH_VERSION as QUERY_HASH_VERSION comment = 'A unique identifier for a query, which can be used to track changes to the query over time, with the version number indicating the iteration of the query.',
    QUERY_HISTORY.QUERY_LOAD_PERCENT as QUERY_LOAD_PERCENT comment = 'The percentage of the system''s load that is attributed to the query, with 0 being the lowest and 100 being the highest.',
    QUERY_HISTORY.QUERY_PARAMETERIZED_HASH_VERSION as QUERY_PARAMETERIZED_HASH_VERSION comment = 'A unique identifier for a parameterized query, used to track the version of the query plan.',
    QUERY_HISTORY.QUERY_RETRY_TIME as QUERY_RETRY_TIME comment = 'The amount of time, in seconds, that the query spent retrying due to transient errors or other issues.',
    QUERY_HISTORY.QUEUED_OVERLOAD_TIME as QUEUED_OVERLOAD_TIME comment = 'The time spent in the queue due to overload, in seconds, before a query was executed.',
    QUERY_HISTORY.QUEUED_PROVISIONING_TIME as QUEUED_PROVISIONING_TIME comment = 'The time, in seconds, that a query spent in the queue waiting for resources to become available before it was executed.',
    QUERY_HISTORY.QUEUED_REPAIR_TIME as QUEUED_REPAIR_TIME comment = 'The time, in seconds, that a query spent in the queue waiting for a repair operation to complete.',
    QUERY_HISTORY.ROWS_DELETED as ROWS_DELETED comment = 'The number of rows deleted as a result of a query execution.',
    QUERY_HISTORY.ROWS_INSERTED as ROWS_INSERTED comment = 'The number of rows inserted into a table as a result of a query execution.',
    QUERY_HISTORY.ROWS_PRODUCED as ROWS_PRODUCED comment = 'The total number of rows returned by a query.',
    QUERY_HISTORY.ROWS_UNLOADED as ROWS_UNLOADED comment = 'The total number of rows unloaded from a table during a query execution.',
    QUERY_HISTORY.ROWS_UPDATED as ROWS_UPDATED comment = 'The number of rows updated as a result of the query execution.',
    QUERY_HISTORY.ROWS_WRITTEN_TO_RESULT as ROWS_WRITTEN_TO_RESULT comment = 'The number of rows written to the result set of a query.',
    QUERY_HISTORY.SCHEMA_ID as SCHEMA_ID comment = 'Unique identifier for the schema that the query was executed against.',
    QUERY_HISTORY.SESSION_ID as SESSION_ID comment = 'Unique identifier for a query session, used to track and manage the execution of a specific query or set of queries.',
    QUERY_HISTORY.TOTAL_ELAPSED_TIME as TOTAL_ELAPSED_TIME comment = 'The total time taken to execute a query, measured in milliseconds.',
    QUERY_HISTORY.TRANSACTION_BLOCKED_TIME as TRANSACTION_BLOCKED_TIME comment = 'The time, in milliseconds, that the query spent waiting for a transaction to be committed or rolled back, blocking the current query from proceeding.',
    QUERY_HISTORY.TRANSACTION_ID as TRANSACTION_ID comment = 'Unique identifier for a specific database transaction.',
    QUERY_HISTORY.USER_DATABASE_ID as USER_DATABASE_ID comment = 'Unique identifier for the database that the user is querying.',
    QUERY_HISTORY.USER_SCHEMA_ID as USER_SCHEMA_ID comment = 'Unique identifier for the schema that the user who executed the query belongs to.',
    QUERY_HISTORY.WAREHOUSE_ID as WAREHOUSE_ID comment = 'Unique identifier for the warehouse associated with the query.',
    WAREHOUSE_METERING_HISTORY.CREDITS_ATTRIBUTED_COMPUTE_QUERIES as CREDITS_ATTRIBUTED_COMPUTE_QUERIES comment = 'The total amount of credits attributed to compute queries, representing the portion of warehouse usage allocated to query processing.',
    WAREHOUSE_METERING_HISTORY.CREDITS_USED as CREDITS_USED comment = 'The amount of credits used by a warehouse, likely representing a measure of resource utilization or consumption, expressed as a decimal value.',
    WAREHOUSE_METERING_HISTORY.CREDITS_USED_CLOUD_SERVICES as CREDITS_USED_CLOUD_SERVICES comment = 'The total amount of credits used for cloud services.',
    WAREHOUSE_METERING_HISTORY.CREDITS_USED_COMPUTE as CREDITS_USED_COMPUTE comment = 'The total amount of compute credits used by the warehouse during the metering period.',
    WAREHOUSE_METERING_HISTORY.WAREHOUSE_ID as WAREHOUSE_ID comment = 'Unique identifier for the warehouse where the metering data was collected.',
    METERING_DAILY_HISTORY.CREDITS_ADJUSTMENT_CLOUD_SERVICES as CREDITS_ADJUSTMENT_CLOUD_SERVICES comment = 'This column represents the daily adjustments made to the credits used for cloud services, with negative values indicating a reduction in credits.',
    METERING_DAILY_HISTORY.CREDITS_BILLED as CREDITS_BILLED comment = 'The total amount of credits billed to customers on a daily basis.',
    METERING_DAILY_HISTORY.CREDITS_USED as CREDITS_USED comment = 'The total amount of credits consumed or utilized by a metering device on a daily basis.',
    METERING_DAILY_HISTORY.CREDITS_USED_CLOUD_SERVICES as CREDITS_USED_CLOUD_SERVICES comment = 'The total amount of credits consumed by cloud services on a daily basis.',
    METERING_DAILY_HISTORY.CREDITS_USED_COMPUTE as CREDITS_USED_COMPUTE comment = 'The total amount of compute credits used by a customer on a daily basis.'
) dimensions (
    QUERY_ATTRIBUTION_HISTORY.END_TIME as END_TIME comment = 'The timestamp when the attribution event ended.',
    QUERY_ATTRIBUTION_HISTORY.PARENT_QUERY_ID as PARENT_QUERY_ID comment = 'Unique identifier of the parent query that triggered the attribution event.',
    QUERY_ATTRIBUTION_HISTORY.QUERY_HASH as QUERY_HASH comment = 'Unique identifier for a query, used to track changes and updates to the query over time.',
    QUERY_ATTRIBUTION_HISTORY.QUERY_ID as QUERY_ID comment = 'Unique identifier for a query, used to track and manage query history and attribution.',
    QUERY_ATTRIBUTION_HISTORY.QUERY_PARAMETERIZED_HASH as QUERY_PARAMETERIZED_HASH comment = 'A unique identifier for a parameterized query, used to track the history of query executions with varying parameters.',
    QUERY_ATTRIBUTION_HISTORY.QUERY_TAG as QUERY_TAG comment = 'This column stores the attribution history of a query, including the Streamlit engine used, the name of the Streamlit app or query, and whether it is a child query.',
    QUERY_ATTRIBUTION_HISTORY.ROOT_QUERY_ID as ROOT_QUERY_ID comment = 'Unique identifier for the root query that triggered the attribution event.',
    QUERY_ATTRIBUTION_HISTORY.START_TIME as START_TIME comment = 'The timestamp when the attribution event started.',
    QUERY_ATTRIBUTION_HISTORY.USER_NAME as USER_NAME comment = 'The user who made the change to the attribution model.',
    QUERY_ATTRIBUTION_HISTORY.WAREHOUSE_NAME as WAREHOUSE_NAME comment = 'The name of the warehouse where the query was executed.',
    QUERY_HISTORY.DATABASE_NAME as DATABASE_NAME comment = 'The name of the database where the query was executed.',
    QUERY_HISTORY.ERROR_CODE as ERROR_CODE comment = 'Error code associated with a query execution, indicating the specific error that occurred during query processing.',
    QUERY_HISTORY.ERROR_MESSAGE as ERROR_MESSAGE comment = 'The reason why a query was terminated, such as user cancellation or exceeding the idle timeout period.',
    QUERY_HISTORY.EXECUTION_STATUS as EXECUTION_STATUS comment = 'The status of a query''s execution, indicating whether it was successful, failed, or resulted in an incident.',
    QUERY_HISTORY.INBOUND_DATA_TRANSFER_CLOUD as INBOUND_DATA_TRANSFER_CLOUD comment = 'Type of data transfer where data is being moved into the system from an external cloud-based source.',
    QUERY_HISTORY.INBOUND_DATA_TRANSFER_REGION as INBOUND_DATA_TRANSFER_REGION comment = 'The region where the data was transferred from.',
    QUERY_HISTORY.IS_CLIENT_GENERATED_STATEMENT as IS_CLIENT_GENERATED_STATEMENT comment = 'Indicates whether the query was generated by a client application or manually entered by a user.',
    QUERY_HISTORY.END_TIME as END_TIME comment = 'The timestamp when a query was completed.',
    QUERY_HISTORY.OUTBOUND_DATA_TRANSFER_CLOUD as OUTBOUND_DATA_TRANSFER_CLOUD comment = 'The cloud service provider used for outbound data transfers.',
    QUERY_HISTORY.OUTBOUND_DATA_TRANSFER_REGION as OUTBOUND_DATA_TRANSFER_REGION comment = 'The region where the data was transferred to, indicating the geographic location of the outbound data transfer.',
    QUERY_HISTORY.QUERY_HASH as QUERY_HASH comment = 'Unique identifier for a query, used to track and analyze query performance and usage patterns.',
    QUERY_HISTORY.QUERY_ID as QUERY_ID comment = 'Unique identifier for a query executed in the system.',
    QUERY_HISTORY.QUERY_PARAMETERIZED_HASH as QUERY_PARAMETERIZED_HASH comment = 'A unique hash value representing a parameterized query, allowing for the identification and grouping of similar queries with different literal values.',
    QUERY_HISTORY.QUERY_RETRY_CAUSE as QUERY_RETRY_CAUSE comment = 'The reason why a query was retried, such as a timeout, network error, or resource constraint.',
    QUERY_HISTORY.QUERY_TAG as QUERY_TAG comment = 'A tag or label assigned to a query to identify its origin, purpose, or category, often used for tracking, filtering, or grouping queries in the query history.',
    QUERY_HISTORY.QUERY_TEXT as QUERY_TEXT comment = 'The text of the SQL query that was executed.',
    QUERY_HISTORY.QUERY_TYPE as QUERY_TYPE comment = 'Type of query executed, such as the start of a database transaction, a commit to save changes, or a select statement to retrieve data.',
    QUERY_HISTORY.RELEASE_VERSION as RELEASE_VERSION comment = 'The version of the software release in which the query was executed.',
    QUERY_HISTORY.ROLE_NAME as ROLE_NAME comment = 'The role that executed the query.',
    QUERY_HISTORY.ROLE_TYPE as ROLE_TYPE comment = 'The type of role being queried, either an application role or a user role.',
    QUERY_HISTORY.SCHEMA_NAME as SCHEMA_NAME comment = 'The name of the schema where the query was executed.',
    QUERY_HISTORY.SECONDARY_ROLE_STATS as SECONDARY_ROLE_STATS comment = 'Stores the secondary role statistics for a query, including the names of the roles, the total count of roles, and the IDs of the roles.',
    QUERY_HISTORY.START_TIME as START_TIME comment = 'The timestamp when the query was initiated.',
    QUERY_HISTORY.USER_DATABASE_NAME as USER_DATABASE_NAME comment = 'The name of the database that the user was querying.',
    QUERY_HISTORY.USER_NAME as USER_NAME comment = 'The user who executed the query.',
    QUERY_HISTORY.USER_SCHEMA_NAME as USER_SCHEMA_NAME comment = 'The schema name of the user who executed the query.',
    QUERY_HISTORY.USER_TYPE as USER_TYPE comment = 'The type of user who executed the query, either a Snowflake service account or a person with a user login.',
    QUERY_HISTORY.WAREHOUSE_NAME as WAREHOUSE_NAME comment = 'The name of the warehouse where the query was executed.',
    QUERY_HISTORY.WAREHOUSE_SIZE as WAREHOUSE_SIZE comment = 'The size of the warehouse used to execute the query, which can impact query performance and resource utilization.',
    QUERY_HISTORY.WAREHOUSE_TYPE as WAREHOUSE_TYPE comment = 'The type of warehouse used to execute the query, either a standard warehouse or a Snowpark-optimized warehouse.',
    WAREHOUSE_METERING_HISTORY.END_TIME as END_TIME comment = 'The date and time when the metering period ended, in ISO 8601 format, including the time zone offset.',
    WAREHOUSE_METERING_HISTORY.START_TIME as START_TIME comment = 'The date and time when the metering event started, in ISO 8601 format, including the time zone offset.',
    WAREHOUSE_METERING_HISTORY.WAREHOUSE_NAME as WAREHOUSE_NAME comment = 'The name of the warehouse where the metering data was collected.',
    METERING_DAILY_HISTORY.SERVICE_TYPE as SERVICE_TYPE comment = 'The type of service being metered, such as warehouse metering, search optimization, or warehouse metering reader, which indicates the specific service or feature being tracked and measured for usage and billing purposes.',
    METERING_DAILY_HISTORY.USAGE_DATE as USAGE_DATE comment = 'Date for which the metering data is recorded.'
) comment = 'Unlock hidden performance insights from your query history to drive measurable cost savings and performance improvements.
' with extension (
    CA = '{
  "tables" : [ {
    "name" : "QUERY_ATTRIBUTION_HISTORY",
    "dimensions" : [ {
      "name" : "PARENT_QUERY_ID",
      "sample_values" : [ "01bf09cd-0106-7234-0022-7287063e6802", "01bf0a09-0106-7234-0022-7287063e86de" ]
    }, {
      "name" : "QUERY_HASH",
      "sample_values" : [ "b6f90150b206c4fd24b70cf04fc242e1", "e14666b5000a6bfef2e140ed8d7847b5" ]
    }, {
      "name" : "QUERY_ID",
      "sample_values" : [ "01bf0a09-0106-7234-0022-7287063e872a", "01bf0a09-0106-7239-0022-7287063e97ca", "01bf09cc-0106-6de7-0022-7287063e7b7a" ]
    }, {
      "name" : "QUERY_PARAMETERIZED_HASH",
      "sample_values" : [ "bd00cfce8ec2b4f1bc8f2549edcef17b", "0a39a5aa2bc8ae8e83b4eb4216932dc4", "64e0c87df69f979fd01ac5e72546889f" ]
    }, {
      "name" : "QUERY_TAG",
      "sample_values" : [ "{\\"StreamlitEngine\\":\\"ExecuteStreamlit\\",\\"StreamlitName\\":\\"PRODUCT_MATCHING_DB.MATCH.TZG3Z8X98CJHOFJH\\",\\"ChildQuery\\":true}", "{\\"StreamlitEngine\\":\\"ExecuteStreamlit\\",\\"StreamlitName\\":\\"PRODUCT_MATCHING_DB.MATCH.ENTITY_RESOLUTION_0_START_HERE\\",\\"ChildQuery\\":true}" ]
    }, {
      "name" : "ROOT_QUERY_ID",
      "sample_values" : [ "01bf0a81-0106-7239-0022-7287063eecb2", "01bf0a08-0106-7234-0022-7287063e860e", "01bf0a09-0106-7234-0022-7287063e86ea" ]
    }, {
      "name" : "USER_NAME",
      "sample_values" : [ "MAKAYLA", "ADMIN", "SYSTEM" ]
    }, {
      "name" : "WAREHOUSE_NAME",
      "sample_values" : [ "SNOWFLAKE_CONNECTOR_FOR_SERVICENOW_WAREHOUSE", "TASTY_BYTES_DBT_WH", "COMPUTE_WH" ]
    } ],
    "facts" : [ {
      "name" : "CREDITS_ATTRIBUTED_COMPUTE",
      "sample_values" : [ 5.159733115E-5, "0.0003071320295", 3.885162327E-5 ]
    }, {
      "name" : "CREDITS_USED_QUERY_ACCELERATION"
    }, {
      "name" : "WAREHOUSE_ID",
      "sample_values" : [ "142", "1", "97" ]
    } ],
    "time_dimensions" : [ {
      "name" : "END_TIME",
      "sample_values" : [ "2025-09-14T05:02:03.320+0000", "2025-09-14T06:00:51.941+0000", "2025-09-14T05:01:16.941+0000" ]
    }, {
      "name" : "START_TIME",
      "sample_values" : [ "2025-09-14T06:07:37.448+0000", "2025-09-14T06:01:00.772+0000", "2025-09-14T06:01:06.176+0000" ]
    } ]
  }, {
    "name" : "QUERY_HISTORY",
    "dimensions" : [ {
      "name" : "DATABASE_NAME",
      "sample_values" : [ "SNOWFLAKE_CONNECTOR_FOR_SERVICENOW", "POSIT_WORKBENCH" ]
    }, {
      "name" : "ERROR_CODE",
      "sample_values" : [ "003001", "000604" ]
    }, {
      "name" : "ERROR_MESSAGE",
      "sample_values" : [ "Instance was stopped due to user interaction or idle timeout." ]
    }, {
      "name" : "EXECUTION_STATUS",
      "sample_values" : [ "INCIDENT", "FAIL", "SUCCESS" ]
    }, {
      "name" : "INBOUND_DATA_TRANSFER_CLOUD"
    }, {
      "name" : "INBOUND_DATA_TRANSFER_REGION"
    }, {
      "name" : "IS_CLIENT_GENERATED_STATEMENT",
      "sample_values" : [ "TRUE", "FALSE" ]
    }, {
      "name" : "OUTBOUND_DATA_TRANSFER_CLOUD",
      "sample_values" : [ "AWS" ]
    }, {
      "name" : "OUTBOUND_DATA_TRANSFER_REGION",
      "sample_values" : [ "us-west-2" ]
    }, {
      "name" : "QUERY_HASH",
      "sample_values" : [ "5e1762063a35c9a0c8eebc92de41359d", "a9471fc49f9209f991ef23c2a4670eba", "f7deeb34a3357780de46becdb2f33bbd" ]
    }, {
      "name" : "QUERY_ID",
      "sample_values" : [ "01b86ff7-0004-31ba-0022-728701be2a8a", "01b86ff7-0004-31ba-0022-728701be2a8e", "01b86ff7-0004-31ba-0022-728701be2a86" ]
    }, {
      "name" : "QUERY_PARAMETERIZED_HASH",
      "sample_values" : [ "83d59f52ce4f5414154929aff7835475", "d70167c6845af238843a649c79e01e40", "a9471fc49f9209f991ef23c2a4670eba" ]
    }, {
      "name" : "QUERY_RETRY_CAUSE"
    }, {
      "name" : "QUERY_TAG",
      "sample_values" : [ "  File \\"/app/.venv/lib/python3.11/site-packages/schedule/__init__.py\\", line 693, in run\\n    ret = self.job_func()\\n  File \\"//main.py\\", line 138, in job\\n    res = session.sql(f\\"DROP SNAPSHOT IF EXISTS {snapshot_name}\\").collect()\\n  File \\"/app/.venv/lib/python3.11/site-packages/snowflake/snowpark/_internal/telemetry.py\\", line 139, in wrap\\n    result = func(*args, **kwargs)\\n", "{\\"StreamlitEngine\\":\\"ExecuteStreamlit\\",\\"StreamlitName\\":\\"DEMO_DB.GRANTAPPS.\\\\\\"Stable Diffusion Model Registry\\\\\\"\\"}" ]
    }, {
      "name" : "QUERY_TEXT",
      "sample_values" : [ "alter dynamic table /* DEMO_CORTEX_SEARCH.FOMC.\\"_CORTEX_SEARCH_REFRESH_FOMC_MINUTES_SEARCH_SERVICE_cbef71dd_d0ca_497a_9842_78bfacac18f4\\" = */ identifier(9696073355284618) refresh at 1735259171881;", "alter dynamic table /* DEMO_CORTEX_SEARCH.FOMC.\\"_CORTEX_SEARCH_SOURCE_FOMC_MINUTES_SEARCH_SERVICE_7b327b14_5e64_44e1_9e1d_141a5fc6d25d\\" = */ identifier(9696073355284614) refresh at 1735259171881;" ]
    }, {
      "name" : "QUERY_TYPE",
      "sample_values" : [ "BEGIN_TRANSACTION", "COMMIT", "SELECT" ]
    }, {
      "name" : "RELEASE_VERSION",
      "sample_values" : [ "8.42.1", "8.43.0", "8.44.2" ]
    }, {
      "name" : "ROLE_NAME",
      "sample_values" : [ "SNOWFLAKE_CONNECTOR_FOR_SERVICENOW", "ACCOUNTADMIN", "POSIT_WORKBENCH" ]
    }, {
      "name" : "ROLE_TYPE",
      "sample_values" : [ "APPLICATION", "ROLE" ]
    }, {
      "name" : "SCHEMA_NAME",
      "sample_values" : [ "INTERNAL", "PUBLIC" ]
    }, {
      "name" : "SECONDARY_ROLE_STATS",
      "sample_values" : [ "{\\"roleNames\\":[],\\"roleCount\\":0,\\"roleIds\\":[]}", "{\\"roleNames\\":[\\"ALL\\"],\\"roleCount\\":2,\\"roleIds\\":[577931016,147950339029]}" ]
    }, {
      "name" : "USER_DATABASE_NAME",
      "sample_values" : [ "ARATH_DB", "TASTYBYTESENDTOENDML_PROD" ]
    }, {
      "name" : "USER_NAME",
      "sample_values" : [ "SYSTEM", "WORKBENCH", "ADMIN" ]
    }, {
      "name" : "USER_SCHEMA_NAME",
      "sample_values" : [ "ML", "ARATH_SCHEMA" ]
    }, {
      "name" : "USER_TYPE",
      "sample_values" : [ "SNOWFLAKE_SERVICE", "PERSON" ]
    }, {
      "name" : "WAREHOUSE_NAME",
      "sample_values" : [ "SNOWFLAKE_CONNECTOR_FOR_SERVICENOW_WAREHOUSE", "LANDINGLENS_NATIVE_APP" ]
    }, {
      "name" : "WAREHOUSE_SIZE",
      "sample_values" : [ "Large", "X-Small" ]
    }, {
      "name" : "WAREHOUSE_TYPE",
      "sample_values" : [ "STANDARD", "SNOWPARK-OPTIMIZED" ]
    } ],
    "facts" : [ {
      "name" : "BYTES_DELETED",
      "sample_values" : [ "471010", "263043", "17449192" ]
    }, {
      "name" : "BYTES_READ_FROM_RESULT",
      "sample_values" : [ "0" ]
    }, {
      "name" : "BYTES_SCANNED",
      "sample_values" : [ "0", "1134592", "3830784" ]
    }, {
      "name" : "BYTES_SENT_OVER_THE_NETWORK",
      "sample_values" : [ "4442754", "70505", "37942" ]
    }, {
      "name" : "BYTES_SPILLED_TO_LOCAL_STORAGE",
      "sample_values" : [ "74", "162353", "0" ]
    }, {
      "name" : "BYTES_SPILLED_TO_REMOTE_STORAGE",
      "sample_values" : [ "0" ]
    }, {
      "name" : "BYTES_WRITTEN",
      "sample_values" : [ "929792", "2560", "672768" ]
    }, {
      "name" : "BYTES_WRITTEN_TO_RESULT",
      "sample_values" : [ "1784", "1756", "7405" ]
    }, {
      "name" : "CHILD_QUERIES_WAIT_TIME",
      "sample_values" : [ "2932", "0" ]
    }, {
      "name" : "CLUSTER_NUMBER",
      "sample_values" : [ "1", "2" ]
    }, {
      "name" : "COMPILATION_TIME",
      "sample_values" : [ "1399", "97", "1144" ]
    }, {
      "name" : "CREDITS_USED_CLOUD_SERVICES",
      "sample_values" : [ "0.000208", 4.2E-5, 1.5E-5 ]
    }, {
      "name" : "DATABASE_ID",
      "sample_values" : [ "118", "199" ]
    }, {
      "name" : "EXECUTION_TIME",
      "sample_values" : [ "2084", "3345", "773" ]
    }, {
      "name" : "EXTERNAL_FUNCTION_TOTAL_INVOCATIONS",
      "sample_values" : [ "2", "5", "1" ]
    }, {
      "name" : "EXTERNAL_FUNCTION_TOTAL_RECEIVED_BYTES",
      "sample_values" : [ "695", "1170", "0" ]
    }, {
      "name" : "EXTERNAL_FUNCTION_TOTAL_RECEIVED_ROWS",
      "sample_values" : [ "200", "14", "15" ]
    }, {
      "name" : "EXTERNAL_FUNCTION_TOTAL_SENT_BYTES",
      "sample_values" : [ "343140", "2760", "2928" ]
    }, {
      "name" : "EXTERNAL_FUNCTION_TOTAL_SENT_ROWS",
      "sample_values" : [ "14", "15", "1" ]
    }, {
      "name" : "FAULT_HANDLING_TIME",
      "sample_values" : [ "3461", "6234" ]
    }, {
      "name" : "INBOUND_DATA_TRANSFER_BYTES",
      "sample_values" : [ "0" ]
    }, {
      "name" : "LIST_EXTERNAL_FILES_TIME",
      "sample_values" : [ "0", "8", "12" ]
    }, {
      "name" : "OUTBOUND_DATA_TRANSFER_BYTES",
      "sample_values" : [ "5339", "146821", "722541" ]
    }, {
      "name" : "PARTITIONS_SCANNED",
      "sample_values" : [ "1", "2", "8" ]
    }, {
      "name" : "PARTITIONS_TOTAL",
      "sample_values" : [ "0", "11", "1" ]
    }, {
      "name" : "PERCENTAGE_SCANNED_FROM_CACHE",
      "sample_values" : [ "0", "1", "0.9945487583" ]
    }, {
      "name" : "QUERY_ACCELERATION_BYTES_SCANNED",
      "sample_values" : [ "0" ]
    }, {
      "name" : "QUERY_ACCELERATION_PARTITIONS_SCANNED",
      "sample_values" : [ "0" ]
    }, {
      "name" : "QUERY_ACCELERATION_UPPER_LIMIT_SCALE_FACTOR",
      "sample_values" : [ "1", "0", "2" ]
    }, {
      "name" : "QUERY_HASH_VERSION",
      "sample_values" : [ "2" ]
    }, {
      "name" : "QUERY_LOAD_PERCENT",
      "sample_values" : [ "50", "100" ]
    }, {
      "name" : "QUERY_PARAMETERIZED_HASH_VERSION",
      "sample_values" : [ "1" ]
    }, {
      "name" : "QUERY_RETRY_TIME",
      "sample_values" : [ "0" ]
    }, {
      "name" : "QUEUED_OVERLOAD_TIME",
      "sample_values" : [ "137", "0", "20" ]
    }, {
      "name" : "QUEUED_PROVISIONING_TIME",
      "sample_values" : [ "0", "86", "279" ]
    }, {
      "name" : "QUEUED_REPAIR_TIME",
      "sample_values" : [ "1609", "0", "1611" ]
    }, {
      "name" : "ROWS_DELETED",
      "sample_values" : [ "0", "7", "3" ]
    }, {
      "name" : "ROWS_INSERTED",
      "sample_values" : [ "7", "1", "0" ]
    }, {
      "name" : "ROWS_PRODUCED",
      "sample_values" : [ "3", "1" ]
    }, {
      "name" : "ROWS_UNLOADED",
      "sample_values" : [ "15178", "1200437", "1200999" ]
    }, {
      "name" : "ROWS_UPDATED",
      "sample_values" : [ "2", "0", "1" ]
    }, {
      "name" : "ROWS_WRITTEN_TO_RESULT",
      "sample_values" : [ "19", "12", "1" ]
    }, {
      "name" : "SCHEMA_ID",
      "sample_values" : [ "451", "659" ]
    }, {
      "name" : "SESSION_ID",
      "sample_values" : [ "9696073382485798", "9696073382488478", "9696073382485786" ]
    }, {
      "name" : "TOTAL_ELAPSED_TIME",
      "sample_values" : [ "119", "159", "88" ]
    }, {
      "name" : "TRANSACTION_BLOCKED_TIME",
      "sample_values" : [ "769", "6878", "2003" ]
    }, {
      "name" : "TRANSACTION_ID",
      "sample_values" : [ "1733599981753000000", "1733599981691000000", "1733623275539000000" ]
    }, {
      "name" : "USER_DATABASE_ID",
      "sample_values" : [ "94", "212" ]
    }, {
      "name" : "USER_SCHEMA_ID",
      "sample_values" : [ "146", "490" ]
    }, {
      "name" : "WAREHOUSE_ID",
      "sample_values" : [ "97", "106" ]
    } ],
    "time_dimensions" : [ {
      "name" : "END_TIME",
      "sample_values" : [ "2024-12-12T07:32:11.052+0000", "2024-12-12T07:32:11.106+0000", "2024-12-12T07:32:12.018+0000" ]
    }, {
      "name" : "START_TIME",
      "sample_values" : [ "2024-11-21T00:01:40.287+0000", "2024-11-21T00:01:13.262+0000", "2024-11-21T00:01:18.763+0000" ]
    } ]
  }, {
    "name" : "WAREHOUSE_METERING_HISTORY",
    "dimensions" : [ {
      "name" : "WAREHOUSE_NAME",
      "sample_values" : [ "LANDINGLENS_NATIVE_APP", "SNOWFLAKE_CONNECTOR_FOR_SERVICENOW_WAREHOUSE", "D4B_WH" ]
    } ],
    "facts" : [ {
      "name" : "CREDITS_ATTRIBUTED_COMPUTE_QUERIES",
      "sample_values" : [ "0.039124861", "0.049929565", "0.041880745" ]
    }, {
      "name" : "CREDITS_USED",
      "sample_values" : [ "0.083992778", "0.168203343", "0.166912495" ]
    }, {
      "name" : "CREDITS_USED_CLOUD_SERVICES",
      "sample_values" : [ "0.000160557", "0.036801655", "0.084204167" ]
    }, {
      "name" : "CREDITS_USED_COMPUTE",
      "sample_values" : [ "0.135277778", "0.083888889", "0.435555556" ]
    }, {
      "name" : "WAREHOUSE_ID",
      "sample_values" : [ "58", "97", "106" ]
    } ],
    "time_dimensions" : [ {
      "name" : "END_TIME",
      "sample_values" : [ "2025-01-31T23:00:00.000+0000", "2025-02-01T01:00:00.000+0000", "2025-02-01T00:00:00.000+0000" ]
    }, {
      "name" : "START_TIME",
      "sample_values" : [ "2024-12-02T13:00:00.000+0000", "2024-10-12T02:00:00.000+0000", "2024-10-12T01:00:00.000+0000" ]
    } ]
  }, {
    "name" : "METERING_DAILY_HISTORY",
    "dimensions" : [ {
      "name" : "SERVICE_TYPE",
      "sample_values" : [ "WAREHOUSE_METERING", "SEARCH_OPTIMIZATION", "WAREHOUSE_METERING_READER" ]
    } ],
    "facts" : [ {
      "name" : "CREDITS_ADJUSTMENT_CLOUD_SERVICES",
      "sample_values" : [ "-0.5409444440", "-0.1256111109", "-0.9793888895" ]
    }, {
      "name" : "CREDITS_BILLED",
      "sample_values" : [ "1.4398671742", "1.3430024838", "5.7357422312" ]
    }, {
      "name" : "CREDITS_USED",
      "sample_values" : [ "16.156382529", "1.472394952", "20.625078599" ]
    }, {
      "name" : "CREDITS_USED_CLOUD_SERVICES",
      "sample_values" : [ "1.987110531", "0.881804490", "0.934006588" ]
    }, {
      "name" : "CREDITS_USED_COMPUTE",
      "sample_values" : [ "5.250833335", "1.632777780", "0.170833332" ]
    } ],
    "time_dimensions" : [ {
      "name" : "USAGE_DATE",
      "sample_values" : [ "2024-12-31", "2025-05-24", "2025-01-03" ]
    } ]
  } ],
  "verified_queries" : [ {
    "name" : "show me the credits used in idle time last 10 days",
    "question" : "show me the credits used in idle time last 10 days",
    "sql" : "SELECT\\nwarehouse_name,\\nROUND(SUM(credits_used_compute),2) as wh_credits,\\nROUND(SUM(credits_attributed_compute_queries),2) as query_credits,\\nwh_credits - query_credits as wh_idle_credits\\nFROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY\\nWHERE start_time::date >= DATEADD(''days'', -10, CURRENT_DATE())\\nGROUP BY ALL;",
    "use_as_onboarding_question" : false,
    "verified_by" : "Aswinee Rath",
    "verified_at" : 1761229806
  } ]
}'
);

/***
3. Create a datashare of Snowflake Documentation Knowledge Extension from Snowflake marketplace
****/
SHOW AVAILABLE LISTINGS ->>
SELECT
    "global_name",
    "title",
    "is_imported"
FROM
    $1
WHERE
    1 = 1
    AND "title" LIKE '%Snowflake Doc%';
--make sure the CKE is not already imported, is_imported is false
    --if imported we are using the imported database as SNOWFLAKE_DOCUMENTATION in rest of our steps
    --if bot imported, if listing global name is not GZSTZ67BY9OQ4 with the global_name from previous query

-- Request the listing
CALL SYSTEM$REQUEST_LISTING_AND_WAIT('GZSTZ67BY9OQ4');

-- Accept legal terms
CALL SYSTEM$ACCEPT_LEGAL_TERMS('DATA_EXCHANGE_LISTING', 'GZSTZ67BY9OQ4');

-- import the share    
CREATE DATABASE SNOWFLAKE_DOCUMENTATION
FROM
    LISTING 'GZSTZ67BY9OQ4';
--check that the share is IMPORTED
    show shares like '%Docs%';

    
    
/***
4. Create an Agent that Connects the Semantic View, and Docs CKE
    ***/
use schema SNOWFLAKE_INSIGHTS.AGENTS;
CREATE
OR REPLACE AGENT SNOWFLAKE_INSIGHTS.AGENTS.Snowflake_Insights_Assistant COMMENT = 'Snowflake Inisghts Assistant for your Snowflake Account using ground truth from your usage data and Snowflake Documentation.' PROFILE = '{"display_name": "Snowflake Insights Assistant", "avatar": "snowflake-icon.png", "color": "blue"}'
FROM
    SPECIFICATION $$
  models:
    orchestration: auto

  orchestration: {}

  instructions:
    response: |
      You are a Snowflake Data Engineer Assistant. Always provide:
      • **Specific recommendations** with clear next steps
      • **Actual metrics** from Snowflake Account Usage history data  
      • **Prioritized solutions** (high-impact first)
      • **Snowflake best practices** (Gen 2 warehouses, clustering, modern SQL)
    
    orchestration: |
      For query performance analysis requests:
      1. First, query the semantic view to identify relevant queries, performance metrics, and patterns
      2. Analyze execution times, compilation times, bytes scanned, and warehouse usage
      3. Prioritize findings by impact (slowest queries, highest resource usage, most frequent errors)
      4. Use Snowflake documentation search to reference best practices and specific features
      5. Provide specific, actionable recommendations with clear next steps

      For optimization questions:
      1. Start with the query history data to understand current performance
      2. Identify bottlenecks and inefficiencies in the data
      3. Reference Snowflake documentation for feature recommendations (Gen 2 warehouses, clustering, etc.)
      4. Provide concrete optimization steps with expected improvements

      For troubleshooting:
      1. Analyze error patterns and compilation issues from query history
      2. Search documentation for specific error resolution guidance  
      3. Provide step-by-step fixes and prevention strategies

      Always ground recommendations in actual data from the user's query history.

    sample_questions:
      - question: "Based on my top 10 slowest queries, can you provide ways to optimize them?"
      - question: "What was the query that's causing performance issues?"
      - question: "Which warehouses should be upgraded to Gen 2?"
      - question: "Show me queries with compilation errors and how to fix them"
      - question: "What are the most common query patterns causing issues?"
      - question: "How can I improve query compilation times?"
      - question: "What Snowflake features am I not using that could help performance?"
      - question: "Would my query benefit from Query Acceleration or Search Optimization Service?"

  tools:
    - tool_spec:
        type: cortex_analyst_text_to_sql
        name: Snowflake_usage_assisstant
        description: |
          Use this tool to analyze Snowflake query performance and identify optimization opportunities. This semantic view provides access to query history data, including execution times, compilation times, bytes scanned, warehouse usage, and error information. 
          Use this tool when users ask about:
          - Slowest running queries and performance bottlenecks
          - Query optimization recommendations 
          - Warehouse utilization and sizing recommendations
          - Compilation errors and troubleshooting
          - Data scanning patterns and efficiency analysis
          - Historical query trends and usage patterns

          The tool returns structured data about query performance metrics that can be used to provide specific, actionable optimization recommendations.
    
    - tool_spec:
        type: cortex_search
        name: Cortex_Knowledge_Extension_Snowflake_Documentation
        description: Search Snowflake Documentation via Snowflake Marketplace Knowledge Extension.
    
  tool_resources:
    Cortex_Knowledge_Extension_Snowflake_Documentation:
      max_results: 4
      name: SNOWFLAKE_DOCUMENTATION.SHARED.CKE_SNOWFLAKE_DOCS_SERVICE
    
    Snowflake_usage_assisstant:
      execution_environment:
        query_timeout: 120
        type: warehouse
        warehouse: SNOWFLAKE_INSIGHTS_WH
      semantic_view: SNOWFLAKE_INSIGHTS.AGENTS.SNOWFLAKE_USAGE_ASSISTANT_SV

  $$;
-- check the agent got created
show agents like 'Snowflake_Insights_Assistant';
    
    
/**
 5. Create Snowflake Intelligence to use the Agent
      ***/
-- Check if Snowflake Intelligence object exists
SHOW SNOWFLAKE INTELLIGENCES;
-- Create the Snowflake Intelligence object if it doesn't exist
CREATE SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;
-- Add your agent to the Snowflake Intelligence object
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
ADD
AGENT SNOWFLAKE_INSIGHTS.AGENTS.SNOWFLAKE_INSIGHTS_ASSISTANT;

    
/***
6.   Go to Snowflake Intelligence UI https://ai.snowflake.com/ and check this newly created agent is available
    ***/



/***
Plan B: if you need to drop the objects for any reason
Uncomment and run the required SQL
****/

-- -- remove the agent from SI
-- ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
-- drop
-- AGENT SNOWFLAKE_INSIGHTS.AGENTS.SNOWFLAKE_INSIGHTS_ASSISTANT;

-- --Drop the agent
-- drop agent SNOWFLAKE_INSIGHTS.AGENTS.SNOWFLAKE_INSIGHTS_ASSISTANT;

-- --drop the semantic view
-- drop semantic view SNOWFLAKE_INSIGHTS.AGENTS.SNOWFLAKE_USAGE_ASSISTANT_SV ;
-- --drop the CKE documentation database
-- drop database SNOWFLAKE_DOCUMENTATION;

-- --drop the database
-- drop database SNOWFLAKE_INSIGHTS;
-- --drop the warehouse
-- drop warehouse SNOWFLAKE_INSIGHTS_WH;
