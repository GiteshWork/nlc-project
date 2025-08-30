# terraform/cloudfront.tf

# 1. Create a Web Application Firewall (WAF)
resource "aws_wafv2_web_acl" "nlc_waf" {
  name        = "nlc-serverless-waf"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }

  # Use the AWS Managed Rule Set for common vulnerabilities
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-common-rules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-main"
    sampled_requests_enabled   = true
  }
}

# 2. Create the CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = replace(aws_apigatewayv2_api.lambda_api.api_endpoint, "https://", "")
    origin_id   = "api-gateway-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "NLC Serverless Platform Distribution"
  default_root_object = "/"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "api-gateway-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100" # Use only North America and Europe for cost savings

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # 3. Attach the WAF to the CloudFront Distribution
  web_acl_id = aws_wafv2_web_acl.nlc_waf.arn
}