*&---------------------------------------------------------------------*
*& Report ZLLM_BASIC_USAGE
*&---------------------------------------------------------------------*
*& Basic Usage Example for Agentic LLM Framework
*&---------------------------------------------------------------------*
REPORT zllm_basic_usage.

*----------------------------------------------------------------------*
* Data Declarations
*----------------------------------------------------------------------*
DATA: lo_llm        TYPE REF TO zif_llm_00_llm_lazy,
      lo_cache      TYPE REF TO zif_llm_00_cache,
      lo_predictor  TYPE REF TO zcl_llm_00_predictoken,
      lv_response   TYPE string,
      lv_tokens     TYPE i,
      ls_env        TYPE zif_llm_00_types=>ts_env.

*----------------------------------------------------------------------*
* Configuration
*----------------------------------------------------------------------*
ls_env-api_key = 'your-openai-api-key'.
ls_env-api_url = 'https://api.openai.com/v1/'.
ls_env-api_model = 'gpt-4'.
ls_env-api_max_token = 4000.

*----------------------------------------------------------------------*
* Initialize Components
*----------------------------------------------------------------------*
" Create cache instance
lo_cache = zcl_llm_00_cache=>new( iv_max_size = 1000 ).

" Create LLM client with cache
lo_llm = zcl_llm_00_llm_lazy=>new( 
  is_env = ls_env
  io_cache = lo_cache
).

" Create token predictor
lo_predictor = zcl_llm_00_predictoken=>new( ).

*----------------------------------------------------------------------*
* Example 1: Simple Chat Completion
*----------------------------------------------------------------------*
WRITE: / '=== Example 1: Simple Chat Completion ==='.

lv_response = lo_llm->chat_completion( 
  iv_prompt = 'Explain ABAP design patterns in one sentence'
).

WRITE: / 'Response:', lv_response.

*----------------------------------------------------------------------*
* Example 2: Token Prediction
*----------------------------------------------------------------------*
WRITE: / / '=== Example 2: Token Prediction ==='.

DATA(lv_abap_code) = |CLASS zcl_example DEFINITION PUBLIC FINAL CREATE PUBLIC.| &&
                    |  PUBLIC SECTION.| &&
                    |    METHODS: constructor.| &&
                    |  PRIVATE SECTION.| &&
                    |ENDCLASS.|.

lv_tokens = lo_predictor->predict_tokens_gpt4( iv_text = lv_abap_code ).

WRITE: / 'ABAP Code:', lv_abap_code.
WRITE: / 'Predicted tokens:', lv_tokens.

*----------------------------------------------------------------------*
* Example 3: Pattern-Based Code Generation
*----------------------------------------------------------------------*
WRITE: / / '=== Example 3: Pattern-Based Code Generation ==='.

DATA: lo_pattern TYPE REF TO zcl_llm_00_pat,
      lv_template TYPE string,
      lv_generated TYPE string.

" Create pattern engine
lo_pattern = zcl_llm_00_pat=>new( ).

" Define template
lv_template = |CLASS {{class_name}} DEFINITION PUBLIC FINAL CREATE PUBLIC.| &&
              |  PUBLIC SECTION.| &&
              |    METHODS: {{method_name}}.| &&
              |  PRIVATE SECTION.| &&
              |ENDCLASS.|.

" Set template
lo_pattern->set_template( 
  iv_name = 'class_template'
  iv_template = lv_template
).

" Generate code
lv_generated = lo_pattern->render( 
  iv_name = 'class_template'
  it_data = VALUE #( 
    ( name = 'class_name' value = 'ZCL_MY_CLASS' )
    ( name = 'method_name' value = 'DO_SOMETHING' )
  )
).

WRITE: / 'Generated Code:'.
WRITE: / lv_generated.

*----------------------------------------------------------------------*
* Example 4: Flow Orchestration
*----------------------------------------------------------------------*
WRITE: / / '=== Example 4: Flow Orchestration ==='.

DATA: lo_flow TYPE REF TO zcl_llm_00_flow_lazy,
      lt_results TYPE zif_llm_00_flow_lazy=>tt_step_results.

" Create flow engine
lo_flow = zcl_llm_00_flow_lazy=>new( ).

" Add steps
lo_flow->add_step( 
  iv_name = 'analyze_code'
  iv_prompt = 'Analyze this ABAP code for best practices: ' && lv_abap_code
).

lo_flow->add_step( 
  iv_name = 'suggest_improvements'
  iv_prompt = 'Based on the analysis, suggest specific improvements'
).

" Execute flow
lt_results = lo_flow->execute( ).

" Display results
LOOP AT lt_results INTO DATA(ls_result).
  WRITE: / 'Step:', ls_result-step_name.
  WRITE: / 'Result:', ls_result-result.
  WRITE: /.
ENDLOOP.

*----------------------------------------------------------------------*
* Example 5: Error Handling
*----------------------------------------------------------------------*
WRITE: / / '=== Example 5: Error Handling ==='.

TRY.
    " Attempt invalid request
    lv_response = lo_llm->chat_completion( iv_prompt = '' ).
    WRITE: / 'Success:', lv_response.
  CATCH zcx_s INTO DATA(lx_error).
    WRITE: / 'Error caught:', lx_error->get_text( ).
ENDTRY.

*----------------------------------------------------------------------*
* Example 6: Performance Monitoring
*----------------------------------------------------------------------*
WRITE: / / '=== Example 6: Performance Monitoring ==='.

DATA: lo_trace TYPE REF TO zif_llm_00_trace.

" Create trace instance
lo_trace = zcl_llm_00_trace=>new( ).

" Log request
lo_trace->log_request( 
  iv_model = 'gpt-4'
  iv_tokens = lv_tokens
  iv_duration = 1500
  iv_status = 'SUCCESS'
).

WRITE: / 'Request logged successfully'.

*----------------------------------------------------------------------*
* Cleanup
*----------------------------------------------------------------------*
FREE: lo_llm, lo_cache, lo_predictor, lo_pattern, lo_flow, lo_trace.

WRITE: / / '=== Examples completed successfully ==='. 