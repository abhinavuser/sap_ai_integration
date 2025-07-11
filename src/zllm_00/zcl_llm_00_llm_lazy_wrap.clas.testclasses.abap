CLASS lcl_ DEFINITION DEFERRED.
CLASS zcl_llm_00_llm_lazy_wrap DEFINITION LOCAL FRIENDS lcl_.

CLASS lcl_ DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO zif_llm_00_llm_lazy.  "class under test
    DATA:
      mo_fl TYPE REF TO zif_llm_00_file_list.

    METHODS: setup.
    METHODS: cc               FOR TESTING. "chat completions
    METHODS: cc_local         FOR TESTING. "chat completions
    METHODS: cc_azure         FOR TESTING. "chat completions
    METHODS: cc_azure2        FOR TESTING. "chat completions
    METHODS: cc_cache         FOR TESTING. "chat completions
    METHODS: cc_cache_bypass  FOR TESTING. "chat completions
    METHODS: cc_json_forced   FOR TESTING.
    METHODS: cc_json_detected FOR TESTING.
    METHODS: cc_json_explicit FOR TESTING.

*   METHODS: embeddings FOR TESTING.
*   METHODS: function_call            FOR TESTING.
*   METHODS: function_call_04         FOR TESTING.
*   METHODS: function_call_and_invoke FOR TESTING.
ENDCLASS.       "lcl_


CLASS lcl_ IMPLEMENTATION.

  METHOD setup.
    mo_fl = zcl_llm_00_file_list_bin=>new_from_bin(
              iv_bin        = '$ZLLM_02_YAAC'
              iv_mask      = '*.env;*.md'
    ).
    DATA(lo_env) = mo_fl->get_by_name( 'afun.env' ).
    DATA(lo_cache) = zcl_llm_00_cache=>new(
      iv_seed  = 0
    ).
    mo_cut = zcl_llm_00_llm_lazy_wrap=>new_from_file(
      io_      = lo_env
      io_cache = lo_cache
    ).
  ENDMETHOD.

  METHOD cc.

*    DATA(go_fl) = zcl_llm_00_file_list_bin=>new_from_bin(        "~ Initialize the file list component using the zcl_llm_00_file_list_bin class with the retrieved binary data.
*      iv_bin  = '$ZLLM_02_YAAC'
*      iv_mask = '*.env;*.md'
*    ).
*
*    DATA(go_cache) = zcl_llm_00_cache=>new( ).                   "~ Initialize the cache component using the zcl_llm_00_cache class for efficient data retrieval.
*
*    DATA(go_llm) = zcl_llm_00_llm_lazy=>new_from_file(           "~ Initialize the LLM component using the zcl_llm_00_llm_lazy class with the specified file and cache.
*      "io_      = go_fl->get_by_name( 'azure-gpt40.env' )"~  <co id="569" type="MCall">{comment-placeholder}</co>
*      io_      = go_fl->get_by_name( 'afun.env' )"~  <co id="569" type="MCall">{comment-placeholder}</co>
*      io_cache = go_cache
*    ). "smart = gpt-4o
*
**--------------------------------------------------------------------*
*    DATA(go_formula) = zcl_llm_00_formula=>new_from_name(        "~ Initialize the formula component using the zcl_llm_00_formula class with the specified name.
*      io_fl   = go_fl
*      iv_name = 'datamodel'
*    ).
*
*    DATA(go_step) = zcl_llm_00_step_lazy=>new_from_formula(      "~ Initialize the step component using the zcl_llm_00_step_lazy class with the formula and LLM components.
*      io_    = go_formula
*      io_llm = go_llm
*    ).
*
*    " this flow is from one step
*    DATA(go_flow) = zcl_llm_00_flow_lazy=>new( VALUE #(          "~ Initialize the flow component using the zcl_llm_00_flow_lazy class with the specified step.
*      ( go_step )
*    ) ).
*
*    DATA(lv_str) = `hi! holala!`.
*
*    DATA(mo_doc) = go_step->start(                         "~ Start a new document processing step using the LLM data.
*      ir_ = REF #( lv_str )
*    ).
*
*    DATA(go_md) = zcl_markdown=>new( ).
*
*    DATA(lv_res)  = mo_doc->to_string( ).            "~ Convert the document object into a string representation for further use.
*    DATA(lv_html) = go_md->text( lv_res ).           "~ Generate HTML content from the string representation of the document.
*    cl_demo_output=>display_html( lv_html ).         "~ Display the generated HTML content using the demo output class.
*    cl_demo_output=>display_text( lv_res  ).         "~ Display the generated MD content using the demo output class.
*
*--------------------------------------------------------------------*
*    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
*      io_fl      = mo_fl
*      iv_name    = 'nya'
**      iv_prefix  = '{'
**      iv_postfix = '}'
**      iv_root    = 'T'
*    ).
*
*    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
*      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
*      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
*    ).
*
**    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
**    cl_demo_output=>display( ).
*
*    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
*      model    = mo_cut->get_config( )-model_name
*      messages = lt_msg
*    ).
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
*
**    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
**    cl_demo_output=>display( ).
*
*    DATA(lo_response) = mo_cut->q( lo_in ).
*    DATA(lv_a) = mo_cut->a( lo_response ).
*
*    cl_demo_output=>write( lv_a ).
*    cl_demo_output=>display( ).

  ENDMETHOD.

  METHOD cc_local.
    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
      io_fl      = mo_fl
      iv_name    = 'nya'
