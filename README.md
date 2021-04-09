# GANSpace: Discovering Interpretable GAN Controls
![Python 3.7](https://img.shields.io/badge/python-3.7-green.svg)
![PyTorch 1.3](https://img.shields.io/badge/pytorch-1.3-green.svg)
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/harskish/ganspace/blob/master/notebooks/Ganspace_colab.ipynb)


> **GANSpace: Discovering Interpretable GAN Controls**<br>
Git workflow:
Open your git bash terminal. Other steps should be followed for other interfaces.
1. Be sure that you are in the right folder, else navigate there
```
$ cd my_folder
```
2. Create a new branch per new task and switch to this branch
```
$ git checkout -b my_branch
```
3. Get remote changes locally in your branch:
```
$ git pull origin my_branch
```
4. Make local changes to your code
5. Check your changes. You will get a list with all changes made in scripts files etc. You can do 'git status' in later steps as well. 
```
$ git status
```
6. Add your files. This can be done in 2 ways:
a. Add all files one by one manually. This helps selecting what you are going to send to remote and what not:
```
$ git add my_file
```
b. If and only if you are sure that all changes made locally should be pushed to the remote, add ALL files by typing:
```
$ git add .
```
7. Commit changes followed by a representative message regarding the reason for commiting (summarize in one sentence what you did)
```
$ git commit -m"changes made according to issue 1234"
```
8. Push to remote
```
$ git push origin my_branch
```
9. Go to github. You will see a 'compare and pull request' button. Click it. You are going to finally merge the changes you just pushed to the existing code. ONLY PROCEED IF YOU ARE SURE YOUR CHANGES ARE WORKING. Write a relevant comment in the corresponding comment box.
10. Create a pull request by clicking the button 'Create pull request'.
11. You need to see a message "This branch has no conflicts with the base branch", else good luck. Then, just click 'Merge pull request.
12. Click 'Confirm merge'. You are done! All local changes you added (git add) are passed from your local branch (my_branch) to the remote main branch (main). ALWAYS KEEP MAIN CLEAN AND FUNCTIONAL! Consider main as the branch you are going to handle to your client or your boss.

## Setup
See the [setup instructions](SETUP.md).

## Usage
This repository includes versions of BigGAN, StyleGAN, and StyleGAN2 modified to support per-layer latent vectors.

**Interactive model exploration**
```
# Explore BigGAN-deep husky
python interactive.py --model=BigGAN-512 --class=husky --layer=generator.gen_z -n=1_000_000

# Explore StyleGAN2 ffhq in W space
python interactive.py --model=StyleGAN2 --class=ffhq --layer=style --use_w -n=1_000_000 -b=10_000

# Explore StyleGAN2 cars in Z space
python interactive.py --model=StyleGAN2 --class=car --layer=style -n=1_000_000 -b=10_000
```
```
# Apply previously saved edits interactively
python interactive.py --model=StyleGAN2 --class=ffhq --layer=style --use_w --inputs=out/directions
```

**Visualize principal components**
```
# Visualize StyleGAN2 ffhq W principal components
python visualize.py --model=StyleGAN2 --class=ffhq --use_w --layer=style -b=10_000

# Create videos of StyleGAN wikiart components (saved to ./out)
python visualize.py --model=StyleGAN --class=wikiart --use_w --layer=g_mapping -b=10_000 --batch --video
```

**Options**
```
Command line paramaters:
  --model      one of [ProGAN, BigGAN-512, BigGAN-256, BigGAN-128, StyleGAN, StyleGAN2]
  --class      class name; leave empty to list options
  --layer      layer at which to perform PCA; leave empty to list options
  --use_w      treat W as the main latent space (StyleGAN / StyleGAN2)
  --inputs     load previously exported edits from directory
  --sigma      number of stdevs to use in visualize.py
  -n           number of PCA samples
  -b           override automatic minibatch size detection
  -c           number of components to keep
```

## Reproducibility
All figures presented in the main paper can be recreated using the included Jupyter notebooks:
* Figure 1: `figure_teaser.ipynb`
* Figure 2: `figure_pca_illustration.ipynb`
* Figure 3: `figure_pca_cleanup.ipynb`
* Figure 4: `figure_style_content_sep.ipynb`
* Figure 5: `figure_supervised_comp.ipynb`
* Figure 6: `figure_biggan_style_resampling.ipynb`
* Figure 7: `figure_edit_zoo.ipynb`

## Known issues
* The interactive viewer sometimes freezes on startup on Ubuntu 18.04. The freeze is resolved by clicking on the terminal window and pressing the control key. Any insight into the issue would be greatly appreciated!

## Integrating a new model
1. Create a wrapper for the model in `models/wrappers.py` using the `BaseModel` interface.
2. Add the model to `get_model()` in `models/wrappers.py`.

## Importing StyleGAN checkpoints from TensorFlow
It is possible to import trained StyleGAN and StyleGAN2 weights from TensorFlow into GANSpace.

### StyleGAN
1. Install TensorFlow: `conda install tensorflow-gpu=1.*`.
2. Modify methods `__init__()`, `load_model()` in `models/wrappers.py` under class StyleGAN.

### StyleGAN2
1. Follow the instructions in [models/stylegan2/stylegan2-pytorch/README.md](https://github.com/harskish/stylegan2-pytorch/blob/master/README.md#convert-weight-from-official-checkpoints). Make sure to use the fork in this specific folder when converting the weights for compatibility reasons.
2. Save the converted checkpoint as `checkpoints/stylegan2/<dataset>_<resolution>.pt`.
3. Modify methods `__init__()`, `download_checkpoint()` in `models/wrappers.py` under class StyleGAN2.

## Acknowledgements
We would like to thank:

* The authors of the PyTorch implementations of [BigGAN][biggan_pytorch], [StyleGAN][stylegan_pytorch], and [StyleGAN2][stylegan2_pytorch]:<br>Thomas Wolf, Piotr Bialecki, Thomas Viehmann, and Kim Seonghyeon.
* Joel Simon from ArtBreeder for providing us with the landscape model for StyleGAN.<br>(unfortunately we cannot distribute this model)
* David Bau and colleagues for the excellent [GAN Dissection][gandissect] project.
* Justin Pinkney for the [Awesome Pretrained StyleGAN][pretrained_stylegan] collection.
* Tuomas Kynkäänniemi for giving us a helping hand with the experiments.
* The Aalto Science-IT project for providing computational resources for this project.

## Citation
```
@inproceedings{härkönen2020ganspace,
  title     = {GANSpace: Discovering Interpretable GAN Controls},
  author    = {Erik Härkönen and Aaron Hertzmann and Jaakko Lehtinen and Sylvain Paris},
  booktitle = {Proc. NeurIPS},
  year      = {2020}
}
```

## License

The code of this repository is released under the [Apache 2.0](LICENSE) license.<br>
The directory `netdissect` is a derivative of the [GAN Dissection][gandissect] project, and is provided under the MIT license.<br>
The directories `models/biggan` and `models/stylegan2` are provided under the MIT license.


[biggan_pytorch]: https://github.com/huggingface/pytorch-pretrained-BigGAN
[stylegan_pytorch]: https://github.com/lernapparat/lernapparat/blob/master/style_gan/pytorch_style_gan.ipynb
[stylegan2_pytorch]: https://github.com/rosinality/stylegan2-pytorch
[gandissect]: https://github.com/CSAILVision/GANDissect
[pretrained_stylegan]: https://github.com/justinpinkney/awesome-pretrained-stylegan
