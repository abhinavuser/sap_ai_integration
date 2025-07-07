# Setup Guide - Agentic LLM Framework

This guide provides step-by-step instructions for setting up the Agentic LLM Framework for SAP ABAP Development.

## Prerequisites

### System Requirements

- **SAP System**: NetWeaver 7.50+ or S/4HANA 2020+
- **Python**: 3.8 or higher
- **Eclipse**: 2023-12 or higher with ABAP Development Tools (ADT)
- **Memory**: Minimum 8GB RAM (16GB recommended)
- **Storage**: 2GB free space

### Required SAP Components

- ABAP Development Tools (ADT)
- HTTP Communication Framework
- JSON Processing
- Encryption/Decryption capabilities

### Required Python Packages

See `requirements.txt` for the complete list. Key packages include:
- pandas >= 1.5.0
- scikit-learn >= 1.3.0
- tiktoken >= 0.5.0
- tensorflow >= 2.13.0

## Installation Steps

### Step 1: SAP System Setup

#### 1.1 Import ABAP Objects

1. **Create Transport Request**
   ```abap
   " Create a new transport request
   CALL FUNCTION 'TR_INSERT_REQUEST'
     EXPORTING
       iv_trfunction = 'K'
       iv_trkorr     = 'ZLLM_001'
   ```

2. **Import Core Package**
   ```abap
   " Import the ZLLM_00 package
   CALL FUNCTION 'RS_CORR_INSERT'
     EXPORTING
       object_class = 'DEVC'
       object_name  = 'ZLLM_00'
       devclass     = '$TMP'
   ```

3. **Import Application Package**
   ```abap
   " Import the ZLLM_99 package
   CALL FUNCTION 'RS_CORR_INSERT'
     EXPORTING
       object_class = 'DEVC'
       object_name  = 'ZLLM_99'
       devclass     = '$TMP'
   ```

#### 1.2 Configure System Parameters

1. **Set API Configuration**
   ```abap
   " Set OpenAI API key
   SET PARAMETER ID 'ZLLM_API_KEY' FIELD 'your-openai-api-key'
   
   " Set API URL
   SET PARAMETER ID 'ZLLM_API_URL' FIELD 'https://api.openai.com/v1/'
   
   " Set default model
   SET PARAMETER ID 'ZLLM_MODEL' FIELD 'gpt-4'
   ```

2. **Configure Rate Limiting**
   ```abap
   " Set rate limiting parameters
   SET PARAMETER ID 'ZLLM_RATE_LIMIT' FIELD '10'
   SET PARAMETER ID 'ZLLM_PAUSE_TIME' FIELD '1'
   ```

#### 1.3 Create Database Tables

1. **Cache Table**
   ```abap
   " Create cache table for LLM responses
   CREATE TABLE zllm_00_cache (
     cache_key    TYPE hash160,
     response     TYPE string,
     created_at   TYPE timestamp,
     expires_at   TYPE timestamp,
     model_name   TYPE string,
     token_count  TYPE i
   )
   ```

2. **Logging Table**
   ```abap
   " Create logging table for monitoring
   CREATE TABLE zllm_00_logs (
     log_id       TYPE guid,
     timestamp    TYPE timestamp,
     operation    TYPE string,
     model_name   TYPE string,
     token_count  TYPE i,
     duration     TYPE i,
     status       TYPE string,
     error_msg    TYPE string
   )
   ```

### Step 2: Python Environment Setup

#### 2.1 Create Virtual Environment

```bash
# Create virtual environment
python -m venv agentic_llm_env

# Activate virtual environment
# On Windows:
agentic_llm_env\Scripts\activate
# On Linux/Mac:
source agentic_llm_env/bin/activate
```

#### 2.2 Install Dependencies

```bash
# Install required packages
pip install -r requirements.txt

# Verify installation
python -c "import pandas, sklearn, tiktoken; print('All packages installed successfully')"
```

#### 2.3 Train ML Models

```bash
# Train token prediction models
python train_models.py --input _predictoken/stats_4_training.tsv --output-dir _predictoken/

# Verify model training
python predict.py --text "Sample ABAP code for testing" --model gpt4
```

### Step 3: Eclipse Plugin Setup

#### 3.1 Build Plugin

```bash
# Navigate to plugin directory
cd version_abap

# Build with Maven
mvn clean install

# Verify build
ls com.developer.nefarious.zjoule.updatesite/target/
```

#### 3.2 Install in Eclipse

1. **Open Eclipse with ADT**
   - Launch Eclipse IDE
   - Ensure ABAP Development Tools are installed

2. **Install Plugin**
   - Go to Help → Install New Software
   - Click "Add" → "Local"
   - Browse to `version_abap/com.developer.nefarious.zjoule.updatesite/target/`
   - Select "ABAP Copilot" feature
   - Follow installation wizard

3. **Restart Eclipse**
   - Restart Eclipse when prompted
   - Verify plugin installation in Window → Preferences → ABAP Copilot

### Step 4: Configuration

