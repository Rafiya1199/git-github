# Create Cloudfront distribution
resource "aws_cloudfront_distribution" "prod_distribution" {
    origin {
        ##The DNS domain name of either the S3 bucket, or web site of your custom origin
        domain_name = local.s3_domain
        origin_id = local.s3_origin_id   ##A unique identifier for the origin.

        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "match-viewer"
            origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }
    # By default, show index.html file
    default_root_object = "index.html"
    #Whether the distribution is enabled to accept end user requests for content.
    enabled = true

    # If there is a 404, return error.html with a HTTP 200 Response
    custom_error_response {
        error_caching_min_ttl = 3000
        error_code = 404
        response_code = 200
        response_page_path = "/error.html"
    }
    
    ##The default cache behavior for this distribution
    ##target_origin_id - The value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.
    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        # forwarded values configuration specifies how CloudFront handles query strings, cookies and headers 
        forwarded_values {
            query_string = true
            cookies {
                forward = "none"
            }
        }
        ##Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern.
        viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }
    ## The price class for this distribution.
    # Distributes content to US and Europe
    price_class = "PriceClass_100"

    # Restricts who is able to access this content
    restrictions {
        geo_restriction {
            # type of restriction, blacklist, whitelist or none
            restriction_type = "none"
        }
    }

    # The SSL configuration for this distribution 
    viewer_certificate {
        cloudfront_default_certificate = true
    }

}

# resource "null_resource" "example1" {
#   provisioner "local-exec" {
#     command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.prod_distribution.id} --paths '/index.html'"
#   }
# }
