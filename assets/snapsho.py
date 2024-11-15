import boto3
import datetime

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    instance_id = 'i-09b106068ba5faedc'  # replace with your instance ID
    
    # Create AMI with timestamp
    ami_name = f"MyScheduledAMI-{datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}"
    response = ec2.create_image(
        InstanceId=instance_id,
        Name=ami_name,
        NoReboot=True  # Set to False if you want to stop the instance before creating the AMI
    )

    ami_id = response['ImageId']
    print(f"Created AMI ID: {ami_id}")
    
    # Log response for debugging
    print(response)
    return response
