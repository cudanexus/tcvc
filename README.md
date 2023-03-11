# Readme for TCVC-Modal

TCVC-Modal is an implementation of the TCVC method for image colorization using PyTorch.

## Todo

- Add batch processing to optimize inference.

## Installation

### Option 1: Install natively

To install TCVC-Modal natively, follow these steps:

1. Clone the repository to your machine using the following command:

    ```
    git clone https://github.com/cudanexus/tcvc
    cd tcvc
    ```

2. Run the installation script as root:

    ```
    sudo bash install.sh
    ```

3. Install the required Python packages using pip:

    ```
    pip install -r requirements.txt
    ```

4. Install the required packages for channelnorm_package, correlation_package, and resample2d_package:

    ```
    cd codes/models/archs/networks/channelnorm_package/ && python setup.py develop
    cd codes/models/archs/networks/correlation_package/ && python setup.py develop
    cd codes/models/archs/networks/resample2d_package/ && python setup.py develop
    cd ../../../../
    ```

5. Download the colorization backbone model and the pretrained models:

    ```
    wget "https://tcvc.s3.amazonaws.com/TCVC_IDC.zip"
    wget "https://tcvc.s3.amazonaws.com/pretrained_models.zip"
    ```

6. Extract the downloaded models and paste them in the `experiments` folder.

7. Run the colorization test:

    ```
    python test_TCVC_onesampling_noGT.py
    ```

### Option 2: Use Docker

To use TCVC-Modal with Docker, follow these steps:

1. Clone the repository to your machine using the following command:

    ```
    git clone https://github.com/cudanexus/tcvc
    cd tcvc
    ```

2. Build the Docker image:

    ```
    docker build -t tcvc .
    ```

3. Run the Docker container:

    ```
    docker run --gpus all --net host --rm -it --name tcvc tcvc
    ```

4. Follow steps 5-7 above to run the colorization test inside the Docker container.

## License

The code is available under the MIT License. Please see the `LICENSE` file for more information.

## Acknowledgments

This implementation is based on the following paper:

- Cheng, Zezhou, Qingxiong Yang, and Bin Sheng. "Deep colorization." Proceedings of the IEEE International Conference on Computer Vision. 2015.

Thanks to the authors for making their work available to the research community.
