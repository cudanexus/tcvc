import alphaui as gr
import requests
import boto3
import subprocess
s3 = boto3.resource('s3')

def upload_to_s3(file, bucket_name, object_name):
    """Upload a file to an S3 bucket."""
    s3.upload_file(file, bucket_name, object_name)

def download_video(url):
    """Download a video from a URL."""
    response = requests.get(url)
    content_type = response.headers.get('content-type')
    if 'video' not in content_type:
        return None
    filename = url.split('/')[-1]
    with open(filename, 'wb') as f:
        f.write(response.content)
    return filename

def upload_org_video(filename,bucket_name):
    upload_to_s3(filename, bucket_name, "upload_videos/"+filename)
    return "org Uploded Video"

def upload_process_video(filename,bucket_name):
    upload_to_s3(filename, bucket_name, "processed_videos/"+filename)
    return "proc Uploded Video"

def process_video(url):
    """Process a video by downloading it and uploading it to an S3 bucket."""
    bucket_name="videos-tcvc"

    filename = download_video(url)
    if filename is not None:
        input_video = filename
        output_images = "/media/mustafa/ubuntu_backup/Projects/tcvc/src/images/test_s3/out_%d.png"

        cmd = ["ffmpeg", "-i", input_video, "-vf", "fps=5", output_images]
        subprocess.call(cmd)
        upload_org_video(filename,bucket_name)

        # Convert images to video
        image_pattern = "/media/mustafa/ubuntu_backup/Projects/tcvc/src/images/test_s3/out_%d.png"
        output_video = "output.mp4"

        cmd = ["ffmpeg", "-framerate", "5", "-i", image_pattern, output_video]
        subprocess.call(cmd)
        upload_process_video(output_video,bucket_name)



        return f"Video uploaded to S3 bucket '{bucket_name}' with object name '{filename}'."
    else:
        return "The URL does not contain a video."

inputs = [
    gr.inputs.Textbox(label="Video URL"),

]

output = gr.outputs.Textbox(label="Output")

gr.Interface(fn=process_video, inputs=inputs, outputs=output, title="Upload Video to S3").launch()
