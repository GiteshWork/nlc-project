# terraform/monitoring.tf

resource "aws_cloudwatch_dashboard" "nlc_serverless_dashboard" {
  dashboard_name = "NLC-Serverless-Platform-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.nlc_db.identifier]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "RDS Database CPU Utilization"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.image_processor.function_name],
            [".", "Errors", ".", "."]
          ],
          period = 300,
          stat   = "Sum",
          region = "us-east-1",
          title  = "Lambda Function Invocations and Errors"
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 7,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", aws_cloudfront_distribution.s3_distribution.id],
            [".", "5xxErrorRate", ".", ".", ".", ".", { "stat": "Average" }]
          ],
          period = 300,
          stat   = "Sum",
          region = "us-east-1",
          title  = "CloudFront Requests and Error Rate"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 7,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/WAFV2", "AllowedRequests", "Region", "us-east-1", "WebACL", split("/", aws_wafv2_web_acl.nlc_waf.arn)[1], "Rule", "ALL"],
            [".", "BlockedRequests", ".", ".", ".", ".", ".", "."]
          ],
          period = 300,
          stat   = "Sum",
          region = "us-east-1",
          title  = "WAF Allowed vs. Blocked Requests"
        }
      }
    ]
  })
}