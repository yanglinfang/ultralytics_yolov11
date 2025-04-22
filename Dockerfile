# --- 基础镜像：devel → runtime（体积更小） ---
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# --- APT 缓存加速，装 Python 3.10 ---
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends python3.10 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# --- 一次性装 cu118 轮子 + vLLM ---
RUN pip install --no-cache-dir \
        torch==2.1.0+cu118 torchvision==0.16.0+cu118 \
        --extra-index-url https://download.pytorch.org/whl/cu118 && \
    pip install --no-cache-dir vllm[cu118]

# ---------- Entrypoint ----------
ENTRYPOINT ["python", "-m", "vllm.entrypoints.openai.api_server"]
# 多行 CMD 写完别漏右括号
CMD ["--model", "deepseek-10b-awq", "--tokenizer", "deepseek-10b-awq", "--port", "8000", "--concurrency", "16", "--max-batch-tokens", "8192", "--log-dir", "vllm_logs"]
