#!/usr/bin/env python3
"""
Python Usage Examples for Agentic LLM Framework

This script demonstrates the Python components of the framework,
including token prediction, model training, and utility functions.
"""

import sys
import os
import json
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from utils import (
    count_tokens_gpt4,
    count_tokens_mistral,
    extract_text_features,
    predict_tokens_gpt4,
    predict_tokens_mistral,
    predict_tokens_from_text
)


def example_1_basic_token_counting():
    """Example 1: Basic token counting with different tokenizers."""
    print("=== Example 1: Basic Token Counting ===")
    
    # Sample ABAP code
    abap_code = """
    CLASS zcl_example DEFINITION PUBLIC FINAL CREATE PUBLIC.
      PUBLIC SECTION.
        METHODS: constructor.
      PRIVATE SECTION.
    ENDCLASS.
    """
    
    # Count tokens with different tokenizers
    gpt4_tokens = count_tokens_gpt4(abap_code)
    mistral_tokens = count_tokens_mistral(abap_code)
    
    print(f"ABAP Code: {abap_code.strip()}")
    print(f"GPT-4 tokens: {gpt4_tokens}")
    print(f"Mistral tokens: {mistral_tokens}")
    print()


def example_2_feature_extraction():
    """Example 2: Extract linguistic features from text."""
    print("=== Example 2: Feature Extraction ===")
    
    # Sample text
    sample_text = """
    This is a sample ABAP class definition.
    It contains multiple lines of code with various elements.
    The class has methods, attributes, and follows best practices.
    """
    
    # Extract features
    features = extract_text_features(sample_text)
    feature_names = [
        "text_length", "word_count", "punctuation_count",
        "number_count", "whitespace_count", "line_count", "sentence_count"
    ]
    
    print(f"Sample text: {sample_text.strip()}")
    print("Extracted features:")
    for name, value in zip(feature_names, features):
        print(f"  {name}: {value}")
    print()


def example_3_token_prediction():
    """Example 3: Predict token counts using ML models."""
    print("=== Example 3: Token Prediction ===")
    
    # Sample ABAP code
    abap_code = """
    CLASS zcl_data_processor DEFINITION PUBLIC FINAL CREATE PUBLIC.
      PUBLIC SECTION.
        TYPES: BEGIN OF ty_data,
                 id       TYPE i,
                 name     TYPE string,
                 value    TYPE f,
                 created  TYPE timestamp,
               END OF ty_data.
        
        METHODS: process_data
                   IMPORTING iv_data TYPE ty_data
                   RETURNING VALUE(rv_result) TYPE string.
        
      PRIVATE SECTION.
        DATA: mv_cache TYPE REF TO zcl_cache.
    ENDCLASS.
    """
    
    # Predict tokens for different models
    gpt4_prediction = predict_tokens_from_text(abap_code, "gpt4")
    mistral_prediction = predict_tokens_from_text(abap_code, "mistral")
    
    print(f"ABAP Code: {abap_code.strip()}")
    print(f"GPT-4 prediction: {gpt4_prediction['predicted_tokens']} tokens")
    print(f"Mistral prediction: {mistral_prediction['predicted_tokens']} tokens")
    print()


def example_4_batch_processing():
    """Example 4: Process multiple code samples in batch."""
    print("=== Example 4: Batch Processing ===")
    
    # Sample code snippets
    code_samples = [
        "CLASS zcl_simple DEFINITION PUBLIC. ENDCLASS.",
        "METHOD process_data. WRITE: 'Hello World'. ENDMETHOD.",
        """
        CLASS zcl_complex DEFINITION PUBLIC FINAL CREATE PUBLIC.
          PUBLIC SECTION.
            METHODS: constructor,
                     process_data IMPORTING iv_data TYPE string,
                     get_result RETURNING VALUE(rv_result) TYPE string.
          PRIVATE SECTION.
            DATA: mv_cache TYPE REF TO zcl_cache,
                  mt_data  TYPE TABLE OF string.
        ENDCLASS.
        """
    ]
    
    print("Processing multiple code samples:")
    for i, code in enumerate(code_samples, 1):
        prediction = predict_tokens_from_text(code, "gpt4")
        print(f"  Sample {i}: {prediction['predicted_tokens']} tokens")
    print()


