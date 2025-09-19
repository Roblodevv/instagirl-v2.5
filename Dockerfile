# Базовый образ с Python и CUDA
FROM nvidia/cuda:12.2.0-cudnn8-runtime-ubuntu22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    wget git python3 python3-pip nano && \
    rm -rf /var/lib/apt/lists/*

# Создание папок
RUN mkdir -p /opt/comfyui/models/unet \
             /opt/comfyui/models/vae \
             /opt/comfyui/models/clip \
             /opt/comfyui/models/loras

# Скачивание моделей
RUN wget -nc -O /opt/comfyui/models/unet/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf \
"https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/LowNoise/Wan2.2-T2V-A14B-LowNoise-Q8_0.gguf" && \
wget -nc -O /opt/comfyui/models/unet/Wan2.2-T2V-A14B-HighNoise-Q8_0.gguf \
"https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/HighNoise/Wan2.2-T2V-A14B-HighNoise-Q8_0.gguf" && \
wget -nc -O /opt/comfyui/models/vae/wan_2.1_vae.safetensors \
"https://huggingface.co/alliestar/wan22-comfyui-complete/resolve/main/vae/wan_2.1_vae.safetensors" && \
wget -nc -O /opt/comfyui/models/clip/umt5_xxl_fp8_e4m3fn_scaled.safetensors \
"https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" && \
wget -nc -O /opt/comfyui/models/loras/Instagirlv2.5-HIGH.safetensors \
"https://huggingface.co/dci05049/Test_Loras_Wan2.2/resolve/main/Instagirlv2.5-HIGH.safetensors" && \
wget -nc -O /opt/comfyui/models/loras/Instagirlv2.5-LOW.safetensors \
"https://huggingface.co/dci05049/Test_Loras_Wan2.2/resolve/main/Instagirlv2.5-LOW.safetensors" && \
wget -nc -O /opt/comfyui/models/loras/Wan21_T2V_14B_lightx2v_cfg_step_distill_lora_rank32.safetensors \
"https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan21_T2V_14B_lightx2v_cfg_step_distill_lora_rank32.safetensors" && \
wget -nc -O /opt/comfyui/models/loras/Lenovo.safetensors \
"https://huggingface.co/Kulight/l3n0v0-lora/resolve/main/Lenovo.safetensors"

# Установка Python-зависимостей ComfyUI
RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu122
RUN pip3 install -U comfyui

# Порты
EXPOSE 3000 8888

# Запуск ComfyUI + файлового менеджера
CMD bash -c "comfyui & python3 -m http.server 8888 --directory /opt/comfyui/models"