*      iv_prefix  = '{'
*      iv_postfix = '}'
*      iv_root    = 'T'
    ).

    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )

      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
    ).

*    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
*    cl_demo_output=>display( ).

    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
      model    = mo_cut->get_config( )-model_name
      messages = lt_msg
    ).

    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).

    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
    cl_demo_output=>display( ).

    DATA(lo_env) = mo_fl->get_by_name( 'afun.env' )." <-
    DATA(lo_cache) = zcl_llm_00_cache=>new(
      iv_seed  = 0
    ).
    DATA(lo_llm) = zcl_llm_00_llm_lazy_wrap=>new_from_file(
      io_      = lo_env
      io_cache = lo_cache
    ).

    DATA(lo_response) = lo_llm->q( lo_in ).
    DATA(lv_a) = lo_llm->a( lo_response ).

    cl_demo_output=>write( lv_a ).
    cl_demo_output=>display( ).
  ENDMETHOD.

  METHOD cc_azure.
*    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
*      io_fl      = mo_fl
*      iv_name    = 'nya'
**      iv_prefix  = '{'
**      iv_postfix = '}'
**      iv_root    = 'T'
*    ).
*
*    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
*      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
*
*      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
*    ).
*
**    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
**    cl_demo_output=>display( ).
*
*    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
*      model    = mo_cut->get_config( )-model_name
*      messages = lt_msg
*    ).
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
*
**    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
**    cl_demo_output=>display( ).
*
*    DATA(lo_env) = mo_fl->get_by_name( 'az-openai.env' )." <-
*    DATA(lo_cache) = zcl_llm_00_cache=>new(
*      iv_seed  = 0
*    ).
*    DATA(lo_llm) = zcl_llm_00_llm_lazy_wrap=>new_from_file(
*      io_      = lo_env
*      io_cache = lo_cache
*    ).
*
*    DATA(lo_response) = lo_llm->q( lo_in ).
*    DATA(lv_a) = lo_llm->a( lo_response ).
*
*    cl_demo_output=>write( lv_a ).
*    cl_demo_output=>display( ).
  ENDMETHOD.

  METHOD cc_azure2.
