# Snowflake Insights Assistant
This is based on amazing work by my colleague [Kaitlyn Wells] (https://www.linkedin.com/in/kaitlyn-wells-b75752b6/) 

A comprehensive Snowflake Agent that provides intelligent query performance analysis and optimization recommendations using your account's usage data and Snowflake documentation.

## Overview

This project creates a Snowflake Insights Assistant that leverages:
- **Semantic Views** over Snowflake Account Usage data
- **Cortex Knowledge Extension** for Snowflake Documentation
- **Snowflake Intelligence** for natural language interactions

The assistant analyzes your query history, identifies performance bottlenecks, and provides actionable optimization recommendations grounded in your actual usage data and Snowflake best practices.

## Features

- 🔍 **Performance Analysis**: Identify slowest queries and performance bottlenecks
- 📊 **Usage Insights**: Analyze warehouse utilization, credit consumption, and resource patterns
- 🛠️ **Optimization Recommendations**: Get specific, actionable recommendations with clear next steps
- 📚 **Documentation Integration**: Access Snowflake best practices and feature recommendations
- 🎯 **Error Troubleshooting**: Analyze error patterns and get resolution guidance
- 💰 **Cost Optimization**: Track idle credits and identify cost-saving opportunities

## Architecture

The solution consists of 6 main components:

1. **Database & Warehouse**: Dedicated infrastructure for the agent
2. **Semantic View**: Structured access to Account Usage views
3. **Documentation Knowledge Extension**: Snowflake documentation from Marketplace
4. **Snowflake Agent**: AI-powered assistant with orchestration logic
5. **Snowflake Intelligence**: Integration with Snowflake Intelligence UI
6. **User Interface**: Access via ai.snowflake.com

## Prerequisites

- Snowflake account with appropriate privileges (ACCOUNTADMIN role recommended)
- Access to `SNOWFLAKE.ACCOUNT_USAGE` views
- Permissions to:
  - Create databases and schemas
  - Create warehouses
  - Create semantic views
  - Request and install Marketplace listings
  - Create agents and Snowflake Intelligence objects

## Installation

See the full SQL script (`SnowflakeInsightsAssistant.sql`) for the complete instructions.

### Step 1: Create Database and Warehouse
### Step 2: Create Semantic View

The semantic view provides structured access to four key Account Usage views:
- `QUERY_ATTRIBUTION_HISTORY`
- `QUERY_HISTORY`
- `WAREHOUSE_METERING_HISTORY`
- `METERING_DAILY_HISTORY`

See the full SQL script (`SnowflakeInsightsAssistant.sql`) for the complete semantic view definition with all facts and dimensions.

### Step 3: Import Snowflake Documentation Knowledge Extension

### Step 4: Create the Snowflake Agent

The agent includes:
- **Orchestration**: Automated model selection
- **Instructions**: Specific guidance for performance analysis, optimization, and troubleshooting
- **Tools**: Cortex Analyst (text-to-SQL) and Cortex Search (documentation)
- **Sample Questions**: Pre-defined queries to get started

See the SQL script for the complete agent specification.

### Step 5: Configure Snowflake Intelligence


### Step 6: Access the Agent

Navigate to [Snowflake Intelligence UI](https://ai.snowflake.com/) to interact with your Snowflake Insights Assistant.

## Usage Examples

### Performance Analysis
```
"Based on my top 10 slowest queries, can you provide ways to optimize them?"
```

### Cost Optimization
```
"Show me the credits used in idle time over the last 10 days"
```

### Troubleshooting
```
"Show me queries with compilation errors and how to fix them"
```

### Feature Recommendations
```
"Which warehouses should be upgraded to Gen 2?"
"Would my query benefit from Query Acceleration or Search Optimization Service?"
```

### Pattern Analysis
```
"What are the most common query patterns causing issues?"
"How can I improve query compilation times?"
```

## Data Sources

### Account Usage Views

The semantic view integrates the following Account Usage metrics:

**Query Attribution History**
- Credits attributed to compute
- Credits used for query acceleration
- Warehouse utilization

**Query History**
- Execution times and compilation times
- Bytes scanned, read, and written
- Rows produced, inserted, updated, deleted
- Error codes and messages
- Warehouse and database information

**Warehouse Metering History**
- Credits used by warehouse
- Credits attributed to compute queries
- Cloud services credits

**Metering Daily History**
- Daily credit usage and billing
- Cloud services adjustments
- Service types (warehouse, search optimization, etc.)

## Key Benefits

✅ **Data-Driven Insights**: Recommendations based on your actual query history  
✅ **Automated Analysis**: AI-powered performance analysis without manual queries  
✅ **Best Practices**: Integrated Snowflake documentation and recommendations  
✅ **Cost Optimization**: Identify idle resources and optimize credit usage  
✅ **Natural Language**: Ask questions in plain English via Snowflake Intelligence UI  
✅ **Proactive Monitoring**: Identify issues before they impact performance  

## Technical Details

### Agent Configuration

- **Orchestration Model**: Auto (automatically selects the best model)
- **Query Timeout**: 120 seconds
- **Warehouse**: SNOWFLAKE_INSIGHTS_WH (X-Small, auto-suspend 60s)
- **Max Results (Documentation Search)**: 4 results per query

### Semantic View Metrics

The semantic view includes over 80 metrics covering:
- Query execution and performance
- Resource utilization
- Data transfer and storage
- Credit consumption
- Error tracking
- Warehouse operations

## Support and Documentation

For additional information:
- [Snowflake Documentation](https://docs.snowflake.com/)
- [Snowflake Intelligence Guide](https://docs.snowflake.com/en/user-guide/snowflake-intelligence)
- [Cortex AI Features](https://docs.snowflake.com/en/user-guide/snowflake-cortex)

## License

This project uses Snowflake Marketplace data (Snowflake Documentation Knowledge Extension) which is subject to Snowflake's licensing terms.

## Author

Created by: Aswinee Rath  
Last Updated: November 2025

---

*Note: This assistant requires access to SNOWFLAKE.ACCOUNT_USAGE views which typically have a latency of 45 minutes to 3 hours for data availability.*

