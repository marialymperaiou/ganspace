#!/bin/bash -l
#
#SBATCH --job-name="Team 1 - GANSpace"
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=56G
#SBATCH --output=team1.%j.out.log
#SBATCH --error=team1.%j.error.log
#SBATCH --account=pa190402 
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export NUM_THREADS=$SLURM_CPUS_PER_TASK

module purge
#module load  gnu/8.3.0  intel/18.0.5 intelmpi/2018.5 cuda/10.1.168 pytorch/1.3.1
#module load  gnu/8 intelmpi/2018 cuda/10.1.168 pytorch/1.7.0


module load gnu/8 cuda/10.1.168 pytorch/1.8.0

source /users/pa19/gealexdl/team1/venv/bin/activate

#TRIAL RUNS and original command (in colab) to replicate in slurm
#!python visualize.py --model $model_name --est $estimator --class $mc --use_w --layer $l -c $num_components --sigma $s 

#srun python3 /users/pa19/gealexdl/team1/ganspace/visualize.py --model StyleGAN2 --est pca --class church --use_w --layer style -c 50 --sigma 3 

#srun python3 /users/pa19/gealexdl/team1/ganspace/visualize.py  --model StyleGAN_ADA --est pca --class ffhq --use_w --layer style -c 20 --sigma 3

#srun python3 /users/pa19/gealexdl/team1/ganspace/visualize.py  --model StyleGAN --est pca --class ffhq --use_w --layer g_mapping -c 20 --sigma 3

#TO DO: 1. ADD layers list for ADA and StyleGAN  2.Add two separate loops, a simple layers-estimators for ada AND a triple layers-data-estimators for Style

#LOOPING FOR StyleGAN-ADA: Over Estimators and Layers (since we only have weights for one class)
#declare -a estimators=("pca" "svd" "rpca" "irpca" "fbpca" "ica")
#declare -a classes=("ffhq" "celebahq" "bedrooms" "car" "cat" "wikiart")
#declare -a layers=("conv1.activate" "to_rgbs.0" "convs.2.conv.modulation" "convs.0.conv.modulation" "convs.1.conv.modulation"
#"convs.3.conv.modulation"  "to_rgbs.0.upsample" "to_rgb1.conv.modulation" "to_rgb1.conv" "to_rgb1")


#for layer in "${layers[@]}"
#do 
#    srun python3 /users/pa19/gealexdl/team1/ganspace/visualize.py  --model StyleGAN_ADA --est pca --class ffhq --use_w --layer "$layer" -c 20 --sigma 3
#done
#deactivate

#LOOPING FOR StyleGAN2
declare -a layers=("style"  "to_rgb1"  "input"  "conv"  "conv1.conv" "convs"  "to_rgbs.0.upsample" "to_rgbs.0.conv" "to_rgbs.0.conv.modulation")
#declare -a classes=("ffhq"  "car"  "cat" "church"  "horse"  "bedrooms"  "kitchen"  "places")

declare -a classes=("car" "kitchen" "places")


for layer in "${layers[@]}" 
do 
    for class in "${classes[@]}"
    do
        srun python3 /users/pa19/gealexdl/team1/ganspace/visualize.py  --model StyleGAN2 --est pca --class "$class" --use_w --layer "$layer" -c 20 --sigma 3
    done
done
deactivate

#example nested loop
#for i in 0 1 2 3 4 5 6 7 8 9
#do
#    for j in 0 1 2 3 4 5 6 7 8 9
#    do 
#        echo "$i$j"
#    done
#done

