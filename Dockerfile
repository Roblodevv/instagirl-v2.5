FROM runpod/pytorch:2.1.0-py3.10-cuda12.1.105-devel-ubuntu22.04

# Рабочая директория
WORKDIR /opt

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    git wget curl unzip nano python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Клонируем ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git comfyui
WORKDIR /opt/comfyui

# Установка зависимостей ComfyUI
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install jupyterlab

# Создаем папки для моделей
RUN mkdir -p /opt/comfyui/models/unet \
    /opt/comfyui/models/vae \
    /opt/comfyui/models/clip \
    /opt/comfyui/models/loras

# Качаем модели
RUN wget -nc -O /opt/comfyui/models/unet/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf \
"https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/LowNoise/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf"

RUN wget -nc -O /opt/comfyui/models/unet/Wan2.2-T2V-A14B-HighNoise-Q8_0.gguf \
"https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/HighNoise/Wan2.2-T2V-A14B-HighNoise-Q8_0.gguf"

RUN wget -nc -O /opt/comfyui/models/vae/wan_2.1_vae.safetensors \
"https://huggingface.co/alliestar/wan22-comfyui-complete/resolve/main/vae/wan_2.1_vae.safetensors"

RUN wget -nc -O /opt/comfyui/models/clip/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
"https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"

RUN wget -nc -O /opt/comfyui/models/loras/Instagirlv2.5-HIGH.safetensors \
"https://huggingface.co/dci05049/Test_Loras_Wan2.2/resolve/main/Instagirlv2.5-HIGH.safetensors"

RUN wget -nc -O /opt/comfyui/models/loras/Instagirlv2.5-LOW.safetensors \
"https://huggingface.co/dci05049/Test_Loras_Wan2.2/resolve/main/Instagirlv2.5-LOW.safetensors"

RUN wget -nc -O /opt/comfyui/models/loras/Wan21_T2V_14B_lightx2v_cfg_step_distill_lora_rank32.safetensors \
"https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan21_T2V_14B_lightx2v_cfg_step_distill_lora_rank32.safetensors"

RUN wget -nc -O /opt/comfyui/models/loras/Lenovo.safetensors \
"https://huggingface.co/Kulight/l3n0v0-lora/resolve/main/Lenovo.safetensors"

# Открываем порты
EXPOSE 3000
EXPOSE 8888

# Стартовый скрипт
CMD jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser & \
    python main.py --listen 0.0.0.0 --port 3000
