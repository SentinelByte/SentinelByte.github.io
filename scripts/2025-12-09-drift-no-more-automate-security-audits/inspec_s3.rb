describe aws_s3_bucket('my-bucket') do
    it { should exist }
    it { should_not be_public }
end
