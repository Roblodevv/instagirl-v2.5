FROM python:3.10-slim

WORKDIR /opt/comfyui

# Установка системных зависимостей
RUN apt update && apt install -y \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Клонирование ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI . && \
    pip install -r requirements.txt

# Создание директорий для моделей
RUN mkdir -p models/unet models/vae models/clip models/loras

# Загрузка моделей
RUN wget -nc -O models/unet/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf \
    "https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/LowNoise/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf" && \
    wget -nc -O models/unet/Wan2.2-T2V-A14B-HighNoise-Q8_0.gguf \
    "https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/HighNoise/Wan2.2-T2V-A14B-HighNoise-Q8_0.gguf" && \
    wget -nc -O models/vae/wan_2.1_vae.safetensors \
    "https://huggingface.co/alliestar/wan22-comfyui-complete/resolve/main/vae/wan_2.1_vae.safetensors" && \
    wget -nc -O models/clip/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" && \
    wget -nc -O models/loras/Instagirlv2.5-HIGH.safetensors \
    "https://huggingface.co/dci05049/Test_Loras_Wan2.2/resolve/main/Instagirlv2.5-HIGH.safetensors" && \
    wget -nc -O models/loras/Instagirlv2.5-LOW.safetensors \
    "https://huggingface.co/dci05049/Test_Loras_Wan2.2/resolve/main/Instagirlv2.5-LOW.safetensors" && \
    wget -nc -O models/loras/Wan21_T2V_14B_lightx2v_cfg_step_distill_lora_rank32.safetensors \
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan21_T2V_14B_lightx2v_cfg_step_distill_lora_rank32.safetensors" && \
    wget -nc -O models/loras/Lenovo.safetensors \
    "https://huggingface.co/Kulight/l3n0v0-lora/resolve/main/Lenovo.safetensors"

# Открытие портов
EXPOSE 3000 8888

# Запуск ComfyUI
CMD ["python", "main.py", "--listen", "--port", "3000"]
