# TCF40 - Create Cloudfront distribution 

## How does it work?
Cloudfront distribution should access objects in S3 bucketwhich is set as the origin. With cache invalidation, CloudFront invalidates every cached version of the file regardless of the header values. 

## Steps
1. Create an S3 bucket
2. Configure the bucket for static website hosting
3. Create  the bucket policy and upload the files: index.html and error.html to the bucket.
4. Create a Cloudfront distribution to access objects in S3 bucket which is set as the origin.
5. Use the Cloudfront distribution domain to check if the configuration is correct. The webpage shown as a result is the index.html file that is uploaded to S3.

## Note:
For cache invalidation, if you need to remove a file from CloudFront edge caches before it expires, you can do the following:
- Invalidate the file from edge caches. The next time a viewer requests the file, CloudFront returns to the origin to fetch the latest version of the file.

## How to test the setup?
## Prerequisites
Make sure line # 67-71 are commented in cloudfront.tf file. And then run "terraform apply" to deploy the resources.

1. Copy the cloudfront domain from the output. Open a new tab in your web browser and paste the domain name of the cloudfront distribution. You should see the web page which says "Welcome to my website. Now hosted on S3 and CloudFront!". If you see this page, then the configuration is working.
2. To test cache invalidation, do the following:

- Modify the index.html file (Type something on line 7 in index.html file) and check if the changes are reflected immediately using the cloudfront domain. You will see that the change is not applied on the cloudfront side. Hence the old version of index.html file is shown.

- To apply the changes to cloudfront side, uncomment line # 67-71 in cloudfront.tf file, save and run "terraform apply" again to create invalidation. Now when you check the webpage with cloudfront domain, The change is reflected immediately.