*    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
*      io_fl      = mo_fl
*      iv_name    = 'nya'
**      iv_prefix  = '{'
**      iv_postfix = '}'
**      iv_root    = 'T'
*    ).
*
*    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
*      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
*
*      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
*    ).
*
**    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
**    cl_demo_output=>display( ).
*
*    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
*      model    = mo_cut->get_config( )-model_name
*      messages = lt_msg
*    ).
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
**
**    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
**    cl_demo_output=>display( ).
*
*    DATA(lo_env) = mo_fl->get_by_name( 'az-openai2.env' )." <-
*    DATA(lo_cache) = zcl_llm_00_cache=>new(
*      iv_seed  = 0
*    ).
*    DATA(lo_llm) = zcl_llm_00_llm_lazy_wrap=>new_from_file(
*      io_      = lo_env
*      io_cache = lo_cache
*    ).
*
*    DATA(lo_response) = lo_llm->q( lo_in ).
*    DATA(lv_a) = lo_llm->a( lo_response ).
*
*    cl_demo_output=>write( lv_a ).
*    cl_demo_output=>display( ).
  ENDMETHOD.

  METHOD cc_cache.
*
*    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
*      io_fl      = mo_fl
*      iv_name    = 'nya'
**      iv_prefix  = '{'
**      iv_postfix = '}'
**      iv_root    = 'T'
*    ).
*
*    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
*      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
*      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
*    ).
*
**    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
**    cl_demo_output=>display( ).
*
*    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
*      model    = mo_cut->get_config( )-model_name
*      messages = lt_msg
*    ).
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
**
**    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
**    cl_demo_output=>display( ).
*
*    DATA(lo_env)   = mo_fl->get_by_name( 'az-openai.env' )." <-
*    DATA(lo_cache) = zcl_llm_00_cache=>new( iv_seed = 111 ).
*    DATA(lo_llm)   = zcl_llm_00_llm_lazy_wrap=>new_from_file(
*      io_      = lo_env
*      io_cache = lo_cache
*    ).
*
*    DATA(lo_response)   = lo_llm->q( lo_in ).
*    DATA(lv_a) = lo_llm->a( lo_response ).
*
*    DATA(lo_response_2) = lo_llm->q( lo_in ).
*    DATA(lv_a_2) = lo_llm->a( lo_response_2 ).
*
*    cl_demo_output=>write( lv_a ).
*    cl_demo_output=>write( lv_a_2 ).
*    cl_demo_output=>display( ).
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act = lv_a
*        exp = lv_a_2
*    ).
  ENDMETHOD.

  METHOD cc_cache_bypass.
*    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
*      io_fl      = mo_fl
*      iv_name    = 'nya'
**      iv_prefix  = '{'
**      iv_postfix = '}'
**      iv_root    = 'T'
*    ).
*
*    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
*      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
*      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
*    ).
*
**    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
**    cl_demo_output=>display( ).
*
*    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
*      model    = mo_cut->get_config( )-model_name
*      messages = lt_msg
*    ).
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
**
**    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
**    cl_demo_output=>display( ).
*
*    DATA(lo_env)   = mo_fl->get_by_name( 'az-openai.env' )." <-
*    DATA(lo_cache) = zcl_llm_00_cache_never=>new( ).
*    DATA(lo_llm)   = zcl_llm_00_llm_lazy_wrap=>new_from_file(
*      io_      = lo_env
*      io_cache = lo_cache
*    ).
*
*    DATA(lo_response)   = lo_llm->q( lo_in ).
*    DATA(lv_a) = lo_llm->a( lo_response ).
*
*    DATA(lo_response_2) = lo_llm->q( lo_in ).
*    DATA(lv_a_2) = lo_llm->a( lo_response_2 ).
*
*    cl_demo_output=>write( lv_a ).
*    cl_demo_output=>write( lv_a_2 ).
*    cl_demo_output=>display( ).
*
*    cl_abap_unit_assert=>assert_differs(
*      EXPORTING
*        act = lv_a
*        exp = lv_a_2
*    ).
*
  ENDMETHOD.

