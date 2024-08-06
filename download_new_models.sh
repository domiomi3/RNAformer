#!/bin/bash

base_url="https://ml.informatik.uni-freiburg.de/research-artifacts/RNAformer2/biophysical_model"

base_dir="models"

models=(rfam_2M_seed_1 rfam_2M_seed_2 rfam_2M_seed_3 rfam_32M_noCy_seed_1 rfam_32M_noCy_seed_2 rfam_32M_noCy_seed_3 rfam_32M_seed_1 rfam_32M_seed_2 rfam_32M_seed_3 rfam_8M_seed_1 rfam_8M_seed_2 rfam_8M_seed_3)

for model in "${models[@]}"; do
    IFS='_' read -r -a parts <<< "$model"
    model_base="${parts[0]}_${parts[1]}"   # rfam_X or rfam_X_noCy
    seed="${parts[2]}_${parts[3]}"        # seed_N

    if [[ "${#parts[@]}" -eq 5 ]]; then
        model_base="${parts[0]}_${parts[1]}_${parts[2]}" # rfam_32M_noCy
        seed="${parts[3]}_${parts[4]}"                    # seed_N
    fi

    model_dir="${base_dir}/${model_base}"

    mkdir -p "${model_dir}"

    pth_url="${base_url}/${model}/state_dict.pth"
    pth_output_path="${model_dir}/${model}.pth"

    yml_url="${base_url}/${model}/config.yml"
    yml_output_path="${model_dir}/${model}.yml"

    echo "Downloading .pth for ${model} to ${pth_output_path}"
    wget -O "${pth_output_path}" "${pth_url}"

    # Download the config file (.yml)
    echo "Downloading .yml for ${model} to ${yml_output_path}"
    wget -O "${yml_output_path}" "${yml_url}"
done

echo "All downloads are complete."