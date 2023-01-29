# Event Driven app

This S3 event driven app uses the principle of decoupling, least-privilege access, and data encryption. Starting with upload [csv file](https://www.kaggle.com/datasets/tmdb/tmdb-movie-metadata) to the S3 bucket, the S3 bucket will notify sqs queue with event body that contains information about the csv file. 


![Infrastructure](./assets/event-driven-app-diagram.png)


## Prerequisites
[AWS CLI Setup](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)