FROM python:3.11-slim

# System deps (basic build tools; most geo/array libs ship manylinux wheels)
# Find this line in your Dockerfile:
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libexpat1 \     
    && rm -rf /var/lib/apt/lists/*

# Make a working directory
WORKDIR /workspace

# Copy requirements and install
COPY jup_requirements.txt .

RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r jup_requirements.txt

# Default command: run Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=", "--NotebookApp.password="]
