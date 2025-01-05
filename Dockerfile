# Dockerfile

# Use NVIDIA CUDA base image with PyTorch support
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Set environment variables for Python and CUDA
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/opt/conda/bin:$PATH"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3-pip python3-dev \
    wget git curl \
    libgl1-mesa-glx libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

# Install PyTorch with CUDA support
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Clone YOLOv11 repository
RUN git clone https://github.com/ultralytics/ultralytics.git /ultralytics

# Set working directory
WORKDIR /ultralytics

# Install YOLOv11 dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose default ports for training logs (if needed)
EXPOSE 6006 5000

# Entry point for running scripts
CMD ["python3"]