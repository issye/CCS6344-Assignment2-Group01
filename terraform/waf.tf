############################################
# AWS WAFv2 Web ACL
# Note:
# Deployment is restricted in AWS Academy
# Sandbox. This file demonstrates the
# intended WAF security configuration.
############################################

resource "aws_wafv2_web_acl" "web_acl" {
  name        = "pawsecure-web-acl"
  description = "WAF protecting the public application endpoint"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  ##########################################
  # Rule 1: AWS Managed Common Rule Set
  ##########################################
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ##########################################
  # Rule 2: SQL Injection Protection
  ##########################################
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ##########################################
  # Rule 3: Cross-Site Scripting (XSS)
  ##########################################
  rule {
    name     = "AWS-AWSManagedRulesXSSRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesXSSRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ##########################################
  # Visibility & Monitoring
  ##########################################
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "pawsecureWebACL"
    sampled_requests_enabled   = true
  }
}