def example_5_cost_estimation():
    """Example 5: Estimate costs based on token predictions."""
    print("=== Example 5: Cost Estimation ===")
    
    # Cost per 1K tokens (example rates)
    costs = {
        "gpt4": 0.03,      # $0.03 per 1K tokens
        "gpt-3.5-turbo": 0.002,  # $0.002 per 1K tokens
        "mistral": 0.001   # $0.001 per 1K tokens
    }
    
    # Sample prompt
    prompt = """
    Please analyze this ABAP code and suggest improvements:
    
    CLASS zcl_legacy DEFINITION PUBLIC.
      PUBLIC SECTION.
        METHODS: old_method.
      PRIVATE SECTION.
        DATA: mv_old_data TYPE string.
    ENDCLASS.
    
    Please provide:
    1. Code quality assessment
    2. Specific improvement suggestions
    3. Modern ABAP best practices
    4. Refactoring recommendations
    """
    
    # Predict tokens and estimate costs
    for model, cost_per_1k in costs.items():
        try:
            prediction = predict_tokens_from_text(prompt, model)
            tokens = prediction['predicted_tokens']
            estimated_cost = (tokens / 1000) * cost_per_1k
            
            print(f"{model.upper()}:")
            print(f"  Predicted tokens: {tokens}")
            print(f"  Estimated cost: ${estimated_cost:.4f}")
        except Exception as e:
            print(f"{model.upper()}: Error - {e}")
    print()


def example_6_model_comparison():
    """Example 6: Compare different models for the same task."""
    print("=== Example 6: Model Comparison ===")
    
    # Test task
    task = "Generate a simple ABAP class for data validation"
    
    models = ["gpt4", "mistral"]
    
    print(f"Task: {task}")
    print("Model comparison:")
    
    for model in models:
        try:
            # Simulate a typical prompt for this task
            prompt = f"""
            {task}
            
            Requirements:
            - Class should be public and final
            - Include validation methods
            - Follow ABAP best practices
            - Include error handling
            - Add documentation
            """
            
            prediction = predict_tokens_from_text(prompt, model)
            print(f"  {model.upper()}: {prediction['predicted_tokens']} tokens")
            
        except Exception as e:
            print(f"  {model.upper()}: Error - {e}")
    print()


def example_7_optimization():
    """Example 7: Optimize prompts for cost efficiency."""
    print("=== Example 7: Prompt Optimization ===")
    
    # Original verbose prompt
    verbose_prompt = """
    Please provide a comprehensive analysis of the following ABAP code.
    I need you to examine every aspect of the code including:
    1. Code structure and organization
    2. Naming conventions and standards
    3. Performance considerations
    4. Security implications
    5. Maintainability factors
    6. Best practices compliance
    7. Potential improvements
    8. Documentation quality
    
    Here is the code to analyze:
    CLASS zcl_example DEFINITION PUBLIC. ENDCLASS.
    """
    
    # Optimized concise prompt
    concise_prompt = """
    Analyze this ABAP code for best practices and suggest improvements:
    CLASS zcl_example DEFINITION PUBLIC. ENDCLASS.
    """
    
    # Compare token usage
    verbose_tokens = predict_tokens_from_text(verbose_prompt, "gpt4")
    concise_tokens = predict_tokens_from_text(concise_prompt, "gpt4")
    
    savings = verbose_tokens['predicted_tokens'] - concise_tokens['predicted_tokens']
    savings_percent = (savings / verbose_tokens['predicted_tokens']) * 100
    
    print("Prompt optimization comparison:")
    print(f"  Verbose prompt: {verbose_tokens['predicted_tokens']} tokens")
    print(f"  Concise prompt: {concise_tokens['predicted_tokens']} tokens")
    print(f"  Token savings: {savings} ({savings_percent:.1f}%)")
    print()


def main():
    """Run all examples."""
    print("Agentic LLM Framework - Python Usage Examples")
    print("=" * 50)
    print()
    
    try:
        example_1_basic_token_counting()
        example_2_feature_extraction()
        example_3_token_prediction()
        example_4_batch_processing()
        example_5_cost_estimation()
        example_6_model_comparison()
        example_7_optimization()
        
        print("All examples completed successfully!")
        
    except Exception as e:
        print(f"Error running examples: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main() 