*
*  METHOD embeddings.
*    DATA(lo_in) = zcl_llm_00_embed_in=>new( VALUE #(
*      input = 'What do you know about HOMELANDER? What is your strategy to defeat him (or, at least, disarm )?'
*    ) ).
*    DATA: lv_json TYPE string.
*    DATA(lo_e) = mo_cut->embeddings( EXPORTING io_ = lo_in  IMPORTING ev_json = lv_json ).
*
*    cl_demo_output=>write( '-- embed' ).
*    cl_demo_output=>write( lo_e->get_json( ) ).
*    cl_demo_output=>write( lo_e->get_( ) ).
*    cl_demo_output=>display( ).
*
*  ENDMETHOD.
*
*
*  METHOD chat_completions.
*    RETURN.
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( VALUE #(
*      messages = VALUE #(
*        ( role = 'system' content = 'You are superwoman!'  )
*        ( role = 'user'   content = 'What do you know about HOMELANDER? What is your strategy to defeat him (or, at least, disarm )?'  ) )
*      functions = zcl_llm_00_array=>new( VALUE #( ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_01_PARAMETER' ) ) ) )
*    ) ).
*
*    DATA(lo_cc) = mo_cut->chat_completions( lo_in ).
*
*    cl_demo_output=>write( '-- chat_completions' ).
*    cl_demo_output=>write( lo_cc->get_json( ) ).
*    cl_demo_output=>write( lo_cc->get_reply( ) ).
*
*  ENDMETHOD.
*
*  METHOD function_call.
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( VALUE #(
*      messages = VALUE #( ( role = 'system' content = 'You are superwoman!'  )
*                          ( role = 'user' content = 'Call a function with three parameters please (pass any fun data)' ) )
*      functions = zcl_llm_00_array=>new( VALUE #( ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_01_PARAMETER' ) )
*                                                  ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_03_PARAMETER' ) )
*                                                )
*                                       )
*    ) ).
*
*    DATA(lo_cc_o1) = mo_cut->chat_completions( lo_in ).
*
*    IF lo_cc_o1->is_function_call( ).
*      DATA(lo_fm) = lo_cc_o1->get_function( ).
*      "lo_fm->invoke( ).
*    ENDIF.
*
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  = lo_cc_o1->is_function_call( )
*        exp                  = 'X'
*    ).
*
*    cl_demo_output=>write( '-- function call ' ).
*    cl_demo_output=>write( lo_cc_o1->get_json( ) ).
*    cl_demo_output=>display( ).
*
*  ENDMETHOD.
*
*  METHOD function_call_04.
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( VALUE #(
*      messages = VALUE #( ( role = 'system' content = 'You are superwoman!'  )
*                          ( role = 'user' content = 'Call a function ZOAI_01_TEST_04_PARAMETER with four parameters please. Pass fun data, to repeat the sting 7 times' ) )
*      functions = zcl_llm_00_array=>new( VALUE #( ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_04_PARAMETER' ) )
*                                                  ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_01_PARAMETER' ) )
*                                                )
*                                       )
*    ) ).
*
*    DATA(lo_cc_o1) = mo_cut->chat_completions( lo_in ).
*
*    IF lo_cc_o1->is_function_call( ).
*      DATA(lo_fm) = lo_cc_o1->get_function( ).
*      lo_fm->invoke( ).
*    ENDIF.
*
**    cl_abap_unit_assert=>assert_equals(
**      EXPORTING
**        act                  = lo_cc_o1->is_function_call( )
**        exp                  = 'X'
**    ).
*
*    cl_demo_output=>write( '-- function call ' ).
*    cl_demo_output=>write( lo_cc_o1->get_json( ) ).
*    cl_demo_output=>display( ).
*
*  ENDMETHOD.
*
*  METHOD function_call_and_invoke.
*    RETURN.
*
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( VALUE #(
*      messages = VALUE #( ( role = 'system' content = 'You are superwoman!'  )
*                          ( role = 'user' content = 'Call a function with three parameters please (pass any fun data)' ) )
*      functions = zcl_llm_00_array=>new( VALUE #( ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_01_PARAMETER' ) )
*                                                  ( zcl_llm_00_function=>new( 'ZOAI_01_TEST_03_PARAMETER' ) )
*                                                )
*                                       )
*    ) ).
*
*    DATA(lo_cc_o1) = mo_cut->chat_completions( lo_in ).
*
*    IF lo_cc_o1->is_function_call( ).
*      DATA(lo_fm) = lo_cc_o1->get_function( ).
*      "lo_fm->invoke( ).
*    ENDIF.
*
*
**    cl_abap_unit_assert=>assert_equals(
**      EXPORTING
**        act                  = lo_cc_o1->is_function_call( )
**        exp                  = 'X'
**    ).
*
*    cl_demo_output=>write( ' JSON ' ).
*    cl_demo_output=>write( lo_cc_o1->get_json( ) ).
*    cl_demo_output=>display( ).
*
*  ENDMETHOD.
*
*  METHOD new.
*
*  ENDMETHOD.

  METHOD cc_json_forced.
    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
      io_fl      = mo_fl
      iv_name    = 'nya'