#### 4.1 Environment Configuration

Create `config/environment.json`:
```json
{
  "llm": {
    "providers": {
      "openai": {
        "api_key": "your-openai-api-key",
        "api_url": "https://api.openai.com/v1/",
        "default_model": "gpt-4",
        "max_tokens": 4000
      },
      "azure": {
        "api_key": "your-azure-api-key",
        "api_url": "https://your-resource.openai.azure.com/",
        "deployment": "your-deployment-name",
        "api_version": "2024-02-15-preview"
      },
      "ollama": {
        "api_url": "http://localhost:11434",
        "default_model": "mistral"
      }
    }
  },
  "cache": {
    "enabled": true,
    "max_size": 1000,
    "ttl_hours": 24
  },
  "rate_limiting": {
    "enabled": true,
    "requests_per_minute": 60,
    "pause_seconds": 1
  }
}
```

#### 4.2 ABAP Configuration

Create `config/abap_config.abap`:
```abap
" ABAP Configuration for Agentic LLM Framework
DATA: ls_config TYPE zif_llm_00_types=>ts_env.

" Set environment configuration
ls_config-api_key = 'your-api-key'.
ls_config-api_url = 'https://api.openai.com/v1/'.
ls_config-api_model = 'gpt-4'.
ls_config-api_max_token = 4000.
ls_config-api_ver = '2024-02-15-preview'.

" Initialize framework
DATA(lo_llm) = zcl_llm_00_llm_lazy=>new( is_env = ls_config ).
```

### Step 5: Verification

#### 5.1 Test ABAP Integration

```abap
" Test basic LLM functionality
DATA(lo_llm) = zcl_llm_00_llm_lazy=>new( is_env = ls_env ).

DATA(lv_response) = lo_llm->chat_completion( 
  iv_prompt = 'Explain ABAP design patterns in one sentence'
).

WRITE: / 'Response:', lv_response.
```

#### 5.2 Test Token Prediction

```bash
# Test Python token prediction
python predict.py --text "CLASS zcl_test DEFINITION PUBLIC FINAL CREATE PUBLIC. ENDCLASS." --model gpt4

# Expected output: Token count prediction
```

#### 5.3 Test Eclipse Plugin

1. **Open ABAP Project**
   - Open Eclipse with ADT
   - Connect to SAP system
   - Open ABAP project

2. **Test Plugin Features**
   - Right-click on ABAP file
   - Select "ABAP Copilot" → "Analyze Code"
   - Verify AI suggestions appear

## Troubleshooting

### Common Issues

#### 1. ABAP Import Errors

**Problem**: Objects fail to import
**Solution**:
```abap
" Check object dependencies
CALL FUNCTION 'RS_WORKBENCH_CHECK'
  EXPORTING
    object_name = 'ZLLM_00'
    object_type = 'DEVC'
```

#### 2. Python Package Issues

**Problem**: Package installation fails
**Solution**:
```bash
# Upgrade pip
python -m pip install --upgrade pip

# Install with specific versions
pip install pandas==1.5.3 scikit-learn==1.3.0
```

#### 3. Eclipse Plugin Issues

**Problem**: Plugin not appearing
**Solution**:
- Check Eclipse error log
- Verify plugin installation in About → Installation Details
- Restart Eclipse in clean mode

#### 4. API Connection Issues

**Problem**: Cannot connect to LLM APIs
**Solution**:
```abap
" Test HTTP connection
DATA(lo_http) = cl_web_http_client_manager=>create_by_http_destination(
  cl_http_destination_provider=>create_url( 'https://api.openai.com' )
).
```

### Performance Optimization

#### 1. Cache Configuration

```abap
" Optimize cache settings
DATA(lo_cache) = zcl_llm_00_cache=>new( 
  iv_max_size = 2000
  iv_ttl_hours = 48
).
```

#### 2. Rate Limiting

```abap
" Configure rate limiting
DATA(ls_limits) = VALUE #(
  req_before_pause = 20
  pause_for = 2
).
```

## Security Considerations

### 1. API Key Management

- Store API keys in SAP secure storage
- Use encryption for sensitive data
- Implement key rotation policies

### 2. Network Security

- Use HTTPS for all API communications
- Implement firewall rules
- Monitor network traffic

### 3. Data Protection

- Validate all inputs
- Sanitize outputs
- Implement audit logging

## Next Steps

After successful setup:

1. **Explore Examples**: Review demo programs in `src/zllm_99/`
2. **Study Design Patterns**: Examine implementations in `abap/`
3. **Customize Configuration**: Adapt settings for your environment
4. **Build Custom Agents**: Create domain-specific agents
5. **Integrate with CI/CD**: Add framework to development pipelines

## Support

For additional support:

- **Documentation**: Check `docs/` directory
- **Examples**: Review `src/zllm_99/` for usage examples
- **Issues**: Report problems in project repository
- **Community**: Join ABAP development forums

---

**Note**: This setup guide assumes a standard SAP development environment. Adjust configurations based on your specific system requirements and security policies. 