*      iv_prefix  = '{'
*      iv_postfix = '}'
*      iv_root    = 'T'
    ).

    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
    ).

*    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
*    cl_demo_output=>display( ).

    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
      model    = mo_cut->get_config( )-model_name
      messages = lt_msg
    ).

    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
*
*    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
*    cl_demo_output=>display( ).

    DATA(lo_env)   = mo_fl->get_by_name( 'afun.env' )." <-
    DATA(lo_cache) = zcl_llm_00_cache_never=>new( ).
    DATA(lo_llm)   = zcl_llm_00_llm_lazy_wrap=>new_from_file(
      io_      = lo_env
      io_cache = lo_cache
    ).

    DATA(lo_response)   = lo_llm->q( lo_in ).
    DATA(lv_a) = lo_llm->a( lo_response ).

    DATA(lo_response_2) = lo_llm->q( lo_in ).
    DATA(lv_a_2) = lo_llm->a( lo_response_2 ).

    cl_demo_output=>write( lv_a ).
    cl_demo_output=>write( lv_a_2 ).
    cl_demo_output=>display( ).

    cl_abap_unit_assert=>assert_differs(
      EXPORTING
        act = lv_a
        exp = lv_a_2
    ).


  ENDMETHOD.

  METHOD cc_json_detected.

  ENDMETHOD.

  METHOD cc_json_explicit.
*    DATA(lo_nya) = zcl_llm_00_formula=>new_from_name(
*      io_fl      = mo_fl
*      iv_name    = 'nya'
**      iv_prefix  = '{'
**      iv_postfix = '}'
**      iv_root    = 'T'
*    ).
*
*    DATA(lt_msg) = VALUE zcl_llm_00_chat_in=>zif_llm_00_types~tt_message_in(
*      ( role = 'system' content = lo_nya->get_sys( )->apply( REF #( '' ) ) )
*      ( role = 'user'   content = lo_nya->get_usr( )->apply( REF #( '' ) ) )
*    ).
*
**    cl_demo_output=>write( zcl_llm_00_json=>to_json( lt_msg ) ).
**    cl_demo_output=>display( ).
*
*    DATA(ls_in) = VALUE zif_llm_00_types=>ts_chat_in(
*      model    = mo_cut->get_config( )-model_name
*      messages = lt_msg
*    ).
*
*    DATA(lo_in) = zcl_llm_00_chat_in=>new( ls_in ).
**
**    cl_demo_output=>write( lo_in->zif_llm_00_json~to_json( ) ).
**    cl_demo_output=>display( ).
*
*    DATA(lo_env)   = mo_fl->get_by_name( 'az-openai.env' )." <-
*    DATA(lo_cache) = zcl_llm_00_cache_never=>new( ).
*    DATA(lo_llm)   = zcl_llm_00_llm_lazy_wrap=>new_from_file(
*      io_      = lo_env
*      io_cache = lo_cache
*    ).
*
*    DATA(lo_response)   = lo_llm->q( lo_in ).
*    DATA(lv_a) = lo_llm->a( lo_response ).
*
*    DATA(lo_response_2) = lo_llm->q( lo_in ).
*    DATA(lv_a_2) = lo_llm->a( lo_response_2 ).
*
*    cl_demo_output=>write( lv_a ).
*    cl_demo_output=>write( lv_a_2 ).
*    cl_demo_output=>display( ).
*
*    cl_abap_unit_assert=>assert_differs(
*      EXPORTING
*        act = lv_a
*        exp = lv_a_2
*    ).
*

  ENDMETHOD.
ENDCLASS.
